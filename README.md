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
| new-pyfile | create_py_template.sh | generate file with description for doxygen |
| code-description-updatever | update_version.sh | update description of code for doxygen |
| monitor-fd | monitor_fd.sh | monitor to the number of file discriptor |

### Detail of commands

#### `new-pyfile`

This command generate Python file with description.

The first argument specifies the file path and name to be genrated.

The seccond argument specifies the author name. If you do not specifies name.
This command first attempts to retrieve the name using `git config --global user.name`, and if it cannot be retrieved, it uses username.

The thrid argument specifies description of @brief. The default description is "template text"

#### `code-description-updatever`

This tool automatically updates metadata (`@version`, `@date`) embedded in Python script files.

When executing, you can specify the version update rules and whether to actually overwrite the file.

The first argument specifies the file path name.

The second argument specifies whether to overwrite the file. If `apply` is specified, the file is overwritten. If nothing is specified or there is a typo, the file is not overwritten, and the changes to be made are dumped.

The thrid argument specifies whether it is a major update or a minor update. If `minor` is specified, only minor updates are applied. For example, (1 -> 1.1).

```zsh
code-description-updatever [path] [overwrite flag] [version rule]

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

#### `monitor-fd`

Command to monitor the number and details of file descriptors currently in use

First argument: Maximum length of the command string to display (integer). If 0, do not display.

Second argument: Display only processes whose command names contain this string (optional)

When the script is terminated using `Ctrl+C`, it outputs "監視終了" and exits normally.
