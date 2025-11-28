from fastapi import APIRouter

router = APIRouter(prefix="/api/planner", tags=["Planner Agent"])

@router.post("/create")
def create_plan(goal: dict):
    return {"message": "Plan created successfully", "plan": {}}
