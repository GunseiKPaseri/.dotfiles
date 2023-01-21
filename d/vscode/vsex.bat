
rem VSCode 拡張機能のインストール
for /f %%a in (./vscode/extension-list.txt) do (
  code --install-extension %%a
)