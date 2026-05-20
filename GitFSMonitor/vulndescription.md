### Vulnerability description

**About the Exploit**
Code Editors (VS Code, Emacs) and Git-aware shell prompts automatically execute Git commands when a user opens a project folder. By poisoning `.git/config` with a `core.fsmonitor` setting that points to an attacker-controlled script, opening a downloaded repo triggers arbitrary code execution with zero user interaction.

**How is it exploited**
`core.fsmonitor` tells Git to use an external program to track file system changes. Any Git command that checks file status (e.g., `git status`, `git rev-parse`) invokes this program. When an IDE opens a folder, it runs these Git commands in the background to populate its UI. The payload fires instantly.

**The Attack Steps**
1. An attacker creates a git repo with `core.fsmonitor` set to `.git/hooks/fsmonitor-watchman`.
2. The hook script contains arbitrary bash/python commands.
3. The attacker distributes the repo as a `.zip` or `.tar.gz` (since `git clone` strips dangerous configs).
4. The victim unzips the archive and opens the folder in VS Code or Emacs.
5. The editor's Git integration triggers `git status` → the hook runs → code executes.

**Under the hood (Brief)**
- VS Code's built-in Git extension continuously polls the repository.
- Emacs triggers `vc-refresh-state` upon opening a file.

**Impact**
* Code runs completely hidden from the user - no terminal output, no prompts.
* Works across macOS, Linux, and Windows (`.bat` payloads).
* Multiple config keys can be abused: `core.fsmonitor`, `core.pager`, `core.editor`, `core.sshCommand`.

***

**Steps to reproduce:**
1. Run `setup_poc.sh` script
2. Run `git status` or open the folder in VS Code / Emacs / Any IDE.
3. Check `execution/executed.txt` - the payload has run.
4. Boom! you hacked! ;)
5. Follow Project X3r0Day for more Abuse tricks!