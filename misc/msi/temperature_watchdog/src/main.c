#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "temp.h"
#include "fan.h"

int main(const int argc, const char** const argv) {
	// Sanity check arguments.
	if(argc < 2) {
		printf("usage: %s <filename>\n", argv[0]);
		return 0;
	}

	while(1) {
		// Grab the maximum temperature.
		int temp = temp_max();

		// Toggle the fan if needed.
		set_fan_auto(70000 > temp);

		// Write the temperature out.
		FILE* const file = fopen(argv[1], "wb");
		fprintf(file, "%i\n", temp / 1000);
		fclose(file);

		// Sleep between iterations.
		sleep(1);

	}
}
