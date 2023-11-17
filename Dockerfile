FROM python:latest

WORKDIR /app

ENV PORT=8080

COPY . .

RUN pip install -r "requirements.txt"

EXPOSE ${PORT}

ENTRYPOINT ["python", "lbg.py"]
