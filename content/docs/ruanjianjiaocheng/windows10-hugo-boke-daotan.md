---
title: "Windows 10 从零搭建 Hugo 博客"
description: "手把手教你在 Windows 10 上用 Hugo 搭博客，源码托管在 GitHub，全球 CDN 加速通过 Cloudflare Pages 部署，完全免费。"
weight: 4
---

很多新手想做个人博客，又不想花钱买服务器。本文手把手教你在 Windows 10 上用 Hugo 搭博客，源码免费托管在 GitHub，**全球 CDN 加速的站点通过 Cloudflare Pages 部署，完全免费**。

## 一、什么是 Hugo？

Hugo 是一个用 Go 语言写的**静态网站生成器**。你写 Markdown，它生成 HTML。速度快、主题多、无数据库，托管在 GitHub 上零成本。

**所需工具清单：**

| 工具 | 用途 | 价格 |
|------|------|------|
| Hugo | 网站生成器 | 免费开源 |
| Git | 版本管理 | 免费开源 |
| GitHub | 代码托管 | 免费 |
| Cloudflare Pages | 网站托管+CDN | 免费 |

---

## 二、安装 Hugo（Windows 10）

### 2.1 安装 Git

如果没有安装 Git，先装它：

1. 打开 https://git-scm.com/download/win
2. 下载 `Git-2.x.x-64-bit.exe`，双击安装
3. **全程下一步即可**，默认选项足够用
4. 安装完成后，右键桌面任意位置，菜单里出现 **"Git Bash Here"** 说明安装成功

### 2.2 安装 Hugo

**方法一：二进制直接下载（推荐，最简单）**

1. 打开 https://github.com/gohugoio/hugo/releases
2. 找到最新版本的 `hugo_extended_0.xxx.x_windows-amd64.zip`（**带 extended 字样的版本**，支持 SCSS/SASS）
3. 解压到 `C:\Hugo` 目录下（新建文件夹）
4. 确认 `C:\Hugo\hugo.exe` 存在

**方法二：winget 安装**

打开 PowerShell（管理员），运行：

```powershell
winget install HugoHugo.Extended
```

### 2.3 配置环境变量

1. 按 `Win + S`，搜索 **"环境变量"**，打开"编辑系统环境变量"
2. 点击 **"环境变量"** 按钮
3. 在"系统变量"里找到 `Path`，双击编辑
4. 点击"新建"，添加 `C:\Hugo`（如果用 winget 安装则是 `C:\Users\你的用户名\AppData\Local\Programs\Hugo`）
5. 确定保存

**验证安装：**
打开 PowerShell 或 Git Bash，运行：

```powershell
hugo version
```

看到类似 `hugo v0.123.0+extended` 说明安装成功。

---

## 三、创建博客项目

### 3.1 生成新站点

打开 Git Bash 或 PowerShell，进入你想放博客的目录（比如桌面），运行：

```powershell
cd Desktop
hugo new site myblog
cd myblog
```

Hugo 会生成如下目录结构：

```
myblog/
├── archetypes/      # 内容模板
├── content/         # 你的文章放这里
├── layouts/         # 页面模板
├── static/          # 静态文件（图片等）
├── themes/          # 博客主题
├── config.toml      # 网站配置文件
└── hugo.toml        # Hugo新版本用这个
```

### 3.2 安装主题（以 PaperMod 为例）

```powershell
cd myblog
git init
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

### 3.3 启用主题

编辑 `hugo.toml`（或 `config.toml`），写入：

```toml
baseURL = "https://example.com/"
languageCode = "zh-cn"
title = "我的博客"
theme = "PaperMod"
```

### 3.4 创建第一篇文章

```powershell
hugo new posts/hello-world.md
```

用记事本或 VS Code 打开 `content/posts/hello-world.md`，编辑内容：

```markdown
---
title: "Hello World"
date: 2026-04-23
draft: false
---

