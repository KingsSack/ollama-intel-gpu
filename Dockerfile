FROM intel/oneapi-basekit:2025.0.1-0-devel-ubuntu24.04

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.11 -y && \
    apt install python3.11-venv -y && \
    pip install --pre --upgrade ipex-llm[cpp] && \
    mkdir -p /llm/ollama && \
    cd /llm/ollama && \
    init-ollama

ENV OLLAMA_NUM_GPU=999
ENV no_proxy=localhost,127.0.0.1
ENV ZES_ENABLE_SYSMAN=1

RUN source /opt/intel/oneapi/setvars.sh

ENV SYCL_CACHE_PERSISTENT=1
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1

EXPOSE 11434

ENV OLLAMA_HOST=0.0.0.0

WORKDIR /llm/ollama

ENTRYPOINT ["./ollama", "serve"]
