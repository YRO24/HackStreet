from fastapi import APIRouter
from services.llm_service import generate_explanation

router = APIRouter(prefix="/api/explain", tags=["Explain Agent"])

@router.post("/score")
def explain_score(score_data: dict):
    explanation = generate_explanation(score_data)
    return {"explanation": explanation}
