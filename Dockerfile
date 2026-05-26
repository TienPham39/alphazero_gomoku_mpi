FROM python:3.6-slim-buster

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    MPLBACKEND=Agg

WORKDIR /workspace

# Debian buster is archived; rewrite apt sources to archive endpoints.
RUN printf "deb http://archive.debian.org/debian buster main\n\
deb http://archive.debian.org/debian-security buster/updates main\n" > /etc/apt/sources.list

# OpenMPI is required for mpi4py and mpiexec-based scripts.
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libopenmpi-dev \
    openmpi-bin \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxrandr2 \
    libxi6 \
    libxcursor1 \
    libxinerama1 \
    libxss1 \
    libxxf86vm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-docker.txt /tmp/requirements-docker.txt
RUN python -m pip install --upgrade "pip<22" "setuptools<60" "wheel<0.38" && \
    python -m pip install -r /tmp/requirements-docker.txt

COPY . /workspace

CMD ["python", "train.py"]
