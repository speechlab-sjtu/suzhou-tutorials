## file structure

`complete.sh`: Entry script which sets up most environment like `bashrc`.
`.create_work_dir.sh`: create working dir for running user. Only *sjtuadmin* have permission to create directories in working dir, so this script shoulb be run with *sjtuadmin*.
`create_work_dir_wrapper`: A c wrapper to run `.create_work_dir.sh`. The setuid bit of this file is *true*, and only users in `sjtu` group have execution permission. It means normal user can run this program and then target script (`.create_work_dir.sh`) is executed as if *sjtuadmin* is executing.
`wrapper.c`: source code for binary file `create_work_dir`
