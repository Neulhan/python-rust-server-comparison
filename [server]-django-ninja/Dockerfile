FROM python:3.11
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
CMD ["uvicorn", "src.asgi:application", "--host", "0.0.0.0", "--port", "80"]
