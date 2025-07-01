#!/bin/bash

# 引数チェック
if [ $# -lt 1 ]; then
  echo "Usage: $0 <filename.py> [author_name] [brief_description]"
  exit 1
fi

file_path="$1"
author_input="$2"
brief="$3"

# ファイル名だけを抽出（@file に使う）
filename=$(basename "$file_path")

# @date 用に現在日時（ISO8601）
current_date=$(date -Iseconds)

# author（第2引数がない場合は git または whoami）
if [ -n "$author_input" ]; then
  author="$author_input"
else
  # git config user.name があれば使う
  author=$(git config --global user.name 2>/dev/null)
  if [ -z "$author" ]; then
    author=$(whoami)
  fi
fi

# brief（第3引数なければデフォルト）
if [ -z "$brief" ]; then
  brief="template text"
fi

# すでにファイルが存在しているか確認
if [ -e "$file_path" ]; then
  echo "Error: File '$file_path' already exists."
  exit 1
fi

# テンプレート書き込み
cat <<EOF > "$file_path"
"""!
@file $filename
@version 1
@author $author
@date $current_date
@brief $brief
"""

this_file_path = pathlib.Path(__file__).parent

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("-c", "--command", help="dump comment", type=str, default="hello world!")
    parser.add_argument("-f", "--flag", help="sample flag", action="store_true")

    args = parser.parse_args()

    text = args.command
    flag = args.flag

    print(f"\{text} with \{flag}")

if __name__ == "__main__":
    main()
EOF

chmod +x "$file_path"

echo "  Created file: $file_path"
echo "  Author : $author"
echo "  Date   : $current_date"
echo "  Brief  : $brief"

