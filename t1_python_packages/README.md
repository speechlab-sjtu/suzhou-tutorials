# tutorial 2: customize your python packages environments

## global packages

There are already many python packages available in module **libs/pythonX.X/XXX**. Deep
learning frameworks are also provided in modules. Check these out before you want
to install a new package.

## The *user install* of `pip`

This scheme is designed to be the most convenient solution for users that don’t
have write permission to the global site-packages directory or don’t want to 
install into it. It is enabled with a simple option:

```bash
pip install --user tensorflow
# or
# python setup.py install --user
man pip # check the manual page first
```

It will install the packages (lib, bin and others) in `user_base` and `user_base` is automatically prepend to `PYTHONPATH`.
Default value of `user_base` is ~/.local for UNIX, and can be altered by setting
the environment variable:

```bash
export PYTHONUSERBASE=~/.another_dir
```

The user local packages will overwrite the global packages, so you can have full
control of your python environments with pre-built packages and your own packages.

## Recommended setup

You can set `pip` to use user installation by default. Add the following lines to
`~/.pip/pip.conf`

```config
[install]
user = true
```

No need to change the installation location (`user_base`) if you follow the
recommended setup in tutorial 0.

## Examples

1. I want to use a python package (`gpustat`) to moniter GPU usages, and at the same time
use the pytorch module.
```bash
pip install gpustat # the package locates in $HOME/.local/lib/pythonXXX
```
2. I want to install a newer version of `Pytorch`:
  - If a stable (release) version, plz contact device group (go to trac for email address) for global upgrading.
  - If a test version:
    ```bash
    module unload pytorch-oldversion
    pip install pytorch-newversion
    # for local packages, `--user` is still needed
    # python setup.py install --user
    ```

ref: https://docs.python.org/3/install/index.html#alternate-installation-the-user-scheme
