#include <stdlib.h>
#include <stdio.h>

int shape_Detection(unsigned char* image_Address);

int main(int argc, char** argv){

FILE *image;
image = fopen("s07-3.bmp", "rb");
char *buffer;
int shape;
unsigned int length;

if (image == NULL){

	printf("\nSuch file does not exist.\n\n");
	return 0;
}

fseek(image, 0, SEEK_END);
length = ftell(image);
fseek(image, 0, SEEK_SET);
buffer = (char *)malloc(sizeof(unsigned char) *length);

if (buffer == NULL){

	printf("\nProblem occurred with setting up the buffer.\n\n");
	fclose(image);
	return 0;
}

fread(buffer, length, 1, image);
fclose(image);
shape = shape_Detection(buffer + 54);
	
if(shape == 1){

 	printf("\nShape 1 detected - L shape. \n\n");

}else if(shape == 2){

	printf("\nShape 2 detected - T shape. \n\n");

}else 
	printf("\nNeither of the shapes was detected. \n\n");

return 0;
}