欢迎来到我的博客！这是第一篇文章。
```

### 3.5 本地预览

```powershell
hugo server
```

打开浏览器访问 **http://localhost:1313**，看到博客首页，说明一切正常。

---

## 四、GitHub 托管

### 4.1 创建 GitHub 仓库

1. 登录 https://github.com
2. 点击右上角 **"+" → New repository**
3. Repository name 填 `myblog`
4. 选择 **Public**
5. 点击 **Create repository**

### 4.2 初始化本地 Git 并推送到 GitHub

在 Git Bash 里（确保在 `myblog` 目录下）：

```powershell
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/你的用户名/myblog.git
git push -u origin main
```

> 如果提示未登录 GitHub，先运行 `git config --global user.name "你的用户名"` 和 `git config --global user.email "你的邮箱"`，然后参考下一节配置认证。

### 4.3 配置 GitHub 认证（推荐用 Token）

为了安全，不推荐在命令行存密码。推荐用 GitHub Personal Access Token：

1. GitHub 右上角头像 → **Settings** → 左侧底部 **Developer settings**
2. **Personal access tokens** → **Tokens (classic)** → **Generate new token**
3. 勾选 `repo` 权限
4. 生成后**立刻复制保存**（只显示一次）

以后 push 时，用户名填 GitHub 用户名，密码填这个 token 即可。

---

## 五、Cloudflare Pages 免费部署

Cloudflare Pages 是目前最良心的免费静态网站托管，有以下优点：

- **免费套餐无流量限制**
- **全球 CDN 节点**，访问速度极快
- 支持自定义域名
- 与 GitHub 联动，代码 push 后**自动部署**

### 5.1 注册 Cloudflare 账号

打开 https://dash.cloudflare.com，注册账号（用 GitHub 账号关联登录最方便）。

### 5.2 创建 Pages 项目

1. Cloudflare Dashboard → 左侧菜单 **Workers & Pages**
2. 点击 **Create application** → **Pages** → **Create a project**
3. 选择 **Connect to Git**
4. 授权 GitHub，选择你的 `myblog` 仓库

### 5.3 配置构建设置

| 字段 | 值 |
|------|-----|
| Project name | `myblog` |
| Production branch | `main` |
| Build command | `hugo --gc` |
| Build output directory | `public` |
| Root directory | `/` |

> Hugo 的构建命令是 `hugo`（加 `--gc` 会清理生成的废弃文件）。输出目录默认是 `public`。

### 5.4 获取部署地址

部署完成后，Cloudflare 会给你一个类似 `https://myblog.pages.dev` 的地址。打开看看，博客已经上线了！

### 5.5 绑定自定义域名（可选）

如果你有域名，想用自己域名访问：

1. Pages 项目 → **Custom domains** → **Set up a custom domain**
2. 输入你的域名，按提示在域名 DNS 处添加 CNAME 记录指向 `myblog.pages.dev`
3. Cloudflare 会自动申请免费 SSL 证书，全站 HTTPS

---

## 六、自动部署：改代码后自动更新网站

配置好 GitHub + Cloudflare Pages 联动后，以后写博客的流程变成：

```
写文章（本地 Markdown）
    ↓
git add . → git commit -m "新文章" → git push
    ↓
Cloudflare Pages 自动检测到新代码
    ↓
自动执行 hugo 构建
    ↓
网站自动更新上线（通常 1-2 分钟）
```

完全自动化，**不用手动上传、不用登录任何后台**。

---

## 七、常见问题

**Q：Hugo server 启动后浏览器打不开 localhost？**
A：确认防火墙没拦截，或者试试 `hugo server --bind 0.0.0.0`。

**Q：Push 到 GitHub 提示权限错误？**
A：用 Personal Access Token 代替密码，或者配置 SSH Key。

**Q：Cloudflare Pages 部署失败？**
A：检查 Build command 是否正确（是 `hugo --gc`，不是 `hugo server`）。

**Q：网站部署后样式乱了？**
A：Hugo 主题里 `public/` 目录要和 `baseURL` 配置一致，检查 `hugo.toml` 里的 `baseURL` 是否以 `/` 结尾。

**Q：Cloudflare Pages 域名被微信拦截了怎么办？**
A：申诉地址：https://developers.weixin.qq.com/community/mitigatement/index，填写你的域名，通常1-3个工作日解封。

---

## 总结

整个流程梳理一下：

```
Windows 安装 Hugo + Git
    ↓
本地创建博客，写 Markdown 文章
    ↓
GitHub 托管源码
    ↓
Cloudflare Pages 自动构建 + 免费托管 + CDN
    ↓
独立博客访问：https://xxx.pages.dev 或自定义域名
```

全程**零服务器费用**，Hugo 生成静态文件，GitHub 存代码，Cloudflare 做 CDN 和托管，性价比极高。赶紧动手试试吧！
