FROM intel/oneapi-basekit:2024.2.1-0-devel-ubuntu22.04

# Install dependencies
RUN apt update && \
    apt upgrade && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.11 -y && \
    apt install python3.11-venv -y && \
    python3.11 -m venv llm_env && \
    source llm_env/bin/activate && \
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
