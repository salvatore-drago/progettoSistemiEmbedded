
DECIMAL

\0 CONSTANT IN
\1 CONSTANT OUT

\ PAROLA CHE RITORNA IL VALORE CONTENUTO NEL REGISTRO TIME
\ ( -- TIME )
: TIMESTAMP TIMER @ ; 

\ RITARDO DIPENDENTE DAL TEMPO
\ ( TEMPO_MICROSEC -- )
: DELAY TIMESTAMP BEGIN 2DUP TIMESTAMP SWAP - <= UNTIL 2DROP ;


\ DATO IN INPUT IL GPIO DA TRATTARE (ES. 17) RESISTUISCE L'INDIRIZZO DEL GPFSEL(N) ADATTO (ES. 3F200004 ---> GPFSEL1) E NUOVAMENTE L'INPUT DATO
\ (GPIO -- GPIO GPIOFSEL)
: SETGPIOFSEL DUP 10 / 4 * GPIOFSEL + ;

\ PAROLA CHE IMPOSTA IL VALORE LOGICO DEI PIN 
\ IN INPUT (000) QUINDI 0, IN OUTPUT (001) QUINDI 1 O IN ALT5 (010) QUINDI 2
\ (GPIO VALORE_LOGICO -- ) (ES.  17 001 ABIL_PIN)
: ABILPIN >R SETGPIOFSEL SWAP 10 MOD 3 * 
			2DUP 7 SWAP LSHIFT INVERT OVER @ AND SWAP ! 
			R> SWAP LSHIFT OVER @ OR SWAP ! ;
			
\ PAROLE CHE IMPOSTANO IL VALORE LOGICO NEI REGISTRI GPIOSET E GPIOCLR
\ (GPIO -- ) (ES. 27 GPIOSET_LOG oppure 27 GPIOCLR_LOG)
: SETGPIO 1 SWAP LSHIFT GPIOSET ! ;
: CLRGPIO 1 SWAP LSHIFT GPIOCLR ! ;

\ PAROLA CHE DETERMINA IL VALORE LOGICO DEL GPIO PASSATO IN INPUT
\ (GPIO -- LOGVAL)
: READLEV 1 SWAP LSHIFT GPIOLEV @ AND 0 = IF 0 ELSE 1 THEN ;


\ PAROLE CHE INCREMENTANO O DECREMENTANO IL VALORE DI UN CONTATORE
\ (VALORE VARIABILE -- )
: DECC DUP @ ROT - SWAP ! ;
: ADDC DUP @ ROT + SWAP ! ;

