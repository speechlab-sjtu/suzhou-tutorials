# SLURM Tutorials 

## 常用的命令

### 查看集群资源

**sinfo**: 查看集群的计算资源
 * 常用选项:
     * `sinfo -N` 按节点显示计算资源
     * `sinfo -l / --long` 显示更加详细的信息
     * `-o <output_format>, --format=<output_format>`
         * 按照需要的项目显示节点信息
         * 常用: `sinfo -o "%10n %10a %10T %12P %10m %10e %12c %20G"` 

### 提交与取消任务

**sbatch**: 向集群中 **`提交任务`**
 * 常用选项:
     * `-p <partition>` : 提交的队列
     * `-w / --nodelist <cherry,...>` : 指定提交节点
     * `-n / --ntasks=<number>` : 需要的 核心 数
         * `--ntasks-per-node=<ntasks>`
     * `--gres=<list>` : 请求 GPU 资源的选项, `--gres=gpu:2` 表示表示需要 2 块 GPU
     * `-J / --job-name <name>`
     * `-o / --output=<output_log>`
     * `-e / --error=<error_log>`

**scancel**: 取消提交的任务

 * 常用命令:
 
     * `scancel <job_id>`
     * `scancel -n <job_name>`
     * `scancel -u <user_name>`

### 查看任务状态

**squeue**: **`查看`** SLURM 调度队列中的任务信息
 * `squeue -u <user name>` : 查看个人任务信息

**scontrol**: 更加细致的 **`监控`** 以及 **`修改`** 队列中的任务
 * `scontrol show job <job_id>`

**sacct**: **`查看`** 提交任务的统计信息

## References
交大 Pi 超算资料: https://pi.sjtu.edu.cn/doc/slurm/
SLURM Workload Manager: https://slurm.schedmd.com/
ACCRE’s SLURM Documentation: http://www.accre.vanderbilt.edu/?page_id=2154

