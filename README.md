# Python Project Structure Generator (PPSG)

PPSG is a lightweight command-line tool for generating common Python project structures quickly and consistently.

This project was created while I was studying Bash, as a way to automate the creation of Python project layouts.
It may also help other developers standardize project structures and save time on repetitive setup tasks.

---

## Features

- Multiple project structure templates:
  - Simple
  - SRC-based (professional layout)
  - Domain-driven
  - Data science
- Optional generation of:
  - `.gitignore` (Python-focused)
  - `pyproject.toml`
- Optional virtual environment creation


---

## Requirements

- Bash
- Python 3.10+ (only required if creating virtual environments)

---

## Installation

### System-wide installation (recommended)

```bash
sudo install -m 755 ppsg.sh /usr/local/bin/ppsg
```

After that, the command will be available globally:

## Usage

```
ppsg <project_name> [structure] [options]
```

## Structures(choose one)
```
--simple   Simple project layout
--src      SRC-based professional layout
--domain   Domain-oriented layout
--data     Data science layout
```

## Options
```
--gitignore   Generate a Python .gitignore
--toml        Generate a basic pyproject.toml
-h, --help    Show help
```
