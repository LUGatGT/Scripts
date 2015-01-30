#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "temp.h"

// The path that we are grabbing temperatures from.
const char* const temperature_path =
"/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp%i_input";

// The length of the temperature path.
// NOTE: We can't use strlen here, keep this in sync with the above string,
// this must be large enough to hold the expanded string (that is, the
// string plus the id).
const int temperature_path_max_length = 64;

// Temperature id bounds, change by machine.
const int min_id = 1;
const int max_id = 5;

// Grab the maximum temperature.
int temp_max() {
	// Stores the max found temperature.
	int tmp = 0;

	// Check every temperature.
	for(int i = min_id; i < max_id + 1; i++) {
		// Temp variable, grab the new temperature we are checking.
		const int tmp2 = temp(i);

		// Store the larger temperature.
		if(tmp2 > tmp) {
			tmp = tmp2;
		}
	}

	// Return the largest temperature.
	return tmp;
}

// Get the temperature from a temperature id.
int temp(const int id) {
	// Generate the correct path.
	char str[temperature_path_max_length];
	snprintf(str, temperature_path_max_length, temperature_path, id);

	// Temp variable for storing temperature.
	int temp;

	// Grab the temperature from the file path we generated.
	FILE* const file = fopen(str, "rb");
	const int read = fscanf(file, "%i", &temp);
	fclose(file);

	// Return the temperature.
	return temp;
}
