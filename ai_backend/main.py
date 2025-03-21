import asyncio
import traceback
from fastapi import FastAPI, WebSocket

from pydantic_models.chat_body import ChatBody
from services.gemini_service import GeminiService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService
from services.image_service import ImageService  # Ensure you have an ImageService to fetch images

app = FastAPI() 

search_service = SearchService()
sort_source_service = SortSourceService()
gemini_service = GeminiService()
image_service = ImageService()  # Initialize image fetching service


# Chat WebSocket
@app.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    
    try:
        await asyncio.sleep(0.1)  # Allow time for connection stabilization

        # Receive JSON data from WebSocket
        data = await websocket.receive_json()
        if not data or "query" not in data:  # Ensure the data is valid
            await websocket.send_json({"error": "Invalid request: 'query' key is missing"})
            return

        query = data["query"]
        print(f"Received query: {query}")

        # Fetch search results and handle potential None values
        search_results = search_service.web_search(query) or []
        print(f"Search results: {search_results}")

        # Fetch images related to the query
        image_url = image_service.get_image_url(query)

        # Send image data only if available
        if image_url:
         await websocket.send_json({"type": "image", "data": image_url})

        print(f"Fetched images: {image_url}")

        # Sort sources, ensuring it does not return None
        sorted_results = sort_source_service.sort_sources(query, search_results) or []
        print(f"Sorted sources: {sorted_results}")

        await asyncio.sleep(0.1)
        await websocket.send_json({"type": "search_result", "data": sorted_results})

        # Send images separately
        await websocket.send_json({"type": "images", "data": image_urls})

        # Generate response and handle NoneType
        response_generator = gemini_service.generate_response(query, sorted_results)
        if response_generator is None:
            response_generator = []
        
        # Send response in chunks
        for chunk in response_generator:
            await asyncio.sleep(0.1)
            await websocket.send_json({"type": "content", "data": chunk})

    except Exception as e:
        print(f"Unexpected error occurred: {e}")
        traceback.print_exc()  # Log the full traceback for debugging
    finally:
        await websocket.close()
        print("WebSocket connection closed")


# Chat Endpoint
@app.post("/chat")
def chat_endpoint(body: ChatBody):
    query = body.query
    print(f"Received query via POST: {query}")

    search_results = search_service.web_search(query) or []
    sorted_results = sort_source_service.sort_sources(query, search_results) or []
    response = gemini_service.generate_response(query, sorted_results) or []
    
    # Fetch images for the query
    image_urls = image_service.fetch_images(query) or []
    
    return {"response": response, "images": image_urls}
