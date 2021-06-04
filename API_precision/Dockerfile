FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

WORKDIR /API_precision
COPY . .
RUN pip install -r requirements.txt
RUN apt-get update 
RUN apt-get install ffmpeg libsm6 libxext6  -y
#ENV PORT 8000
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "127.0.0.1", "--port", "8080"]



