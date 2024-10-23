# Use an official Python runtime as a parent image
FROM python:3.12-alpine

# Set environment variables for Poetry
ENV POETRY_VERSION=1.8.1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1 \
    POETRY_HOME="/opt/poetry"

# Install system dependencies
RUN apk add --no-cache gcc musl-dev python3-dev libffi-dev openssl-dev cargo curl bash

# Install Poetry globally
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    chmod +x $POETRY_HOME/bin/poetry

# Add Poetry to PATH
ENV PATH="$POETRY_HOME/bin:$PATH"

# Set the working directory inside the container
WORKDIR /app

ENV PYTHONPATH=/app/api/src

# Copy the poetry files
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN poetry install --no-root

# Copy the application code
COPY src ./api/src

# Expose the FastAPI port
EXPOSE 8000

# Command to run the FastAPI app using Uvicorn
CMD ["uvicorn", "api.src.main:app", "--host", "0.0.0.0", "--port", "8000"]
