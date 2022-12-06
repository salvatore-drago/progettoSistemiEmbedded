
DECIMAL

\NUMERO STANZE
2 CONSTANT NROOMS
VARIABLE COUNTER


\CREAZIONE VETTORI PERIFERICHE, L'INDICE INDICA LA STANZA (ES. GREENLEDS[0]= VALORE GPIO CORRISPONDENDE AL LED VERDE DELLA STANZA 0)

CREATE GREENLEDS NROOMS 1 -  ALLOT ALIGN
CREATE REDLEDS NROOMS 1 - ALLOT ALIGN
CREATE BLULEDS NROOMS 1 - ALLOT ALIGN
CREATE THERMOS NROOMS 1 - ALLOT ALIGN
CREATE BUZZERS NROOMS 1 - ALLOT ALIGN
CREATE SERVOS NROOMS 1 - ALLOT ALIGN
CREATE FLAMES NROOMS 1 - ALLOT ALIGN



\ INIZIALIZZAZIONE VARIABILE COUNTER CON VALORE NROOMS
\ ( -- )
: INITC NROOMS COUNTER ! ;

\PAROLE DI UTILITA' PER ARRAY   

\ ( GPIO  ARRAY_SENS  N_CELLA -- ) (ES_SCRITTURA: 170  GREENLEDS 1 ASTORE)
: ASTORE + C! ;
\ ( ARRAY_SENS N_CELLA -- VALUE) (ES_LETTURA: GREENLEDS 1 AREAD)
: AREAD + C@ ;


\INIZIALIZZAZIONE STANZA 0
7 REDLEDS 0 ASTORE 
8 GREENLEDS 0 ASTORE
9 BLULEDS 0 ASTORE
5 THERMOS 0 ASTORE
13 BUZZERS 0 ASTORE
12 SERVOS 0 ASTORE
6 FLAMES 0 ASTORE

\INIZIALIZZAZIONE STANZA 1 (UGUALE A STANZA 0 PER PROVA)
7 REDLEDS 1 ASTORE
8 GREENLEDS 1 ASTORE
9 BLULEDS 1 ASTORE
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


\SEZIONE GESTIONE PWM
HEX

OFFSETPI @ 001010A0 + CONSTANT CM_PWMCTL 
OFFSETPI @ 001010A4 + CONSTANT CM_PWMDIV 
5A000000 CONSTANT CM_PASSWD \ PASSWORD PER MODIFICA 
1 4 LSHIFT CONSTANT CM_PWMCTL_ENAB \ BIT DI ABILITAZIONE DEL CM_PWM CHE CORRISPONDE AL QUARTO


: VALUE_PWM_CTL2 100 ; \0000 0001 0000 0000 ABILITIAMO IL SECONDO CANALE DEL PWM
: VALUE_PWM_CTL1  1 ; \0000 0000 0000 0001 ABILITIAMO IL PRIMO CANALE DEL PWM
 
 0 PWMCTL ! \ TURN OFF PWM
 

DECIMAL  
 
CM_PASSWD 1 OR CM_PWMCTL @ OR CM_PWMCTL ! \ 19,2 MHz frequenza oscillatore RASP PI 3
CM_PASSWD DIVIDER @ 12 LSHIFT OR CM_PWMDIV ! \ frequenza di uscita = 19,2 MHz/192 = 100KHz
CM_PASSWD CM_PWMCTL_ENAB OR CM_PWMCTL @ OR CM_PWMCTL !


: RANGE 2000 ; \ PWM Range = (frequenza PWM=100KHz ) /(frequenza di output desiderata = 50Hz COME DA DOCUMENTAZIONE SERVO SG90) (1/0,02 SEC)

\( -- )
: PWMSET1 VALUE_PWM_CTL1 1 7 LSHIFT OR PWMCTL ! \IMPOSTIAMO IL CANALE 1 IN M/S     0000 0000 1000 0001
		RANGE PWMRNG1 ! ;
\( -- )
: PWMSET2 VALUE_PWM_CTL2 1 15 LSHIFT OR PWMCTL ! \IMPOSTIAMO IL CANALE 2 IN M/S    1000 0001 0000 0000
		RANGE PWMRNG2 ! ;
\

\SEZIONE GESTIONE I2C
HEX

OFFSETPI @ 00205000 + CONSTANT I2C0
OFFSETPI @ 00804000 + CONSTANT I2C1
OFFSETPI @ 00805000 + CONSTANT I2C2 \  dedicato all'interfaccia HDMI: NON UTILIZZARE 

0 CONSTANT _C          \ CONTROL 1000 0000 1000 0000
4 CONSTANT _S          \ STATUS
8 CONSTANT _DLEN       \ DATA LENGHT  0:15 BIT ESPRIMONO IL NUMERO DI BYTE DA INVIARE
0C CONSTANT _A         \ SLAVE ADDRESS REGISTER  0X27  100111 (PCF8574T)     
10 CONSTANT _FIFO      \ DATA FIFO AGGIUNGI UN BYTE ALLA CODA FIFO DA 16 BYTE, USARE BIT 0:7
14 CONSTANT _DIV       \ CORE_CLOCK/_DIV  ----> 150 MHZ/ 1500 = 100 KHZ DI DEFAULT, BIT 0:15 
18 CONSTANT _DEL       \ data delay register DEFAULT
1C CONSTANT _CLKT      \ clock stretch timeout DEFAULT


\( I2Cn REG_NAME -- REG  )
: SELI2C + ;

\( I2C -- )
: I2CCLEAR  _C SELI2C DUP @ 1 5 LSHIFT OR SWAP ! ; \ PULIRE LA FIFO

\( I2C -- )
: I2CDATALEN 1 SWAP  _DLEN SELI2C  ! ; \ STABILIRE IL NUMERO DI BYTE DA INVIARE

\( I2C DATA -- )
: I2CDATA SWAP _FIFO SELI2C ! ; \ SETTARE I DATI DA INVIARE

\( I2C -- )
: I2CRESET _S SELI2C 302 SWAP ! ; \RESETTARE IL FLAG DI DONE  1100000010

\( I2C ADDR_SLAVE -- )
: I2CSLAVE SWAP _A SELI2C ! ; \ SETTA L'INDIRIZZO DELLO SLAVE

\( I2C --  )
: I2CSTART _C SELI2C  8080 SWAP ! ;  \INIZIARE LA COMUNICAZIONE

\( I2C -- )
: I2CDONE BEGIN DUP _S SELI2C @ 1 1 LSHIFT AND 0 = WHILE  REPEAT I2CRESET  ; \ASPETTARE CHE L'INVIO TERMINI 

\(DATA  I2C -- )
: I2CSEND DUP I2CRESET  DUP I2CCLEAR DUP I2CDATALEN DUP ROT I2CDATA  DUP I2CSTART I2CDONE ; \ INVIAMO SEMPRE 1 BYTE ALLA VOLTA