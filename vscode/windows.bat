@echo off
rem cd�𒲐����Ă���Ǘ��Ҍ����Ŏ��s����


mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%CD%\settings.json"


rem �g���@�\�̃C���X�g�[��
for /f %%a in (extension-list) do (
  code --install-extension %%a
)