declare -xr JSON_HEADER='Content-Type: application/json'

POST_SLACK_ENABLE=0
POST_TEAMS_ENABLE=0

SLACK_POST_URL=""
SLACK_POST_CHANNEL='#general'
SLACK_POST_NAME="$(hostname)"
SLACK_POST_EMOJI=':ghost:'

TEAMS_POST_URL=""

function post(){

  # slack
  if [[ $POST_SLACK_ENABLE  != 0 ]] && [[ "$SLACK_POST_URL" != "" ]];then
    curl -sSL -X POST --data-urlencode \
      "payload={\"channel\": \"${SLACK_POST_CHANNEL}\", \"username\": \"${SLACK_POST_NAME}\", \"text\": \"${SLACK_POST_TEXT}\", \"icon_emoji\": \"$SLACK_POST_EMOJI\"}" "$SLACK_POST_URL"
  fi

  # Microsoft Teams
  if [[ $POST_TEAMS_ENABLE  != 0 ]] && [[ "$TEAMS_POST_URL" != "" ]];then
    curl -d "{\"text\": \"$POST_TEXT\"}" -H "$JSON_HEADER" "$TEAMS_POST_URL"
  fi
}
