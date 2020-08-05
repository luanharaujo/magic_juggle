#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	FILE *fp_in, *fp_out;
	char nome[100], comando[100];
	int tam;
	int tempo, bateria, maior_bateria = 0;
	float x, y, z, pitch, yaw, roll;
	float vx_ref, vy_ref, yawrate_ref, zdistance_ref;

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
	fclose(fp_out);;

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
	while(fscanf(fp_in,"%d,{'stateEstimate.x': %f, 'stateEstimate.y': %f, 'stateEstimate.z': %f, 'pm.batteryLevel': %d, 'stabilizer.roll': %f, 'stabilizer.pitch': %f, 'stabilizer.yaw': %f},%f,%f,%f,%f\n", &tempo, &x, &y, &z, &bateria, &roll, &pitch, &yaw, &vx_ref, &vy_ref, &yawrate_ref, &zdistance_ref) != EOF)
	{
		if(bateria > maior_bateria)
			maior_bateria = bateria;
		fprintf(fp_out, "%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", tempo, x, y, z, roll, pitch, yaw, vx_ref, vy_ref, yawrate_ref, zdistance_ref);
	}

	fclose(fp_in);
	fclose(fp_out);

	printf("Bateria: %d%%\n", maior_bateria);



	return 0;
}