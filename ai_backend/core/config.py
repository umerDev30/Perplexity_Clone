from dotenv import load_dotenv

from pydantic_settings import BaseSettings  # we need to install pydantic_settings separately(pip install pydantic_settings)

load_dotenv()  # we loaded the file .env using this python package


class Settings(BaseSettings):
    TAVILY_API_KEY: str = ""
#  pydantic and our application will be able to figure out the Tavily API key if it's present
#  and if it's not present, we'll just give it a default value of an empty string
#  this class Settings extended to BaseSettings that comes from pydantic settings

#  when we extend our class with BaseSettings, pydantic will automatically go and pull values from environment
#  variable based on this particular name TAVILY_API_KEY

    Gemini_API_KEY: str = ""
