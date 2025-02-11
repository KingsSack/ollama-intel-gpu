#!/bin/bash

mkdir -p /llm/ollama
cd /llm/ollama
init-ollama

./ollama serve > ollama.log
