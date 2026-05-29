# PIN-Code

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)
![Flutter](https://img.shields.io/badge/Flutter-Dart-blue?logo=flutter)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![License](https://img.shields.io/github/license/fes-ho/PIN-Code)

A full-stack mobile application that consists of a **Flutter** mobile frontend and a **Python** REST API backend, containerised with Docker.

---

## Table of Contents

- [About](#about)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Backend (API)](#backend-api)
  - [Frontend](#frontend)
  - [Docker (full stack)](#docker-full-stack)
- [Running the App](#running-the-app)
- [Contributing](#contributing)
- [License](#license)

---

## About

It is structured as a monorepo with two main components:

- **`api/`** — A Python REST API (managed with [Poetry](https://python-poetry.org/)) that serves as the application backend, including a `/health` endpoint for container health checks.
- **`frontend/`** — A cross-platform Flutter application targeting iOS, Android (and optionally desktop/web) that consumes the API.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile Frontend | [Flutter](https://flutter.dev/) / Dart |
| Backend API | Python 3.10+, [Poetry](https://python-poetry.org/) |
| Containerisation | Docker, Docker Compose |
| Code Quality | [Codacy](https://www.codacy.com/) |

---

## Project Structure

```
PIN-Code/
├── api/                  # Python REST API
│   └── ...               # Routes, models, business logic
├── frontend/             # Flutter mobile application
│   └── ...               # Screens, widgets, services
├── docker-compose.yml    # Orchestrates api + autoheal services
├── INSTALL.md            # Detailed installation steps
└── README.md
```

---

## Prerequisites

- **Python ≥ 3.10** — [Download](https://www.python.org/downloads/)
- **Poetry** — Python dependency manager ([Install guide](https://python-poetry.org/docs/#installation))
- **Flutter SDK** — [Install guide](https://docs.flutter.dev/get-started/install)
- **Docker & Docker Compose** *(optional, for containerised deployment)*

---

## Installation

### Backend (API)

1. **Install Poetry:**

   ```bash
   # If your Python executable is python3
   python3 -m pip install poetry

   # If your Python executable is python
   python -m pip install poetry
   ```

2. **Enable in-project virtual environments:**

   ```bash
   python3 -m poetry config virtualenvs.in-project true
   ```

3. **Install dependencies:**

   ```bash
   cd api
   python3 -m poetry install
   ```

4. **(VSCode users) Select the interpreter:**
   - Linux: `api/.venv/bin/python`
   - Windows: `api/.venv/Scripts/python.exe`

---

### Frontend

```bash
cd frontend
flutter pub get
```

---

### Docker (full stack)

Spin up the API (with auto-heal) using Docker Compose:

```bash
docker compose up --build
```

The API will be available at `http://localhost:8000`.  
A health check is automatically performed at `http://localhost:8000/health` every 15 seconds.

---

## Running the App

**Backend only:**

```bash
cd api
python3 -m poetry run uvicorn main:app --reload
# or whichever entrypoint is configured in pyproject.toml
```

**Flutter frontend:**

```bash
cd frontend
flutter run
```

Make sure the API is running and that the base URL in the Flutter app points to your machine's address (e.g. `http://10.0.2.2:8000` for the Android emulator, or `http://localhost:8000` for a physical device on the same network / desktop).

---

## Contributing

Contributions, issues, and feature requests are welcome. Please open an issue first to discuss what you would like to change, then submit a pull request against `main`.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

---

## License

Distributed under the **Apache 2.0 License**. See [`LICENSE`](LICENSE) for details.
