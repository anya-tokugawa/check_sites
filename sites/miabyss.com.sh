#!/bin/bash -eu
cd "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../"
source "./config.sh"

dir="./sites/miabyss.com.d"
raw="$dir/raw.txt"
mkdir -p "$dir"

curl "http://miabyss.com/news.html" > "$raw"

sed -i -e 's;\r;;g' "$raw"

old="$dir/old.csv"
now="$dir/now.csv"

if [[ -f "$now" ]];then
  mv "$now" "$old"
fi

if [[ -f "$old" ]];then
  OLD_IDS="$dir/OLD_IDS.lst"
  cut -d, -f1 "$old" > "$OLD_IDS"
fi


START='<!--▽記事 -->'
END='<!--△記事 -->'
STARTS=( $(  grep "$START" "$raw" -n | cut -d: -f1 ) )
ENDS=( $(  grep "$END" "$raw" -n | cut -d: -f1 ) )

tmp="$dir/article.txt"
for (( i=0; i < ${#STARTS[*]}; i=$((i + 1)) ));do
  sed -n "${STARTS[$i]},${ENDS[$i]}p" "$raw" > "$tmp"
  id="$( grep -Po '<div id=".*?">' "$tmp" | cut -d'"' -f2)"
  lk="$( grep -Po '<a href=".*?">' "$tmp" | cut -d'"' -f2)"
  dt="$( grep "news_day" "$tmp" |   sed -e 's;<[^>]*>;;g')"
  tl="$( grep "news_title" "$tmp" | sed -e 's;<[^>]*>;;g')"
  echo "$id,$lk,$dt,$tl" >> "$now"
  if [[ -v OLD_IDS ]];then
    if ! grep -q "$id" "$OLD_IDS";then
      POST_TEXT="NEW_ITEM[$dt]: $tl <https://miabyss.com/$lk>"
      post
    fi
  fi
done



