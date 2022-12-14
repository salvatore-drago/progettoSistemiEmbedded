
DECIMAL

20000 CONSTANT M_ATTESA \DEVE TENERE IL GPIO DATA IN USCITA BASSA PER ALMENO 18 MS, DOPO DEVE RIPORTARE IL GPIO IN INGRESSO
160 CONSTANT S_ATTESA \IL SENSORE ATTENDE 160 US PRIMA DI COMINCIARE AD INVIRAE I DATI
40 CONSTANT N_BITS \ [High humidity (8 BITS) - Low humidity (8 BITS) - High temp (8 BITS) - Low temp (8 BITS) - Parity bit (8 BITS)]
4800 CONSTANT ALT \ DURATA MASSIMA INTERA TRASMISSIONE
80 CONSTANT 1END \ IL SENSORE MANTIENE L'USCITA ALTA QUANDO HA TERMINAO DI INVIARE I DATI PER 80 MICROSECONDI

VARIABLE TI1 \TEMPO INIZIALE
VARIABLE TI2

VARIABLE ACC
VARIABLE BASE
VARIABLE HHUMIDITY
VARIABLE HTEMPERATURE
VARIABLE LHUMIDITY
VARIABLE LTEMPERATURE  
VARIABLE PARITY

CREATE DATI N_BITS 1 - ALLOT ALIGN

\ INIZIALIZZAZIONE VARIABILE ACC CON VALORE 0
\ ( -- )
: INITACC 0 ACC ! ;


\(BIT_FINE BIT_INIZIO -- )
: INITBASE - BASE ! ;

\INIZIALIZZAZIONE VARIABILI TEMPORALI
: INITTI1 TIMESTAMP TI1 ! ;
: INITTI2 TIMESTAMP TI2 ! ;

\COMANDO PER COMUNICARE AL SENSORE CHE IL MICROCONTROLLORE E' PRONTO A RICEVERE I DATI
\ ( STANZA -- STANZA GPIO )                          
: START DUP THERMOS SWAP AREAD DUP 2DUP DUP CLRGPIO  001  ABILPIN  CLRGPIO M_ATTESA DELAY 000 ABILPIN ;


\COMANDO PER ATTENDERE CHE IL SENSORE INIZI A COMUNICARE
\ (-- )
: WAIT S_ATTESA DELAY ;

\FUNZIONE CHE RITORNA FALSE QUANDO LETX=0 E LETY=1 ALTRIMENTI RITORNA TRUE  (LETX : PENULTIMA LETTURA;  LETY : ULTIMA LETTURA;)
\ (LETX LETY -- BOOL)
: SWITCHED 1 = SWAP 0 = AND -1 = IF 0 ELSE -1 THEN ;


\ RILEVA E MEMORIZZA NELL'ARRAY DATI[N] L'ENNESIMO VALORE COMUNICATO DAL SENSORE
\ (GPIO ACC  -- GPIO ACC )  \29 ??
: ZERONEREAD SWAP 2DUP 29 DELAY READLEV DUP 0 = IF DATI ROT ASTORE  ELSE DATI ROT ASTORE INITTI2 BEGIN DUP READLEV 1 = TIMESTAMP TI2 @ - 1END < AND WHILE REPEAT THEN SWAP DROP ;


\LETTURA DATI GPLEV
\( STANZA GPIO -- STANZA GPIO)
: READS INITACC INITTI1 BEGIN ACC @ N_BITS < TIMESTAMP TI1 @ - ALT < AND  WHILE BEGIN DUP READLEV  0 = WHILE REPEAT ACC @  ZERONEREAD 1 ACC ADDC REPEAT ; \ 1500000 DELAY  ;

\( STANZA -- )
: RILEVAZIONE START WAIT READS DROP DROP ;

\PAROLA PER TRASFORMARE LA LETTUTA BINARIA IN DATI IN VALORE DECIMALE
\( VARIABILE DATI BIT_FINE BIT_INIZIO -- VAL_DEC)
: FETCHING 2DUP INITBASE INITACC ACC ADDC BEGIN ACC @ 2DUP SWAP <= WHILE ROT SWAP AREAD BASE @ LSHIFT  1 BASE DECC  1 ACC ADDC SWAP DATI SWAP  REPEAT DROP DROP DROP + + + + + + + SWAP ! ;

\ COMANDI DI TUTILITA PER LETTURA [High humidity (8 BITS) - Low humidity (8 BITS) - High temp (8 BITS) - Low temp (8 BITS) - Parity bit (8 BITS)]
\( -- )

: READHHUMIDITY HHUMIDITY DATI 7 0 FETCHING ;

: READLHUMIDITY LHUMIDITY DATI 15 8 FETCHING ;

: READHTEMP HTEMPERATURE DATI 23 16 FETCHING ;

: READLTEMP LTEMPERATURE DATI 31 24 FETCHING ;

: READPARITY PARITY DATI 39 32 FETCHING ;


\EFFETTUA LA VERIFICA ATTRAVERSO PARITY BIT
\ ( -- BOLL) ( DA MODIFICARE)
: CHECKSUM READHHUMIDITY READLHUMIDITY READHTEMP  READLTEMP READPARITY  HHUMIDITY @ LHUMIDITY @ HTEMPERATURE @ LTEMPERATURE @ + + + DUP PARITY @ = IF DROP -1  ELSE
                                                                                                                             DUP PARITY @ 256 +  = IF DROP -1  ELSE
                                                                                                                                            DROP 0 THEN THEN  ;

