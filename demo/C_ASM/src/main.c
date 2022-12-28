#include <sys/types.h>
#include <stdio.h>

#include "fx_screen.h"

//================================================================
// ASM functions. Implemented in "asm-functions.s"
void asm_helloBitmapBrothers();
void asm_callbackHelloPalaceSoftware();
void asm_keypressed();
__uint32_t asm_multiply(__uint32_t a, __uint32_t b);

//================================================================
// Standard C function. Callable (and called) from ASM.
void helloPalaceSoftware()
{
    printf("C > Hello Palace Software\r\n");
}

//================================================================
// Main program
void run()
{
    // inits display in medium resolution with a custom palette
    ScreenContext* screenContext = initMediumResolution();
    
    // Starting the demo
    printf("Starting C <-> ASM Demo\r\n");
    printf("-----------------------\r\n");

    // simply calls ASM   
    asm_helloBitmapBrothers();

    // calls ASM which calls a C function
    asm_callbackHelloPalaceSoftware(); 

    // calls a "complex" function with parameters and return value
    printf("asm_multiply(6,3) =  %d\r\n", asm_multiply(6, 3)); 

    printf("\r\nFinished [PRESS ENTER]\r\n");

    // let's call a last function coded in ASM
    asm_keypressed();

    // Restoring the resolution and its palette  
    restoreScreenContext(screenContext);
}

//================================================================
// Standard C entry point
int main(int argc, char *argv[])
{  
    // switching to supervisor mode and execute run()
    // needed because of direct memory access for reading/writing the palette
    Supexec(&run);
}
