@echo off
rem cdを調整してから管理者権限で実行せよ
rem vimrcをユーザーホームディレクトリに
del "C:\Users\%USERNAME%\.vimrc"
mklink "C:\Users\%USERNAME%\.vimrc" "%CD%\dot_vimrc"
rmdir "C:\Users\%USERNAME%\.vim\"
mklink /D "C:\Users\%USERNAME%\.vim\" "%CD%\dot_vim\"
rem Latex latexmk Build設定ファイルをユーザーホームディレクトリに
del "C:\Users\%USERNAME%\.latexmkrc"
mklink "C:\Users\%USERNAME%\.latexmkrc" "%CD%\d\.latexmkrc"
rem GitBash用設定
del "C:\Users\%USERNAME%\.minttyrc"
mklink "C:\Users\%USERNAME%\.minttyrc" "%CD%\dot_minttyrc"

rem VSCode setting.jsonの共有
del "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json"
mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\d\vscode\settings.json"

