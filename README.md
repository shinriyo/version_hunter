# Version Hunter

## 使い方

### スクリプトと同じディレクトリに、以下のように apps.txt を用意します。

```
# Google Play (アプリ名とURLのセット)
My Google App 1|https://play.google.com/store/apps/details?id=com.example.app1
My Google App 2|https://play.google.com/store/apps/details?id=com.example.app2

# Apple App Store
My iOS App 1|https://apps.apple.com/jp/app/id1234567890
My iOS App 2|https://apps.apple.com/jp/app/id0987654321

# Microsoft Store
My Windows App 1|https://apps.microsoft.com/store/detail/app-id-1
My Windows App 2|https://apps.microsoft.com/store/detail/app-id-2
```

## 実行

```
sh version_hunter.sh
```

## 出力例

```
App Version Log - 2024-11-24
My Google App 1 (Google Play): 1.2.3
My Google App 2 (Google Play): 4.5.6
My iOS App 1 (App Store): 2.1.0
My iOS App 2 (App Store): 3.0.1
My Windows App 1 (Microsoft Store): 5.4.3
My Windows App 2 (Microsoft Store): 6.7.8
```
