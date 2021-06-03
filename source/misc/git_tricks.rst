Git 使用技巧
======================================


收集一些偶尔会用到，但是不想看帮助文档的 Git 使用技巧。


------


清空历史提交
-----------------------------------------

随着提交越来越多，仓库体积也会越来越大。对于个人维护的项目，如果想要清理过去所有提交以减小仓库体积，可以使用下面这种 `简单粗暴的方法 <https://zhuanlan.zhihu.com/p/73029640>`_ ：

#. 创建孤立分支并将当前提交的文件检出到新分支： ``git checkout --orphan <newBranch>``
#. 添加所有文件： ``git add .``
#. 提交更改： ``git commit``
#. 删除原分支： ``git branch -D master``
#. 重命名新分支： ``git branch -m master``
#. 强制提交到远程分支： ``git push -f origin master``

.. warning::
    这种方法简单粗暴，会不可恢复地删除过往历史，在执行该操作前请做好备份。



提取特定版本的文件
-----------------------------------------

可以采取下面的命令将特定版本中的某个文件提取出来，并写入到一个新文件中：

.. code-block:: bash

    git show <comment-id>:<filename> > <newfilename>        # 用法
    git show 7926ba:spdoc.rst > spdoc.temp.rst              # 示例


.. note::
    需要准确知道待提取的文件在对应版本下的名字。对文件夹内的文件，应当以相对路径的形式给出。


保存 HTTP 帐号密码
-----------------------------------------

如果使用 HTTP 的方式克隆仓库，在每次提交代码到远程仓库时都需要提供帐号和密码，这无疑是个繁琐的操作。为了将密码保存在本地，可以使用 `储存凭证 <https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%87%AD%E8%AF%81%E5%AD%98%E5%82%A8#_credential_caching>`_ 的功能：

.. code-block:: bash

    git config --global credential.helper store