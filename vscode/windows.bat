@echo off
rem User�ȉ��̐ݒ�t�@�C���̃����N�𐶐�
mklink /D "C:\Users\%USERNAME%\AppData\Roaming\Code\User" "%CD%\User"

rem �g���@�\�̃C���X�g�[��
for /f %%a in (extension-list) do (
  code --install-extension %%a
)