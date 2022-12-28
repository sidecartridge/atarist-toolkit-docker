; ---------------------------------------------------
; Hello, Bitmap Brothers! en assembleur pour Atari ST 
; (inspiré du HelloWorld de Vretrocomputing, 2019.)
; Date : 02/2021
; ---------------------------------------------------

; -- DEBUT ----------------------------------------------------------------------
; affichage du message
	PEA     MESSAGE	        ; 4 octets sur la pile (PEA = PUSH EFFECTIVE ADDRESS)
	MOVE.W	#9,-(sp)		; 2 octets sur la pile (9 = affiche chaine)s
	TRAP	#1
	ADDQ.L	#6,sp			; ajustement de la pile 6 octets

; attente d'une touche
	MOVE.W	#8,-(sp)		; 2 octets sur la pile (8 = attente clavier)
	TRAP	#1
	ADDQ.L	#2,sp			; ajustement de la pile de 2 octects

; fin du processus, retour au GEM
	CLR.W   -(sp)			; 1 octet sur la pile
	TRAP    #1				; pas de besoin d'ajuster
; -- FIN ------------------------------------------------------------------------

; -- EQUATES ------------------------------------
CR	EQU	$0D	; ASCII Carriage Return
LF	EQU	$0A	; ASCII Line Feed
ES	EQU	$00	; Fin de chaine 
EA	EQU	$82 ; E accent aigue selon la table ASCII
; -- EQUATES ------------------------------------

; -- DATA -----------------------------------------------
MESSAGE:
	DC.B	  "Hello Bitmap Brothers!",CR,LF
	DC.B	  "----------------------",CR,LF
	DC.B      "- Compil",EA," avec vasm sur Linux",CR,LF
	DC.B      "- Link",EA," avec vlink sur Linux",CR,LF
	DC.B	  "----------------------",CR,LF
	DC.B	  "<APPUYER SUR UNE TOUCHE>",CR,LF,ES
; -- DATA -----------------------------------------------
