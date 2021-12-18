#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define ROOT_ID (0)

void exec(const char *cmd[])
{
	switch (fork()) {
		case 0:
            execvp((char *)cmd[0], (char **)cmd);
			_exit(2);
		case -1:
			exit(2);
		default:
			wait(NULL);
	}
}

int main(void)
{
	const char *prime_switch[] = {"sudo", "prime-switch", NULL };
	const char *startx[] = {"startx", NULL };

	/* Save old user id and switch to root. */
	uid_t old_uid = getuid();
	setuid(ROOT_ID);

	/* Run prime switch. */
	exec(prime_switch);

	/* Switch back to the old user id. */
	setuid(old_uid);

	/* Start the X server. */
	exec(startx);

	return 0;
}
