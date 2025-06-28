#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

trap "echo '監視終了'; exit" SIGINT SIGTERM

current_limit=$(ulimit -n)

  echo "--------------------"
  echo "時間: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "ユーザー: $(whoami)"
  echo "ファイルディスクリプタ上限: $current_limit"
  echo "--------------------"

val=$1
search_str=$2

if ! [[ "$val" =~ ^[0-9]+$ ]]; then
	val=0
fi

while true; do
  start_time=$(date +%s)
  total_fd_count=0
  searched_fd_count=0 

  for pid in $(ps -u $(whoami) -o pid=); do
    fd_count=$(ls /proc/$pid/fd 2>/dev/null | wc -l)
		if [ "$val" -gt 0 ]; then
    	cmd=$(ps -p $pid -o cmd= | cut -c1-$val)
      if [ -z "$search_str" ]; then
        echo -e "${GREEN}  PID: $pid, ファイルディスクリプター数: $fd_count, コマンド: $cmd${NC}"
      else
        if [[ "$cmd" == *"$search_str"* ]]; then
          echo -e "${GREEN}  PID: $pid, ファイルディスクリプター数: $fd_count, コマンド: $cmd${NC}"
          searched_fd_count=$((searched_fd_count + fd_count))
        fi
      fi
    fi

		total_fd_count=$((total_fd_count + fd_count)) 

  done

  if [ -z "$search_str" ]; then
    if [ $total_fd_count -gt $current_limit ]; then
      echo -e "${RED}$(date '+%Y-%m-%d %H:%M:%S.%3N') $(whoami) ファイルディスクリプターの合計: $total_fd_count 上限: $current_limit${NC}"
    else 
      echo -e "${BLUE}$(date '+%Y-%m-%d %H:%M:%S.%3N') $(whoami) ファイルディスクリプターの合計: $total_fd_count 上限: $current_limit${NC}"
    fi
  else
      if [ $total_fd_count -gt $current_limit ]; then
      echo -e "${RED}$(date '+%Y-%m-%d %H:%M:%S.%3N') $(whoami) ファイルディスクリプターの合計: $total_fd_count 検索合計: $searched_fd_count 上限: $current_limit${NC}"
    else 
      echo -e "${BLUE}$(date '+%Y-%m-%d %H:%M:%S.%3N') $(whoami) ファイルディスクリプターの合計: $total_fd_count 検索合計: $searched_fd_count 上限: $current_limit${NC}"
    fi
  fi
  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  
  if [ $elapsed_time -lt 1 ]; then
    sleep $((1 - elapsed_time))
  fi

  if [ "$val" -gt 0 ]; then
    sleep 1
  fi
done

