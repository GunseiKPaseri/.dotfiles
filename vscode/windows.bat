@echo off
rem User以下の設定ファイルのリンクを生成
mklink /D "C:\Users\%USERNAME%\AppData\Roaming\Code\User" "%CD%\User"

rem 拡張機能のインストール
for /f %%a in (extension-list) do (
  code --install-extension %%a
)