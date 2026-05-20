### Vulnerability description

**About the Exploit**
The VS Code Python extension is vulnerable to Remote Code Execution (RCE). If a user opens a project folder that contains a Python virtual env (`.venv`), the extension automatically runs the Python binary in the background to check the environment for Pylance and interpreter settings. If an attacker hides a modified `.pth` file inside that `.venv`, the code inside it will run automatically. 

The user does not have to open a terminal, run a script, or click any prompts (except trust this folder(which will be skipped if parent folder is already trusted)). Simply opening the folder in VS Code triggers the exploit.

**How is it exploited**
When a Python interpreter starts, it runs a built-in file called `site.py`. This file checks the `site-packages` folder for any files ending in `.pth`. If it finds a line in a `.pth` file that starts with "import ", it executes that entire line as Python code. This happens immediately on startup.

**The Attack Steps**
1. An attacker creates a normal looking Python project but decides to commit the `.venv` folder to git instead of ignoring it.
2. Inside `.venv/lib/python3.14/site-packages/`, they drop a text file named `easy-install.pth`.
3. Inside that file, they write a one-line payload that starts with "import " (for example: `import os; open("/home/cran/PoC/VSCode/src/hacked","w").write("You are hacked!")`).
4. They publish the project to GitHub.
5. The victim downloads the project and opens the folder in VS Code.

**Under the hood (Brief)**
When the folder opens, the Python extension sees the `.venv` and tries to set up the workspace. To do this, it runs commands like `.venv/bin/python3 -c "import sys..."` in the background. Because the extension invokes the Python binary, Python processes the malicious `.pth` file and runs the attacker's code. 

Pylance and test discovery tools also trigger this same process. The payload will fire several times before the user even looks at a file.

**Impact**
* The code runs completely hidden from the user.
* It's so sneaky because many don't even check .venv and just ignores it.

***

**Steps to reproduce:**
1. Run `setup_poc.sh` script
2. Go to newly created `malicious-repo`
3. Script creates a `.venv/lib/python3.14/site-packages/easy-install.pth` which have python code to create a text file in `/src/hacked/`
4. Open `malicious-repo` in VSCode
6. Check your `/src/` directory. You will see `/src/hacked/`
7. Boom! you hacked! ;)
8. Follow Project X3r0Day for more Abuse tricks!