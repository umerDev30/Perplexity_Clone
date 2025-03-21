from pydantic import BaseModel


# basemodel from pydantic will allow us to specify
# the type and will automatically tell the fast API endpoint that what we are requesting for is the body of the req.
class ChatBody(BaseModel):  # created a class of chat body which extends basemodel as soon as we extend basemodel we are saying that this is a pydantic model if it's a pydantic model and this ChatBody is used anywhere it's going to be the body of the req.
    query: str  # we require from the body is a query which is a type of string of we pass any other it will convert it to a string otherwise it will throw an error.so, it performs a type validation for us.
