---
title: "Hugo 博客一键推送脚本"
description: "创建一个 Windows 批处理脚本，双击即可自动推送 Hugo 博客内容到 GitHub，并自动触发 Cloudflare Pages 部署。"
weight: 5
---

Hugo 博客每次更新内容都要手动执行 `git add`、`git commit`、`git push` 三个命令，很繁琐。本文教你创建一个批处理脚本，**双击即可自动推送**，还能避免 Windows 批处理文件的中文乱码问题。

---

## 一、问题场景

假设你的 Hugo 博客工作流是：

1. 本地写好 Markdown 文章，放在 `content/` 目录下
2. 执行 `git add content/` 添加到暂存区
3. 执行 `git commit -m "新文章"` 提交
4. 执行 `git push` 推送到 GitHub
5. Cloudflare Pages 自动检测到更新，触发构建部署

每次都手动敲三行命令很烦，尤其是**一天可能更新好几次**的时候。

---

## 二、创建批处理脚本

### 2.1 最简单的版本

在你的 Hugo 博客根目录（比如 `C:\Users\yourname\my-book-blog`）新建 `push-now.bat`：

```bat
@echo off
cd /d "你的博客路径"
git add content/
git commit -m "auto push %date% %time:~0,5%"
git push
pause
```

双击运行，看到 `Press any key to continue...` 说明执行成功。

### 2.2 加上中文提示（推荐）

```bat
@echo off
cd /d "你的博客路径"
echo 正在添加文件...
git add content/
echo 正在提交...
git commit -m "auto push %date% %time:~0,5%"
echo 正在推送到 GitHub...
git push
echo 成功！已推送到 GitHub
pause
```

这样执行过程一目了然。

---

## 三、解决批处理文件中文乱码问题

### 3.1 问题现象

你在批处理文件里写了中文 `echo 正在推送到 GitHub...`，双击运行后变成：

```
'鍒?GitHub...' 不是内部或外部命令
```

这是因为 **Windows 的 cmd.exe 默认使用 GBK 编码**，而很多编辑器（包括记事本保存时）默认用 UTF-8，导致中文被错误解析，命令被截断。

### 3.2 根本原因

| 组件 | 默认编码 | 问题 |
|------|---------|------|
| Windows cmd.exe | GBK (CP936) | 只能正确读取 ANSI/GBK 文件 |
| 记事本（Win10+） | UTF-8 无 BOM | 中文在 cmd 里乱码 |
| VS Code 默认 | UTF-8 无 BOM | 中文在 cmd 里乱码 |

### 3.3 解决方法

**方法一：用记事本另存为 ANSI 编码**

1. 用记事本打开 `.bat` 文件
2. 点击 **文件 → 另存为**
3. 编码选择 **ANSI**
4. 保存覆盖原文件

**方法二：用命令行工具自动写入 GBK 编码**

如果你用的是 OpenClaw/QClaw，可以用 `qclaw-text-file` 技能：

```powershell
python "C:\Program Files\QClaw\resources\openclaw\config\skills\qclaw-text-file\scripts\write_file.py" `
  --path "你的博客路径\push-now.bat" `
  --content-file "临时文件路径"
```

这个脚本会**自动检测文件内容和当前系统**，Windows 上 `.bat` 含中文时自动使用 GBK 编码写入。

---

## 四、脚本进阶：只在有改动时才提交

有时候你点太快，但内容其实没变化，会出现：

```
no changes added to commit
Everything up-to-date
```

改用这个版本，**先检查是否有改动**：

```bat
@echo off
cd /d "你的博客路径"
git add content/

REM 检查是否有改动
git status --short --porcelain | findstr /v "^?? public/" | findstr /v "^ M public/" > nul
if errorlevel 1 (
    echo 内容无变化，无需提交
    pause
    exit /b 0
)

echo 正在提交内容变更...
git commit -m "auto push %date% %time:~0,5%"
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
```

这个版本会：
- 检查 `git status` 是否有改动
- 排除 `public/` 目录（Hugo 构建产物，通常不需要提交）
- 分支判断，输出不同的中文提示
- **每个分支都有 `pause`**，确保你能看清执行结果

---

## 五、创建桌面快捷方式

为了更方便，可以创建一个桌面快捷方式：

1. 右键桌面 → **新建 → 快捷方式**
2. 对象位置填：`cmd.exe /c "C:\你的博客路径\push-now.bat"`
3. 命名为"推送博客"
4. 右键快捷方式 → **属性** → **更改图标**，选个顺眼的

以后双击桌面图标就能一键推送了！

---

## 六、常见问题

**Q：双击脚本闪退，看不到执行结果？**
A：脚本末尾缺少 `pause` 命令，加上即可。

**Q：提示"系统找不到指定的路径"？**
A：检查 `cd /d` 后的路径是否正确，路径有空格要用双引号包裹。

**Q：中文显示乱码怎么办？**
A：确保 `.bat` 文件用 GBK/ANSI 编码保存（见本文第三节）。

**Q：提示 `git: command not found`？**
A：Git 未安装或未添加到环境变量 PATH，参考 [Windows 10 从零搭建 Hugo 博客]({{< relref "/docs/jiaocheng/windows10-hugo-boke-daotan/" >}}) 安装 Git。

**Q：推送时提示需要登录 GitHub？**
A：配置 Git 用户名和邮箱，或使用 Personal Access Token/SSH Key 认证。

---

## 总结

创建一个简单的批处理脚本：

```
编写 push-now.bat（GBK 编码）
    ↓
放到 Hugo 博客根目录
    ↓
双击运行 → 自动执行 add + commit + push
    ↓
Cloudflare Pages 自动部署
    ↓
博客更新完成！
```

从此告别手动敲命令，**写作 → 双击推送 → 自动上线**，效率拉满！
