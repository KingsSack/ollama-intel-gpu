FROM intel/oneapi-basekit:2025.0.1-0-devel-ubuntu24.04

ENV TZ=Asia/Shanghai
ARG PIP_NO_CACHE_DIR=false

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        software-properties-common \
        gpg-agent && \
    # Add deadsnakes PPA for Python 3.11
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-distutils \
        python3.11-venv && \
    # Configure Python
    rm -f /usr/bin/python3 && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    # Install pip using get-pip.py
    wget -q https://bootstrap.pypa.io/get-pip.py && \
    python3.11 get-pip.py --break-system-packages && \
    rm get-pip.py && \
    # Install IPEX
    pip install --pre --upgrade ipex-llm[cpp]

# Download and install Ollama
RUN mkdir -p /llm/ollama && \
    cd /llm/ollama && \
    ollama-init

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
ENTRYPOINT ["/bin/bash", "-c", "source /opt/intel/oneapi/setvars.sh && ./ollama serve"]
