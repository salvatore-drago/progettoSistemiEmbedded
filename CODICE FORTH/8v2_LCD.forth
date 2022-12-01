P7 D7
P6 D6
P5 D5
P4 D4
P3 BACK
P2 ENABLE
P1 R/W' 0:R 1:W
P0 RS

VARIABLE TI4
: INITTI4 TIMESTAMP TI4 ! ;

\: CHANGEROOM TIMESTAMP TI4 @ - 5000000 >=  IF ROOM @ 1 + NROOMS MOD ROOM ! -1 INITTI4 ELSE 0 THEN ;
\: CHANGEROOM ROOM @ 1 + NROOMS MOD ROOM ! ;

\: RESET INITC LCDINIT BEGIN COUNTER @ WHILE 1 COUNTER DECC 
                                            \COUNTER @ WHITE SETCOLOR 
                                            \COUNTER @ OFF RING 
                                            \COUNTER @ APRI FIREDOOR  
                      \REPEAT -1 ROOM ! 0 II ! INITTI4  ; 

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







DECIMAL

\NUMERO STANZE
4 CONSTANT NROOMS
VARIABLE COUNTER


\CREAZIONE VETTORI PERIFERICHE, L'INDICE INDICA LA STANZA (ES. GREENLEDS[0]= VALORE GPIO CORRISPONDENDE AL LED VERDE DELLA STANZA 0)

CREATE GREENLEDS NROOMS 1 -  ALLOT ALIGN
CREATE REDLEDS NROOMS 1 - ALLOT ALIGN
CREATE BLULEDS NROOMS 1 - ALLOT ALIGN
CREATE THERMOS NROOMS 1 - ALLOT ALIGN
CREATE BUZZERS NROOMS 1 - ALLOT ALIGN
CREATE SERVOS NROOMS 1 - ALLOT ALIGN
CREATE FLAMES NROOMS 1- ALLOT ALIGN



\ INIZIALIZZAZIONE VARIABILE COUNTER CON VALORE NROOMS
\ ( -- )
: INITC NROOMS COUNTER ! ;

\PAROLE DI UTILITA' PER ARRAY   

\ ( GPIO  ARRAY_SENS  N_CELLA -- ) (ES_SCRITTURA: 170  GREENLEDS 1 ASTORE)
: ASTORE + C! ;
\ ( ARRAY_SENS N_CELLA -- VALUE) (ES_LETTURA: GREENLEDS 1 AREAD)
: AREAD + C@ ;


\INIZIALIZZAZIONE STANZA 0
17 REDLEDS 0 ASTORE 
18 GREENLEDS 0 ASTORE
27 BLULEDS 0 ASTORE
5 THERMOS 0 ASTORE
13 BUZZERS 0 ASTORE
12 SERVOS 0 ASTORE
6 FLAMES 0 ASTORE

\INIZIALIZZAZIONE STANZA 1 (UGUALE A STANZA 0 PER PROVA)
17 REDLEDS 1 ASTORE
18 GREENLEDS 1 ASTORE
27 BLULEDS 1 ASTORE
5 THERMOS 1 ASTORE
13 BUZZERS 1 ASTORE
12 SERVOS 1 ASTORE
6 FLAMES 1 ASTORE

\INIZIALIZZAZIONE STANZA 2 (UGUALE A STANZA 0 PER PROVA)
17 REDLEDS 0 ASTORE 
18 GREENLEDS 0 ASTORE
27 BLULEDS 0 ASTORE
5 THERMOS 0 ASTORE
13 BUZZERS 0 ASTORE
12 SERVOS 0 ASTORE
6 FLAMES 0 ASTORE

\INIZIALIZZAZIONE STANZA 3 (UGUALE A STANZA 0 PER PROVA)
17 REDLEDS 1 ASTORE
18 GREENLEDS 1 ASTORE
27 BLULEDS 1 ASTORE
5 THERMOS 1 ASTORE
13 BUZZERS 1 ASTORE
12 SERVOS 1 ASTORE
6 FLAMES 1 ASTORE

\MODIFICA GPIOFSEL PER TUTTI I GPIO COLLEGATI AD UNA TIPOLOGIA DI SENSORI (PER TUTTE LE STANZE) 
\ ( VALORE_LOGICO ARRAY_SENS --  ) 

: ABILS INITC BEGIN COUNTER @ WHILE 2DUP COUNTER @ 1 - AREAD SWAP ABILPIN 1 COUNTER DECC COUNTER @ 0 = IF DROP DROP THEN REPEAT ;


\ABILITA GPIO SENSORI LED IN OUTPUT
1 REDLEDS ABILS
1 GREENLEDS ABILS
1 BLULEDS ABILS

\ABILITA GPIO THERMOS IN INPUT
0 THERMOS ABILS

\ ABILITA GPIO FLAMES IN INPUT
0 FLAMES ABILS

\ABILITA GPIO BUZZERS IN OUTPUT
1 BUZZERS ABILS

\ABILITA GPIO SERVOS 
\VEDI 7_SERVO   VENGONO ABILITATI CON LE RISPETTIVE FUNZIONI ALT DI GESTIONE DEL PWM AL MOMENTO DELL'UTILIZZO

\I2C PER DISPLAYLED
\ABILITA GPIO 2 E 3 IN SDA E SCL
2 4 ABILPIN
3 4 ABILPIN

\ABILITA GPIO BOTTONE AVVIO\SPEGNIMENTO IN INGRESSO
\23 0 ABILPIN


\ABILITA GPIO BOTTONE DISPLAY IN INGRESSO
\25 0 ABILPIN

