@echo off
rem cd�𒲐����Ă���Ǘ��Ҍ����Ŏ��s����
rem vimrc�����[�U�[�z�[���f�B���N�g����
del "C:\Users\%USERNAME%\.vimrc"
mklink "C:\Users\%USERNAME%\.vimrc" "%CD%\d\.vimrc"
rmdir "C:\Users\%USERNAME%\.vim\"
mklink /D "C:\Users\%USERNAME%\.vim\" "%CD%\d\.vim\"
rem Latex latexmk Build�ݒ�t�@�C�������[�U�[�z�[���f�B���N�g����
del "C:\Users\%USERNAME%\.latexmkrc"
mklink "C:\Users\%USERNAME%\.latexmkrc" "%CD%\d\.latexmkrc"
rem GitBash�p�ݒ�
del "C:\Users\%USERNAME%\.minttyrc"
mklink "C:\Users\%USERNAME%\.minttyrc" "%CD%\d\.minttyrc"

rem VSCode setting.json�̋��L
del "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json"
mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\d\vscode\settings.json"

