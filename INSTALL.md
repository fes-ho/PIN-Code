# Installation Steps

1. Make sure to have Python >3.10

2. Install poetry

```sh
# If python executable is python
python3 -m pip install poetry

# If python3 executable is python
python -m pip install poetry
```

3. Activate virtual-envs in project

```sh
# python3 executable
python3 -m poetry config virtualenvs.in-project true

# python executable
python -m poetry config virtualenvs.in-project true
```

4. Install poetry dependencies

```sh
# Enter api directory (might vary depending on your current working directory)
cd api

# Install poetry dependencies
python3 -m poetry install

# (In case executable is named python)
python -m poetry install
```

4. (If using VSCode) Select interpreter

   - Interpreter is located inside 

     - Linux: _api/.venv/bin/python_
     - Windows: _api/.venv/Scripts/python.exe_
