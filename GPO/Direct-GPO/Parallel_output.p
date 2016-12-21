

.origin 0                        // start of program in PRU memory
.entrypoint START                // program entry point (for a debugger)

#define PERIOD 200000      		 // 5ns per instruction -> 1 kHz
#define LOOP_N 1000   			 // number of repetitions

#define PRU0_R31_VEC_VALID 32    // allows notification of program completion
#define PRU_EVTOUT_0    3        // the event number that is sent back

START:
	MOV	r0, LOOP_N        // store the length of the delay in REG0

CYCLE:
	MOV r1, PERIOD
	MOV	r30, 0xff
	MOV	r30, 0x00

	MOV	r30, 0xff
	MOV	r30, 0x00

	MOV	r30, 0xff
	MOV	r30, 0x00

	MOV	r30, 0xff
	MOV	r30, 0x00
WAIT:
	SUB	r1, r1, 1      	  // Decrement REG1 by 1
	QBNE	WAIT, r1, 0   // Loop to WAIT, unless REG1=0

	SUB	r0, r0, 1        // decrement REG0 by 1
	QBNE	CYCLE, r0, 0  // Loop to LOOP, unless REG0=0

END:                             // notify the calling app that finished
	MOV	R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
	HALT                     // halt the pru program
