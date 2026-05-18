Two PoCs showing how hidden config and project files can trigger code execution when you open a project in VS Code or your terminal.

### 1. .pth file in a committed .venv

VS Code's Python extension checks your virtual environment when you open a project folder. Python runs .pth files in site-packages/ on startup. If someone commits a .venv with a malicious .pth file, VS Code triggers it automatically.

```bash
cd VSCode
bash setup_poc.sh
code .
```

Check /tmp/pwned. If it exists, the code ran.

### 2. Git core.fsmonitor config poisoning

Git's core.fsmonitor setting lets you point to a custom script for file watching. If someone sends you a zipped repo with this set, any Git command runs the script. VS Code runs git status in the background. Emacs runs vc-refresh-state. Shell prompts with git info do the same.

This does not work over git clone. Git strips it. Someone has to send you a zip or tarball.

```bash
cd GitFSMonitor
bash setup_poc.sh
git status
cat execution/executed.txt
```

### Notes

Both PoCs abuse the same thing: tools run commands in the background, and payloads hide in config files or environments those tools trust. Neither is a bug in git or VS Code. They are doing what they were built to do.

Each folder has a setup_poc.sh that creates the environment. Generated files like .git/ and .venv/ are not tracked in this repo. Run the script, test the PoC, delete the generated folders when you are done.
