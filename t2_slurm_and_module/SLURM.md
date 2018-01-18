# SLURM Tutorials 
## 资源调度和申请
### Gres
SLURM 采用Generic Resource (GRES) 管理GPU. 为了提高资源利用率,苏州超算每一
块卡对应2个GRES的资源.

经过GRES的调度之后,`CUDA_VISIBLE_DEVICES`会自动设置,多卡任务不需要再对GPU进
行选择,把任务分配到你能看到的所有GPU上即可.

### 示例:
```bash
sbatch -p 4gpuq --gres=gpu:2 # 申请2块GPU,CUDA_VISIBLE_DEVICES=0,1
sbatch -p 4gpuq --gres=gpu:1 # 申请1块GPU,CUDA_VISIBLE_DEVICES=0

## 如果两个任务分别申请1个GPU资源
sbatch -p 4gpuq --gres=gpu:1 # CUDA_VISIBLE_DEVICES=0
sbatch -p 4gpuq --gres=gpu:1 # 可能申请到同一块卡CUDA_VISIBLE_DEVICES=0/1/2/3
```
## 命令概览

| 命令 | 功能 |
| -------- | -------- |
| [sinfo](#sinfo)    | 查看集群状态与计算资源 |
| [squeue](#squeue)   | 查看 SLURM 调度队列中的任务信息 |
| [sbatch](#sbatch)   | 提交任务脚本，任务在后台运行 |
| [sattach](#sattach)  | 连接上一个正在运行的任务 |
| [srun](#srun)     | 实时交互式提交任务，当前窗口阻塞至任务完成 |
| [scancel](#scancel)  | 取消任务 |
| [sstat](#sstat)    | 查看正在运行任务的状态信息|
| [scontrol](#scontrol) | 详细的监控与调整任务信息|
| [sacct](#sacct)    | 查看任务的统计信息 |



## 常用命令 details

### <span id="sinfo"> **sinfo**: 查看集群的计算资源 </span>

> **sinfo** [*OPTIONS...*]

* 常用选项:

    | 选项 | 功能 |
    | -------- | -------- |
    | `sinfo -N`     | 按节点显示计算资源 |
    |`sinfo -l / --long` | 显示更加详细的信息 |
    |  `-o <output_format>, --format=<output_format>` | 按照需要的项目显示节点信息 |
    * sinfo 具体可以显示的 format 信息详见: [info man](https://slurm.schedmd.com/sinfo.html)
    * 常用: `sinfo -o "%10n %10a %10T %12P %10m %10e %12c %20G"` 

### <span id="squeue"> **squeue**: 查看任务队列 </span>

> **squeue** [*OPTIONS...*]

* 常用选项:

    | 选项 | 功能 |
    | -------- | -------- |
    | `squeue -j JOB_ID`     | 显示某个任务信息 |
    | `squeue -l` | 显示更加详细的队列信息 |
    | `squeue -u USER_LIST` | 特定用户的任务信息 |

### <span id="srun"> **srun**: 提交任务（实时交互式） </span>

> **srun** [ *OPTIONS(0)...* ] executable(0) [*args(0)...*]

 * 常用选项基本和 [sbatch](#sbatch) 一致

 * 是前台交互式提交任务，可以直接提交命令（而不仅是脚本）比如：

     * 在远程节点 kunshan 运行一个 bash
     ```
     $ srun -p 3gpuq -w kunshan /bin/bash
     
     hosname 
     kunshan
     
     nvidia-smi 
     ...
     ```
     * 向 3gpuq 队列中的 kunshan 查看 GPU 状态
     ```
     $ srun -p 3gpuq -w kunshan nvidia-smi
     ```
     > 可 快速两次 <ctrl-c> 或者 一次 <ctrl-d> 结束此次 srun

### <span id="sbatch"> **sbatch**: 提交任务脚本（后台批量提交式）</span>

> **sbatch** [ *OPTIONS(0)...* ] script(0) [*args(0)...*]

 * 常用选项:
 
    | 选项 | 功能 |
    | ------- | -------- |
    | `-p / --partition=<partition>` | 提交的队列 |
    | `-w / --nodelist=<cherry,...>` | 指定提交节点 |
    | `-n / --ntasks=<number>` |  需要的 核心（process） 数 | 
    | `--gres=<list>` | 请求 GPU 资源的选项, `--gres=gpu:2` 表示表示需要 2 块 GPU |
    | `-J / --job-name=<name>` | 设置任务的名称 |
    | `-o / --output=<output_log>` | 标准输出 standard output |
    | `-e / --error=<error_log>` | 标准错误输出 standard error  |

 1. 提交任务脚本可以直接在命令行使用 **sbatch** + options 提交

     > **sbatch** -p *3gpuq* --gres=*gpu:2* --job-name=*test-run* **test_run.sh** 
    
    这种方式可能会报错 `sbatch: error: line must start with #! followed by the path to an interpreter`, 这是脚本内第一行要是 `#!/bin/bash` 或者 `#!/usr/bin/python` 等来指定脚本的解释器
    
 2. 另外可以将 options 全部指定在脚本内，需要在脚本开始添加形如`#SBATCH --n 1`  之类的选项
     
    * 一个只运行 ***hostname*** 命令并睡眠 10s 的脚本例子 **test_run.sh** :
    ```
    #!/bin/bash
    #SBATCH --job-name=test-hostname
    #SBATCH --partition=cpuq
    #SBATCH -n 1
    #SBATCH --mail-type=end
    #SBATCH --mail-user=YOU@EMAIL.COM
    #SBATCH --output=%j.out
    #SBATCH --error=%j.err
    #SBATCH --time=00:00:10

    /bin/hostname
    sleep 10
    ```
    可以直接运行 `sbatch test_run.sh` 提交。
    
    > p.s. 如果在 *命令行* 中再次使用 sbatch 的选项，将会覆盖脚本中的相应选项
    > 
    > p.p.s. `sbatch` 提交的脚本中，可以使用 `srun` 
    
### <span id="sattach"> **sattach**: `连接`一个正在执行的任务 </span>

> **sattach** [*options*] <jobid.stepid> 

 * sbatch 提交任务脚本之后，脚本在后台进入队列，自动运行。使用 `sattach` 可以将后台的任务的 I/O 显示到前台来，便于直接观察。
 * 可以 <ctrl-c> 退出 sattach，不会对任务有任何影响

    > p.s. 若没有 stepid ，可以使用 0。即 `sattach jobid.0`

### <span id="scancel"> **scancel**: `取消`提交的任务 </span>

> **scancel** [*OPTIONS...*] [*job_id[_array_id][.step_id*]] [*job_id[_array_id][.step_id]...*]

 * 常用选项:
 
    | 选项 | 功能 |
    | ------- | -------- |
    | `scancel <job_id>` | 取消任务 via job_id |
    | `scancel -n <job_name>` | 取消任务 via job_name |
    | `scancel -u <user_name>` |  取消 user_name 的全部任务 | 

### <span id="sstat"> **sstat**: 查看 `正在运行` 任务的状态信息
    
> **sstat** [*options*]

 * 常用选项
 
    | 选项 | 功能 |
    | ------- | -------- |
    | `sstat -j <job(.step)>` | 任务的运行信息 |
    | `sstat -e` | 列出所有可显示的项目 |
    | `sstat -i / --pidformat` | 显示 (JobId,Nodes,Pids) | 
    | `sstat -o, --format, --fields "FORMAT"` | 按要求显示信息 |
    
    > ***常用 format:*** 
    > 
    > `--format="JobId,Pids,AveCPU,AveRSS,MaxRSS" ` 
    > 
    > (任务ID，进程ID，平均CPU， 平均占用RAM，最高占用RAM)

### <span id="scontrol"> **scontrol**: 更加细致的 `监控` 以及 `修改` 队列中的任务 </span>

> **scontrol** [*OPTIONS...*] [*COMMAND...*]

 * 常用选项:
 
    | 选项 | 功能 |
    | ------- | -------- |
    | `scontrol show job JOB_ID` | JOB_ID 的详细信息 |
    | `scontrol show partitions` | SLURM 队列的详细信息 |
    | `scontrol --help` | 帮助信息 |

### <span id="sacct"> **sacct**: 查看任务的`统计信息` </span> 

> sacct [*OPTIONS...*]
 
 * 常用选项: 
 
    | 选项 | 功能 |
    | ------- | -------- |
    | `sacct -l` | 详细统计信息 |
    | `sacct -e` | 列出所有可统计项目 |
    | `sacct --format="LAYOUT"` | 按 *所选项目* 显示统计信息 | 
    | `sacct -u USER_NAME` | 某用户信息 |
    | `sacct -S YYYY-MM-DD` | 设置统计开始时间 |

    > `sacct` 默认只显示过去 `24小时` 的统计数据

## References
交大 Pi 超算资料: https://pi.sjtu.edu.cn/doc/slurm/

SLURM Workload Manager: https://slurm.schedmd.com/

ACCRE’s SLURM Documentation: http://www.accre.vanderbilt.edu/?page_id=2154

