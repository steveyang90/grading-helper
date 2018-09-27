#!/bin/bash

# Grading Helper
# Function for W271 Graders to do the following:
#   1. Clone student repositories
#   2. Pull Weekly Student Work into its own branch
#
# Required:
# `student_list.txt` file with each student GitHub handle on its own line
#
# Args:
#   -w : week number (int between 1 - 14)
#   -d : due datetime (e.g. `2018-09-17 16:00:00`)

function validate_week() {
  grep -F -q -x "$1" <<EOF
1
2
3
4
5
6
7
8
9
10
11
12
13
14
EOF
}

# parse options
while getopts "w:d:" opt; do
  case ${opt} in
    w)
      WEEK_NUMBER="${OPTARG}"
      validate_week "${WEEK_NUMBER}" \
        || (echo "Invalid week number '$WEEK_NUMBER'."; exit 1)
      ;;
    d)
      DUE_DATE="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# set -e

# check that student list exists
if [ ! -e student-list.txt ]; then
  echo "Missing student_list.txt"
  echo "Create student list file with GitHub handles."
  exit
fi
STUDENT_LIST=`cat student-list.txt`

# iterate through list of students and clone
for i in $STUDENT_LIST; do
  # check if already cloned
  if [[ -e f18-$i ]]; then
    echo "f18-${i} already exists."
    continue
  fi
  git clone https://github.com/MIDS-W271/f18-$i.git
done

# check week branch
if [[ -z "$WEEK_NUMBER" ]]; then
  echo "No week number specified."
  exit
fi
TARGET_BRANCH="week-${WEEK_NUMBER}"

# check datetime
if [[ -z "$DUE_DATE" ]]; then
  echo "No due date specified."
  echo $DUE_DATE
  exit
fi

# iterate through list of students and pull
for i in $STUDENT_LIST; do
  echo "==== Pulling Assigment Submissions for ${i}==="
  if [[ ! -e f18-$i ]]; then
    echo "f18-${i} could not be found."
    continue
  fi
  cd f18-$i
  git checkout master
  git pull
  git checkout -B $TARGET_BRANCH `git rev-list -n 1 --before="${DUE_DATE}" \
  --committer=steveyang90 --invert-grep master`
  cd ..
done
