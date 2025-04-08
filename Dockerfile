# ------------ Stage 1: Build ------------
    FROM python:3.13.0a6-alpine AS builder

    # Set environment variables
    ENV PYTHONDONTWRITEBYTECODE=1
    ENV PYTHONUNBUFFERED=1
    
    # Set working directory
    WORKDIR /app
    
    # Install system dependencies for building
    RUN apk update && apk add --no-cache \
        build-base \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python3-dev \
        postgresql-dev \
        libpq \
        curl
    
    # Install pip and dependencies
    COPY requirements.txt .
    RUN pip install --upgrade pip && \
        pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt
    
    # ------------ Stage 2: Final ------------
    FROM python:3.13.0a6-alpine
    
    WORKDIR /app
    
    # Copy only runtime dependencies from the builder
    COPY --from=builder /wheels /wheels
    COPY --from=builder /usr/lib/python3.13/site-packages /usr/lib/python3.13/site-packages
    COPY --from=builder /usr/local/bin /usr/local/bin
    
    # Install runtime dependencies
    RUN apk add --no-cache \
        libffi \
        musl \
        openssl \
        postgresql-libs && \
        pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*
    
    # Copy your app
    COPY . .
    
    # Expose FastAPI port
    EXPOSE 8000
    
    # Run the app
    CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
    