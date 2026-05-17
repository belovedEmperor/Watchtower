FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY scheduler/requirements.txt ./scheduler/requirements.txt
RUN pip install --no-cache-dir -r scheduler/requirements.txt

COPY scheduler ./scheduler

EXPOSE 8000

CMD ["uvicorn", "api:app", "--app-dir", "scheduler", "--host", "0.0.0.0", "--port", "8000"]
