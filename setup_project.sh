#!/bin/bash

echo -e "Choose what to do: \n"
echo  "1: Make the directory structure. "
echo  "2: Dynamic Configuration (Stream Editing)"
echo  "3: Process Management (The Trap)"
echo  "4: Health Check and see if python is install successfully"
echo ""
read -p "Enter your choice(1-4): " x

case $x in
1)
  dir=attendance_tracker
  if  [[ ! -d  "dir*"]]
  then
  read -p "Name your directory $dir_ :" y
  mkdir -p "${dir}_${y}"
  cd ${dir}_${y}
  else
  echo "Directory already exists!"
  fi
  ;;

  *)
  echo "Please make choice"
  ;;
  esac
  
  