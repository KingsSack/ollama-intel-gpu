FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

# Set environment variables
ENV DEVICE=Arc \
    OLLAMA_NUM_GPU=999 \
    no_proxy=localhost,127.0.0.1 \
    ZES_ENABLE_SYSMAN=1 \
    SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1 \
    ONEAPI_DEVICE_SELECTOR=level_zero:0 \
    OLLAMA_HOST=0.0.0.0

EXPOSE 11434

WORKDIR /llm/ollama

ENTRYPOINT ["/bin/bash", "-c", "cd /llm/scripts/ && source ipex-llm-init --gpu --device $DEVICE && bash start-ollama.sh && tail -f /llm/ollama/ollama.log"]
