@echo off
rem cd�𒲐����Ă���Ǘ��Ҍ����Ŏ��s����
rem vimrc�����[�U�[�z�[���f�B���N�g����
del "C:\Users\%USERNAME%\.vimrc"
mklink "C:\Users\%USERNAME%\.vimrc" "%CD%\.vimrc"
rmdir "C:\Users\%USERNAME%\.vim\"
mklink /D "C:\Users\%USERNAME%\.vim\" "%CD%\.vim\"
rem Latex latexmk Build�ݒ�t�@�C�������[�U�[�z�[���f�B���N�g����
del "C:\Users\%USERNAME%\.latexmkrc"
mklink "C:\Users\%USERNAME%\.latexmkrc" "%CD%\.latexmkrc"
rem GitBash�p�ݒ�
del "C:\Users\%USERNAME%\.minttyrc"
mklink "C:\Users\%USERNAME%\.minttyrc" "%CD%\.minttyrc"

rem VSCode setting.json�̋��L
del "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json"
mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\vscode\settings.json"

