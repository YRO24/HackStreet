def compute_genfi_score(profile: dict):
    # Mock scoring logic
    income = profile.get("income", 0)
    expenses = profile.get("expenses", 0)
    
    if income > 0:
        ratio = expenses / income
        if ratio < 0.3:
            score = 850
        elif ratio < 0.5:
            score = 750
        else:
            score = 650
    else:
        score = 600
        
    breakdown = {
        "payment_history": "Excellent",
        "credit_utilization": "Low",
        "age_of_credit": "2 years"
    }
    return score, breakdown
