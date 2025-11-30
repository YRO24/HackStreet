from pydantic import BaseModel
from datetime import date

class BankTransaction(BaseModel):
    id: int
    amount: float
    type: str
    date: date