# Module Tutorials

是一种环境变量的管理工具，使用 module 命令能够有效的修改自己的环境变量 **`PATH`**、 **`LIBRARY_PATH`** 等

## Some Notes:

1. 在苏州人工智能研究院的超算上推荐使用 module 来管理环境变量，实验室中也有有自己维护的软件包，加载路径命令为:

    `module use /mnt/lustre/sjtu/shared/tools/cm/modulefiles/`

    希望大家多使用这个里面的软件包，尽量不要使用自己的虚拟环境（方便别人复现工作，可以直接跑写好的脚本）。如果有什么软件缺失，可想设备委员组提交申请添加。

2. 超算中其他可用的 modulefiles：

    `module use /mnt/lustre/cm/shared/modulefiles` (默认已经加载)

    `module use /mnt/lustre/cm/shared/global/modulefiles/dev/`
  
    `module use /mnt/lustre/cm/shared/global/modulefiles/machinelearning/`


## 常用命令

* `module avail` : 查看可用的所有环境模块
* `module list` : 列出所有加载的环境模块
* `module purge` : 卸载所有环境模块
* `module load / add <module>` : **载入** 某个环境模块
* `module unload / rm <module>` : **卸载** 某个环境模块
* `module whatis <module>` : 查看某个环境模块的说明信息
* `module display / show <module>` : 查看某个环境模块的中对环境变量的操作
* `module use <modulefiles path>` : 使用 `<path>` 下定义的 modulefiles 加入 环境模块数据库
* `module unuse <modulefiles path>` : 删除`<path>` 下定义的 modulefiles

## References
Module 文档: https://modules.readthedocs.io/en/stable/index.html


