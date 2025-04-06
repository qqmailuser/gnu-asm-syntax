@echo off
setlocal EnableDelayedExpansion

:: ��� build Ŀ¼
if exist build (
    rd /s /q build
    if errorlevel 1 (
        echo �����޷����buildĿ¼
        goto :error
    )
)
mkdir build
if errorlevel 1 (
    echo �����޷�����buildĿ¼
    goto :error
)

:: ������
call vsce package -o build
if errorlevel 1 (
    echo ���󣺲������ʧ��
    goto :error
)

:: �������µ� .vsix �ļ�����װ
set "found=0"
for /f "delims=" %%i in ('dir /b /o:-d "build\*.vsix"') do (
    set "found=1"
    echo ���ڰ�װ: %%i
    call code --install-extension "build\%%i"
    if errorlevel 1 (
        echo ���󣺲����װʧ��
        goto :error
    )
    goto :done
)

if !found!==0 (
    echo ����δ�ҵ�������.vsix�ļ�
    goto :error
)

:done
echo ��װ���
goto :exit

:error
echo ����δ��ɣ��������ϴ�����Ϣ
pause
exit /b 1

:exit
pause
exit /b 0

