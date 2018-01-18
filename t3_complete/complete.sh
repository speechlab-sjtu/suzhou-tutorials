# Copy the sample bashrc to personal directory

export GROUP_DIR=/mnt/lustre/sjtu
export ORIGIN_USERNAME=$(whoami)
export OLD_HOME=/home/sjtu/$ORIGIN_USERNAME
export WORK_DIR=$GROUP_DIR/users/$ORIGIN_USERNAME
export TMP_FILES=/tmp/$ORIGIN_USERNAME

# every diretory should be group readable
chmod g+x $OLD_HOME
chmod g+r $OLD_HOME -R

# copy the sample .bashrc for group init scripts
cp $GROUP_DIR/shared/scripts/sample.bashrc $OLD_HOME/.bashrc
cp $GROUP_DIR/shared/scripts/sample.zshrc $OLD_HOME/.zshrc

# invoke privilliged scripts to create working dir and chown
cd .utils/ && \
  ./create_work_dir_wrapper && \
  rsync -avz $OLD_HOME/ $WORK_DIR/ 

chmod g+r $WORK_DIR -R
chmod g+x $WORK_DIR

# link some useful resources
###
# total 40
# drwxr-----  5 kys10     sjtu 4096 Dec  1 12:02 .
# drwxr-x--- 10 sjtuadmin sjtu 4096 Dec  1 19:18 ..
# -rw-------  1 kys10     sjtu  146 Dec  1 12:02 .bash_history
# -rw-r--r--  1 kys10     sjtu   88 Dec  1 12:01 .bash_profile
# -rw-r-----  1 kys10     sjtu  509 Dec  1 12:02 .bashrc
# drwxr-xr-x  3 kys10     sjtu 4096 Dec  1 11:55 .cache
# drwxr-xr-x  3 kys10     sjtu 4096 Dec  1 11:55 .config
# drwxr-----  2 kys10     sjtu 4096 Nov 29 23:14 .ssh
# -rw-------  1 kys10     sjtu 1059 Dec  1 12:02 .viminfo
# -rw-------  1 kys10     sjtu   52 Dec  1 12:02 .Xauthority
# 
###

ESSENTIAL_FILES=(.bash_history .bash_profile .bashrc .config .ssh .viminfo .Xauthority)
cd $WORK_DIR

# some files are simply a symbolic link to original home
for file in ${ESSENTIAL_FILES[@]}; do
  rm $file -rf && ln -s $OLD_HOME/$file
done
ln -s ../../shared/data


# set default user mode for pip
mkdir .pip
cp $GROUP_DIR/shared/scripts/sample.pip.conf .pip/pip.conf

# reload the bashrc
source ~/.bashrc
#TODO: remove redundant files in original home
