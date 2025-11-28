def generate_explanation(score_data):
    prompt = f"""
    You are GenFi, an AI financial mentor.
    Given {score_data}, explain in plain English:
    1. What this score means,
    2. How to improve it,
    3. Suggest one repayment strategy.
    """
    # Return mock text for demo if API unavailable
    return "Your score shows strong payment behaviour but high EMI ratio. Try saving ₹5k more monthly to reduce risk."
