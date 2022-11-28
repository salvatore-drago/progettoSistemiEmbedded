
DECIMAL

VARIABLE II 
0 II !
VARIABLE MIN_H
40 MIN_H !
VARIABLE MAX_H
69 MAX_H !
VARIABLE MIN_T
10 MIN_T !
VARIABLE MAX_T
27 MAX_T !

-2 CONSTANT FLAGDIGIT


CREATE HUMIDITY NROOMS 1 - ALLOT ALIGN
CREATE TEMPERATURE NROOMS 1 - ALLOT ALIGN 

\( STANZA(II) --- )
: MSTORE DUP CHECKSUM IF HHUMIDITY @ HUMIDITY ROT ASTORE HTEMPERATURE @ TEMPERATURE ROT ASTORE ELSE THEN ;

HEX 

\(MISURA ---)
: PRINTNUMBER FLAGDIGIT SWAP BEGIN LASTDIGIT DUP 9 > WHILE REPEAT 
                             BEGIN DUP FLAGDIGIT <> WHILE DIGITPRINT REPEAT DROP ;

\(---) 
: ROOMDISPLAY STANZA SEND_CHAR PUNTI SEND_CHAR ROOM @ PRINTNUMBER SPACE SEND_CHAR  ;
\(--- TEMPERATURA)
: TEMPFETCH TEMPERATURE II @ AREAD ;

\(---)
: TEMPDISPLAY GRADI SEND_CHAR PUNTI SEND_CHAR TEMPERATURE ROOM @ AREAD PRINTNUMBER SPACE SEND_CHAR  ;

\(--- UMIDITA)
: HUMFETCH HUMIDITY II @ AREAD ;

\(---)
: HUMDISPLAY HUM SEND_CHAR PUNTI SEND_CHAR HUMIDITY ROOM @ AREAD PRINTNUMBER ;

\(---)
: DISPLAY ROOMDISPLAY TEMPDISPLAY HUMDISPLAY ;

\(---)
: SHOW DISPLAYCLEAR 1000 DELAY DISPLAY ;

\(--- BOOL)
: CHECK HUMFETCH DUP MIN_H > SWAP MAX_H < AND TEMPFETCH DUP MIN_T > SWAP MAX_T < AND AND ; \ DA VERIFICARE PASSO PASSO 

: RESET INITC LCDINIT BEGIN COUNTER @ WHILE COUNTER @ WHITE SETCOLOR 
                                            COUNTER @ OFF RING 
                                            COUNTER @ APRI FIREDOOR  
                                            1 COUNTER DECC REPEAT 0 ROOM ! 0 II ! 0 POWER_FLAG ! SHOW ;

\(---)
: MAIN RESET BEGIN 
              POWER
              POWER_FLAG @ IF 
                              0 II ! BEGIN
                                      II @ NROOMS < WHILE
                                          II @ DUP RILEVAZIONE MSTORE CHECK IF 
                                                                              II @ GREEN SETCOLOR
                                                                            ELSE
                                                                              II @ YELLOW SETCOLOR 
                                                                            THEN  
                                                                II @ ISFIRE IF
                                                                              II @ DUP DUP RED SETCOLOR ON RING CHIUDI FIREDOOR
                                                                            ELSE
                                                                              II @ DUP OFF RING APRI FIREDOOR
                                                                            THEN                                                                                                    
                                      CHANGEROOM IF SHOW ELSE THEN  
                                      REPEAT  
                            ELSE
                                RESET
                            THEN
            AGAIN ;
