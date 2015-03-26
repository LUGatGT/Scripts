#if 0
gcc "$0" && exec ./a.out "$@"
exit 1
#endif

/* This is a hacky way that you can run a c file as if it were an executable.
 *
 * Here is an explaination of how it works if your interested:
 * This hack works by abusing these three things:
 * 1. If you try to run a program/script in your shell and it does not
 *    have a #!/path/to/interpreter or it's not a binary then your shell
 *    will run it as if it were a shell script.
 * 2. Shell comments begin with a #
 * 3. You can tell the compiler to ignore content between #if 0 #endif blocks
 *
 * Exec is required so that it won't continue executing the file as if it were
 * a shell script. exit 1 is used so that if gcc fails it won't continue to
 * run it as a shell script either.
 *
 */


#include <stdio.h>
int main()
{
    printf("hello world\n");
    return 0;
}

