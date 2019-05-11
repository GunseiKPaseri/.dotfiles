@echo off
rem cdを調整してから管理者権限で実行せよ

rem Latex latexmk Build設定ファイルをユーザーホームディレクトリに
mklink "C:\Users\%USERNAME%\.latexmkrc" "%CD%\.latexmkrc"

rem VSCode setting.jsonの共有
mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\vscode\settings.json"


rem VSCode 拡張機能のインストール
for /f %%a in (./vscode/extension-list.txt) do (
  code --install-extension %%a
)