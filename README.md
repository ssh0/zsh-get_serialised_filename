# zsh-get_seriarised_filename

useful function to get serialised filename

# Usage

In your shell script, sometimes you want save a file in '/path/to/save'
with serial-numbered file name.
Assume that the structure of '/path/to/save' is now

```
    path
    └── to
        └── save
            ├── 01_file
            ├── 02_file
            ├── 04_file
            ├── file_001.txt
            ├── file_002.txt
            └── file_003.txt
```

Then you can get the serial-numberd file name like below:

1: if you want to create "**file_004.txt**"

```
someoperation > "\$(get_serialised_filename -d "/path/to/save" -b "file_" -e "txt")"
```

(equal)

```
someoperation > "/path/to/save/file_004.txt"
```

2: if you want to create "**05_file**"

```
someoperation > "\$(get_serialised_filename -d "/path/to/save" -n 2 -a "_file")"
```

(equal)

```
someoperation > "/path/to/save/05_file"
```

3: if you want to create "**/path/to/other/newfile_001.md**"

```
someoperation > "\$(get_serialised_filename -d "/path/to/other" -b "newfile_" -e "md")"
```

(equal)

```
someoperation > "/path/to/other/newfile_001.md"
```

But this may fail because 'other' directory doesn't exist yet.
This script only returns filename but doesn't anything except that.

# Install

## With sh plugin manager

You can use zsh-plugin-manger (antigen, zgen, zplug, and so on)

In your `zshrc`:

**antigen**

```
antigen bundle ssh0/zsh-get_seriarised_filename
```

**zgen**

```
zgen load ssh0/get_seriarised_filename
```

**zplug**

```
zplug "ssh0/get_seriarised_filename"
```

## Manuall installation

This script also works in bash. If you want use this function from bash,
you can install with below steps.

1: Clone this repository into your computer.

```
git clone https://github.com/ssh0/zsh-get_seriarised_filename.git ~/.zsh/plugins/zsh-get_seriarised_filename
```

2: source from your `zshrc` (or `bashrc`).

In `zshrc`(or `bashrc`):

```
source $HOME/.zsh/plugins/zsh-get_seriarised_filename/get_seriarised_filename.sh
```

# License

This script is published under MIT License.

# Author

ssh0 (Shotaro Fujimoto) <fuji101ijuf@gmail.com>

