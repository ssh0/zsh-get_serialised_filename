#!/bin/bash
# written by Shotaro Fujimoto (https://github.com/ssh0)
# first edited: 2015-12-16
#
# get_serialised_filename - useful function to get serialised filename
#

get_serialised_filename() {

  local root_dir num_of_digits checkint optstr pattern i filename

  # default value
  root_dir="$(pwd)"    # option -d
  num_of_digits=3      # option -n


  usage() {
    echo "Usage: get_serialised_filename [OPTOINS]"
    echo ""
    echo "See help message from command line by:"
    echo "    get_serialised_filename -h"
    echo ""
  }


  long_usage() {
    cat << EOF

NAME
      get_serialised_filename - useful function to get serialised filename

USAGE
      get_serialised_filename [OPTOINS]
      (At least one option from (-b -a -e -h) are necessary.)

OPTIONS
      -h  Show this help message.

      -b filename_before
          Set the string put to before the number.

      -a filename_after
          Set the string put to after the number.

      -e filename_extension
          Set the extension of the file.

      -d root_dir
          Specify the directory to search.

      -n num_of_digits
          Specify the number of digits.

EXAMPLES
In your shell script, sometimes you want save a file in '/path/to/save'
with serial-numbered file name.
Assume that the structure of '/path/to/save' is now

    path
    └── to
        └── save
            ├── 01_file
            ├── 02_file
            ├── 04_file
            ├── file_001.txt
            ├── file_002.txt
            └── file_003.txt

Then you can get the serial-numberd file name like below:

1. if you want to create "file_004.txt"
      someoperation > "\$(get_serialised_filename -d "/path/to/save" -b "file_" -e "txt")"

    (equal)
      someoperation > "/path/to/save/file_004.txt"

2. if you want to create "05_file"
      someoperation > "\$(get_serialised_filename -d "/path/to/save" -n 2 -a "_file")"

    (equal)
      someoperation > "/path/to/save/05_file"

3. if you want to create "/path/to/other/newfile_001.md"
      someoperation > "\$(get_serialised_filename -d "/path/to/other" -b "newfile" -e "md")"

    (equal)
      someoperation > "/path/to/other/newfile_001.md"

    But this may fail because 'other' directory doesn't exist yet.
    This script only returns filename but doesn't anything except that.

EOF
  }


  cleanup_namespace() {
    unset -f usage long_usage $0
  }


  trap cleanup_namespace EXIT

  checkint=0
  optstr="d:n:b:a:e:h"
  while getopts "${optstr}" OPT; do
    case ${OPT} in
      "d")
        root_dir="${OPTARG%/}"
        ;;
      "n")
        num_of_digits=${OPTARG}
        ;;
      "b")
        filename_before="${OPTARG}"
        checkint=$(($checkint+1))
        ;;
      "a")
        filename_after="${OPTARG}"
        checkint=$(($checkint+1))
        ;;
      "e")
        filename_extension="${OPTARG#\.}"
        checkint=$(($checkint+1))
        ;;
      "h")
        long_usage
        checkint=$(($checkint+1))
        return 0
        ;;
    esac
  done


  # check whether at least one necessary arguments are given
  [ $checkint = 0 ] && {
    usage; echo "missing some necessary arguments"; return 1
  }

  # if filename_extension is not empty, add "." before the extension.
  [ -n "${filename_extension}" ] && filename_extension="\.${filename_extension}"

  # make filename pattern
  pattern='s/'"${filename_before}"'\([0-9]\{'"${num_of_digits}"'\}\)'
  pattern=${pattern}"${filename_after}${filename_extension}"'/\1/p'

  if [ -d "${root_dir}" ]; then
    i=$(( $(command -p ls "${root_dir}" | sed -n $pattern | tail -n 1) + 1 ))
  else
    i=1
  fi

  filename="${root_dir}/${filename_before}$(printf "%0${num_of_digits}d" $i)"
  filename=$filename"${filename_after}${filename_extension#\\}"

  echo "${filename}"

  return 0

}

