# GENFI - Modern Financial Assistant

A comprehensive AI-powered financial platform that combines credit analysis, insurance advisory, and intelligent financial planning in one unified application.

## Overview

GENFI is a Flutter-based mobile application with a FastAPI backend that provides users with personalized financial insights, credit scoring, insurance recommendations, and AI-powered financial advisory services. The platform leverages machine learning models and Google's Gemini AI to deliver intelligent, contextual financial guidance.

## Core Features

### Credit Analysis System
- Real-time credit score prediction using trained ML models
- Personalized credit recommendations based on financial profile
- Risk assessment with detailed explanations
- Credit improvement suggestions and actionable insights
- Integration with GenFi Credit Agent system

### Insurance Advisory
- AI-powered insurance chatbot using Google Gemini AI
- Personalized insurance recommendations based on user profile
- Coverage gap analysis and policy suggestions
- Support for health, life, vehicle, home, and travel insurance
- Account Aggregator data integration for enhanced recommendations

### Financial Dashboard
- Multi-category dashboard (General, Insurance, Investment, Credit)
- Real-time financial metrics and KPI tracking
- Gamification system with user levels and achievements
- Transaction history and expense tracking
- Interactive charts and financial visualizations

### AI-Powered Chat System
- Natural language processing for financial queries
- Context-aware responses based on user's financial profile
- Conversation history maintenance
- Multi-domain expertise covering credit, insurance, and general finance

## Technical Architecture

### Frontend (Flutter)
- Cross-platform mobile application
- Material Design 3 with custom theming
- Animated UI components using animate_do package
- Responsive design with adaptive layouts
- State management with built-in Flutter state management

### Backend (FastAPI)
- RESTful API architecture with automatic OpenAPI documentation
- Multiple specialized routers for different financial domains
- Machine learning model integration with pickle/joblib support
- Google Generative AI integration for conversational interfaces
- CORS-enabled for web deployment

### Machine Learning Integration
- Support for scikit-learn, XGBoost, LightGBM models
- Custom GenFi Credit Agent system integration
- Real-time model inference with fallback mechanisms
- Feature engineering and data preprocessing pipelines

## API Endpoints

### Credit Analysis
- `POST /api/credit/genfi-analyze` - Comprehensive credit analysis
- `POST /api/credit/predict` - ML-powered credit prediction
- `POST /api/credit/chat-analysis` - Conversational credit insights
- `POST /api/credit/load-genfi-system` - Model deployment endpoint

### Insurance Services
- `POST /api/insurance/chat` - AI insurance advisory chat
- `GET /api/insurance/advice` - Personalized insurance recommendations
- `GET /api/insurance/user/{user_id}` - User insurance profile
- `POST /api/insurance/add-policy` - Policy management
- `GET /api/insurance/policies/types` - Available policy types

### Financial Planning
- `POST /api/planner/analyze` - Financial planning analysis
- `POST /api/explain/query` - Financial explanation service

## Installation and Setup

### Prerequisites
- Flutter SDK (3.0+)
- Python 3.8+
- FastAPI and dependencies
- Google Generative AI API key

### Frontend Setup
```bash
cd flutter_app
flutter pub get
flutter run
```

### Backend Setup
```bash
cd backend
pip install -r requirements.txt
python main.py
```

### Environment Configuration
Configure API keys and model paths in the backend configuration files.

## Data Models

### User Profile
- Personal information (age, income, dependents)
- Financial metrics (debt, credit utilization, employment)
- Insurance portfolio and existing policies
- Transaction history and spending patterns

### Credit Analysis
- Credit score prediction with confidence intervals
- Risk categorization (Low, Medium, High)
- Factor analysis and improvement recommendations
- Historical credit performance tracking

### Insurance Recommendations
- Policy type prioritization based on user profile
- Coverage amount suggestions
- Premium optimization recommendations
- Provider comparison and selection

## Security and Privacy

- Bank-level security protocols
- Data encryption in transit and at rest
- User consent and data privacy compliance
- Secure API authentication and authorization
- No storage of sensitive financial credentials

## Development Status

Currently in active development with the following completed modules:
- Core credit analysis system with ML integration
- Insurance advisory with AI chatbot functionality
- Multi-dashboard financial interface
- API infrastructure with comprehensive endpoints
- Flutter mobile application with responsive design

## API Documentation

When the backend is running, comprehensive API documentation is available at:
- Interactive docs: `http://localhost:8000/docs`
- OpenAPI spec: `http://localhost:8000/openapi.json`

## Architecture Patterns

- Model-View-Controller (MVC) architecture
- Repository pattern for data access
- Service layer for business logic
- Dependency injection for modular components
- Observer pattern for state management

## Contributing

This project follows standard Flutter and Python development practices. Ensure all code is properly formatted and includes appropriate tests before submitting contributions.

## License

This project is part of the HackStreet repository and follows the associated licensing terms.
