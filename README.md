# 🤖 GenAIOps – AI API Gateway

**GenAIOps** is a FastAPI-powered gateway that allows you to interact with multiple advanced language models from a single interface.

---

## 🚀 Features

- ✅ **OpenAI GPT-4o**: Access the latest OpenAI model with web search capabilities.
- ✅ **Meta LLaMA 4** (via OpenRouter): Randomly selects between two free variants for your request.
- ✅ **DeepSeek R1 Zero** (via OpenRouter): Leverage the powerful open model by DeepSeek.

---

## 🔌 Endpoints

### 📘 `/generate-openai/`
Send a prompt to OpenAI’s `gpt-4o` with optional web search enabled.

### 🦙 `/generate-meta/`
Interact with **Meta’s LLaMA 4** models, randomly selecting between:
- `llama-4-scout`
- `llama-4-maverick`

### 🔬 `/generate-deepseek/`
Submit prompts to **DeepSeek R1 Zero**, an open-access model from DeepSeek.

All endpoints accept a simple POST request with:
```json
{
  "prompt": "Your question or task here"
}
