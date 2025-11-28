from pydantic import BaseModel
from datetime import date

class UPITransaction(BaseModel):
    id: int
    amount: float
    receiver: str
    date: date
