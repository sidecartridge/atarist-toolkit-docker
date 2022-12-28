#include <sys/types.h>
#include <stdio.h>

__uint16_t* videoAddress;

const short LOW_RES = 0;
const short MEDIUM_RES = 1;

__uint16_t savedResolution;
__uint16_t savedPalette[16];

__uint16_t palette[16] =
{
    0x000, 
    0x300,
    0x030,
    0x003,
    0x330,
    0x033,
    0x303,
    0x333,
    0x000,
    0x700,
    0x070,
    0x007,
    0x770,
    0x077,
    0x707,
    0x777
};

// gets color value in the current palette
__uint16_t GetColor(short colorIndex)
{
    return Setcolor(colorIndex, -1);
}

// saves the current palette into a buffer
void SavePalette(__uint16_t* paletteBuffer)
{
    for(int i=0; i < 16; i++)
    {
        paletteBuffer[i] = GetColor(i);
    }
}

// saves the current resolution and its palette
void SaveResolutionAndPalette()
{
    savedResolution = Getrez(); // Get current resolution
    SavePalette(savedPalette); // Save the palette
}

// restores the saved resolution and its palette
void RestoreResolutionAndPalette()
{
    Setscreen(-1,-1, savedResolution);
    Setpalette(savedPalette);
}

// changes the current resolution
void SetResolution(short resolution)
{
    Setscreen(-1,-1, resolution);
}

void DisplayInfo()
{
    SetResolution(MEDIUM_RES);
    Setcolor(0, 0x000);
    Setcolor(1, 0x777);
    Setcolor(2, 0x700);
    Setcolor(3, 0x070);
    printf("Starting ...\r\n");
    printf("Video Address : %x\r\n", videoAddress);
    printf("Press [ENTER]\r\n");
    getchar();
}

void DisplayScreen()
{
    // pattern : 16 pixels into 4 words
    __uint16_t pixels[4] =
    {
        0b1000000000000001,
        0b0100000000000001,
        0b0000000000000000,
        0b1100000000000001
    };

    // not optimized, but better for understanding
    // 20 blocks * 200 lines = 4000 iterations
    for(int i = 0 ; i < 4000 ; i ++)
    {
        short offset = 4 * i;
        videoAddress[offset]     = pixels[0];
        videoAddress[offset + 1] = pixels[1];
        videoAddress[offset + 2] = pixels[2];
        videoAddress[offset + 3] = pixels[3];
    }
}

// demo runs here
int main(int argc, char *argv[])
{
    // inits
    videoAddress = Logbase(); // get the logical pointer of the video RAM
    SaveResolutionAndPalette();
    DisplayInfo();
 
    // demo
    SetResolution(LOW_RES);
    Setpalette(palette);
    DisplayScreen();    
    getchar();

    // restore initial state   
    RestoreResolutionAndPalette();
    return 0;
}