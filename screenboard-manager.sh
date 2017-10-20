#!/usr/bin/env bash -e

usage() {
    cat <<EOF
Usage: ./screenboard-manager.sh -m \$MODE -e \$ENV -i \$ID

MODE:
    show   : show current remote screen status
    pull   : update local screen status file (./status/)
    diff   : diff for between local and remote
    update : update remote screen with local current screen status
ENV:
    test-prd or test-stg or ...
ID:
    screen board id : screen board id which you want to operate
    ex) 230368
    https://app.datadoghq.com/screen/230368/s-screenboard-xxxxxxxxxxxx
ex)
    ./screenboard-manager.sh show -e test-prd -i 230368
EOF
}

ENV=""
S_ID=""
MODE=""
while getopts m:e:i:h OPT
do
  case $OPT in
    "h" ) usage ;;
    "m" ) FLG_M="TRUE" ; MODE="$OPTARG" ;;
    "e" ) FLG_E="TRUE" ; ENV="$OPTARG" ;;
    "i" ) FLG_I="TRUE" ; S_ID="$OPTARG" ;;
  esac
done

CONFIG_DIR=./config/
CONFIG_FILE_PATH=$CONFIG_DIR.dogrc_$ENV
mkdir -p $CONFIG_DIR 2>/dev/null
if [ ! -e $CONFIG_FILE_PATH ]; then
  echo "you must set config file on $CONFIG_FILE_PATH"
  exit 0
fi

STATUS_DIR=./status/$ENV/
STATUS_FILE_PATH=$STATUS_DIR$S_ID.json

DIFF_DIR=./.diff/$ENV/
DIFF_FILE_PATH=$DIFF_DIR$S_ID.json

DATE=`date +%Y%m%d_%H-%M-%S`
UPDATE_LOG_DIR=./log/$ENV/$S_ID/
UPDATE_LOG_FILE_PATH=$UPDATE_LOG_DIR"update-"$DATE.json

dog_show () {
  dog --config $CONFIG_FILE_PATH screenboard show $S_ID | jq '.'
}

dog_push () {
  dog --config $CONFIG_FILE_PATH screenboard push $STATUS_FILE_PATH
}

screenboard_show () {
  dog_show
}

screenboard_pull () {
#  git pull
  echo $STATUS_FILE_PATH
  if [ -e $STATUS_FILE_PATH ]; then
    echo "status file "$STATUS_FILE_PATH" already exits . ok to update this status file ? (yes)"
    read ANSWER
    case $ANSWER in
      "yes" | "Yes" | "YES" ) ;;
      * ) exit 0;;
    esac
  fi 
  mkdir -p $STATUS_DIR 2>/dev/null
  dog_show>$STATUS_FILE_PATH
  echo "$STATUS_FILE_PATH has already updated !!"
}

screenboard_diff () {
  if [ ! -e $STATUS_FILE_PATH ]; then
    echo "status file is not exits. Please pull mode at first."
    exit 0
  fi
  mkdir -p $DIFF_DIR 2>/dev/null
  dog_show >$DIFF_FILE_PATH
  diff -u $DIFF_FILE_PATH $STATUS_FILE_PATH
}

screenboard_push () {
  screenboard_diff
  echo "push ok ? (yes)"
  read ANSWER
  case $ANSWER in
      "yes" | "Yes" | "YES" ) ;;
      * ) exit 0;;
  esac
  mkdir -p $UPDATE_LOG_DIR 2>/dev/null
  dog_show | tee $UPDATE_LOG_FILE_PATH
  dog_push 
#  git add .
#  git commit -m "update log file $UPDATE_LOG_FILE_PATH"
#  git push
}

case $MODE in
    show)
        screenboard_show
        ;;
    pull)
        screenboard_pull
        ;;
    diff)
        screenboard_diff
        ;;
    push)
        screenboard_push
        ;;
    *)
        usage
        exit 1
        ;;
esac
