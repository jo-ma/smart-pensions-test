# BUILDER
# install dependencies in builder stage
FROM python:3.8.1-slim-buster AS builder

# working directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc

# lint
RUN pip install --upgrade pip
RUN pip install flake8
COPY . /app/
RUN flake8 --ignore=E501,F401 .

# install python dependencies
COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


# FINAL
FROM python:3.8.1-slim-buster


ENV APP_HOME = /app
WORKDIR $APP_HOME

# install dependencies
RUN apt-get update 
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*

COPY ./src .

EXPOSE 8080

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]