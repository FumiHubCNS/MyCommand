#!/bin/bash

# 引数チェック
if [ $# -lt 1 ]; then
  echo "Usage: $0 <python_file.py> [minor] [apply]"
  exit 1
fi

file="$1"
apply="$2"
update_type="$3"

# ファイル存在チェック
if [ ! -f "$file" ]; then
  echo "Error: File not found: $file"
  exit 1
fi

# 現在のバージョンと日付を取得
version_line=$(grep '^@version' "$file")
date_line=$(grep '^@date' "$file")
current_version=$(echo "$version_line" | awk '{print $2}')
current_date=$(echo "$date_line" | awk '{print $2}')

# バージョン更新
if [[ "$update_type" == "minor" ]]; then
  major=$(echo "$current_version" | cut -d. -f1)
  minor=$(echo "$current_version" | cut -d. -f2)
  if [[ -z "$minor" ]]; then
    minor=0
  fi
  new_minor=$((minor + 1))
  new_version="${major}.${new_minor}"
else
  major=$(echo "$current_version" | cut -d. -f1)
  new_major=$((major + 1))
  new_version="${new_major}"
fi

# 新しい日付（ISO 8601形式）
new_date=$(date -Iseconds)

# 書き換えるかどうかの確認
if [[ "$apply" == "apply" ]]; then
  # 実際にファイルを書き換える
  sed -i '' "s/^@version.*/@version ${new_version}/" "$file"
  sed -i '' "s/^@date.*/@date ${new_date}/" "$file"
  #sed -i "s/^@version.*/@version ${new_version}/" "$file"
  #sed -i "s/^@date.*/@date ${new_date}/" "$file"

  echo "  Updated $file"
  echo "  Version: $current_version → $new_version"
  echo "  Date   : $current_date → $new_date"
else
  # 変更前後の内容を表示のみ（dry-run）
  echo "  Dry run (no changes made): $file"
  echo "  Version: $current_version → $new_version"
  echo "  Date   : $current_date → $new_date"
  echo "  (To apply changes, add 'apply' as third argument)"
fi

