# ------------ Stage 1: Builder ------------
    FROM python:3.13.0a6-alpine AS builder

    ENV PYTHONDONTWRITEBYTECODE=1
    ENV PYTHONUNBUFFERED=1
    
    WORKDIR /app
    
    # Install build dependencies
    RUN apk add --no-cache \
        build-base \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python3-dev \
        postgresql-dev \
        curl
    
    # Copy requirements and build wheels
    COPY requirements.txt .
    RUN pip install --upgrade pip \
     && pip wheel --no-cache-dir --wheel-dir=/wheels -r requirements.txt
    
    # ------------ Stage 2: Final Minimal Image ------------
    FROM python:3.13.0a6-alpine
    
    ENV PYTHONDONTWRITEBYTECODE=1
    ENV PYTHONUNBUFFERED=1
    
    WORKDIR /app
    
    # Install only runtime dependencies
    RUN apk add --no-cache \
        libffi \
        musl \
        openssl \
        postgresql-libs \
        curl
    
    # Copy prebuilt wheels from builder
    COPY --from=builder /wheels /wheels
    RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*
    
    # Copy app source code
    COPY . .
    
    EXPOSE 8000
    
    CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
    