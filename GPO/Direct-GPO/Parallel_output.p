.origin 0                       // start of program in PRU memory
.entrypoint START               // program entry point (for a debugger)

#define PRU0_R31_VEC_VALID 32   // allows notification of program completion
#define PRU_EVTOUT_0    3       // the event number that is sent back

START:
        WBC r31.t16             // wait bit clear - i.e., button press
                                // Toggle 4 times Parallel output pins
        MOV     r30, 0xffff
        MOV     r30, 0x0000

        MOV     r30, 0xffff
        MOV     r30, 0x0000

        LBCO r30, C24, 0, 4     // load PRU1 Data RAM into r30 (use c24 const addr)

CYCLE:
        SUB     r30, r30, 1     // Decrement REG30 by 1 - i.e., parallel output current value on pins
        QBNE    CYCLE, r30, 0   // Loop to CYCLE, unless REG30=0

END:                            // notify the calling app that finished
        MOV     R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
        HALT