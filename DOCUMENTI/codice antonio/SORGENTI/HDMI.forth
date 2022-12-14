HEX 

: FBUFFER FRAMEBUFFER @ ;

FRAMEBUFFER 1 CELLS + @ CONSTANT WIDTH
FRAMEBUFFER 2 CELLS + @ CONSTANT HEIGHT

VARIABLE N_PIXEL \ INDICA IL NUMERO DI PIXEL DI CUI È COMPOSTA UNA RIGA
VARIABLE POSX \ INDICA LA POSIZIONE X DEL PUNTO DI PARTENZA
VARIABLE POSY \ INDICA LA POSIZIONE Y DEL PUNTO DI PARTENZA
VARIABLE REL_HEIGHT \ INDICA L'ALTEZZA DELLA FIGURA DA RAPPRESENTARE
VARIABLE REL_WIDTH \ INDICA LA ALRGHEZZA DELLA FIGURA DA RAPPRESENTARE

\ COLORI UTILIZZATI
: BLU 00291CB2 ;
: VERDE 0000F281 ;
: NERO 00000000 ;
: BIANCO 00FFFFFF ;
: ROSSO 00FF0000 ;
: GIALLO 00FFFF00 ;

\ ARRAY CONTENENTE LE INFORMAZIONI PER FAR APPARIRE LA PRIMA SCHERMATA
CREATE DISTRIBUTORE 
BIANCO , WIDTH , HEIGHT , 0 , 0 , 
BLU , WIDTH , F , 0 , 0 ,
BLU , WIDTH , F , 0 , 168 ,
BLU , WIDTH , F , 0 , 2F1 ,
BLU , F , HEIGHT , 0 , 0 ,
BLU , F , HEIGHT , 3F1 , 0 ,
VERDE , 7A , 34 , CF , 143 ,
VERDE , 7A , 34 , 2CB , 143 ,
VERDE , 7A , 34 , CF , 2CC ,
VERDE , 7A , 34 , 2CB , 2CC ,

\PAROLA CHE DETERMINA LA POSIZIONE/OFFSET DEL PIXEL
\UTILIZZA COME INPUT I VALORI CONTENUTI DENTRO LE VARIABILI POSX POSY
\ CHE RAPPRESENTANO IL PRIMO PIXEL SOTTO FORMA DI COORDINATE COLONNA RIGA
\( -- INDIRIZZO )
: POSITIONPIXEL POSX @ POSY @ WIDTH * + 4 * FBUFFER + ;

\ PAROLE CHE PERMETTONO DI RAPPRESENTARE A SCHERMO UNA 
\ RIGA NELLE 2 DIVERSE DIREZIONI
: ORIZONTALE_D N_PIXEL ! POSITIONPIXEL CONTATORE ! \ ( COLORE N_PIXEL -- )
			   BEGIN DUP CONTATORE @ !
					 4 CONTATORE ++I
					 1 N_PIXEL --I N_PIXEL @ 
				0 = UNTIL DROP ; 

: VERT_VSUD N_PIXEL ! POSITIONPIXEL CONTATORE ! \ ( COLORE N_PIXEL -- )			   
			   BEGIN DUP CONTATORE @ !
					 1000 CONTATORE ++I
					 1 N_PIXEL --I N_PIXEL @ 
				0 = UNTIL DROP ;  

\ PAROLA CHE STAMPA A VIDEO UN RETTANGOLO
\ (COLORE REL_WIDTH REL_HEIGHT POSX POSY -- )
: RETTANGOLO POSY ! POSX ! 2DUP REL_HEIGHT ! REL_WIDTH !
			 > IF
				BEGIN
					DUP REL_WIDTH @ ORIZONTALE_D
					1 POSY ++I 
					1 REL_HEIGHT --I
				REL_HEIGHT @ 0 = UNTIL
				DROP
			ELSE
				BEGIN
					DUP REL_HEIGHT @ VERT_VSUD
					1 POSX ++I 
					1 REL_WIDTH --I
				REL_WIDTH @ 0 = UNTIL
				DROP
			 THEN ;

: CODICE1 NERO 5 25 ED 14A RETTANGOLO \1
		  NERO 18 5 FC 14A RETTANGOLO \2
		  NERO 5 15 10F 14A RETTANGOLO
		  NERO 18 5 FC 15A RETTANGOLO
		  NERO 5 15 FC 15A RETTANGOLO
		  NERO 18 5 FC 16A RETTANGOLO 
		  NERO 5 25 11D 14A RETTANGOLO \A
		  NERO 18 5 11D 14A RETTANGOLO
		  NERO 5 25 132 14A RETTANGOLO
		  NERO 18 5 11D 15A RETTANGOLO ;
		  
: CODICE2 NERO 5 25 2E6 14A RETTANGOLO \1
		  NERO 18 5 2F5 14A RETTANGOLO \3
		  NERO 5 25 308 14A RETTANGOLO
		  NERO 18 5 2F5 16A RETTANGOLO
		  NERO E 5 2FA 15A RETTANGOLO 
		  NERO 5 25 316 14A RETTANGOLO \A
		  NERO 18 5 316 14A RETTANGOLO
		  NERO 5 25 32B 14A RETTANGOLO
		  NERO 18 5 316 15A RETTANGOLO ;

: CODICE3 NERO 18 5 DA 2D4 RETTANGOLO \2
		  NERO 5 15 ED 2D4 RETTANGOLO		  
		  NERO 18 5 DA 2E4 RETTANGOLO		  
		  NERO 5 15 DA 2E4 RETTANGOLO 		  
		  NERO 18 5 DA 2F4 RETTANGOLO		  
		  NERO 18 5 FD 2D4 RETTANGOLO \2
		  NERO 5 15 110 2D4 RETTANGOLO		  
		  NERO 18 5 FD 2E4 RETTANGOLO		  
		  NERO 5 15 FD 2E4 RETTANGOLO 		  
		  NERO 18 5 FD 2F4 RETTANGOLO 	  
		  NERO 5 25 11D 2D4 RETTANGOLO \B
		  NERO 16 5 11D 2D4 RETTANGOLO
		  NERO 16 5 11D 2E4 RETTANGOLO
		  NERO 16 5 11D 2F4 RETTANGOLO
		  NERO 5 C 133 2D9 RETTANGOLO
		  NERO 5 C 133 2E9 RETTANGOLO ;

: CODICE4 NERO 18 5 2DB 2D4 RETTANGOLO \2
		  NERO 5 15 2EE 2D4 RETTANGOLO		  
		  NERO 18 5 2DB 2E4 RETTANGOLO		  
		  NERO 5 15 2DB 2E4 RETTANGOLO 		  
		  NERO 18 5 2DB 2F4 RETTANGOLO		  
		  NERO 18 5 2FC 2D4 RETTANGOLO \3
		  NERO F 5 303 2E4 RETTANGOLO		  
		  NERO 18 5 2FC 2F4 RETTANGOLO		  
		  NERO 5 25 310 2D4 RETTANGOLO 		  
		  NERO 5 25 31E 2D4 RETTANGOLO \B
		  NERO 16 5 31E 2D4 RETTANGOLO
		  NERO 16 5 31E 2E4 RETTANGOLO
		  NERO 16 5 31E 2F4 RETTANGOLO
		  NERO 5 C 334 2D9 RETTANGOLO
		  NERO 5 C 334 2E9 RETTANGOLO ;		  







