---
title: "Zotero 文献管理"
date: 2020-06-20
tags: ["Zotero","文献管理"]
categories: ["好用的软件"]
draft: false
---

说到文献管理软件，大家可能或多或少听说过 [EndNote](https://endnote.com/) 或 [NoteExpress](http://www.inoteexpress.com/) ，这里再跟大家分享 [Zotero](https://www.zotero.org/)，旨在提供一个新的选择，分享开源的强大。这篇文章主要介绍文献管理软件 Zotero 的基本用法，包括：添加题录、获取原文、添加笔记、文献引用、文档整理和数据同步。为了增强数据同步功能，本文还将对坚果云进行补充介绍。

<!--more-->

## Zotero 基本用法

### 安装

从 [Zotero官网](https://www.zotero.org/) 下载安装包可轻松完成安装，下载界面会识别当前浏览器并推荐相应的插件，同样，点击并安装该插件。

{{< image src="./zotero01.png" caption="Zotero 下载页面" width="70%" >}}

安装完成后打开 Zotero，其界面大概可以分为三部分：左侧是用户自定义的文件夹，中部是当前文件夹下收录的题录，右侧则是选中的题录的详细信息。

{{< image src="./zotero02.png" caption="Zotero 主界面" width="70%" >}}

对于 Windows 用户，Zotero 安装时会自动添加 Microsoft Word 插件，在 Word 界面的顶部应当能够看到多出的 Zotero 菜单栏。如果没有，可在 Zotero 的设置中依次找到 `Edit → Preferences → Cite → Word Processors` 并重新安装插件即可。

{{< image src="./zotero03.png" caption="Word 的 Zotero 插件" width="70%" >}}

### 添加题录

为了管理文献，首先需要将文献的题录添加到 Zotero 数据库中，我们可以采用三种方法。首先自然是手动输入，在 Zotero 主界面上部点击绿色圆圈的加号，选择题录的类型（书籍、学位论文、期刊文献等等）即可创建空题录，并在右侧手动输入相关信息即可完成录入，这种无疑是比较麻烦的方法，写在前面自然也是当作炮灰，抛砖引玉。

添加题录的第二种方法就是从文件或剪切板板导入。几乎所有的文献检索网站都支持将文献题录导出，以学校图书馆搜索结果为例，搜索文献并点击引用时，可以将文献题录导出到不同格式（令人惊讶的是居然有标准 Zotero 格式），实际上任意下载一种格式都可以从 Zotero 中正确导入。例如下载 BibTex 格式，将会得到一个 `.bib` 文件。

{{< image src="./zotero04.png" caption="从网站导出题录" width="70%" >}}

在 Zotero 主界面找到 `File → Import...` ，然后选择刚才下载的 `.bib` 文件即可完成导入。可能会有小伙伴觉得使用这种方法一个一个地下载题录再导入很不方便，实际上很多文献检索网站都有批量导出的功能：只要将看中的文献进行标记（不同的网站提示可能不一样，例如有的可以在前面打勾，有的提供"Save Item"选项），然后批量导出，进而可以批量导入到 Zotero 。

如果觉得这样依然比较麻烦，那么第三种方法就是使用之前安装的浏览器插件进行全自动收录。打开文献的网站后，Zotero 的浏览器插件会自动进行识别，识别成功后图标会发生相应改变，例如期刊文献的图标如下图所示。点击插件，选择题录保存的文件夹，点击`Done` 即可。

{{< image src="./zotero05.png" caption="使用 Zotero 插件导入题录" width="70%" >}}

{{< admonition note >}}
该功能在本地使用时需要提前打开 Zotero 软件，或者从插件登陆在线帐号，否则无法顺利导入题录。
{{< /admonition >}}

### 获取原文

如果在导入题录的时候使用的是浏览器插件，且相应的文献通过正常渠道可以免费下载，那么稍等一会儿，你会看到 Zotero 能够自动下载文献并与题录关联，是不是非常棒呢！

如果相关的文献在正常渠道不可以免费下载，那么很遗憾 Zotero 将不会自动下载。假如学校购买了相应数据库，可以手动下载后右键点击题录添加附件将文献原文与题录进行关联。

如果文献在正常渠道不免费，学校又没有买，那只得采用一点非正常渠道咯：[SciHub](https://sci-hub.se/)。为了使用SciHub，你需要知道文献的身份证，即所谓的 DOI，其通常是以 `10.` 开头的字符串，如 `10.1088/0264-9381/33/3/035010` ，一般在文献检索网站都有该信息。得到 DOI 后，我们就可以在 SciHub 进行下载。

{{< admonition info>}}
作为文献收录最全的非正常渠道，SciHub 为科研人员提供了免费的文献，因此也受到官方的封杀。但更多的人认为知识不应当受到限制，因而 SciHub 通过不断更换域名得以维持。例如本文写成时可用的域名为 <https://sci-hub.se/> 。
{{< /admonition >}}

Zotero 作为开源软件，获取 DOI 这种事情麻烦但又常见的事情，当然可以有插件来解决：使用 [Zotero-ShortDOI](https://github.com/bwiernik/zotero-shortdoi) 获取文献 DOI，然后利用 [Zotero-SciHub](https://github.com/ethanwillis/zotero-scihub) 即可获得原文，而这只需要两次鼠标的右键即可完成。

在 Zotero 中安装插件也非常简单：下载相关 `.xpi` 文件，在主界面的 `Tools → Add-ons` 点击齿轮选择从文件安装插件，然后重启软件即可。

{{< image src="./zotero06.png" caption="安装 Zotero 插件" width="70%" >}}

{{< admonition tip >}}
有些浏览器在点击 `.xpi` 文件的链接后不会自动下载，右键该链接并选择"链接保存为..."即可。
{{< /admonition >}}

### 添加笔记

右键题录可以为题录添加笔记，也可以从上部添加笔记的按钮中添加独立笔记。然而 Zotero 自带的笔记功能不支持 Markdown 语法，为了对此功能进行扩充，可以使用 [MarkdownHere](https://github.com/adam-p/markdown-here) 插件。我不打算展开介绍 [Markdown 教程](https://www.runoob.com/markdown/md-tutorial.html)，附以超链接供大家参考。

使用 Markdown 语法编写好笔记后，点击 `File → Markdown Toggle` 即可进行渲染。需要说明的是，如果重新编辑笔记，需要再次点击 `Markdown Toggle` 回到文本模式，编辑完成后重新渲染，否则该功能不会正常工作。


### 文献引用

Zotero 对 Word 的支持使得文献引用非常简单，只需要在 Word 中点击 `Zotero → Add/Edit Citation` ，第一次使用时会提示选择样式，这里不得不再夸一下 Zotero 极为丰富的样式库。例如我们标准格式是由 GB/T7714 规定的，点击添加，并在新弹出的对话框稍作搜索即可下载标准的引用样式，选择即可。以后需要修改样式时可以从 `Edit → Preferences → Cite → Styles` 重新设置。

{{< image src="./zotero07.png" caption="文献引用样式设置" width="70%" >}}

选择好样式之后，软件会自动调出题录数据库，选择题录并回车即可。默认视图下仅有一个搜索框可以根据文献的名字进行搜索，但也可选择经典视图打开题录数据库进行手动选择。

{{< image src="./zotero08.png" caption="插入文献引用" width="70%" >}}

使用 Zotero 插件进行文献引用时，不需要在意操作的先后顺序，Zotero 能够根据引文在文中出现的先后顺序自动对编号进行修改。当文章写完后，在 Word 点击 `Zotero → Add/Edit Bibliography` 即可自动生成参考文献列表，如下图所示。

{{< image src="./zotero09.png" caption="生成参考文献列表" width="70%" >}}

可以看出，文献引用的格式大体上是正确的，但是对多语言支持并不是很好，表现在英文文献作者较多时应当用"et al"，而不能用"等"。进一步，参考文献列表的字体与 Word 的使用有关，可能出现字体大小不对的情况，这都要求我们对参考文献进行手动修改。

手动修改文献列表前建议先对文档进行备份。从 Word 点击 `Zotero → Unlink Citations` ，断开参考文献列表与文献编号的关联（在 EndNote 中称之为格式化，这将使得新插入的参考文献重新从 1 开始编号，因此务必确认参考文献已经全部引用），这样就可以将参考文献列表变成文本，进行修改。

关于参考文献引用，$\\LaTeX$ 的 [gbt7714 宏包](https://www.ctan.org/pkg/gbt7714) 提供了非常好的多语言支持，这里稍微秀一下，相关用法可以参考 $\\LaTeX$ 的学习记录：[自动化引用]({{< ref "../../latex/latex05-cite/index.md" >}}) 。

{{< image src="./zotero10.png" caption="LaTeX 的文献管理示意" width="70%" >}}

### 文档整理

Zotero 自动下载的文献原文默认储存在其数据路径下，并以一些奇怪的文件夹名称进行归类，不利于文献的集中管理。为了将文献原文汇总到一个文件夹，可以使用 [ZotFile](http://zotfile.com/) 插件：它能够跟踪某个文件夹下新增的文件，并将该文件剪切到另一个文件夹，同时进行自定义格式的重命名。因此，我们需要告诉它 Zotero 的默认储存目录，然后让它将该文件夹下新增的文件（自动下载的文献原文）剪切到自定义的文件夹中。应当注意的是，这样做虽然能够完成文件的转移，但是会导致 Zotero 中打开题录附件时出现"附件不存在"的错误，因此还需要进一步将 Zotero 附件的默认位置改为 ZotFile 的目标文件夹。

{{< image src="./zotero11.png" caption="`ZotFile` 插件配置" width="70%" >}}

### 数据同步

注册并登录 Zotero 即可自动同步自身数据文件夹下的数据。根据 [Zotero 同步规则](https://www.zotero.org/support/sync) ，题录和笔记（Zotero 内置的笔记功能）内容不限空间，附件（主要是文献原文）仅提供 300M 免费空间。为了突破附件空间的限制，我们可以选择付费，也可以通过 WebDAV 来进行容量扩展。截止到这个文章最后修改，国内支持 WebDAV 功能的网盘只有坚果云。大家无须叹气，我保证坚果云和 Zotero 一样好用！

### 其他小技巧

- 复制题录：直接鼠标拖拽即可
- 移动题录：按住 `Shift` 后用鼠标进行拖拽
- 查看题录所在收集箱：选中题录后长按 `Alt` (Linux) 或 `Ctrl` (Windows)


## 坚果云扩展同步功能

[坚果云](https://www.jianguoyun.com/) 是一个面向协同合作的云盘，它支持自动同步和版本控制等功能。但是我决定不花精力写太多关于坚果云其他功能的介绍，除非坚果云能够把这一波广告费发给我，哼！


### 安装与使用

从 [坚果云官网](https://www.jianguoyun.com/) 下载安装包后双击安装即可，注册账号之类的东西我想应该不必多少。对于个人用户，免费账户完全够用，并且值得称赞的是，坚果云没有广告！

安装好坚果云之后，我们只需要右键某个文件夹选择坚果云同步即可，如此做，该文件下的文件都能自动同步到坚果云服务器，因此将这个文件夹成为同步文件夹。

与其他网盘不同的是，在联网状态下，坚果云同步文件夹的内容会实时更新以保持与服务器一致。可以将该文件夹共享给团队进行协同工作。协同工作时，为避免冲突，当一个人在修改某一文件时，该文件将会被锁定，其他人不可编辑。当由于网络延迟或断网使得多人编辑的同一文档出现冲突时，坚果云会有冲突提醒，并能够调用差异对比工具辅助进行冲突解决。

同步文件夹下的文件修改后会形成多个版本，用户可以随时提取之前的版本。因此，勒索病毒什么的完全就不用担心，因为同步到了云端，即使当前版本被加密，从云端重新下载最近的版本即可。也就是说，版本控制确保了损失的最小化。

{{< image src="./zotero12.png" caption="坚果云文件历史" width="70%" >}}

下面我们将重点回到使用坚果云扩展 Zotero 的同步功能，可以采用两种方法： WebDAV 同步和直接同步。

### 使用 WebDAV 同步 Zotero 附件

坚果云提供了提供了 WebDAV 接口，那么我们就可以利用坚果云对数据进行同步。从网页进入坚果云的个人账户设置，在安全选项中的第三方软件管理可以看到坚果云服务器地址。点击添加应用，写好备注即可生成第三方接口的密码（有时候叫做授权码）。

{{< image src="./zotero13.png" caption="坚果云 WebDAV 设置" width="70%" >}}

然后打开 Zotero，点击 `Edit → Preferences → Sync` ，将文件同步选项改为 WebDAV，输入坚果云提供的服务器地址，用户账号和刚才生成的第三方接口密码即可。

{{< image src="./zotero14.png" caption="Zotero 同步设置" width="70%" >}}

我在 Zotero 配置坚果云服务器时添加了 `/WebDAV` ，这就创建了单独的文件夹以管理坚果云的 WebDAV 服务，以免与自己的其他文件混淆。在这种方案下，如果使用 ZotFile 将附件剪切到了其他文件夹，则无法同步附件。也就是说，这种方案配置简单，但是与 ZotFile 对文件集中管理的思路不太一致。


### 结合 ZotFile 同步 Zotero 附件

上面提到了 ZotFile 管理文献原文时将文献移动到了指定的文件夹，直接用坚果云同步这个文件夹不就可以了嘛：右键收录文献的文件夹，点击"使用坚果云同步"即可。

综上所述，如果你想图简单而不在意文献原文的汇总整理，那么就不需要使用 ZotFile 插件，直接采用坚果云 WebDAV 接口进行同步；如果你有一定的强迫症并愿意折腾，那么就可以使用 ZotFile 转移文献原文后用坚果云的同步文件夹进行同步。
