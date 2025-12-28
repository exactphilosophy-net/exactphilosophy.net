#!/bin/bash

WEB_VALIDATOR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function webValidator_validateFileSizes {
  local SOURCE_DIR="$1"
  local TARGET_DOMAIN="$2"
  shift 2
  echo -n "validate sizes "
  SECONDS=0
  local ERRORS=""

  for FILE in $(cd "$SOURCE_DIR" && find -L * -type f); do
    #echo "$FILE"
    if [[ "$FILE" == *".DS_Store" || "$FILE" == *$'Icon\r' ]]; then
      continue
    fi
    local SKIP=0
    for SKIP_DIR in "$@"; do
      if [[ "$FILE" == "$SKIP_DIR/"* ]]; then
        #echo -n "!"
        SKIP=1
        break
      fi
    done
    if [ $SKIP -eq 1 ]; then
      continue
    fi

    local OUT="="
    local TMPFILE="/tmp/headers-$TARGET_DOMAIN"
    rm -f "$TMPFILE"
    # only get headers for status and content-length, not body
    curl --silent --head --location "https://$TARGET_DOMAIN/$FILE" 2>&1 | tr -d '\015' >"$TMPFILE"
    local STATUS=$(awk '/^HTTP\/2/{print $2}' "$TMPFILE")
    local INFO=
    if [ "$STATUS" != "200" ]; then
      # file missing online or could not download
      OUT="-"
      INFO="HTTP status: $STATUS"
    else
      # file online, compare sizes - rsync should normally have ensured that files are identical
      # (use real file in desktop folder not symlink, -L fails if target file is updated)
      # (downlading and then comparing with "cmp" or "md5" was about 5x slower for xphi, 5 vs 1 min)
      # (calculating md5 by nginx on pi zero would also be slow, already 3 sec for 70 MB file file)
      local SIZE_LOCAL=$(stat -f%z "$SOURCE_DIR/$FILE")
      local SIZE_REMOTE=$(awk '/^content-length:/{print $2}' "$TMPFILE")
      if [ "$SIZE_LOCAL" != "$SIZE_REMOTE" ]; then
        # file different online
        OUT="≠"
        INFO="size: local $SIZE_LOCAL <=> $SIZE_REMOTE remote"
      fi
    fi
    echo -n "$OUT"
    if [ "$OUT" != "=" ]; then
      ERRORS="$ERRORS\n$OUT $FILE ($INFO)"
    fi
  done

  if [ "$ERRORS" != "" ]; then
    echo -e "$ERRORS"
    echo
    exit 1
  fi
  echo " $SECONDS sec"
}

# this is purely local, hence could be done before publishing,
# but got used to do it this way with "publish validate" and
# publishing with rsync is usually very fast if small changes
function webValidator_validateHtmlFiles {
  local SOURCE_DIR="$1"
  local HTML_FILES_TO_VALIDATE_EXPR="$2"
  # validate html
  echo -n "validate html ."
  SECONDS=0
  local HTML_FILES_TO_VALIDATE=$(cd "$SOURCE_DIR" && eval $HTML_FILES_TO_VALIDATE_EXPR)
  #echo "HTML_FILES_TO_VALIDATE ---$HTML_FILES_TO_VALIDATE---"
  local RESULT=$(cd "$SOURCE_DIR" && java -jar "$WEB_VALIDATOR_SCRIPT_DIR/vnu/vnu.jar" --html --stdout $HTML_FILES_TO_VALIDATE || true)
  if [ "$RESULT" != "" ]; then
    echo -e "\n$RESULT\n"
    exit 1
  fi  
  local N=$(wc -w <<< "$HTML_FILES_TO_VALIDATE")
  echo -n "$(head -c $N < /dev/zero | tr '\0' '*')"
  echo " $SECONDS sec"
}
