P7 D7
P6 D6
P5 D5
P4 D4
P3 BACK
P2 ENABLE
P1 R/W' 0:R 1:W
P0 RS

\(---) 
: MAINB RESET BEGIN 
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