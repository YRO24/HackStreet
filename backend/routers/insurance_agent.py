from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any

router = APIRouter(prefix="/api/insurance", tags=["Insurance Agent"])

# ---------------------------------------------------
# GEMINI INITIALIZATION
# ---------------------------------------------------

import google.generativeai as genai
from config import config

genai.configure(api_key=config.GEMINI_API_KEY)

try:
    # Try the most available model first
    gemini_model = genai.GenerativeModel("gemini-pro")
    GEMINI_AVAILABLE = True
    print("✅ Gemini Pro initialized successfully")
except Exception as e:
    print(f"⚠️  Gemini Pro model initialization error: {e}")
    try:
        # Try newer model as fallback
        gemini_model = genai.GenerativeModel("gemini-1.5-flash")
        GEMINI_AVAILABLE = True
        print("✅ Gemini 1.5 Flash initialized as fallback")
    except Exception as e2:
        print(f"❌ All Gemini models failed: {e2}")
        GEMINI_AVAILABLE = False
        gemini_model = None

# ---------------------------------------------------
# MODELS
# ---------------------------------------------------

class InsurancePolicy(BaseModel):
    type: str
    coverage: int
    premium: int
    provider: str

class Profile(BaseModel):
    age: int
    dependents: int
    income: int
    city: str

class AAData(BaseModel):
    user_id: str
    profile: Profile
    insurances: List[InsurancePolicy]
    accounts: List[Dict[str, Any]] = []

class ChatRequest(BaseModel):
    user_id: str
    message: str
    history: List[Dict[str, str]] = []

class ChatResponse(BaseModel):
    reply: str
    history: List[Dict[str, str]]

# ---------------------------------------------------
# FAKE AA DB
# ---------------------------------------------------

FAKE_AA_DB = {
    "user1": AAData(
        user_id="user1",
        profile=Profile(age=23, dependents=0, income=600000, city="mumbai"),
        insurances=[
            InsurancePolicy(
                type="health",
                coverage=300000,
                premium=12000,
                provider="care health"
            ),
            InsurancePolicy(
                type="life",
                coverage=5000000,      # example 50 lakh term plan
                premium=9000,          # example premium
                provider="lic"
            )
        ],
        accounts=[{"type": "savings", "balance": 80000}]
    )
}

# ---------------------------------------------------
# RECOMMENDATION ENGINE
# ---------------------------------------------------

def has_policy(aa: AAData, policy_type: str):
    for p in aa.insurances:
        if p.type.lower() == policy_type.lower():
            return p
    return None

def build_recommendations(aa: AAData):
    recs = []
    profile = aa.profile

    if not has_policy(aa, "health"):
        recs.append({
            "type": "health",
            "priority": "high",
            "reason": "A basic health plan protects against unexpected medical expenses."
        })

    if profile.dependents > 0:
        recs.append({
            "type": "life",
            "priority": "high",
            "reason": f"You have {profile.dependents} dependents. Term insurance is recommended."
        })

    return recs

# ---------------------------------------------------
# ENDPOINTS
# ---------------------------------------------------

@router.post("/chat", response_model=ChatResponse)
def chat_with_insurance_agent(req: ChatRequest):
    """Chat with the Insurance Agent AI powered by Gemini"""
    try:
        aa = FAKE_AA_DB.get(req.user_id)

        if not aa:
            return ChatResponse(reply="Cannot find AA data for this user.", history=req.history)

        profile = aa.profile
        existing = ", ".join(p.type for p in aa.insurances) or "None"
        recs = build_recommendations(aa)

        rec_text = "\n".join(
            f"- {r['type']} ({r['priority']}): {r['reason']}"
            for r in recs
        )

        system = f"""
You are GenFi's Insurance Advisor AI.
Use simple language. Be smart, friendly, and helpful.

AA Profile:
•  Age: {profile.age}
•  Income: {profile.income}
•  Dependents: {profile.dependents}
•  Existing Insurance: {existing}

Recommendations:
{rec_text}

Give short, helpful answers.
"""

        prompt = system + "\nConversation:\n"

        for h in req.history:
            prompt += f"{h['role'].capitalize()}: {h['content']}\n"

        prompt += f"User: {req.message}\nAI:"

        if GEMINI_AVAILABLE and gemini_model:
            try:
                response = gemini_model.generate_content(prompt)
                reply = response.text
            except Exception as e:
                reply = f"I'm having trouble connecting to my AI service right now. Here's what I can tell you based on your profile:\n\nAge: {profile.age}, Income: ₹{profile.income:,}\nExisting policies: {existing}\n\n{rec_text if rec_text else 'Your current insurance coverage looks good!'}\n\nError: {str(e)}"
        else:
            reply = f"""I'm currently unable to provide AI-powered responses. Here's a basic analysis:

Age: {profile.age}, Income: ₹{profile.income:,}
Existing policies: {existing}

{rec_text if rec_text else 'Your current insurance coverage looks good!'}"""

        req.history.append({"role": "user", "content": req.message})
        req.history.append({"role": "assistant", "content": reply})

        return ChatResponse(reply=reply, history=req.history)
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Insurance chat error: {str(e)}")

@router.get("/user/{user_id}")
def get_user_insurance_data(user_id: str):
    """Get user's insurance and AA data"""
    user_data = FAKE_AA_DB.get(user_id)
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")
    return user_data

@router.get("/advice")
def get_insurance_advice(user_id: str):
    """Get personalized insurance recommendations"""
    try:
        aa = FAKE_AA_DB.get(user_id)
        if not aa:
            raise HTTPException(status_code=404, detail="User not found")

        recs = build_recommendations(aa)
        return {
            "user_id": user_id,
            "existing_policies": [p.dict() for p in aa.insurances],
            "recommendations": recs,
            "profile": aa.profile.dict()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Advice generation error: {str(e)}")

@router.post("/add-policy")
def add_insurance_policy(user_id: str, policy: InsurancePolicy):
    """Add a new insurance policy for a user"""
    try:
        if user_id not in FAKE_AA_DB:
            raise HTTPException(status_code=404, detail="User not found")
        
        FAKE_AA_DB[user_id].insurances.append(policy)
        return {"message": "Policy added successfully", "policy": policy.dict()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error adding policy: {str(e)}")

@router.get("/policies/types")
def get_policy_types():
    """Get available insurance policy types"""
    return {
        "policy_types": [
            {"type": "health", "description": "Medical and health insurance"},
            {"type": "life", "description": "Term and life insurance"},
            {"type": "vehicle", "description": "Car and bike insurance"}, 
            {"type": "home", "description": "Home and property insurance"},
            {"type": "travel", "description": "Travel insurance"}
        ]
    }