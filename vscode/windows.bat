@echo off
rem cdを調整してから管理者権限で実行せよ


rem 拡張機能のインストール
for /f %%a in (extension-list) do (
  code --install-extension %%a
)

mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\settings.json"
