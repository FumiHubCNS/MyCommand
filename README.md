# MyCommand

This repository is a collection of **custom commands (shell scripts etc)** designed to streamline everyday tasks.

Place the created scripts in `./script/` and generate a symbolic link in `/.bin` to manage the command name of executable.

To command these scripts, add the path to `./bin` to `~/.zshrc`, etc.


```zsh
ehco "export PATH=$PWD/bin:\$PATH" >> ~/.zshrc
```

## List of script

| command name | script file | bref description | 
| -- | -- | -- |
| new-pf | create_py_template.sh | generate file with description for doxygen |
| update-cdd | update_version.sh | update description of code for doxygen |
| monitor-fd | monitor_fd.sh | monitor to the number of file discriptor |
| dump-us | dump-uv-scripts.sh | dump uv scripts |

### Detail of commands

#### `new-pf (create python file with code desctiprion)`

This command generate Python file with description.

The first argument specifies the file path and name to be genrated.

The seccond argument specifies the author name. If you do not specifies name.
This command first attempts to retrieve the name using `git config --global user.name`, and if it cannot be retrieved, it uses username.

The thrid argument specifies description of @brief. The default description is "template text"

#### `update-cdd (update code description)`

This tool automatically updates metadata (`@version`, `@date`) embedded in Python script files.

When executing, you can specify the version update rules and whether to actually overwrite the file.

The first argument specifies the file path name.

The second argument specifies whether to overwrite the file. If `apply` is specified, the file is overwritten. If nothing is specified or there is a typo, the file is not overwritten, and the changes to be made are dumped.

The thrid argument specifies whether it is a major update or a minor update. If `minor` is specified, only minor updates are applied. For example, (1 -> 1.1).

```zsh
update-cdd [path] [overwrite flag] [version rule]

```

Example to be overwritten descriptions

```python
"""!
@file meson_theory.py
@version 1 
@author Hideeki YUKAWA
@date 1949-11-03T00:00:00+09:00 
@brief On the Interaction of Elementary Particles. I.
"""
```

#### `monitor-fd` (monitor file　descriptor)

Command to monitor the number and details of file descriptors currently in use

First argument: Maximum length of the command string to display (integer). If 0, do not display.

Second argument: Display only processes whose command names contain this string (optional)

When the script is terminated using `Ctrl+C`, it outputs "監視終了" and exits normally.


#### `dump-us` (dump uv scripts)

This command show the command list that can be used in `uv run`.
these commands is defined in `pyproject.toml` , and this command read this file.
you have to execute command in working directory of uv.


this command can search the commands added by [tool.uv.sources] using `curl`.
if you can use `curl` command, please use `--use-network`.
if you can not use it's command, this command search `.venv/bin/`.
(in this case, other excecutabls are also dumped)

```zs
dump-us [--use-network]
```
