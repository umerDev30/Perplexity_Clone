import google.generativeai as genai
from core.config import Settings
from typing import List, Dict  # Use for older Python versions if necessary

settings = Settings()


class GeminiService:
    def _init_(self):
        genai.configure(api_key=settings.Gemini_API_KEY)
        self.model = genai.GenerativeModel("gemini-1.5-pro")  # Ensure this matches the actual API usage

    def generate_response(self, query: str, search_results: List[Dict]):
        # Construct the context text from the search results
        context_text = "\n\n".join([
            f"Source {i + 1} ({result['url']}):\n{result['content']}"
            for i, result in enumerate(search_results)
        ])

        # Build the full prompt
        full_prompt = f"""
        Context from web search:
        {context_text}

        Query: {query}
        Please provide a comprehensive, detailed, well-cited, and accurate response using the above context. 
        Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge unless it is absolutely necessary.
        """

        # Generate the response
        response = self.model.generate_content(full_prompt, stream=True)
        for chunk in response:
         yield chunk.text  # Return the generated response, unlike return yield allow us to come back to function.