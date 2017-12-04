#!/usr/bin/bash

# Congruadulations, you have passed all the tutorials.

echo 'Applying the recommended setups...'
mkdir $WORK_DIR

# change the owner of working dir
/cm/shared/apps/utils/aichown $ORIGIN_USERNAME $WORK_DIR -r
