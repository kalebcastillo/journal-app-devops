FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY api/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt 
COPY api ./api
COPY start.sh ./start.sh
RUN chmod +x ./start.sh
CMD ["./start.sh"]