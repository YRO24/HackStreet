"""
Model Conversion Utility
Helps convert your Jupyter notebook model for production use
"""

import pickle
import joblib
import os

def save_model_for_production(model, scaler=None, feature_names=None, model_path="credit_model.pkl"):
    """
    Save your trained model in a format ready for production
    
    Args:
        model: Your trained ML model (sklearn, xgboost, etc.)
        scaler: Optional preprocessing scaler
        feature_names: List of feature names in order
        model_path: Where to save the model
    """
    try:
        model_data = {
            'model': model,
            'scaler': scaler,
            'features': feature_names or [],
            'model_type': type(model).__name__
        }
        
        with open(model_path, 'wb') as f:
            pickle.dump(model_data, f)
        
        print(f"Model saved successfully to {model_path}")
        print(f"Model type: {type(model).__name__}")
        if feature_names:
            print(f"Features: {feature_names}")
        
        return model_path
        
    except Exception as e:
        print(f"Error saving model: {e}")
        return None

def convert_notebook_to_model(notebook_model, notebook_scaler=None):
    """
    Example function showing how to convert your notebook model
    
    In your Jupyter notebook, run something like:
    
    ```python
    # After training your model in the notebook
    from model_converter import convert_notebook_to_model
    
    # Save your model
    model_path = convert_notebook_to_model(
        your_trained_model, 
        your_scaler_if_any
    )
    print(f"Model saved to: {model_path}")
    ```
    """
    
    # Example feature names - replace with your actual features
    feature_names = [
        'age', 'income', 'credit_score', 'debt_to_income', 
        'employment_years', 'loan_amount', 'loan_tenure',
        'existing_loans', 'credit_utilization', 'payment_history'
    ]
    
    return save_model_for_production(
        notebook_model, 
        notebook_scaler, 
        feature_names,
        "models/credit_model.pkl"
    )

# Usage examples for different model types
def example_usage():
    """
    Examples of how to use this converter with different models
    """
    
    # For scikit-learn models:
    """
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.preprocessing import StandardScaler
    
    # In your notebook after training:
    model_path = save_model_for_production(
        model=your_rf_model,
        scaler=your_standard_scaler,
        feature_names=['feature1', 'feature2', ...],
        model_path='models/rf_credit_model.pkl'
    )
    """
    
    # For XGBoost models:
    """
    import xgboost as xgb
    
    # Save XGBoost model
    your_xgb_model.save_model('models/xgb_credit_model.json')
    
    # Or use pickle for consistency
    model_path = save_model_for_production(
        model=your_xgb_model,
        model_path='models/xgb_credit_model.pkl'
    )
    """
    
    # For TensorFlow/Keras models:
    """
    # Save TensorFlow model
    your_tf_model.save('models/tf_credit_model')
    
    # Or save with additional metadata
    model_path = save_model_for_production(
        model=your_tf_model,
        scaler=your_scaler,
        model_path='models/tf_credit_model.pkl'
    )
    """

if __name__ == "__main__":
    print("Model Converter Utility")
    print("Use this script to convert your Jupyter notebook models for production")
    print("See example_usage() for different model types")