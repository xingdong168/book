@echo off
cd /d C:\Users\Zhang\.qclaw\workspace\my-book-blog
echo 正在添加文件...
git add content/
echo 正在提交...
git commit -m "auto push %date% %time:~0,5%"
echo 正在推送到 GitHub...
git push
echo 成功！已推送到 GitHub
pause
