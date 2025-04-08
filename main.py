from fastapi import FastAPI, HTTPException
from openai import OpenAI
import random
import os
from dotenv import load_dotenv

load_dotenv()

openai_api_key = os.getenv("OPENAI_API_KEY")
openrouter_api_key = os.getenv("OPENROUTER_API_KEY")

META_LATEST_MODEL=[
    "meta-llama/llama-4-scout:free",
    "meta-llama/llama-4-maverick:free"
]

# Randomly select a model
selected_meta_model = random.choice(META_LATEST_MODEL)

client_openai = OpenAI(api_key=openai_api_key)
client_llama4 = OpenAI(base_url="https://openrouter.ai/api/v1",
                    api_key=openrouter_api_key)

app = FastAPI(
    title="GenAIOps - AI API Gateway",
    description="""
🚀 **GenAIOps** is a unified FastAPI-powered gateway for interacting with multiple AI models, including:

- ✅ OpenAI GPT-4o
- ✅ Meta's LLaMA 4 (via OpenRouter)
- ✅ DeepSeek R1 Zero (via OpenRouter)

Use `/generate-openai/`, `/generate-meta/`, or `/generate-deepseek/` to interact with your desired model.
""",
    version="1.0.0"
)

@app.post("/generate-openai/")
async def generate(prompt: str):
    try:
        response = client_openai.responses.create(
        model="gpt-4o",
        tools=[{"type": "web_search_preview"}],
        input=prompt
        )

        return response.output_text

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.post("/generate-meta/")
async def generate(prompt: str):
    try:
        completion = client_llama4.chat.completions.create(
        model=selected_meta_model,
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ]
        )
        return completion.choices[0].message.content

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate-deepseek/")
async def generate(prompt: str):
    try:
        completion = client_llama4.chat.completions.create(
        model="deepseek/deepseek-r1-zero:free",
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ]
        )
        return completion.choices[0].message.content

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
