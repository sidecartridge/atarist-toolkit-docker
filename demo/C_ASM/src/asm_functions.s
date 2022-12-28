; -------------------------------------------------------------------------------
; -- Declaring C functions to be called by ASM	
; -------------------------------------------------------------------------------
	XREF	_helloPalaceSoftware	; mapped to void helloPalaceSoftware();
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- Declaring ASM functions to be called from C
; -------------------------------------------------------------------------------
	XDEF	_asm_helloBitmapBrothers
	XDEF	_asm_callbackHelloPalaceSoftware
	XDEF	_asm_keypressed
	XDEF	_asm_multiply
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- Implementation of  : void asm_helloBitmapBrothers();
; -- Description : write the string placed in MESSAGE
; -------------------------------------------------------------------------------
_asm_helloBitmapBrothers:
	PEA			MSG_PREFIX		; Stack : 4 bytes (PEA = PUSH EFFECTIVE ADDRESS)
	BSR			print_string        
	ADDQ.L		#4,sp			; Stack : ajustment 4 bytes
	PEA			MESSAGE			; Stack : 4 bytes 
	BSR			print_string
	ADDQ.L		#4,sp			; Stack : ajustment 4 bytes
	RTS
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- Implementation of  : void  asm_callbackHelloPalaceSoftware(); 
; -- Description : Simply calls the C funtion "helloPalaceSoftWare()".
; -------------------------------------------------------------------------------
_asm_callbackHelloPalaceSoftware:
	PEA		MSG_PREFIX				; Stack : 4 bytes 
	BSR		print_string            
	ADDQ.L	#4,sp					; Stack : ajustment 4 bytes
	BSR		_helloPalaceSoftware	; Calls C void helloPalaceSoftware();
	RTS
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- Implementation of  : void asm_keypressed(); 
; -- Description : wait for a key to be pressed. 
; -------------------------------------------------------------------------------
_asm_keypressed:
	MOVE.W	#8,-(sp)	; Stack : 2 bytes (#8 = key pressed wait)
	TRAP	#1
	ADDQ.L	#2,sp		; Stack : ajustment 2 bytes
	RTS
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- Implementation of  : __uint32_t asm_multiply(__uint32_t a, __uint32_t b); 
; -- Description : multiplies 2 numbers (16 bits unsigned integers) and returns 
; --               the value in D0.
; -------------------------------------------------------------------------------
_asm_multiply:
	MOVE.L	4(SP), D0	;get 1st parameter (32 bits), put in D0
	MOVE.L	8(SP), D1	;get 2nd parameter (32 bits), put in D1
	MULU	D1, D0		;multiply D1 with D0 and put the result in D0
	RTS
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; -- ASM routine : print_string 
; -- Description : Subroutine to easily print a string.
; -- Usage : 	PEA		MSG				; Stack : 4 bytes 
; --			BSR		print_string        
; --			ADDQ.L	#4,sp			; Stack : ajustment 4 bytes
; -------------------------------------------------------------------------------             
print_string:
	MOVE.L	4(SP),D0	; let's get the parameter in the stack with offset
	MOVE.L	D0,-(SP)	; place it on the stack again
	MOVE.W	#9,-(SP)	; Stack : 2 bytes (#9 = display string)
	TRAP	#1			; displaying the prefix
	ADDQ.L	#6,SP		; Stack : ajustment 6 bytes (4+2) 
	RTS
; -------------------------------------------------------------------------------	

; -------------------------------------------------------------------------------   
; -- EQUATES
; -------------------------------------------------------------------------------
CR	EQU	$0D		; ASCII Carriage Return
LF	EQU	$0A		; ASCII Line Feed
ES	EQU	$00		; Fin de chaine 
; -----------------------------------------------

; -------------------------------------------------------------------------------
; -- DATA
; -------------------------------------------------------------------------------
MESSAGE:
	DC.B	"Hello Bitmap Brothers!",CR,LF,ES
MSG_PREFIX:
	DC.B	"ASM > ",ES
; -------------------------------------------------------------------------------
