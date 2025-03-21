from typing import List
from sentence_transformers import SentenceTransformer
import numpy as np


class SortSourceService:
    def __init__(self):  # When the class is created, it initializes a sentence transformer model
        self.embedding_model = SentenceTransformer(
            "all-MiniLM-L6-v2")  # This model converts a text into numerical vectors (embeddings) that can be compared.

    def sort_sources(self, query: str,
                     search_results: List[dict]):  # query: A string that represents what the user is searching for.
        #  search_results: A list of dictionaries, where each dictionary represents a search result.Each result has at least a "content" key.
        try:
            relevant_docs = []
            query_embedding = self.embedding_model.encode(
                query)  # Processes the Query Converts the query into a numerical embedding using the sentence transformer model.

            for res in search_results:
                res_embedding = self.embedding_model.encode(
                    res["content"])  # For each result, the content is also converted into an embedding.

                similarity = float(
                    np.dot(query_embedding, res_embedding)
                    / (np.linalg.norm(query_embedding) * np.linalg.norm(res_embedding))
                )  # The similarity score is calculated between the query embedding and the result embedding

                res["relevance_score"] = similarity

                if similarity > 0.3:
                    relevant_docs.append(res)

            return sorted(
                relevant_docs, key=lambda x: x["relevance_score"], reverse=True
            )  # relevant_docs: This is a list of dictionaries, where each dictionary represents a search result.i.e: relevant_docs = [{"content": "Document 1", "relevance_score": 0.85}]
        # The sorted() function takes a list and sorts it based on a specific condition you define.
        # The key parameter tells sorted() how to compare the items in the list.
        # This is a lambda function (an anonymous, one-line function).
        # It takes each dictionary x from the list and uses the value of its "relevance_score" key as the basis for sorting.
        # The reverse=True means the list is sorted in descending order (the highest scores first).
        except Exception as e:
            print(e)
