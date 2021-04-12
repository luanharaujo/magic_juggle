#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	FILE *fp_in, *fp_out, *fp_list;
	int i, flag;
	char parametros[150], parametros_aux[150];
	float valor;

	fp_list = fopen("lista_param.txt","r");
	fp_out = fopen("/home/pi/git/magic_juggle/dados/ultimos_parametros.csv","w");
	fp_in = fopen("/home/pi/git/magic_juggle/dados/ultimos_parametros.txt","r");
	
	//printf("%p %p %p \n", fp_out, fp_in, fp_list);
	//perror("fopen");

	while(fscanf(fp_list,"%s\n", parametros) != EOF)
	{
		fseek(fp_in,0,SEEK_SET);
		flag = 0;
		while(!flag && (fscanf(fp_in,"%s", parametros_aux) != EOF))
		{
			if(strcmp(parametros,parametros_aux)==0)
			{
				fscanf(fp_in,"%f", &valor);
				fprintf(fp_out,"%f\n", valor);
			}
		}
	}

	fclose(fp_in);
	fclose(fp_out);
	fclose(fp_list);

	return 0;
}