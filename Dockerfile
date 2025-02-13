FROM intel/oneapi-basekit:2025.0.1-0-devel-ubuntu24.04

ENV TZ=Asia/Shanghai
ARG PIP_NO_CACHE_DIR=false

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get install -y --no-install-recommends python3.11 python3-pip && \
    # Install pip and IPEX
    wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3 get-pip.py && rm get-pip.py && \
    pip install --pre --upgrade ipex-llm[cpp] && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN mkdir -p /llm/ollama && \
    cd /llm/ollama && \
    init-ollama

# Set environment variables
ENV OLLAMA_NUM_GPU=999 \
    no_proxy=localhost,127.0.0.1 \
    ZES_ENABLE_SYSMAN=1 \
    SYCL_CACHE_PERSISTENT=1 \
    SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1 \
    OLLAMA_HOST=0.0.0.0

# Source Intel oneAPI environment variables
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/intel/oneapi/setvars.sh" >> ~/.bashrc

EXPOSE 11434
WORKDIR /llm/ollama
ENTRYPOINT ["./ollama", "serve"]
