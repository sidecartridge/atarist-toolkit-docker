#include <stdlib.h>
#include "fx_screen.h"

void initScreenContext(ScreenContext* screenContext)
{
    screenContext->videoAddress = Logbase();   // Get the logical pointer of the video RAM
    screenContext->savedResolution = Getrez(); // Get current resolution
    savePalette(screenContext->savedPalette);  // Save the palette
    setFullBlackPalette();                     // put lights off before
}

// saves the current palette into a buffer (works only in supervisor mode)
void savePalette(__uint16_t* paletteBuffer)
{
   memcpy(paletteBuffer, PALETTE_ADDRESS, sizeof(__uint16_t) * 16); // 16 colors, 16 bits each.
}

// restores the saved resolution and its palette
void restoreResolutionAndPalette(ScreenContext* screenContext)
{
    Setscreen(-1,-1, (*screenContext).savedResolution);
    Setpalette((*screenContext).savedPalette);
}

// changes the current resolution
void setResolution(short resolution)
{
    Setscreen(-1,-1, resolution);
}

void setMediumResolutionPalette()
{
    Setcolor(0, 0x000);
    Setcolor(1, 0x777);
    Setcolor(2, 0x700);
    Setcolor(3, 0x070);
}

void setFullBlackPalette()
{
    for(int i = 0 ; i < 16 ; i++)
    {
        Setcolor(i, 0x000);
    }
}

ScreenContext* initMediumResolution()
{
    ScreenContext* screenContext = malloc(sizeof(ScreenContext));
    initScreenContext(screenContext);
    setResolution(MEDIUM_RES);
    setMediumResolutionPalette();
    return screenContext;
}

void restoreScreenContext(ScreenContext* screenContext)
{
    restoreResolutionAndPalette(screenContext);
    free(screenContext);
}
