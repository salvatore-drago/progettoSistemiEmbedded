
DECIMAL





500000 CONSTANT PRESSIONE \LA PRESSIONE SUI BOTTONI DEVE DURARE ALMENO 0.5 SEC

VARIABLE POWER_FLAG \ 0: SISTEMA SPENTO, -1: SISTEMA ACCESSO;;
0 POWER_FLAG !
VARIABLE TI3
VARIABLE ROOM \ STANZA SELEZIONATA 
0 ROOM !



: INITTI3 TIMESTAMP TI3 ! ;


\( GPIO -- BOOL)
: PUSHED INITTI3 BEGIN DUP READLEV WHILE REPEAT TIMETSAMP TI3 @ - PRESSIONE >= IF DROP -1 ELSE DROP 0 THEN ;

\( -- )
: POWER 23 PUSHED IF POWER_FLAG @ IF 0 POWER_FLAG ! ELSE -1 POWER_FLAG ! THEN  ELSE THEN ;

\ ( -- )
: CHANGEROOM 24 PUSHED IF ROOM @ 1 + NROOMS MOD ROOM ! ELSE THEN ;