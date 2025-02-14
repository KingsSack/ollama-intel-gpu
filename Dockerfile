FROM intel/oneapi-basekit:2025.0.2-0-devel-ubuntu22.04

ENV TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1 \
    SYCL_CACHE_PERSISTENT=1
ARG PIP_NO_CACHE_DIR=false

# Install dependencies
RUN apt-get update && \
    # Set timezone
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    # Python for installing ipex-llm
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3-pip \
        python3.11-dev \
        python3.11-distutils \
        python3-wheel && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.11 /usr/bin/python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    # Install pip using get-pip.py
    wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    # Install ipex-llm
    pip install --pre --upgrade ipex-llm[cpp]

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV DEVICE=Arc \
    OLLAMA_NUM_GPU=999 \
    no_proxy=localhost,127.0.0.1 \
    ZES_ENABLE_SYSMAN=1 \
    SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1 \
    OLLAMA_HOST=0.0.0.0

EXPOSE 11434
WORKDIR /llm/ollama
ENTRYPOINT ["/bin/bash", "-c", "source ipex-llm-init --gpu --device $DEVICE && mkdir -p /llm/ollama && cd /llm/ollama && ollama-init && source /opt/intel/oneapi/setvars.sh && ./ollama serve"]
