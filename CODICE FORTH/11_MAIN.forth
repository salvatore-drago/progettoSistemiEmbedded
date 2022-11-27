
DECIMAL

VARIABLE II 
0 II !
VARIABLE MIN_H
55 MIN_H !
VARIABLE MAX_H
69 MAX_H !
VARIABLE MIN_T
18 MIN_T !
VARIABLE MAX_T
27 MAX_T !
VARIABLE CYCLETEMP
0 CYCLETEMP !
VARIABLE CYCLEHUM
0 CYCLEHUM !
VARIABILE CYCLEROOM
0 CYCLEROOM !

CREATE HUMIDITY NROOMS 1 - ALLOT ALIGN
CREATE TEMPERATURE NROOMS 1 - ALLOT ALIGN 

\( STANZA -- )
: MSTORE DUP CHECKSUM IF HHUMIDITY @ HUMIDITY ROT ASTORE HTEMPERATURE @ TEMPERATURE ROT ASTORE ELSE THEN ;

\( STANZA -- BOOL )
: CHECK DUP HYMIDITY SWAP AREAD DUP MIN_H > SWAP MAX_H < AND SWAP TEMPERATURE SWAP AREAD DUP MIN_T > SWAP MAX_T < AND AND IF -1 ELSE 0 THEN  ;

: RESET INITC BEGIN COUNTER @ WHILE COUNTER @ WHITE SETCOLOR 
                                    COUNTER @ OFF RING 
                                    COUNTER @ APRI FIREDOOR 
                                    0 ROOM ! 
                                   -1 DISPLAY  
                                    1 COUNTER DECC REPEAT ;

\SOSTITUISCE MOMENTANEAMENTE DISPLAY LED O HDMI
HEX 


\ (---) 
: ROOMDISPLAY STANZA SEND_CHAR PUNTI SEND_CHAR ROOM @ CYCLEROOM ! BEGIN CYCLEROOM @ LASTDIGIT DUP CYCLETEMP ! 0 <> WHILE DIGITPRINT REPEAT DIGITPRINT SPACE SEND_CHAR ;

\(---)
: TEMPFETCH TEMPERATURE ROOM @ AREAD ;

\(---)
: TEMPDISPLAY GRADI SEND_CHAR PUNTI SEND_CHAR TEMPFETCH CYCLETEMP ! BEGIN CYCLETEMP @ LASTDIGIT DUP CYCLETEMP ! 0 <> WHILE DIGITPRINT REPEAT DIGITPRINT SPACE SEND_CHAR ;

\(---)
: HUMFETCH HUMIDITY ROOMFETCHVA AREAD;

\(---)
: HUMDISPLAY HUM SEND_CHAR PUNTI SEND_CHAR HUMFETCH CYCLEHUM ! BEGIN CYCLEHUM @ LASTDIGIT DUP CYCLEHUM ! 0 <> WHILE DIGITPRINT REPEAT DIGITPRINT SPACE SEND_CHAR ;

\(---)
: DISPLAY DISPLAYCLEAR ROOMDISPLAY TEMPDISPLAY HUMDISPLAY ;

\(---)
: MAIN BEGIN 
        POWER
        POWER_FLAG @ IF 
                        0 II ! BEGIN
                                II @ NROOMS < WHILE \DOPO LA VERIFICA DI TEMP E UMIDITA VA FATTA QUELLA DEL SENSORE DI FIAMMA : FIAMMA;
                                    II @ DUP DUP RILEVAZIONE MSTORE CHECK IF 
                                                                            II @ GREEN SETCOLOR
                                                                          ELSE
                                                                            II @ YELLOW SETCOLOR 
                                                                          THEN  
                                                              II @ ISFIRE IF
                                                                            II @ DUP DUP RED SETCOLOR ON RING CHIUDI FIREDOOR
                                                                          ELSE
                                                                            II @ DUP OFF RING APRI FIREDOOR
                                                                          THEN
                                    \ VA VISUALIZZATO QUALCOSA NEL DISPLAY- SEMPRE STANZA 0 FINO A QUANDO NON VIENE CAMBIATO ATTRAVERSO IL BOTTONE   : DISPLAY;
                                    
                                CHANGEROOM DISPLAY \ DISPLAY è FATTO IN MODO CHE DA VA A LEGGERE HUMIDITY E TEMPERATURE DI ROOM E COMUNICHI CON IL DISPLAY, SE RICEVA -1 RESETTA LO SCHERMO
                                
                               REPEAT   
                     ELSE
                        \\ AZZERRARE TUTTO: LED- DISPALY - RING 
                        RESET
                     THEN
       AGAIN ;