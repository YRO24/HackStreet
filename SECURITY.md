Security Configuration Guide

This document outlines the security configuration for GENFI.

Environment Variables

The application uses environment variables for sensitive configuration. These are managed through a .env file that should NEVER be committed to version control.

Backend Setup

1. Create a .env file in the backend directory:
   cp backend/.env.example backend/.env

2. Update the values in backend/.env with your actual keys:
   - GEMINI_API_KEY: Your Google Generative AI API key
   - HF_TOKEN: Your Hugging Face API token (if applicable)
   - DATABASE_URL: Your database connection string
   - JWT_SECRET: Your JWT signing secret (minimum 32 characters in production)

3. Install python-dotenv:
   pip install python-dotenv

4. The config.py module will automatically load these variables.

Sensitive Information Locations

The following should NEVER be committed to version control:

1. API Keys:
   - Google Generative AI keys
   - Hugging Face tokens
   - Database credentials

2. Authentication:
   - JWT secrets
   - User credentials
   - Session tokens

3. Configuration:
   - Database URLs
   - Private endpoints
   - Feature flags for unpublished features

Gitignore Configuration

The .gitignore file has been updated to exclude:
- All .env files
- .env.local files
- Environment-specific .env files

This prevents accidental commits of sensitive data.

Configuration Module

The backend/config.py module provides centralized configuration management:

from config import config

# Access configuration
api_key = config.GEMINI_API_KEY
environment = config.ENVIRONMENT

Validation

The config module includes validation:
- Checks for required environment variables
- Validates production configuration
- Raises errors for missing critical keys

This prevents the application from running with incomplete configuration.

Flutter Configuration

API endpoints and non-sensitive configuration are stored in:
lib/core/config/api_config.dart

This file is safe to commit as it contains no sensitive information.

Best Practices

1. Never hardcode API keys or secrets in source code
2. Use .env files for local development
3. Use environment variables in production
4. Rotate secrets regularly
5. Use strong JWT secrets (minimum 32 characters)
6. Restrict API key permissions to minimum required scope
7. Monitor API key usage for unusual activity

Environment-Specific Configuration

Development:
- Use .env file with development keys
- ENVIRONMENT=development
- LOG_LEVEL=DEBUG

Production:
- Set environment variables through deployment platform
- ENVIRONMENT=production
- LOG_LEVEL=ERROR
- JWT_SECRET must be strong and unique

Example .env file (with placeholder values):

GEMINI_API_KEY=AIzaSyBLRan3LNd2mSRLCDEPW_Gmac0YX4UrH2M
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
DATABASE_URL=postgresql://user:password@localhost/genfi
JWT_SECRET=your_very_long_secret_key_at_least_32_characters_long
ENVIRONMENT=development
API_HOST=0.0.0.0
API_PORT=8000
LOG_LEVEL=INFO

For more information, see backend/.env.example
