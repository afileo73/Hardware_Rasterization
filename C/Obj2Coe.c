#include <stdio.h>
#include <string.h>

//This program converts from a .obj to three .coe files that hold vector data, face data, and 
    
int main(){
    FILE * fp, * fp2, *fp3, *fp4;
    char fstr[50];
	
    printf("What .obj file do you want to convert? (i.e. example.obj)\n");
    scanf("%s", fstr); //Read file name to be converted i.e. object.obj
    
    fp = fopen(fstr, "r"); //Open file to convert
    
    if(fp == NULL) {
      printf("Error opening file: File DNE\n");
      return(-1);
    }else{
        printf("File %s opened successfully.\n", fstr);
    }
    
    fp2 = fopen("vector.coe", "w+"); //Create output file
    fp3 = fopen("face.coe", "w+"); //Create output file  https://blender.stackexchange.com/questions/148242/why-obj-export-writes-face-normals-instead-of-vertex-normals
    fp4 = fopen("normal.coe", "w+"); //Create output file
    
    fprintf(fp2, ";width = 10\n"); //This is a comment to provide info about the width of the data to the user
    fprintf(fp2, "memory_initialization_radix=16;\n"); //Sets the coe file to be in hex
    fprintf(fp2, "memory_initialization_vector=\n"); //Starts the vector of data
    
    fprintf(fp3, ";width = 8\n"); //This is a comment to provide info about the width of the data to the user
    fprintf(fp3, "memory_initialization_radix=16;\n"); //Sets the coe file to be in hex
    fprintf(fp3, "memory_initialization_vector=\n"); //Starts the vector of data
    
    fprintf(fp4, ";width = 10\n"); //This is a comment to provide info about the width of the data to the user
    fprintf(fp4, "memory_initialization_radix=16;\n"); //Sets the coe file to be in hex
    fprintf(fp4, "memory_initialization_vector=\n"); //Starts the vector of data
    
    int x1, y1, z1, f1, f2, f3, vnx1, vny1, vnz1, fn;
    float x, y, z, vnx, vny, vnz;
    char c1, c2;
    char strcheck[50];
    int countv = 0, countvn = 0, countf = 0;
    do {
        c1 = fgetc(fp);
        c2 = fgetc(fp);
        if ((c1=='v') && (c2==' ')){ //Checking for vector line
            //fscanf(fp, "%d %d %d", &x, &y, &z); //reads x, y, and z and stores as integers (16 bit signed?)
            fscanf(fp, "%f", &x);
            fscanf(fp, "%f", &y);
            fscanf(fp, "%f", &z);
            if((x>320 || x<-320)||(y>320 || y<-320)||(z>320 || z<-320)){
                printf("Vectors are outside of size range for 640x480 display. Please resize object in Blender and try again.");
                return(0);
            }
            //printf("DEBUG: x=%f, y=%f, z=%f\n",x,y,z); //Debug, check that values are as expected (No decimal, correct number)
            x1 = (int)x;
            y1 = (int)y;
            z1 = (int)z;
			x1 = x1 & 0x3FF; //Bitwise mask to make output 10 bytes
			y1 = y1 & 0x3FF;
			z1 = z1 & 0x3FF;
            fprintf(fp2, "%X,%X,%X,\n", x1, y1, z1);
            countv++;
            //printf("DEBUG: x= %X, y= %X, z= %X\n",x1,y1,z1); //Debug, check that values are as expected (SIGNED!?!?!)
        }else if((c1=='v') && (c2=='n')){   //May be issue with really small numbers.
			fscanf(fp, "%f", &vnx);
            fscanf(fp, "%f", &vny);
            fscanf(fp, "%f", &vnz);
			vnx1 = (int)vnx;
            vny1 = (int)vny;
            vnz1 = (int)vnz;
			vnx1 = vnx1 & 0x3FF; //Bitwise mask to make output 10 bytes
			vny1 = vny1 & 0x3FF;
			vnz1 = vnz1 & 0x3FF;
            fprintf(fp4, "%X,%X,%X,\n", vnx1, vny1, vnz1);
            countvn++;
		}else if((c1=='f') && (c2==' ')){   //Needs to be changed to account for normals
			fscanf(fp, "%d",&f1);
			fgetc(fp); fgetc(fp); // skips '//' characters
			fgetc(fp); //skips normal
			fscanf(fp, "%d",&f2);
			fgetc(fp); fgetc(fp); // skips '//' characters
			fgetc(fp); //skips normal
			fscanf(fp, "%d",&f3);
			fgetc(fp); fgetc(fp); // skips '//' characters
			fscanf(fp, "%d",&fn);
			fprintf(fp3, "%X,%X,%X,\n",f1,f2,f3);
			countf++;
		}
    } while(fgets(strcheck, 50, fp)!= NULL); //Checks for EOF
    
    printf("%d Vectors, %d Normal Vectors, and %d Faces converted to .coe files. \n", countv, countvn, countf);
    printf("Make sure to turn the last ',' in the files into ';' because I am bad at coding.\n");
	printf("Also add the face count as the first data entry into face.coe.\n");
    
    fclose(fp);
    fclose(fp2);
	fclose(fp3);
	fclose(fp4);
    return(0);
}