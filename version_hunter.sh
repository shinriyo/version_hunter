#!/bin/bash

# apps.txt のパス
APPS_FILE="apps.txt"

# ログファイルの指定
LOG_FILE="version_log.txt"

# Google Playのバージョン取得関数
get_google_play_version() {
    URL=$1
    # HTMLソースを取得
    HTML=$(curl -s "$URL")

    # 必要なデータを抽出
    VERSION=$(echo "$HTML" | sed -nE 's/.*\[[^,]*,[^,]*,[^,]*,\"([0-9]+\.[0-9]+\.[0-9]+)\".*/\1/p' | head -n 1)

    if [ -n "$VERSION" ]; then
        echo $VERSION
    else
        # 必要なデータを抽出
        VERSION=$(echo "$HTML" | sed -nE 's/.*\[\[\["([0-9]+\.[0-9]+\.[0-9]+)"\]\].*/\1/p')
        echo $VERSION
    fi
}

# App Storeのバージョン取得関数
get_app_store_version() {
    URL=$1
    APP_ID=$(echo "$URL" | sed -n 's/.*id\([0-9]*\).*/\1/p')
    API_URL="https://itunes.apple.com/lookup?id=${APP_ID}"
    VERSION=$(curl -s "$API_URL" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
    echo "$VERSION"
}

# Microsoft Storeのバージョン取得関数
get_microsoft_store_version() {
    URL=$1
    VERSION=$(curl -s "$URL" | sed -n 's/.*<meta name="version" content="\([^"]*\)".*/\1/p')
    echo "$VERSION"
}

# ログファイル初期化
echo "App Version Log - $(date)" > "$LOG_FILE"

# apps.txt を読み込んで処理
while IFS= read -r line; do
    # 空行やコメントをスキップ
    [[ -z "$line" || "$line" == \#* ]] && continue

    # アプリ名とURLを分割
    APP_NAME=$(echo "$line" | cut -d'|' -f1)
    URL=$(echo "$line" | cut -d'|' -f2)

    # ストアタイプを判定してバージョン取得
    if [[ "$URL" == *"play.google.com"* ]]; then
        VERSION=$(get_google_play_version "$URL")
        STORE="Google Play"
    elif [[ "$URL" == *"apps.apple.com"* ]]; then
        VERSION=$(get_app_store_version "$URL")
        STORE="App Store"
    elif [[ "$URL" == *"apps.microsoft.com"* ]]; then
        VERSION=$(get_microsoft_store_version "$URL")
        STORE="Microsoft Store"
    else
        VERSION="Unknown"
        STORE="Unknown"
    fi

    # ログに記録
    echo "$APP_NAME ($STORE): $VERSION" | tee -a "$LOG_FILE"

done < "$APPS_FILE"
