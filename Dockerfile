FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

ENV DEVICE=Arc

EXPOSE 11434
ENV OLLAMA_HOST=0.0.0.0
ENV ZES_ENABLE_SYSMAN=1
ENV OLLAMA_NUM_GPU=999

RUN source ipex-llm-init --gpu --device $DEVICE \
    mkdir -p /llm/ollama; \
    cd /llm/ollama; \
    init-ollama;

WORKDIR /llm/ollama

ENTRYPOINT ["./ollama", "serve"]
