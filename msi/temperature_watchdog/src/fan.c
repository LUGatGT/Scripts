#include <stdlib.h>
#include <stdio.h>
#include "fan.h"

// The file used for setting the fan state.
const char* const fan_file =
"/sys/devices/platform/msi-laptop-pf/auto_fan";

void set_fan_auto(bool state) {
	// Set the fan's state.
	FILE* file = fopen(fan_file, "wb");
	fprintf(file, "%i\n", state);
	fclose(file);
}
