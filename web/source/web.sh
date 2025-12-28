#!/bin/bash

# needs LaTeX, Java (for html validation) and (via Homebrew) GraphicsMagick, qpdf

function main {
  protect
  setup
  if [ $# -eq 0 ]; then ARGS="web"; else ARGS=$*; fi
  for ARG in $ARGS; do
    if [ "$ARG" == "lua" ]; then lua
    elif [ "$ARG" == "web" ]; then web
    elif [ "$ARG" == "pdfs" ]; then pdfs
    elif [ "$ARG" == "imgs" ]; then imgs
    elif [ "$ARG" == "publish" ]; then publish
    elif [ "$ARG" == "validate" ]; then validate
    elif [ "${ARG##*.}" == "img" ]; then img "${ARG%.*}" ""
    elif [ "${ARG##*/}" == "" ]; then img "${ARG%/}" ""
    elif [ "$ARG" == "pocket" ]; then pocket
    elif [ "$ARG" == "debug" ]; then set -x
    else
      printf "unknown target '$ARG'\n$(tput bold)usage: $(basename "$0") [lua|web|pdfs|imgs|publish|validate|*.img|*/|pocket]*$(tput sgr 0)\n" >&2
      exit 1
    fi
  done
  success
}

function protect {
  # set -x / +x to debug a section
  set -e -u
  trap 'dofail $? $LINENO' EXIT
}

function dofail {
  local RC="$1"
  local LINE="$2"
  echo "$(tput bold)$(basename "$0") failed$(tput sgr 0) $(tput setaf 7)(rc $RC around line $LINE)$(tput sgr0)" >&2
}

function setup {
  cd "${0%/*}/.."
  
  LATEX="pdflatex"

  WEBDIR=$(pwd)
  WEBS=""
  WEBS="$WEBS welcome:index-de"
  WEBS="$WEBS way:weg"
  WEBS="$WEBS  spacetime:raumzeit"
  WEBS="$WEBS  metamorphosis:metamorphose"
  WEBS="$WEBS  greek:griechisch"
  WEBS="$WEBS  iching:iging"
  WEBS="$WEBS  origins:urspruenge"
  WEBS="$WEBS evolutions:evolutionen"
  WEBS="$WEBS  feelings:gefuehle"
  WEBS="$WEBS  starsigns:sternzeichen"
  WEBS="$WEBS  artemis:artemis-de"
  WEBS="$WEBS  noindex:noindex-de"
  WEBS="$WEBS synthesis:synthese"
  WEBS="$WEBS  measurement:messung"
  WEBS="$WEBS  psyche:psyche-de"
  WEBS="$WEBS  dreams:traeume"
  WEBS="$WEBS references:referenzen"
  WEBS="$WEBS series:reihe"
  WEBS="$WEBS links:links-de"

  ARTDIR="artemis/texts"
  ARTS=""
  ARTS="$ARTS garden/garden"
  ARTS="$ARTS garden/jardin"
  ARTS="$ARTS garden/garten"
  ARTS="$ARTS xphi/what-is-exactphilosophy"
  ARTS="$ARTS iching/elemental-changes-i-ching"
  ARTS="$ARTS iching/elementare-wandlungen-i-ging"
  ARTS="$ARTS star-signs/elementary-star-signs"
  ARTS="$ARTS star-signs/elementare-sternzeichen"
  ARTS="$ARTS astro-how/how-astrology-might-really-work"
  ARTS="$ARTS astro-how/wie-astrologie-wirklich-funktionieren-koennte"
  ARTS="$ARTS astro-teasers/astro-teasers"
  ARTS="$ARTS cognition/sources-of-cognition"
  ARTS="$ARTS cognition/quellen-der-erkenntnis"
  ARTS="$ARTS elements/the-pyramids-and-the-four-elements"
  ARTS="$ARTS elements/the-roots-of-the-four-elements-in-empedocles-poem-and-similarly-veiled-in-the-hippocratic-oath"
  ARTS="$ARTS neutrinos/are-dark-matter-and-energy-neutrinos"
  ARTS="$ARTS paradoxes/paradox-of-love"
  ARTS="$ARTS paradoxes/paradox-of-measurement"
  ARTS="$ARTS paradoxes/paradox-of-solar-eclipses"
  ARTS="$ARTS paradoxes/paradox-of-decoherence"
  ARTS="$ARTS paradoxes/paradox-of-pi"
  ARTS="$ARTS caesar-rodney/caesar-rodney-birth-time"
  ARTS="$ARTS lilith/lilith-premiere-mention"
  ARTS="$ARTS lilith/lilith-first-mention"
  ARTS="$ARTS lilith/lilith-erste-erwaehnung"
  ARTS="$ARTS dada/dada-und-duchamps-fountain"
  ARTS="$ARTS dada/dada-and-duchamps-fountain"
  ARTS="$ARTS dada/dada-et-la-fontaine-de-duchamp"
  ARTS="$ARTS amber/ambers-seen-and-not-heard-prank"
  ARTS="$ARTS secrets/prague-played-dan-brown-in-the-secret-of-secrets"
  ARTS="$ARTS artemisia/white-red-black-and-triple-moon-goddess"
  ARTS="$ARTS artemisia/white-red-black-and-the-green-goddess"
  ARTS="$ARTS artemisia/sleeping-beauty-dreaming"
  ARTS="$ARTS artemisia/future"
  ARTS="$ARTS artemisia/mysteries-of-life"
  ARTS="$ARTS tesla/teslacard-postcard-action-2010"
  ARTS="$ARTS tma/mountain-astrologer-ads"
  ARTS="$ARTS delphi/delphi-for-palm-os"
  ARTS="$ARTS hood/sherwood-forrest"  
  ARTS="$ARTS zeitzeugnisse/discoveries-revisited"
  ARTS="$ARTS zeitzeugnisse/web-archives"
  ARTS="$ARTS zeitzeugnisse/usenet-odyssey"
  ARTS="$ARTS zeitzeugnisse/mondfaden"
  ARTS="$ARTS zeitzeugnisse/timeline"
  ARTS="$ARTS cargo-cult-astrology/cargo-cult-astrology"
  ARTS="$ARTS cargo-cult-astrology/cargo-kult-astrologie"
  ARTS="$ARTS zeitzeugnisse/wei-chi"
  ARTS="$ARTS zeitzeugnisse/renegades"  
  ARTS="$ARTS lego/moebius-lego"
  ARTS="$ARTS art/die-neugierige-statue"
  ARTS="$ARTS art/elemental-improvisation"
  ARTS="$ARTS art/visual-art-gallery"
  ARTS="$ARTS art/way-of-the-fox"

  . source/shared/ssh-publisher.sh
  . source/shared/web-validator.sh
}

function lua {
  LATEX="lualatex"
}

function webs {
  for WEBPAIR in $WEBS; do
    local ARR=(${WEBPAIR//:/ })
    echo -n "${ARR[0]} "
  done
}

function menus {
  echo "contents mobile"
}

function isMenu {
  local MENU="$1"
  [ "$MENU" == "contents" ] || [ "$MENU" == "mobile" ]
}

function langs {
  echo "en de"
}

function otherLang {
  local LANG="$1"
  if [ "$LANG" == "en" ]; then
    echo "de"
  else
    echo "en"
  fi
}

function isIndex {
  local WEB="$1"
  local LANG="$2"
  [ "$WEB" == "welcome" ] && [ "$LANG" == "en" ]
}

function webTarget {
  local WEB="$1"
  local LANG="$2"
  if isIndex "$WEB" "$LANG"; then
    echo "index"
    return
  fi
  for WEBPAIR in $WEBS; do
    local ARR=(${WEBPAIR//:/ })
    if [ "$WEB" == "${ARR[0]}" ]; then
      if [ "$LANG" == "en" ]; then
        echo "${ARR[0]}"
      else
        echo "${ARR[1]}"
      fi
      return
    fi
  done
  exit 1
}

function itemSub {
  local ITEM="$1"
  if isMenu "$ITEM"; then
    echo "source"
  else
    echo "$ITEM"
  fi
}

function pdfs {
  echo -n "pdfs "
  SECONDS=0
  for ITEM in $(webs) $(menus); do
    for LANG in $(langs); do
      echo -n "."
      texToPdf "$WEBDIR/$(itemSub "$ITEM")" "$ITEM-$LANG.tex"
    done
  done
  for ART in $ARTS; do
    local ARR=(${ART//\// })
    echo -n "."
    texToPdf "$WEBDIR/$ARTDIR/${ARR[0]}" "${ARR[1]}.tex"
  done
  echo " $SECONDS secs"
}

function texToPdf {
  local DIR="$1"
  cd "$DIR"
  local TEX="$2"
  #echo "$DIR - $TEX"
  $LATEX -interaction=batchmode "$TEX" >/dev/null
}

function imgs {
  echo -n "imgs "
  SECONDS=0
  for ITEM in $(webs) $(menus); do
    for LANG in $(langs); do
      echo -n "."
      img "$ITEM" "$LANG"
    done
  done
  echo " $SECONDS secs"
}

function img {
  local ITEM="$1"
  local LANG="$2"
  if [ "$LANG" == "" ]; then
    local ITEMLANG="$1"
    ITEM=${ITEMLANG%-*}
    LANG=${ITEMLANG##*-}
  fi
  local EXT; EXT=$(getImgExt "$ITEM")
  local DIR; DIR="$WEBDIR/$(itemSub "$ITEM")"
  #echo "$DIR/$ITEM-$LANG.$EXT"
  # directory exists?
  if [ ! -d "$DIR" ]; then
    fail "no directory $DIR"
  fi
  cd "$DIR"
  # pdf exists?
  if [ ! -f "$ITEM-$LANG.pdf" ]; then
    texToPdf "$DIR" "$ITEM-$LANG.tex"
  fi
  # remember old height if contents/mobile
  if isMenu "$ITEM"; then
    local OLDHEIGHT
    if [ -e "$ITEM-$LANG.jpg" ]; then
      OLDHEIGHT=$(getImageDimension "$ITEM-$LANG.jpg" "%h")
    else
      OLDHEIGHT="(no file)"
    fi
  fi
  # remove image if exists
  if [ -f "$ITEM-$LANG.$EXT" ]; then
    rm "$ITEM-$LANG.$EXT"
  fi
  pdfToTrimmedImg "$ITEM" "$LANG" "$EXT"
  # verify that image was created
  if [ ! -f "$ITEM-$LANG.$EXT" ]; then
    fail "no resulting $ITEM-$LANG.$EXT"
  fi
  # add border if contents/mobile, and notify if height changed
  if isMenu "$ITEM"; then
    if [ "$ITEM" == "contents" ]; then
      addMenuImageBorders "$ITEM" "$LANG" 734 40
    elif [ "$ITEM" == "mobile" ]; then
      addMenuImageBorders "$ITEM" "$LANG" 1010 0
    fi
    EXT="jpg"
    local HEIGHT; HEIGHT=$(getImageDimension "$ITEM-$LANG.jpg" "%h")
    if [ "$HEIGHT" != "$OLDHEIGHT" ]; then
      echo "$ITEM-$LANG height $OLDHEIGHT => $HEIGHT"
    fi
  fi
}

function getImgExt {
  local ITEM="$1"
  if isMenu "$ITEM"; then
    echo "png"
  elif [ "$ITEM" == "artemis" ]; then
    echo "png"
  else
    echo "jpg"
  fi
}

function pdfToTrimmedImg {
  local ITEM="$1"
  local LANG="$2"
  local EXT="$3"
  local TARGET
  if [ "$EXT" == "jpg" ]; then
    TARGET="-strip -quality 50% $ITEM-$LANG.jpg"
  else
    TARGET="-define png:include-chunk=none PNG24:$ITEM-$LANG.png"
  fi
  gm convert -density 600 "$ITEM-$LANG.pdf" \
    -flatten -trim -blur 2.6 -resize 50% +repage -density 72 \
    $TARGET
}

function getImageDimension {
  local FILE="$1"
  local FORMAT="$2"
  local DIM; DIM=$(gm identify -format "$FORMAT" "$FILE" 2>/tmp/magick-err.txt)
  local ERR; ERR=$(cat /tmp/magick-err.txt)
  if [ "$ERR" != "" ]; then
    fail "$FILE: $ERR"
  fi
  echo "$DIM"
}

function getImageHalfWidth {
 local FILE="$1"
 local WIDTH; WIDTH=$(getImageDimension "$FILE" "%w")
 WIDTH=$(((WIDTH + 1) / 2))
 echo "$WIDTH"
}

function addMenuImageBorders {
  local MENU="$1"
  local LANG="$2"
  local WIDTH="$3"
  local BORDER="$4"
  local HEIGHT; HEIGHT=$(getImageDimension "$MENU-$LANG.png" "%h")
  HEIGHT=$((HEIGHT + 2 * BORDER))
  gm convert "$MENU-$LANG.png" -bordercolor white -border "$BORDER" \
    -gravity west -extent "${WIDTH}x${HEIGHT}" \
    -strip -quality 50% -density 72 "$MENU-$LANG.jpg"
  rm "$MENU-$LANG.png"
}

function web {
  webClean
  webPages
  webArts
  webGeneral
  webWidthsCss
  webSitemap
  webSink
}

function webClean {
  cd "$WEBDIR"
  if [ -d sink ]; then
    if [ -d sink/noindex ]; then
      rm -r sink/noindex
    fi
    touch sink/dummy
    rm sink/*
  else
    mkdir sink
  fi
}

function webPages {
  #echo -n "webs "
  #SECONDS=0
  cd "$WEBDIR"
  checkNoLatexInHtml
  for MID in mid1 mid2; do
    setSvgSizes source "$MID.html" "/tmp/$MID-svg.html"
  done
  for WEB in $(webs); do
    setSvgSizes "$WEB" "$WEB-visual.html" /tmp/visual.html
    for LANG in $(langs); do
      #echo -n "."
      #echo "$(webTarget "$WEB" "$LANG")".html
      local OTHERLANG; OTHERLANG=$(otherLang "$LANG")

      for MID in mid1 mid2; do
        sed "s/##$OTHERLANG##/$(webTarget "$WEB" "$OTHERLANG")/g" "/tmp/$MID-svg.html" >/tmp/$MID.html
      done
      cat \
        "source/top.html" \
        "$WEB/$WEB-title.html" \
        /tmp/mid1.html \
        /tmp/visual.html \
        /tmp/mid2.html \
        "$WEB/$WEB-text.html" \
        source/bot.html \
        >"/tmp/page.html"
      htmlMultiToSingleLanguage "/tmp/page.html" sink/"$(webTarget "$WEB" "$LANG")".html "$LANG"

      for EXT in aux log synctex.gz "synctex(busy)"; do
        if [ -f "$WEB/$WEB-$LANG.$EXT" ]; then rm "$WEB/$WEB-$LANG.$EXT"; fi
      done
      if [ -f "$WEB/$WEB.log" ]; then rm "$WEB/$WEB.log"; fi
    done
    local WEBIMGS; WEBIMGS="$(ls "$WEB/$WEB"*.jpg)"
    for FILE in $WEBIMGS; do ln -s "../$FILE" sink; done
  done
  for LOG in def def-stronger def-lib contents mobile; do
    if [ -f "source/$LOG.log" ]; then rm "source/$LOG.log"; fi
  done
  # cleanup temporary files
  for MID in mid1 mid2; do
    rm "/tmp/$MID-svg.html"
    rm "/tmp/$MID.html"
  done
  rm /tmp/visual.html
  rm /tmp/page.html
  #echo " $SECONDS secs"
}

function checkNoLatexInHtml {
  local FAILED=0
  local REGEX="[\\\`~{}]"
  for WEB in $(webs); do
    if grep -q "$REGEX" "$WEB/$WEB-text.html"; then
      echo -e "$WEB/$WEB-text.html:"
      grep "$REGEX" "$WEB/$WEB-text.html"
      FAILED=1
    fi
  done
  if [ $FAILED -eq 1 ]; then
    exit 1
  fi
}

function htmlMultiToSingleLanguage {
  local INFILE="$1"
  local OUTFILE="$2"
  local LANG="$3"
  local OTHERLANG; OTHERLANG=$(otherLang "$LANG")
  if [ -f "$OUTFILE" ]; then rm "$OUTFILE"; fi
  local SKIP=0
  while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
    local ISTAG=0
    if [ "$LINE" == "-----" ]; then
      continue
    elif [ "$LINE" == "<$LANG>" ]; then
      ISTAG=1
      SKIP=0
    elif [ "$LINE" == "<$OTHERLANG>" ]; then
      ISTAG=1
      SKIP=1
    elif [ "$LINE" == "</$LANG>" ] || [ "$LINE" == "</$OTHERLANG>" ]; then
      ISTAG=1
      SKIP=0
    fi
    if [ $SKIP -eq 0 ] && [ $ISTAG -eq 0 ]; then
      echo "$LINE" >>"$OUTFILE"
    fi
  done < "$INFILE"
}

function setSvgSizes {
  local DIR="$1"
  local INFILE="$2"
  local OUTFILE="$3"
  cd "$WEBDIR"
  if [ -f "$OUTFILE" ]; then rm "$OUTFILE"; fi
  while IFS="" read -r LINE || [ -n "$LINE" ]; do
    if [[ $LINE == *"AUTOSVG"* ]]; then
      local CLASS; CLASS=$(expr "$LINE" : '.* class="\([^"]*\)".*')
      local IMGFILE; IMGFILE=$(expr "$LINE" : '.* image="\([^"]*\)".*')
      # get width and height in a single call because is relatively slow...
      local WH; WH=$(getImageDimension "$DIR/$IMGFILE" "%w %h")
      local WHARRAY; read -r -a WHARRAY <<< "$WH"
      local WIDTH=${WHARRAY[0]}
      local HEIGHT=${WHARRAY[1]}
      echo "<svg class=\"$CLASS\" viewBox=\"0 0 $WIDTH $HEIGHT\" >" >>"$OUTFILE"
      echo "  <image width=\"$WIDTH\" height=\"$HEIGHT\" xlink:href=\"$IMGFILE\"></image>" >>"$OUTFILE"
    else
      echo "$LINE" >>"$OUTFILE"
    fi
  done < "$DIR/$INFILE"
}

function webArts {
  cd "$WEBDIR"
  for ART in $ARTS; do
    ln -s "../$ARTDIR/$ART.pdf" sink
    for EXT in aux log synctex.gz; do
	  if [ -f "$ARTDIR/$ART.$EXT" ]; then rm "$ARTDIR/$ART.$EXT"; fi
	done
  done
}

function webGeneral {
  cd "$WEBDIR"
  # menus (and cleanup latex generated files)
  for MENU in $(menus); do
    for LANG in $(langs); do
      ln -s "../source/$MENU-$LANG.jpg" sink
      for EXT in aux log synctex.gz; do
	    if [ -f "source/$MENU-$LANG.$EXT" ]; then rm "source/$MENU-$LANG.$EXT"; fi
	  done
	done
  done
  # various files
  for FILE in title.jpg white.jpg style.css robots.txt noindex; do
    ln -s ../source/$FILE sink
  done
  for DIR in source/favicons source/cmusans source/perma source/temp artemis/perma; do
    local FILES_IN_DIR; FILES_IN_DIR="$(ls $DIR)"
    for FILE in $FILES_IN_DIR; do ln -s "../$DIR/$FILE" sink; done
  done
  # cleanup
  local DS_STORE_FILES; DS_STORE_FILES="$(find -L sink -type f -name '.DS_Store')"
  for FILE in $DS_STORE_FILES; do
    rm "$FILE"
  done
}

function webWidthsCss {
  cd "$WEBDIR"
  for MENU in $(menus); do
    for LANG in $(langs); do
      webWidthCssNonWeb "$MENU" "$MENU-$LANG"
    done
  done
  for NAME in title white; do
    webWidthCssNonWeb "$NAME" "$NAME"
  done
  echo >> sink/widths.css
  for WEB in $(webs); do
    if [ "$WEB" == "artemis" ]; then
      for FILE in $(cd artemis; ls artemis-*.jpg); do
        NAME="${FILE%.*}"
        local WIDTH; WIDTH=$(getImageHalfWidth "artemis/$FILE")
        echo "svg.$NAME {max-width: ${WIDTH}px}" >> sink/widths.css
        echo "svg.$NAME rect:hover {fill:#80ff80}" >> sink/widths.css
      done
    else
      for LANG in $(langs); do
        local WIDTH; WIDTH=$(getImageHalfWidth "$WEB/$WEB-$LANG.jpg")
        echo "svg.$WEB-$LANG {max-width: ${WIDTH}px}" >> sink/widths.css
      done
    fi
  done
}

function webWidthCssNonWeb {
  local ITEM="$1"
  local ITEMLANG="$2"
  local WIDTH; WIDTH=$(getImageHalfWidth "source/$ITEMLANG.jpg")
  local MAXORNOT
  if [ "$ITEM" == "contents" ]; then
    MAXORNOT="width"
  else
    MAXORNOT="max-width"
  fi
  echo "svg.$ITEMLANG {$MAXORNOT: ${WIDTH}px}" >> sink/widths.css
}

function webSitemap {
  cd "$WEBDIR/sink"
  local DATE; DATE=$(date +%Y-%m-%d)
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >sitemap.xml
  echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >>sitemap.xml
  for LANG in $(langs); do
    echo >>sitemap.xml
    echo "  <!-- core web pages ($LANG) -->" >>sitemap.xml
    echo >>sitemap.xml
    for WEB in $(webs); do
      if [ "$WEB" == "welcome" ]; then
        echo "  <url>" >> sitemap.xml
        echo -n "    <loc>https://www.exactphilosophy.net/" >> sitemap.xml
        if ! isIndex "$WEB" "$LANG"; then
          echo -n "$(webTarget "$WEB" "$LANG").html" >>sitemap.xml
        fi
        echo "</loc>" >>sitemap.xml
        echo "    <lastmod>$DATE</lastmod>" >>sitemap.xml
        echo "    <priority>1.0</priority>" >>sitemap.xml
        echo "  </url>" >>sitemap.xml
        echo >>sitemap.xml
      elif [ "$WEB" != "noindex" ]; then
        echo -n "  <url><loc>https://www.exactphilosophy.net/" >> sitemap.xml
        echo "$(webTarget "$WEB" "$LANG").html</loc><lastmod>$DATE</lastmod></url>" >>sitemap.xml
      fi
    done
  done
  echo >>sitemap.xml
  echo "  <!-- artemis articles (multiple languages) -->" >>sitemap.xml
  echo >>sitemap.xml
  for ART in $ARTS; do
    ARR=(${ART//\// })
    echo "  <url><loc>https://www.exactphilosophy.net/${ARR[1]}.pdf</loc><lastmod>$DATE</lastmod></url>" >>sitemap.xml
  done
  echo >>sitemap.xml
  echo "</urlset>" >>sitemap.xml
}

function webSink {
  cd "$WEBDIR"
  if [ -f sink/.DS_Store ]; then
    rm sink/.DS_Store
  fi
  if [ -d ~/Desktop/sink ]; then
    rm -r ~/Desktop/sink
  fi
  # -p preserves modification times (and more),
  # combined with -t for rsync speeds up publication
  cp -LRp sink/ ~/Desktop/sink/
}

function publish {
  local SSH_CONFIG_DIR=/Volumes/pies/misc/hosting/local
  local SSH_SOURCE_DIR=~/Desktop/sink
  local SSH_TARGET_ID="xphi"
  sshPublisher_publish $SSH_CONFIG_DIR $SSH_SOURCE_DIR "$SSH_TARGET_ID"
}

function validate {
  local SOURCE_DIR=~/Desktop/sink
  local TARGET_DOMAIN=www.exactphilosophy.net
  # not excluding other forums, yet, because might more likely still change there
  local DIRS_TO_SKIP_IN_SIZE_VALIDATION="noindex/odyssey/astro/img"
  # temporary: exclude test files for LaTeX Stack Exchange
  local HTML_FILES_TO_VALIDATE_EXPR="find -L * -type f -name '*.html' | sed -e '/origins-maxai.html/d' | sed -e '/origins-make4ht.html/d'"
  webValidator_validateFileSizes $SOURCE_DIR $TARGET_DOMAIN $DIRS_TO_SKIP_IN_SIZE_VALIDATION
  webValidator_validateHtmlFiles $SOURCE_DIR "$HTML_FILES_TO_VALIDATE_EXPR"
}

function pocket {
  # absolute symlinks for latex
  pocketClean
  pocketWork
  pocketWebpages
}

function pocketClean {
  cd "$WEBDIR"
  if [ -d workpocket ]; then
    touch workpocket/dummy
    rm -rf workpocket/*
  else
    mkdir workpocket
  fi
}

function pocketWork {
  mkdir "$WEBDIR/workpocket/source"
  cd "$WEBDIR/source"
  local IMGS; IMGS="$(ls i-* 2>/dev/null || true)"
  for IMG in $IMGS; do
    ln -s "$WEBDIR/source/$IMG" "$WEBDIR/workpocket/source/$IMG"
  done
  for WEB in $(webs); do
    mkdir "$WEBDIR/workpocket/$WEB"
    cd "$WEBDIR/$WEB"
    local IMGS; IMGS="$(ls i-* 2>/dev/null || true)"
    for IMG in $IMGS; do
      ln -s "$WEBDIR/$WEB/$IMG" "$WEBDIR/workpocket/$WEB/$IMG"
    done
  done
}

function pocketWebpages {
  echo -n "pocket book pages "
  for LANG in $(langs); do
    echo -n "" > "$WEBDIR/workpocket/web-$LANG.inc"
  done
  SECONDS=0
  pocketWebpagesDef
  echo -n "."
  for WEB in $(webs); do
    if [ "$WEB" != "noindex" ]; then
      cp "$WEBDIR/$WEB/$WEB.tex" "$WEBDIR/workpocket/$WEB/$WEB.tex"
      for LANG in $(langs); do
        echo -n "."
        # so far nothing to adjust
        cp "$WEBDIR/$WEB/$WEB-$LANG.tex" "$WEBDIR/workpocket/$WEB/$WEB-$LANG.tex"
        texToPdf "$WEBDIR/workpocket/$WEB" "$WEB-$LANG.tex"
        local N; N=$(pdfPageCount "$WEB-$LANG.pdf")
        for ((I=1; I <= N; I++)); do
          local LINE="\bookWeb{$WEB}{-$LANG}{$I}"
          if [ $I -eq 1 ]; then
            LINE="$LINE\addcontentsline{toc}{\\toctype$WEB}{\\toctitle$WEB}"
          fi
          echo "$LINE" >> "$WEBDIR/workpocket/web-$LANG.inc"
        done
      done
    fi
  done
  echo " $SECONDS secs"
}

function pocketWebpagesDef {
  local REPLACE=0
  while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
    if [[ $LINE == \\documentclass* ]]; then
      REPLACE=1
      cat "$WEBDIR/source/pocket/webpage-doc-def.tex"
    elif [ "$LINE" == "" ]; then
      REPLACE=0
      echo
    elif [ $REPLACE -eq 0 ]; then
      echo "$LINE"
    fi
  done < "$WEBDIR/source/def.tex" > "$WEBDIR/workpocket/source/def.tex"
  cp "$WEBDIR/source/def-stronger.tex" "$WEBDIR/workpocket/source/def-stronger.tex"
  cp "$WEBDIR/source/def-lib.tex" "$WEBDIR/workpocket/source/def-lib.tex"
}

function pdfPageCount {
  local PDFFILE="$1"
  identify "$PDFFILE" 2>/dev/null | wc -l | tr -d ' '
}

function fail {
  echo "$(tput bold)$1$(tput sgr 0)" >&2
  exit 1
}

function success {
  trap - EXIT
}

main "$@"
