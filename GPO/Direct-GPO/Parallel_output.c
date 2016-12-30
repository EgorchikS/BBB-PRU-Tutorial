/**
*   based on the example code at:
*   http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader_API_Guide
*
*  modified by EGOR SPIRIDONOV for PRU GPIO Tutorial
*/

#include <stdio.h>
#include <stdlib.h>
#include <prussdrv.h>
#include <pruss_intc_mapping.h>

#define PRU_NUM	1   // using PRU1 for these examples

int main (int argc, char* argv[])
{
   unsigned int ret;

   if(getuid()!=0){
      printf("You must run this program as root. Exiting.\n");
      exit(EXIT_FAILURE);
   }

   if(argc!=2) {
    printf("Usage is Parralel_output and integer number of delay \n");
    printf(" e. g. ./Parralel_output 100\n");
    return 2;
    }

   char *p;
   unsigned int cyc = (unsigned int) strtol(argv[1], &p, 10);
   printf("Delay for %d cycles\n", cyc);

   // Initialize structure used by prussdrv_pruintc_intc
   // PRUSS_INTC_INITDATA is found in pruss_intc_mapping.h
   tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

   // Allocate and initialize memory
   prussdrv_init ();
   ret = prussdrv_open(PRU_EVTOUT_0);
   if (ret)
   {
       printf("prussdrv_open open failed\n");
       return (ret);
   }

   // Map PRU's interrupts
   prussdrv_pruintc_init(&pruss_intc_initdata);

   // Write a number of cycles into PRU1 Data RAM0
   prussdrv_pru_write_memory(PRUSS0_PRU1_DATARAM , 0, &cyc, 4);

   // Load and execute the PRU program on the PRU
   prussdrv_exec_program (PRU_NUM, "./Parallel_output.bin");

   // Wait for event completion from PRU, returns the PRU_EVTOUT_0 number
   int n = prussdrv_pru_wait_event (PRU_EVTOUT_0);
   printf("PRU program completed, event number %d.\n", n);

   // Disable PRU and close memory mappings
   prussdrv_pru_disable(PRU_NUM);
   prussdrv_exit ();
   return EXIT_SUCCESS;
}
