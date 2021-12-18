#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

/* Parameters */
#define GVT_PCI ("0000:00:02.0")
#define GVT_GUID ("886353de-edcb-4049-9c26-fc5e3664a4e3")
#define MDEV_TYPE ("i915-GVTg_V5_4")
#define HUGE_PG_COUNT ("2750") /* 2750 * 2048 = 5632000 (5.5GiB) */

/* Test Value */
#define CHECK_ARG(index, str) (0 == strcmp(argv[index], str))

/* Usage prompt */
#define USAGE ("usage: %s <task[\"init\", \"stop\"]>\n")

/* Task values */
#define TASK_INIT ("init")
#define TASK_STOP ("stop")

/* Arguments */
enum program_arguments {
	ARG_INVALID_VALUE = -1,
	ARG_PROGRAM_NAME = 0,
	ARG_TASK,
	ARG_COUNT
};

/* 
 * echo "$HUGE_PG_COUNT" > "/proc/sys/vm/nr_hugepages"
 */
void allocate_huge_pages()
{
	char file_path[4096] = {0};
	FILE *file = NULL;

	/* Generate path */
	snprintf(file_path, sizeof(file_path), 
			 "/proc/sys/vm/nr_hugepages",
			 GVT_PCI,
			 MDEV_TYPE);

	/* Open the file */
	file = fopen(file_path, "w");
	if (NULL == file) {
		return;
	}

	/* Write to the file */
	fprintf(file, "%s\n", HUGE_PG_COUNT);
}

/* 
 * echo "0" > "/proc/sys/vm/nr_hugepages"
 */
void free_huge_pages()
{
	char file_path[4096] = {0};
	FILE *file = NULL;

	/* Generate path */
	snprintf(file_path, sizeof(file_path), 
			 "/proc/sys/vm/nr_hugepages",
			 GVT_PCI,
			 MDEV_TYPE);

	/* Open the file */
	file = fopen(file_path, "w");
	if (NULL == file) {
		return;
	}

	/* Write to the file */
	fprintf(file, "0\n");
}

/* 
 * echo "$GVT_GUID" > "/sys/bus/pci/devices/$GVT_PCI/mdev_supported_types/$MDEV_TYPE/create"
 */
void create_gpu()
{
	char file_path[4096] = {0};
	FILE *file = NULL;

	/* Generate path */
	snprintf(file_path, sizeof(file_path), 
			 "/sys/bus/pci/devices/%s/mdev_supported_types/%s/create",
			 GVT_PCI,
			 MDEV_TYPE);

	/* Open the file */
	file = fopen(file_path, "w");
	if (NULL == file) {
		return;
	}

	/* Write to the file */
	fprintf(file, "%s\n", GVT_GUID);
}

/*
 * echo 1 > "/sys/bus/pci/devices/$GVT_PCI/$GVT_GUID/remove"
 */
void remove_gpu()
{
	char file_path[4096] = {0};
	FILE *file = NULL;

	/* Generate path */
	snprintf(file_path, sizeof(file_path),
			 "/sys/bus/pci/devices/%s/%s/remove",
			 GVT_PCI,
			 GVT_GUID);

	/* Open the file */
	file = fopen(file_path, "w");
	if (NULL == file) {
		return;
	}

	/* Write to the file */
	fprintf(file, "1\n");
}

void start_network()
{
	char *virsh[] = {"sudo", "virsh", "net-start", "default", NULL };

	switch (fork()) {
		case 0:
			execvp(virsh[0], virsh);
			break;
		case -1:
			break;
		default:
			wait(NULL);
	}
}

int main(int argc, char *const argv[])
{
	setuid(0);
	if (ARG_COUNT != argc) {
		/* Print usage prompt */
		printf(USAGE, argv[ARG_PROGRAM_NAME]);
	} 
	else if (CHECK_ARG(ARG_TASK, TASK_INIT)) {
		/* Create the gpu and start network */
		create_gpu();
		start_network();
		//allocate_huge_pages();
	} 
	else if (CHECK_ARG(ARG_TASK, TASK_STOP)) {
		/* Remove the gpu */
		remove_gpu();
		//free_huge_pages();
	} 
	else {
		/* Print usage prompt */
		printf(USAGE, argv[ARG_PROGRAM_NAME]);
	}
	return 0;
}
