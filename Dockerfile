FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

ENV OLLAMA_HOST=0.0.0.0

ENV SYCL_CACHE_PERSISTENT=1
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
ENV ONEAPI_DEVICE_SELECTOR=level_zero:0

ENV OLLAMA_NUM_GPU=999
ENV ZES_ENABLE_SYSMAN=1

RUN source ipex-llm-init --gpu --device Arc; \
    mkdir -p /llm/ollama; \
    cd /llm/ollama; \
    init-ollama;

EXPOSE 11434

WORKDIR /llm/ollama

ENTRYPOINT ["./ollama", "serve"]
