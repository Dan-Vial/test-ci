DOMAIN="dvpro.fr"
APPROOT="apps_nodejs/app_dvpro"
APPTMP="$APPROOT/tmp"
APPOLD="~/$APPTMP/$(date +%s%N)"
REPO="test-ci"
OWNER="Dan-Vial"
URL_DOWNLOAD=""
RELEASE_LATEST=""
RELEASE_CURRENT="$(cat $(dirname $0)/../../version.txt)"
FILE_NAME=""

create_app() {
  cloudlinux-selector create --json --interpreter nodejs --app-root "$APPROOT" --domain "$DOMAIN" --app-uri "$APPROOT"
}

npmi_app() {
  cloudlinux-selector install-modules --json --interpreter nodejs --domain "$DOMAIN" --app-root "$APPROOT"
}

npmrun_app() {
# $1="script name" $2="script_opt1" $3="script_opt2"
  cloudlinux-selector run-script --json --interpreter nodejs --domain "$DOMAIN" --app-root "$APPROOT" --script-name "$1" -- --script_opt1 --script_opt2 "$2" "$3"
}

start_app() {
  cloudlinux-selector start --json --interpreter nodejs --domain "$DOMAIN" --app-root "$APPROOT"
}

stop_app() {
  cloudlinux-selector stop --json --interpreter nodejs --domain "$DOMAIN" --app-root "$APPROOT"
}

old_app() {
# old app save in tmp
  mkdir "$APPOLD" "$APPOLD/public"
  mv "~/$APPROOT/public/assets" "$APPOLD/public/assets"
  mv "~/$APPROOT/public/index.html" "$APPOLD/public/index.html"
  mv "" ""
}

# install_app() {
# # first install

# }

# update_app() {
# }

test_version() {
# Extraction des parties principales
  version_core=$(echo "$1" | sed -E 's/^v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
  major=$(echo "$version_core" | cut -d. -f1)
  minor=$(echo "$version_core" | cut -d. -f2)
  patch=$(echo "$version_core" | cut -d. -f3)

  other_version_core=$(echo "$2" | sed -E 's/^v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
  other_major=$(echo "$other_version_core" | cut -d. -f1)
  other_minor=$(echo "$other_version_core" | cut -d. -f2)
  other_patch=$(echo "$other_version_core" | cut -d. -f3)

# test version 
  if [ "$major" -ge "$other_major" ]; then 
    if [ "$minor" -ge "$other_minor" ]; then 
      if [ "$patch" -ge "$other_patch" ]; then 
        echo "Application déjat à jour."
        exit 1
      fi
    fi
  fi

  echo "go update."
}

download_app() {
  echo "Start download..."
  
  # un test si bien download
  JSON="$(curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28"   https://api.github.com/repos/$OWNER/$REPO/releases/latest)"

  RELEASE_LATEST="$(node -e "let url_download = JSON.parse(\`$JSON\`); console.log(url_download.tag_name)")"

  echo "$RELEASE_CURRENT" "$RELEASE_LATEST"
  test_version "$RELEASE_CURRENT" "$RELEASE_LATEST"

  FILE_NAME="$(node -e "let url_download = JSON.parse(\`$JSON\`); console.log(url_download.assets[0].name)")"

  URL_DOWNLOAD="$(node -e "let url_download = JSON.parse(\`$JSON\`); console.log(url_download.assets[0].browser_download_url)")"

  curl -L "$URL_DOWNLOAD" > "$FILE_NAME"
  
  echo "Download success."
}