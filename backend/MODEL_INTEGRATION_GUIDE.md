# Integrating Your Jupyter Notebook Model

## Quick Integration Steps

### 1. Export Your Model from Jupyter Notebook

Add this code cell to the end of your Jupyter notebook:

```python
# At the end of your notebook, after running the GenFi Credit Agent
import pickle
import os

# Create models directory
os.makedirs('../backend/models', exist_ok=True)

# Export your complete GenFi system
genfi_system = {
    'TransactionAnalyzer': TransactionAnalyzer,
    'GenFiScorer': GenFiScorer, 
    'RepaymentPlanner': RepaymentPlanner,
    'FinancialAdvisorLLM': FinancialAdvisorLLM,
    'GenFiCreditAgent': GenFiCreditAgent,
    'hf_token': HF_TOKEN,  # Your Hugging Face token
    'sample_user_profile': user_profile,  # Your user profile template
    'weights': GenFiScorer.WEIGHTS,  # Scoring weights
    'system_type': 'GenFi_Credit_Agent'
}

# Save to backend
with open('../backend/models/genfi_system.pkl', 'wb') as f:
    pickle.dump(genfi_system, f)

print("✅ GenFi Credit Agent system exported successfully!")
print(f"📊 Exported components: {list(genfi_system.keys())}")
print("🔗 Ready to integrate with Flutter app!")
```

### 2. Start Your Backend Server

```bash
cd backend
pip install -r requirements.txt
python main.py
```

✅ **Server Status: RUNNING**
- Server URL: http://localhost:8000
- API Documentation: http://localhost:8000/docs
- Test endpoint: `curl http://localhost:8000/`

### 3. Load Your GenFi System via API

```bash
# Load your exported GenFi system
curl -X POST "http://localhost:8000/api/credit/load-genfi-system" \
  -H "Content-Type: application/json" \
  -d '{"model_path": "models/genfi_system.pkl"}'
```

### 4. Test GenFi Predictions

```bash
curl -X POST "http://localhost:8000/api/credit/genfi-analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Rahul Sharma",
    "monthly_income": 90000,
    "income_type": "Salaried", 
    "loan_goal": "Home Loan",
    "loan_amount": 5000000,
    "interest_rate": 8.5,
    "tenure_years": 20,
    "current_emis": 0,
    "missed_payments": false,
    "bank_transactions": [],
    "upi_transactions": []
  }'
```

## Alternative Methods

### Option 2: Direct Python Integration
If your model is complex, you can also:
1. Copy your model training code to `backend/models/train_model.py`
2. Run training as part of backend startup
3. Use the model directly without file I/O

### Option 3: Model API Service
Deploy your model as a separate service:
1. Create a separate FastAPI service for just the model
2. Your main backend calls this model service
3. Good for scaling and model updates

## Supported Model Types

- **scikit-learn**: RandomForest, SVM, LogisticRegression, etc.
- **XGBoost**: XGBClassifier, XGBRegressor
- **LightGBM**: LGBM models
- **TensorFlow/Keras**: Neural networks
- **Custom Models**: Any Python model with `.predict()` method

## Flutter Integration

Your Flutter chat will automatically use the model via the existing API endpoints:
- `/api/credit/predict` - Direct ML predictions
- `/api/credit/chat-analysis` - Conversational responses with ML insights

## GenFi System Features Expected

Your GenFi Credit Agent expects these user profile fields:
- **name**: User's full name
- **monthly_income**: Monthly income in rupees
- **income_type**: "Salaried" or "Business" 
- **loan_goal**: Purpose like "Home Loan", "Car Loan", etc.
- **loan_amount**: Requested loan amount
- **interest_rate**: Annual interest rate (e.g., 8.5)
- **tenure_years**: Loan tenure in years
- **current_emis**: Existing EMI obligations
- **missed_payments**: Boolean for payment history
- **bank_transactions**: Array of bank transaction data
- **upi_transactions**: Array of UPI transaction data

Transaction data structure:
```python
# Bank transactions
{
  'month': 1,
  'date': '2024-01-01', 
  'type': 'credit'|'debit',
  'amount': 50000.0,
  'description': 'SALARY CREDIT FROM EMPLOYER'
}

# UPI transactions  
{
  'month': 1,
  'merchant': 'Swiggy',
  'amount': 500.0,
  'category': 'Food'
}
```