from core.config import Settings
from tavily import TavilyClient
import trafilatura

settings = Settings()
tavily_client = TavilyClient(
    api_key=settings.TAVILY_API_KEY)  # tavily job is just to give url to get more data we can use package called trafilatura


class SearchService:
    def web_search(self,
                   query: str):  # this function is basically going to search the web and return all the search results it gets.it will return us a list with all the results and data
        try:
            results = []
            response = tavily_client.search(query, max_results=10)
            search_results = response.get("results", [])
            #  now we will loop through every result in this search_results and use this trafilatura package to fetch the url to extract the main content.
            for result in search_results:
                download = trafilatura.fetch_url(
                    result.get("url"))  # when we call fetch_url method, we're basically downloading the main content
                content = trafilatura.extract(download, include_comments=False)  # to avoid html comments
                results.append({
                    "title": result.get("title", ""),
                    "url": result.get("url"),
                    "content": content
                })
            return results  # the job of this web search function is to search the entire web and return a list of all the results and all the data,
        # and here we are not passing all the data, we are passing the content, title and url for additional context to Gemini, and
        # also when we display stuff on our front-end, we are going to list out all the sources for that we will require title and
        # url of the source so users can click and search for themselves

        except Exception as e:
          print(e)
# there are two approaches you can take here the first approach is to use the Gemini API over here to search the web what
# do I mean by that well we can use Gemini to create a list of queries from the main query.
# the other way is to use the service designed for this task, so by using tavily we can just take the query put it to Tavily, and it will give us all the search results
