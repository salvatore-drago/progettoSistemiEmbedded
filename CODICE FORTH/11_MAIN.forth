
DECIMAL

0 VARIABLE II 
55 VARIABLE MIN_H
69 VARIABLE MAX_H
18 VARIABLE MIN_T
27 VARIABLE MAX_T

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
\( -- )
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
                                                              II @ FIAMMA IF
                                                                            II @ DUP OFF RING APRI FIREDOOR
                                                                          ELSE
                                                                            II @ DUP DUP RED SETCOLOR ON RING CHIUDI FIREDOOR
                                                                          THEN
                                    \ VA VISUALIZZATO QUALCOSA NEL DISPLAY- SEMPRE STANZA 0 FINO A QUANDO NON VIENE CAMBIATO ATTRAVERSO IL BOTTONE   : DISPLAY;
                                    
                                CHANGEROOM ROOM DISPLAY \ DISPLAY è FATTO IN MODO CHE DA VA A LEGGERE HUMIDITY E TEMPERATURE DI ROOM E COMUNICHI CON IL DISPLAY, SE RICEVA -1 RESETTA LO SCHERMO
                                
                               REPEAT   
                     ELSE
                        \\ AZZERRARE TUTTO: LED- DISPALY - RING 
                        RESET
                     THEN
       AGAIN ;