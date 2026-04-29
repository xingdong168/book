@echo off
cd /d "C:\Users\Zhang\.qclaw\workspace\my-book-blog"
git add content/
git status --short --porcelain | findstr /v "^?? public/" | findstr /v "^ M public/" > nul
if errorlevel 1 (
    echo 内容无变化，无需提交
    pause
    exit /b 0
)
echo 正在提交内容变更...
git commit -m "%~1"
if errorlevel 1 (
    echo 错误：提交失败
    pause
    exit /b 1
)
echo 正在推送到 GitHub...
git push
if errorlevel 1 (
    echo 错误：推送失败
    pause
    exit /b 1
)
echo 成功！已推送到 GitHub
pause
exit /b 0
