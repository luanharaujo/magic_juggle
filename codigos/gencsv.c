#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	FILE *fp_in, *fp_out;
	char nome[100], comando[100];
	int tam, i;

	int variavel_int;
	float variavel_float;
	char variavel_name[70];
	char caractere;

	//inicio da ganbiarra
	strcpy(nome,argv[1]);
	tam = strlen(nome);
	nome[tam-3] = 'c';
	nome[tam-2] = 's';
	nome[tam-1] = 'v';
	system("sleep 1");
	//a ganbiara continua no script dooutro computador


	fp_out = fopen("/home/bitcraze/git/magic_juggle/dados/nome.txt","w");
	fprintf(fp_out, "%s", nome);
	fclose(fp_out);

	sprintf(comando,"/home/bitcraze/git/magic_juggle/dados/%s",argv[1]); 
	fp_in = fopen(comando,"r");
	
	strcpy(nome,comando);
	tam = strlen(nome);
	nome[tam-3] = 'c';
	nome[tam-2] = 's';
	nome[tam-1] = 'v';

	fp_out = fopen(nome,"w");
	fscanf(fp_in,"Connecting to radio://0/80/2M\nConnected to radio://0/80/2M");
	//printf("0\n");
	do
	{
		fscanf(fp_in,"%c", &caractere);
		switch (caractere)
		{
			case '\'':
				i = 0;
				do
				{
					fscanf(fp_in,"%c", &caractere);
					variavel_name[i++] = caractere;
				}while(caractere != '\'');
				variavel_name[--i] = '\0';
				
				fprintf(fp_out, "%s,", variavel_name);
			break;

			case '#':
				fprintf(fp_out, "\n");
			break;
		}
	}while(caractere != '#');
	fseek(fp_in,0,SEEK_SET);
	while(fscanf(fp_in,"%c", &caractere) != EOF)
	{
		switch (caractere)
		{
			case '\'':
				i = 0;
				do
				{
					fscanf(fp_in,"%c", &caractere);
					variavel_name[i++] = caractere;
				}while(caractere != '\'');
				variavel_name[--i] = '\0';
				
				if(strcmp(variavel_name,"tempo")==0)
				{
					fscanf(fp_in,": %d", &variavel_int);
					fprintf(fp_out, "%d,", variavel_int);
				}else if(variavel_name[i-1] == 'Z')
				{
					fscanf(fp_in,": %d", &variavel_int);
					fprintf(fp_out, "%d,", variavel_int);
				}else
				{
					fscanf(fp_in,": %f", &variavel_float);
					fprintf(fp_out, "%f,", variavel_float);
				}
			break;

			case '#':
				fprintf(fp_out, "\n");
			break;
		}
	}

	fclose(fp_in);
	fclose(fp_out);

	return 0;
}