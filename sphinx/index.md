# Sphinx 搭建博客


Sphinx 是一个静态网页生成工具，可以将 reStructuredText 转化为静态网站，特别适合教程、说明等文档的编写。本文介绍如何基于此部署自己的博客。

<!--more-->

## 概述

静态网页可以由 [Sphinx](https://www.sphinx-doc.org/zh_CN/master/) 编译而成，源代码托管于 [GitHub](https://github.com/iChunyu/iChunyu.github.io/) 仓库，生成的静态网站部署在 [Read the Docs](https://readthedocs.org/)。以这种方式建立网站的主要步骤为：

- 安装并初始化 Sphinx 项目；
- 在 GitHub 建立文档源码托管仓库；
- 从 Read the Docs 导入 Sphinx 项目。

## Sphinx 的安装与配置

在 Linux 系统上，可以通过以下命令安装 Sphinx:

``` bash
pip install sphinx sphinx_rtd_theme
```

其中 `sphinx` 是主程序，`sphinx_rtd_theme` 是很常用的一个主题，更多主题可以在 [Sphinx Themes Gallery](https://sphinx-themes.org) 查看。

新建文件夹用于存放 Sphinx 文档的源码。在该文件夹打开终端后，运行 `sphinx-quickstart` 以快速创建 Sphinx 工程。依次会出现以下提示：

1.  `> Separate source and build directories (y/n) [n]:`

    是否将源码和编译后的文件分开？为了更好地管理文件，最好将它们分开，输入
    `y` 以确认；

2.  `> Project name:`

    根据自己的爱好给项目起个名字吧，我的嘛，就叫"某春雨的后花园"；

3.  `> Author name(s):`

    作者的名字，喜欢用真名或者笔名都可以，我就叫大春雨吧；

4.  `> Project release []:`

    项目的发行版本？直接回车跳过吧！

5.  `> Project language [en]:`

    项目的语言默认是英文，而我想使用简体中文，于是输入 `zh_CN` ，回车，搞定！

项目初始化之后，文件夹将具有以下结构：

```text
.
├── build/
├── make.bat
├── Makefile
└── source/
   ├── conf.py
   ├── index.rst
   ├── _static/
   └── _templates/
```

初始话的文件夹为空，这时只需要在该项目的根目录下运行 `make html` 就可以生成最基本的静态页面样板，生成的结果可以在 `build/html/index.html`
中查看。

默认的主题似乎不是很好看的样子，那我们就在 `source/conf.py` 中进行修改吧，大概在第 54 行，改！

``` python
html_theme = 'sphinx_rtd_theme'
```

至此，基本的设置就完成了。

## GitHub 源码托管

代码托管涉及到 [Git](https://git-scm.com/) 的使用，基本规则可以参考 [Git 版本控制]({{< ref "../../tool/learnGit/index.md" >}}) 。这里我们只需要在 GitHub 建立仓库，例如 `helps` 。然后在 Sphinx 项目目录下运行以下命令即可。

``` bash
git init
echo "build/" > .gitignore
git add .
git commit -m 'Initial commit'
git remote add origin git@github.com:iChunyu/helps.git
git push -u origin main
```

上述各条命令的功能简述如下：

1.  初始化 Git 仓库；
2.  设置 Git 忽略 `build/` 文件夹；
3.  将所有文件保存到暂存区；
4.  将暂存区文件提交到 Git 仓库；
5.  添加远程分支，注意自己远程分支的地址；
6.  将当前分支推送到远程分支。

## Read the Docs 网站部署

注册并登录 Read the Docs ，与发现有个 `Import a Project` 按钮，点之。根据提示与 GitHub 绑定，然后会刷新出仓库列表，选择保存 Sphinx 项目的仓库，然后根据提示进行设置，完成导入即可。

在 Read the Docs 导入项目之后，会在相应的 GitHub 仓库部署一个钩子。这个钩子的功能就是检测该仓库的提交，每当有新的提交，Read the Docs 将会根据最新的仓库重新编译 Sphinx 项目，并部署在项目所设置的网站上。

这样以来就基本配置好了，剩下的只要依据 [reStructuredText](http://www.pythondoc.com/sphinx/index.html) 的规则编写文档即可。当然，Sphinx 也可以通过插件提供 Markdown 支持。reStructuredText 具有很同意的风格和完善的扩展，但使用稍微复杂一点点；而 Markdown 虽然简单，却存在很多“方言”，不同的编辑器会有不同的特性。各位可以自行取舍。

## GitHub Pages 网站部署

生成的静态网站还可以直接由 GitHub Pages 进行托管，但需要遵循相关规则：

1. 生成的静态网站所有内容都要放置在根目录 `docs/` 文件夹下：`cp -r build/html/* docs/`；
2. 在根目录和 `docs/` 下添加 `.nojekyll` 文件以取消 Jekyll 支持： `tuoch .nojekyll`；
3. 在 GitHub 仓库设置的 Pages 选项中修改文件夹为 `docs/` 。

