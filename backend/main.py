from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config import config
from routers import credit_agent, planner_agent, explain_agent, insurance_agent

# Validate configuration on startup
config.validate()

app = FastAPI(title="GenFi Credit & Insurance Agent API")

# Add CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(credit_agent.router)
app.include_router(planner_agent.router)
app.include_router(explain_agent.router)
app.include_router(insurance_agent.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to GenFi Credit Agent API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=config.API_HOST, port=config.API_PORT)
