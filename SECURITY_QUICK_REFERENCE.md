Quick Security Reference

Setup Checklist

1. Install Dependencies:
   cd backend
   pip install python-dotenv

2. Configure Environment:
   cp backend/.env.example backend/.env
   Edit backend/.env and add your actual values

3. Verify Setup:
   python -c "from config import config; config.validate()"

4. Run Application:
   python main.py

Files You Need to Update

backend/.env
- Add your actual GEMINI_API_KEY
- Add your HF_TOKEN (if using Hugging Face models)
- Add your DATABASE_URL (if using external database)
- Generate and set JWT_SECRET

Do NOT Commit

.env (any variation)
.env.local
__pycache__
*.pyc
.Python
build/
dist/

API Keys Status

GEMINI_API_KEY: In backend/.env (protected)
HF_TOKEN: In backend/.env (protected)
DATABASE_URL: In backend/.env (protected)
JWT_SECRET: In backend/.env (protected)

All API keys and secrets now use environment variables instead of hardcoding.

File Changes Summary

New Files:
- backend/.env
- backend/.env.example
- backend/config.py
- lib/core/config/api_config.dart
- SECURITY.md
- backend/SECURITY_SETUP.md
- SECURITY_AUDIT_REPORT.md

Updated Files:
- backend/main.py (now uses config module)
- backend/routers/insurance_agent.py (loads API key from env)
- backend/requirements.txt (added python-dotenv)
- .gitignore (excludes .env files)

For Development

1. Copy .env.example to .env:
   cp backend/.env.example backend/.env

2. Edit .env with your development API keys

3. Run with: python main.py

For Production

1. Set environment variables through your deployment platform:
   - AWS: Secrets Manager or Parameter Store
   - Google Cloud: Secret Manager
   - Azure: Key Vault
   - Heroku: Config Vars
   - Docker: Environment variables in deployment

2. Set ENVIRONMENT=production in your platform

3. Use strong JWT_SECRET (minimum 32 random characters)

4. Set LOG_LEVEL=ERROR

Configuration is validated on startup, so missing critical variables will cause immediate error and prevent application from running.

All sensitive data is now secure and properly managed through environment variables.
