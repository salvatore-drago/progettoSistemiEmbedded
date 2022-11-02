
\ GESTIONE E ABILITAZIONE DEL TASTIERINO NUMERICO

\ GPIO UTILIZZATI PER COLLEGARE IL KEYPAD
: KM_ROW8 2 ;
: KM_ROW7 3 ;
: KM_ROW6 4 ;
: KM_ROW5 5 ;
: KM_COL4 6 ;
: KM_COL3 7 ;
: KM_COL2 8 ;
: KM_COL1 9 ;



\FUNZIONE CHE IMPOSTA IL LIVELLO LOGICO ALTO 1 
\DELLE COLONNE DELLA MATRICE
: VALUE_COL_H 1 KM_COL4 GPIOSET_LOG
			  1 KM_COL3 GPIOSET_LOG
			  1 KM_COL2 GPIOSET_LOG
			  1 KM_COL1 GPIOSET_LOG ;
			  

\ FUNZIONE CHE ABILITA LE RIGHE IN INPUT 000
\ E LE COLONNE IN OUTPUT 001
: ABIL_KM KM_ROW8 IN ABIL_PIN KM_ROW7 IN ABIL_PIN 
		  KM_ROW6 IN ABIL_PIN KM_ROW5 IN ABIL_PIN 
		  KM_COL4 OUT ABIL_PIN KM_COL3 OUT ABIL_PIN
		  KM_COL2 OUT ABIL_PIN KM_COL1 OUT ABIL_PIN 
		  VALUE_COL_H  ;

ABIL_KM 



\ GESTIONE E ABILITAZIONE DEL SENSORE AD ULTRASUONI
\ GPIO
: TRIG 20 ;
: ECHO 21 ;

: ABIL_ULTRASUONI TRIG OUT ABIL_PIN ECHO IN ABIL_PIN ;

ABIL_ULTRASUONI

: TRIG_H 1 TRIG GPIOSET_LOG ;
: TRIG_L 1 TRIG GPIOCLR_LOG ;


: IMPULSO_ULTRASUONI TRIG_H 10 DELAY TRIG_L ;

VARIABLE TIMESONIC
\ PAROLA CHE DETERMINA IL TEMPO DI PARTENZA DEL SUONO,
\ IL TEMPO DI RITORNO E NE OTTIENE LA DIFFERENZA
\ ( -- TEMPO_IMPIEGATO)
: SONIC IMPULSO_ULTRASUONI  
			BEGIN 
				ECHO READLEV DUP 
				1 = IF 
					TIMESTAMP TIMESONIC ! 
				THEN 
			1 = UNTIL
			BEGIN 
				ECHO READLEV DUP 
				0 = IF 
					TIMESTAMP TIMESONIC @ - SWAP 
				ELSE
					\ CODICE CHE CONTROLLA SE IL SENSORE AD ULTRASUONI RICEVE IL SEGNALE DI ECHO
					\ ENTRO 10 MILLISECONDI CHE CORRISPONDONO A 1,8 METRI
					TIMESTAMP TIMESONIC @ - 10000 > 
					IF DROP 10000 0 THEN 
				THEN				
			0 = UNTIL ; 

