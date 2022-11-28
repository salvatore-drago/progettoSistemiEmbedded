
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

\(---)
: MSTORE ROOM @ DUP CHECKSUM IF HHUMIDITY @ HUMIDITY ROT ASTORE HTEMPERATURE @ TEMPERATURE ROT ASTORE ELSE THEN ;

HEX 

\(MISURA ---)
: PRINTNUMBER FLAGDIGIT SWAP BEGIN LASTDIGIT DUP 9 > WHILE REPEAT 
                             BEGIN DUP FLAGDIGIT <> WHILE DIGITPRINT REPEAT DROP ;

\(---) 
: ROOMDISPLAY STANZA SEND_CHAR PUNTI SEND_CHAR ROOM @ PRINTNUMBER SPACE SEND_CHAR  ;
\(--- TEMPERATURA)
: TEMPFETCH TEMPERATURE ROOM @ AREAD ;

\(---)
: TEMPDISPLAY GRADI SEND_CHAR PUNTI SEND_CHAR TEMPFETCH PRINTNUMBER SPACE SEND_CHAR  ;

\(--- UMIDITA)
: HUMFETCH HUMIDITY ROOM @ AREAD ;

\(---)
: HUMDISPLAY HUM SEND_CHAR PUNTI SEND_CHAR HUMFETCH PRINTNUMBER ;

\(---)
: DISPLAY ROOMDISPLAY TEMPDISPLAY HUMDISPLAY ;

: SHOW DISPLAYCLEAR 1000 DELAY DISPLAY ;

\(--- BOOL)
: CHECK HUMFETCH DUP MIN_H > SWAP MAX_H < AND TEMPFETCH DUP MIN_T > SWAP MAX_T < AND AND IF -1 ELSE 0 THEN  ;

: RESET INITC BEGIN COUNTER @ WHILE COUNTER @ WHITE SETCOLOR 
                                    COUNTER @ OFF RING 
                                    COUNTER @ APRI FIREDOOR 
                                    0 ROOM ! 
                                    SHOW  
                                    1 COUNTER DECC REPEAT ;

\(---)
: MAIN BEGIN 
        POWER
        POWER_FLAG @ IF 
                        0 II ! BEGIN
                                II @ NROOMS < WHILE \DOPO LA VERIFICA DI TEMP E UMIDITA VA FATTA QUELLA DEL SENSORE DI FIAMMA : FIAMMA;
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
                                CHANGEROOM SHOW \ SHOW è FATTO IN MODO CHE DA VA A LEGGERE HUMIDITY E TEMPERATURE DI ROOM E COMUNICHI CON IL DISPLAY, SE RICEVA -1 RESETTA LO SCHERMO
                                
                               REPEAT   
                     ELSE

                        RESET
                     THEN
       AGAIN ;
