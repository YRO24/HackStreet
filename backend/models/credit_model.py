"""
GenFi Credit System Integration
Integrates your complete GenFi Credit Agent system
"""

import pickle
import numpy as np
import pandas as pd
from typing import Dict, Any, Tuple, List
import joblib
import os

class GenFiCreditSystem:
    def __init__(self, model_path: str = None):
        """Initialize the GenFi Credit System"""
        self.system_components = None
        self.TransactionAnalyzer = None
        self.GenFiScorer = None
        self.RepaymentPlanner = None
        self.FinancialAdvisorLLM = None
        self.GenFiCreditAgent = None
        self.hf_token = None
        self.weights = None
        
        if model_path and os.path.exists(model_path):
            self.load_system(model_path)
    
    def load_system(self, model_path: str):
        """Load the GenFi system from file"""
        try:
            with open(model_path, 'rb') as f:
                system_data = pickle.load(f)
            
            if isinstance(system_data, dict) and 'system_type' in system_data:
                # Load GenFi components
                self.TransactionAnalyzer = system_data.get('TransactionAnalyzer')
                self.GenFiScorer = system_data.get('GenFiScorer')
                self.RepaymentPlanner = system_data.get('RepaymentPlanner')
                self.FinancialAdvisorLLM = system_data.get('FinancialAdvisorLLM')
                self.GenFiCreditAgent = system_data.get('GenFiCreditAgent')
                self.hf_token = system_data.get('hf_token')
                self.weights = system_data.get('weights', {})
                self.system_components = system_data
                
                print(f"✅ GenFi system loaded successfully from {model_path}")
                print(f"📊 Components: {list(system_data.keys())}")
            else:
                # Fallback for old format
                self.system_components = system_data
                print(f"⚠️  Loaded data in legacy format from {model_path}")
                
        except Exception as e:
            print(f"❌ Error loading GenFi system: {e}")
            self.system_components = None
    
    def preprocess_data(self, user_data: Dict[str, Any]) -> np.ndarray:
        """Convert user data to model input format"""
        try:
            # Example feature engineering - adjust based on your model
            features = {
                'age': user_data.get('age', 30),
                'income': user_data.get('monthly_income', 50000),
                'credit_score': user_data.get('current_credit_score', 750),
                'debt_to_income': user_data.get('total_debt', 0) / max(user_data.get('monthly_income', 1), 1),
                'employment_years': user_data.get('employment_years', 5),
                'loan_amount': user_data.get('loan_amount', 100000),
                'loan_tenure': user_data.get('loan_tenure_months', 60),
                'existing_loans': user_data.get('existing_loans_count', 0),
                'credit_utilization': user_data.get('credit_utilization', 30) / 100,
                'payment_history': user_data.get('payment_history_score', 85) / 100,
            }
            
            # Convert to array in the correct order
            feature_array = np.array([list(features.values())]).reshape(1, -1)
            
            # Apply scaling if scaler is available
            if self.scaler:
                feature_array = self.scaler.transform(feature_array)
                
            return feature_array
            
        except Exception as e:
            print(f"Error preprocessing data: {e}")
            return np.array([[0] * 10])  # Default fallback
    
    def genfi_analyze(self, user_profile: Dict[str, Any]) -> Dict[str, Any]:
        """Perform GenFi credit analysis"""
        if self.system_components is None:
            return {
                "error": "GenFi system not loaded",
                "credit_score": 0,
                "recommendations": [],
                "risk_assessment": "HIGH"
            }
        
        try:
            # Use GenFiCreditAgent if available
            if self.GenFiCreditAgent:
                # Create user profile for GenFi system
                analysis = self.GenFiCreditAgent.analyze_user(user_profile)
                return {
                    "credit_score": analysis.get("credit_score", 0),
                    "recommendations": analysis.get("recommendations", []),
                    "risk_assessment": analysis.get("risk_level", "MEDIUM"),
                    "repayment_plan": analysis.get("repayment_plan", {}),
                    "status": "success"
                }
            
            # Fallback analysis using individual components
            credit_score = 650  # Default
            recommendations = [
                "Maintain regular income flow",
                "Reduce existing debt burden",
                "Build emergency savings"
            ]
            
            # Basic risk assessment
            income = user_profile.get('monthly_income', 0)
            debt = user_profile.get('total_debt', 0)
            
            if income > 50000 and debt < income * 5:
                risk_level = "LOW"
                credit_score = 750
            elif income > 30000 and debt < income * 8:
                risk_level = "MEDIUM"
                credit_score = 680
            else:
                risk_level = "HIGH"
                credit_score = 580
            
            return {
                "credit_score": credit_score,
                "recommendations": recommendations,
                "risk_assessment": risk_level,
                "repayment_plan": {},
                "status": "success"
            }
            
        except Exception as e:
            return {
                "error": str(e),
                "credit_score": 0,
                "recommendations": [],
                "risk_assessment": "HIGH"
            }

    def predict_credit_score(self, user_data: Dict[str, Any]) -> Tuple[int, float, Dict[str, Any]]:
        """Predict credit score using GenFi system or fallback"""
        try:
            if self.GenFiScorer and self.system_components:
                # Use GenFi scorer
                genfi_result = self.genfi_analyze(user_data)
                score = genfi_result.get('credit_score', 650)
                confidence = 0.9 if genfi_result.get('status') == 'success' else 0.7
                explanation = self._generate_explanation(user_data, score, confidence)
                return int(score), float(confidence), explanation
            else:
                # Fallback to rule-based scoring
                return self._fallback_scoring(user_data)
            
        except Exception as e:
            print(f"GenFi prediction error: {e}")
            return self._fallback_scoring(user_data)
    
    def _fallback_scoring(self, user_data: Dict[str, Any]) -> Tuple[int, float, Dict[str, Any]]:
        """Rule-based fallback scoring when model is unavailable"""
        score = 650  # Base score
        
        # Income factor
        income = user_data.get('monthly_income', 50000)
        if income > 100000:
            score += 50
        elif income > 75000:
            score += 30
        elif income < 30000:
            score -= 40
        
        # Debt-to-income ratio
        debt = user_data.get('total_debt', 0)
        debt_ratio = debt / max(income, 1)
        if debt_ratio < 0.3:
            score += 40
        elif debt_ratio > 0.6:
            score -= 60
        
        # Credit utilization
        utilization = user_data.get('credit_utilization', 30)
        if utilization < 10:
            score += 30
        elif utilization > 80:
            score -= 50
        
        # Employment stability
        emp_years = user_data.get('employment_years', 5)
        if emp_years > 5:
            score += 20
        elif emp_years < 2:
            score -= 30
        
        score = max(300, min(850, score))
        
        explanation = {
            'factors': {
                'income_level': 'positive' if income > 50000 else 'negative',
                'debt_ratio': 'positive' if debt_ratio < 0.4 else 'negative',
                'credit_utilization': 'positive' if utilization < 30 else 'negative',
                'employment_stability': 'positive' if emp_years > 3 else 'neutral'
            },
            'recommendations': [
                'Maintain low credit utilization (under 30%)',
                'Pay bills on time to improve payment history',
                'Keep old credit accounts open to maintain credit age'
            ]
        }
        
        return score, 0.75, explanation
    
    def _generate_explanation(self, user_data: Dict[str, Any], score: int, confidence: float) -> Dict[str, Any]:
        """Generate explanation for the credit score"""
        
        # Score categories
        if score >= 800:
            category = "Excellent"
            color = "green"
        elif score >= 740:
            category = "Very Good"
            color = "light_green"
        elif score >= 670:
            category = "Good"
            color = "yellow"
        elif score >= 580:
            category = "Fair"
            color = "orange"
        else:
            category = "Poor"
            color = "red"
        
        return {
            'score_category': category,
            'category_color': color,
            'confidence': confidence,
            'key_factors': self._identify_key_factors(user_data),
            'improvement_tips': self._get_improvement_tips(user_data, score),
            'risk_level': 'Low' if score > 700 else 'Medium' if score > 600 else 'High'
        }
    
    def _identify_key_factors(self, user_data: Dict[str, Any]) -> list:
        """Identify key factors affecting the score"""
        factors = []
        
        income = user_data.get('monthly_income', 50000)
        if income > 75000:
            factors.append("Strong income level")
        elif income < 30000:
            factors.append("Low income may limit credit options")
        
        debt_ratio = user_data.get('total_debt', 0) / max(income, 1)
        if debt_ratio > 0.5:
            factors.append("High debt-to-income ratio")
        elif debt_ratio < 0.3:
            factors.append("Healthy debt-to-income ratio")
        
        utilization = user_data.get('credit_utilization', 30)
        if utilization > 80:
            factors.append("High credit utilization")
        elif utilization < 10:
            factors.append("Excellent credit utilization")
        
        return factors
    
    def _get_improvement_tips(self, user_data: Dict[str, Any], score: int) -> list:
        """Generate personalized improvement tips"""
        tips = []
        
        if score < 650:
            tips.extend([
                "Focus on paying all bills on time",
                "Reduce credit card balances below 30% of limits",
                "Avoid opening new credit accounts for now"
            ])
        elif score < 750:
            tips.extend([
                "Continue maintaining good payment habits",
                "Consider paying down debt to improve utilization ratio",
                "Keep old accounts open to maintain credit history length"
            ])
        else:
            tips.extend([
                "Maintain your excellent credit habits",
                "Consider becoming an authorized user on family accounts",
                "Monitor your credit report regularly for accuracy"
            ])
        
        return tips

    def get_financial_advice(self, query: str, user_context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Get financial advice using GenFi FinancialAdvisorLLM"""
        try:
            if self.FinancialAdvisorLLM:
                advice = self.FinancialAdvisorLLM.get_advice(query, user_context)
                return {
                    "advice": advice,
                    "status": "success"
                }
            
            # Fallback advice
            return {
                "advice": f"Based on your query about '{query}', I recommend consulting with a financial advisor for personalized guidance.",
                "status": "fallback"
            }
            
        except Exception as e:
            return {
                "error": str(e),
                "advice": "Unable to provide advice at this time."
            }


# Global GenFi system instance
genfi_system = GenFiCreditSystem()

def load_genfi_system(model_path: str):
    """Load your GenFi system from pickle file"""
    global genfi_system
    genfi_system.load_system(model_path)
    
def analyze_credit_profile(user_data: Dict[str, Any]) -> Dict[str, Any]:
    """Main function to get GenFi credit analysis"""
    genfi_result = genfi_system.genfi_analyze(user_data)
    score, confidence, explanation = genfi_system.predict_credit_score(user_data)
    
    return {
        'genfi_analysis': genfi_result,
        'predicted_score': score,
        'confidence': confidence,
        'explanation': explanation,
        'timestamp': pd.Timestamp.now().isoformat()
    }