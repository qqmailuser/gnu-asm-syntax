@echo off
setlocal EnableDelayedExpansion

:: 清空 build 目录
if exist build (
    rd /s /q build
    if errorlevel 1 (
        echo 错误：无法清空build目录
        goto :error
    )
)
mkdir build
if errorlevel 1 (
    echo 错误：无法创建build目录
    goto :error
)

:: 编译插件
call vsce package -o build
if errorlevel 1 (
    echo 错误：插件编译失败
    goto :error
)

:: 查找最新的 .vsix 文件并安装
set "found=0"
for /f "delims=" %%i in ('dir /b /o:-d "build\*.vsix"') do (
    set "found=1"
    echo 正在安装: %%i
    call code --install-extension "build\%%i"
    if errorlevel 1 (
        echo 错误：插件安装失败
        goto :error
    )
    goto :done
)

if !found!==0 (
    echo 错误：未找到编译后的.vsix文件
    goto :error
)

:done
echo 安装完成
goto :exit

:error
echo 操作未完成，请检查以上错误信息
pause
exit /b 1

:exit
pause
exit /b 0

