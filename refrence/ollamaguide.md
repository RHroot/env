# Ollama Local Setup Guide

This guide covers the essential commands to pull, customize, and run models locally using Ollama.

---

## 1. Pull the Base Model

### To get started, download the **Llama 3 8B** model from the Ollama library.

```bash
ollama pull llama3:8b
```

## 2. Create a Custom Local Instance

### Create a named variation of the model. This is useful for maintaining a specific local configuration:

```bash
ollama create llama3-local -f <(echo "FROM llama3:8b")
```

## 3. Run the Model

### Launch an interactive session with your new local model instance:

```bash
ollama run llama3-local
```
