from pydantic import BaseModel

class UserProfile(BaseModel):
    name: str
    income: float
    expenses: float
    goal: str
