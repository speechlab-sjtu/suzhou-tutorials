# tutorial 0: about working directory
In clusters, you will have a separate working directory besides the default home directory.

## differences

- Usage: *home* is used for login and initialization.
- Accessibility: *home* is only mounted in the login node, while *working* dir is mounted in
all nodes.
- Quotas: *home* has a litlle quota (~500M) while *working* dir gives you ~1T free space.
- Safety: *working* dir is more fault tolerent (RAID5 and DFS).
- Speed: *working* dir is faster (RAID5).

## Principles

Although I don't know the reason why they cannot be in one place, everyone should follow
the principles below:
- *cd* to working dir once you logged in.
- try to store all your files in working dir.

## A recommended setup:

In this setup, we use the *working dir* as a **fake home**, thus the **real home** is transparent to users.

### file structure

```
|-- home
|   `-- ky219
|       |-- .bashrc
|       `-- .ssh
`-- work_dir
    `-- ky219
        |-- .bashrc -> home/ky219/.bashrc
        `-- .ssh -> home/ky219/.ssh
```

### init script
Prepend the following lines to the starting line of your `.bashrc`:

```bash
export HOME="work_dir/ky219"
cd $HOME

### other envs
```

Your **fake home** directory will be the *working dir*. Both `ssh` and `scp` will `cd` to the **fake home** by default.

```bash
ssh suzhou

# after login
pwd
# work_dir/ky219/
```
