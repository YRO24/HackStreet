from fastapi import APIRouter, HTTPException
from core.scoring_engine import compute_genfi_score
from core.planner_engine import generate_repayment_plan
from models.credit_model import analyze_credit_profile, load_genfi_system
from pydantic import BaseModel
from typing import Optional

router = APIRouter(prefix="/api/credit", tags=["Credit Agent"])

class CreditProfile(BaseModel):
    age: Optional[int] = 30
    monthly_income: Optional[float] = 50000
    current_credit_score: Optional[int] = 650
    total_debt: Optional[float] = 0
    employment_years: Optional[int] = 5
    loan_amount: Optional[float] = 100000
    loan_tenure_months: Optional[int] = 60
    existing_loans_count: Optional[int] = 0
    credit_utilization: Optional[float] = 30
    payment_history_score: Optional[int] = 85

@router.post("/load-genfi-system")
def load_genfi_model(model_path: str):
    """Load your GenFi Credit Agent system from pickle file"""
    try:
        load_genfi_system(model_path)
        return {"message": "GenFi system loaded successfully", "model_path": model_path}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error loading GenFi system: {str(e)}")

@router.post("/genfi-analyze")
def genfi_credit_analyze(profile: dict):
    """GenFi-powered comprehensive credit analysis"""
    try:
        # Get GenFi analysis
        analysis_result = analyze_credit_profile(profile)
        
        return {
            "genfi_analysis": analysis_result['genfi_analysis'],
            "credit_score": analysis_result['predicted_score'],
            "confidence": analysis_result['confidence'],
            "explanation": analysis_result['explanation'],
            "timestamp": analysis_result['timestamp'],
            "system": "GenFi Credit Agent"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"GenFi analysis error: {str(e)}")

@router.post("/analyze")
def analyze_credit(profile: dict):
    """Original analysis endpoint (backward compatibility)"""
    score, breakdown = compute_genfi_score(profile)
    plan = generate_repayment_plan(profile, score)
    return {"genfi_score": score, "breakdown": breakdown, "plan": plan}

@router.post("/predict")
def predict_credit(profile: CreditProfile):
    """New ML-powered credit prediction"""
    try:
        # Convert Pydantic model to dict
        user_data = profile.dict()
        
        # Get prediction from GenFi system
        prediction_result = analyze_credit_profile(user_data)
        
        # Generate repayment plan based on prediction
        plan = generate_repayment_plan(user_data, prediction_result['predicted_score'])
        
        return {
            "genfi_prediction": prediction_result,
            "repayment_plan": plan,
            "model_used": "GenFi Credit Agent System"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@router.post("/chat-analysis")
def chat_credit_analysis(profile: CreditProfile, question: Optional[str] = ""):
    """Enhanced analysis for chatbot integration"""
    try:
        user_data = profile.dict()
        prediction_result = analyze_credit_profile(user_data)
        
        # Generate conversational response
        score = prediction_result['predicted_score']
        explanation = prediction_result['explanation']
        
        # Create chatbot-friendly response
        response = {
            "score": score,
            "category": explanation['score_category'],
            "confidence": explanation['confidence'],
            "risk_level": explanation['risk_level'],
            "key_insights": explanation['key_factors'],
            "recommendations": explanation['improvement_tips'],
            "conversation_response": _generate_chat_response(score, explanation, question)
        }
        
        return response
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Chat analysis error: {str(e)}")

def _generate_chat_response(score: int, explanation: dict, question: str = "") -> str:
    """Generate natural language response for chatbot"""
    category = explanation['score_category']
    
    base_response = f"Based on my analysis, your predicted credit score is {score}, which falls in the '{category}' range. "
    
    if score >= 750:
        base_response += "This is an excellent score that will help you qualify for the best interest rates and credit terms. "
    elif score >= 650:
        base_response += "This is a decent score, but there's room for improvement to access better credit products. "
    else:
        base_response += "This score indicates some credit challenges that we should work on improving together. "
    
    # Add key insights
    if explanation['key_factors']:
        base_response += f"Key factors affecting your score include: {', '.join(explanation['key_factors'])}. "
    
    # Add recommendations
    if explanation['improvement_tips']:
        base_response += f"To improve your score, I recommend: {explanation['improvement_tips'][0]}. "
    
    # Handle specific questions
    if question and "improve" in question.lower():
        base_response += f"For improvement, focus on: {', '.join(explanation['improvement_tips'][:3])}."
    elif question and "loan" in question.lower():
        if score >= 700:
            base_response += "With your score, you should qualify for competitive loan rates."
        else:
            base_response += "You may want to improve your score before applying for major loans."
    
    return base_response
