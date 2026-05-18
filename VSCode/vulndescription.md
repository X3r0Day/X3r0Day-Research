### Vulnerability description

**Overview**
The VS Code Python extension is vulnerable to zero-click Remote Code Execution (RCE). If a user opens a project folder that contains a pre-built Python virtual environment (`.venv`), the extension automatically runs the Python binary in the background to check the environment for Pylance and interpreter settings. If an attacker hides a modified `.pth` file inside that `.venv`, the code inside it will run automatically. 

The user does not have to open a terminal, run a script, or click any prompts. Simply opening the folder in VS Code triggers the exploit.

**How it works**
When a Python interpreter starts, it runs a built-in file called `site.py`. This file checks the `site-packages` folder for any files ending in `.pth`. If it finds a line in a `.pth` file that starts with "import ", it executes that entire line as Python code. This happens immediately on startup.

**The Attack Steps**
1. An attacker creates a normal looking Python project but decides to commit the `.venv` folder to git instead of ignoring it.
2. Inside `.venv/lib/python3.14/site-packages/`, they drop a text file named `easy-install.pth`.
3. Inside that file, they write a one-line payload that starts with "import " (for example: `import os; open("/tmp/pwned","w").write("pwned")`).
4. They publish the project to GitHub.
5. The victim downloads the project and opens the folder in VS Code.

**Why VS Code triggers it**
When the folder opens, the Python extension sees the `.venv` and tries to set up the workspace. To do this, it runs commands like `.venv/bin/python3 -c "import sys..."` in the background. Because the extension invokes the Python binary, Python processes the malicious `.pth` file and runs the attacker's code. 

Pylance and test discovery tools also trigger this same process. The payload will fire several times before the user even looks at a file.

**Impact**
* The code runs completely hidden from the user.
* Supply chain security tools that scan `pip install` commands will miss this because the virtual environment is already built and downloaded with the repo.
* Antivirus tools ignore it because the `.pth` file is just plain text.

***

*(For the "Steps to reproduce" box on the form, use this simple list):*

`**Steps to reproduce:**
1. Run the provided `setup_poc.sh` script. This will create a folder called `malicious-repo` with a `.venv` inside it.
2. The script adds a file at `.venv/lib/python3.14/site-packages/easy-install.pth` containing a simple Python command to create a text file in your `/tmp/` folder.
3. Open VS Code.
4. Go to File > Open Folder and select the `malicious-repo` folder.
5. Wait a few seconds
6. Check your `/tmp/` directory. You will see `/tmp/vscode_rce_poc.txt` has been created. The code ran without opening a terminal or running any project files.`