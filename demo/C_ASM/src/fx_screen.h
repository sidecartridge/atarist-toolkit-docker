#ifndef FX_SCREEN_H_   
#define FX_SCREEN_H_

#include <sys/types.h>
#include <stdio.h>
#include <string.h>

/* CONSOLE UTILITY FUNCTIONS */
#define clearHome() puts("\033E\033H")
#define locate(x,y) printf("\033Y%c%c", (char) (32+y), (char) (32+x))

/* SCREEN DEFINITIONS AND FUNCTIONS */
#define LOW_RES 0
#define MEDIUM_RES 1
#define PALETTE_ADDRESS (void*) 0xFF8240

typedef struct ScreenContext ScreenContext;
struct ScreenContext {
    __uint16_t* videoAddress;
    __uint16_t savedResolution;
    __uint16_t savedPalette[16];
};

ScreenContext* initMediumResolution();

void restoreScreenContext(ScreenContext* screenContext);

void initScreenContext(ScreenContext* screenContext);

// restores the saved resolution and its palette
void restoreResolutionAndPalette(ScreenContext* screenContext);

// saves the current palette into a buffer (works only in supervisor mode)
void savePalette(__uint16_t* paletteBuffer);

// changes the current resolution
void setResolution(short resolution);

// sets a new palette with 0:black, 1:white, 2:red and 3:green on the first 4 colors.
void setMediumResolutionPalette();

// sets all the palette colors to black
void setFullBlackPalette();

#endif
