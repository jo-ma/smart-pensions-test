from pydantic import BaseModel
from typing import Optional


class Reason(BaseModel):
    """Defines the model of a Reason"""
    id: Optional[str] = None
    reason: str
