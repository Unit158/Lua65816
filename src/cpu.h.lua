#ifndef LIB65816_CPU_H
#define LIB65816_CPU_H

/*
 * lib65816/cpu.h Release 1p1
 * See LICENSE for more details.
 *
 * Code originally from XGS: Apple IIGS Emulator (gscpu.h)
 *
 * Originally written and Copyright (C)1996 by Joshua M. Thompson
 * Copyright (C) 2006 by Samuel A. Falvo II
 *
 * Modified for greater portability and virtual hardware independence.
 */

#include <lib65816/config.h>


/*
 * Union definition of a 16-bit value that can also be 
 * accessed as its component 8-bit values. Useful for
 * registers, which change sized based on teh settings
 * the M and X program status register bits.
 */

typedef union {
#ifdef WORDS_BIGENDIAN
    struct { byte   H,L; } B;
#else
    struct { byte   L,H; } B;
#endif
    word16  W;
} dualw;

/* Same as above but for addresses. */

typedef union {
    struct { byte   Z,B,H,L; } B;
    struct { word16 H,L; } W;
    word32  A;
} duala;



/* Definitions of the 65816 registers, in case you want
 * to access these from your own routines (such as from
 * a WDM opcode handler routine.
 *
 * ATTENTION: DO NOT DEPEND ON THESE -- THESE WILL EVENTUALLY BE REPLACED
 * WITH A STRUCTURE THAT MAINTAINS ALL CPU STATE.
 */

extern dualw    A;  /* Accumulator           */
extern dualw    D;  /* Direct Page Register      */
extern byte     P;  /* Processor Status Register */
extern int      E;  /* Emulation Mode Flag       */
extern dualw    S;  /* Stack Pointer             */
extern dualw    X;  /* X Index Register          */
extern dualw    Y;  /* Y Index Register          */
extern byte     DB; /* Data Bank Register        */

#ifndef CPU_DISPATCH

extern union {      /* Program Counter       */
#ifdef WORDS_BIGENDIAN
    struct { byte Z,PB,H,L; } B;
    struct { word16 Z,PC; } W;
#else
    struct { byte L,H,PB,Z; } B;
    struct { word16 PC,Z; } W;
#endif
    word32  A;
} PC;

#endif



/* Current cycle count */

#if defined ( __sparc__ ) && defined ( __GNUC__ )
register word32 cpu_cycle_count asm ("g5");
#else
extern word32   cpu_cycle_count;
#endif



/* These are the core memory access macros used in the 65816 emulator.
 * Set these to point to routines which handle your emulated machine's
 * memory access (generally these routines will check for access to
 * memory-mapped I/O and things of that nature.)
 *
 * The SYNC pin is useful to trap OS calls, whereas the VP pin is
 * needed to emulate hardware which modifies the vector addresses.
 */

#define EMUL_PIN_SYNC 1 // much more work to provide VPD and VPA
#define EMUL_PIN_VP   2
#define M_READ(a)         MEM_readMem(a, cpu_cycle_count, 0)
#define M_READ_OPCODE(a)  MEM_readMem(a, cpu_cycle_count, EMUL_PIN_SYNC)
#define M_READ_VECTOR(a)  MEM_readMem(a, cpu_cycle_count, EMUL_PIN_VP)
#define M_WRITE(a,v)      MEM_writeMem((a),(v), cpu_cycle_count)


/* Set this macro to your emulator's "update" routine. Your update
 * routine would probably do things like update hardware sprites,
 * and check for user keypresses. CPU_run() calls this routine
 * periodically to make sure the rest of your emulator gets time
 * to run.
 *
 * v is the number of CPU clock cycles that have elapsed since the last
 * call.
 */

#define E_UPDATE(v)     EMUL_hardwareUpdate(v)



/* Set this macro to your emulator's routine for handling the WDM
 * pseudo-opcode. Useful for trapping certain emulated machine
 * functions and emulating them in fast C code.
 *
 * v is the operand byte immediately following the WDM opcode.
 */

#define E_WDM(v)        EMUL_handleWDM( (v), cpu_cycle_count )