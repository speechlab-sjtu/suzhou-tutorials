#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
    setreuid(geteuid(), getuid());
    system( "bash .create_work_dir.sh" );
    return 0;
}
