@echo off
rem cd�𒲐����Ă���Ǘ��Ҍ����Ŏ��s����
rem vimrc�����[�U�[�z�[���f�B���N�g����
mklink "C:\Users\%USERNAME%\.vimrc" "%CD%\.vimrc"
mklink /D "C:\Users\%USERNAME%\.vim\" "%CD%\.vim\"
rem Latex latexmk Build�ݒ�t�@�C�������[�U�[�z�[���f�B���N�g����
mklink "C:\Users\%USERNAME%\.latexmkrc" "%CD%\.latexmkrc"
rem GitBash�p�ݒ�
mklink "C:\Users\%USERNAME%\.minttyrc" "%CD%\.minttyrc"

rem VSCode setting.json�̋��L
mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\vscode\settings.json"


rem VSCode �g���@�\�̃C���X�g�[��
for /f %%a in (./vscode/extension-list.txt) do (
  code --install-extension %%a
)