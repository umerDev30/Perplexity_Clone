import random

class ImageService:
    # ✅ Sample image URLs (Replace this with a real API or a database)
    IMAGE_DATABASE = {
        "elon musk": "https://example.com/elon_musk.jpg",
        "apple": "https://example.com/apple_logo.jpg",
        "football": "https://example.com/football.jpg",
    }

    DEFAULT_IMAGES = [
        "https://example.com/default1.jpg",
        "https://example.com/default2.jpg",
        "https://example.com/default3.jpg",
    ]

    def get_image_url(self, query: str) -> str | None:
        """Fetch an image URL based on the query."""
        if not query:
            return None  # ✅ Return None for empty queries

        query_lower = query.strip().lower()

        # ✅ If query matches exactly, return the corresponding image
        if query_lower in self.IMAGE_DATABASE:
            return self.IMAGE_DATABASE[query_lower]

        # ✅ Return a random fallback image if no exact match
        return random.choice(self.DEFAULT_IMAGES) if self.DEFAULT_IMAGES else None
