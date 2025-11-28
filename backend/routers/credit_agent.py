from fastapi import APIRouter
from core.scoring_engine import compute_genfi_score
from core.planner_engine import generate_repayment_plan

router = APIRouter(prefix="/api/credit", tags=["Credit Agent"])

@router.post("/analyze")
def analyze_credit(profile: dict):
    score, breakdown = compute_genfi_score(profile)
    plan = generate_repayment_plan(profile, score)
    return {"genfi_score": score, "breakdown": breakdown, "plan": plan}
