#!/bin/bash

set -e

# =========================
# Python Project Structure Generator
# =========================

show_help() {
    cat << EOF
Uso:
  $0 <nome_do_projeto> [estrutura] [opções]

Estruturas (flags obrigatórias, escolha uma):
  --src        Estrutura profissional com src/
  --simple     Estrutura simples
  --domain     Estrutura orientada a domínio
  --data       Estrutura para Data Science

Opções:
  --gitignore  Cria .gitignore padrão Python
  --toml       Gera pyproject.toml básico
  -h, --help   Exibe esta ajuda

Exemplos:
  ./pystruct.sh MeuProjeto --src --gitignore --toml
  ./pystruct.sh ProjetoDS --data --gitignore
EOF
}

create_gitignore() {
cat << 'EOF' > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
dist/
.eggs/
*.egg-info/
.installed.cfg
wheels/

# Virtual environments
.env
.venv
env/
venv/
ENV/

# Unit test / coverage
.coverage
.coverage.*
.pytest_cache/
htmlcov/

# Jupyter
.ipynb_checkpoints/

# mypy / ruff
.mypy_cache/
.ruff_cache/

# IDEs
.idea/
.vscode/

# OS
.DS_Store
EOF
}

create_pyproject() {
cat << EOF > pyproject.toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = ""
authors = [{ name = "$USER" }]
readme = "README.md"
requires-python = ">=3.10"
dependencies = []
EOF
}

ask_venv() {
    read -p "Deseja criar um ambiente virtual (venv)? [y/N]: " CREATE_VENV
    if [[ "$CREATE_VENV" =~ ^[Yy]$ ]]; then
        python3 -m venv .venv
        echo "Ambiente virtual criado em .venv/"
    fi
}

# ---------- PARSING ----------

if [[ $# -lt 2 ]]; then
    show_help
    exit 1
fi

PROJECT_NAME="$1"
shift

STRUCTURE=""
CREATE_GITIGNORE=false
CREATE_TOML=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --src|--simple|--domain|--data)
            STRUCTURE="$1"
            ;;
        --gitignore)
            CREATE_GITIGNORE=true
            ;;
        --toml)
            CREATE_TOML=true
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Opção inválida: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

if [[ -z "$STRUCTURE" ]]; then
    echo "Erro: você deve escolher uma estrutura."
    show_help
    exit 1
fi

mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# ---------- ESTRUTURAS ----------

case "$STRUCTURE" in

--src)
    mkdir -p src/"$PROJECT_NAME"/{services,models,utils}
    mkdir -p tests
    touch src/"$PROJECT_NAME"/__init__.py
    touch src/"$PROJECT_NAME"/__main__.py
    touch README.md requirements.txt
    ;;

--simple)
    touch main.py utils.py README.md
    ;;

--domain)
    mkdir -p src/"$PROJECT_NAME"/{domain,application,infrastructure,interface}
    touch src/"$PROJECT_NAME"/domain/{entities.py,value_objects.py,rules.py}
    touch src/"$PROJECT_NAME"/application/{use_cases.py,services.py}
    touch src/"$PROJECT_NAME"/infrastructure/{database.py,api_client.py}
    touch src/"$PROJECT_NAME"/interface/{cli.py,gui.py}
    touch README.md requirements.txt
    ;;

--data)
    mkdir -p data/{raw,processed,external}
    mkdir -p notebooks outputs/figures src
    touch notebooks/exploration.ipynb
    touch src/{preprocessing.py,features.py,models.py}
    touch requirements.txt README.md
    ;;

esac

# ---------- OPCIONAIS ----------

if [ "$CREATE_GITIGNORE" = true ]; then
    create_gitignore
fi

if [ "$CREATE_TOML" = true ]; then
    create_pyproject
fi

ask_venv

echo "Projeto '$PROJECT_NAME' criado com sucesso."

