FROM python:3.9-alpine

WORKDIR /usr/src/app

USER root

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src src

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--workers", "2", "--host", "0.0.0.0", "--port", "8080"]