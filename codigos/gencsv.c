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


	fp_out = fopen("../dados/nome.txt","w");
	fprintf(fp_out, "%s", nome);
	fclose(fp_out);

	sprintf(comando,"../dados/%s",argv[1]); 
	fp_in = fopen(comando,"r");
	
	strcpy(nome,comando);
	tam = strlen(nome);
	nome[tam-3] = 'c';
	nome[tam-2] = 's';
	nome[tam-1] = 'v';

	fp_out = fopen(nome,"w");
	fscanf(fp_in,"Connecting to radio://0/80/2M\nConnected to radio://0/80/2M");//pulando a linha que imprimi a conexão com o rário
	
	do//loopp para pegar e salvar os nomes das variáveis
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

				//loop para subistituir os "." por "_" para que o nome da variável fique melhor no matlab
				i=0;
				while(variavel_name[i] != '\0')
				{
					if(variavel_name[i]=='.')
						variavel_name[i++] = '_';
					else
						i++;
				}

				
				fprintf(fp_out, "%s,", variavel_name);
			break;

			case '#':
				fprintf(fp_out, "\n");
			break;
		}
	}while(caractere != '#');
	fseek(fp_in,0,SEEK_SET);//voltando ao inicio do arquivo de entrada
	fscanf(fp_in,"Connecting to radio://0/80/2M\nConnected to radio://0/80/2M");//pulando a linha que imprimi a conexão com o rário
	while(fscanf(fp_in,"%c", &caractere) != EOF)//loop para pegar todos os dados
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
				
				if(strcmp(variavel_name,"tempo")==0)//tempo é inteiro
				{
					fscanf(fp_in,": %d", &variavel_int);
					fprintf(fp_out, "%d,", variavel_int);
				}else if(variavel_name[i-1] == 'Z')//se terminar em Z é int_16
				{
					fscanf(fp_in,": %d", &variavel_int);
					fprintf(fp_out, "%d,", variavel_int);
				}else//outras variáveis são float
				{
					fscanf(fp_in,": %f", &variavel_float);
					fprintf(fp_out, "%f,", variavel_float);
				}//****tem ainda que tratar para a valoar da bateria que é int também, porém eu ainda não sei qual o nome que vem no arquivo*****//
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