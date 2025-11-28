from fastapi import FastAPI
from routers import credit_agent, planner_agent, explain_agent

app = FastAPI(title="GenFi Credit Agent API")

app.include_router(credit_agent.router)
app.include_router(planner_agent.router)
app.include_router(explain_agent.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to GenFi Credit Agent API"}
