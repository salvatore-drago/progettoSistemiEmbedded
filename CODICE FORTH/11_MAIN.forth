
DECIMAL
VARIABLE TI4
: INITTI4 TIMESTAMP TI4 ! ;

VARIABLE ROOM \ STANZA SELEZIONATA 
0 ROOM !

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

-2 CONSTANT FLAGDIGIT \ VARIABILE DI UTILITA' PER TERMINARE L'INVIO DI DATI


CREATE HUMIDITY NROOMS 1 - ALLOT ALIGN \ ARRAY DOVE VENGONO SALVATI I VALORI DELLE ULTIME MISURAZIONI DELL'UMIDITA PER OGNI STANZA
CREATE TEMPERATURE NROOMS 1 - ALLOT ALIGN \ ARRAY DOVE VENGONO SALVATI I VALORI DELLE ULTIME MISURAZIONI DELLA TEMPERATURA PER OGNI STANZA

\PAROLA PER SALVARE UMIDITA E TEMPERATURA LETTE NEGLI ARRAY
\( STANZA(II) --- )
: MSTORE DUP CHECKSUM IF HHUMIDITY @ HUMIDITY ROT ASTORE HTEMPERATURE @ TEMPERATURE ROT ASTORE ELSE THEN ;

\(MISURA ---)
: PRINTNUMBER FLAGDIGIT SWAP BEGIN LASTDIGIT DUP 9 > WHILE REPEAT 
                             BEGIN DUP FLAGDIGIT <> WHILE DIGITPRINT REPEAT DROP ;

\(---) 
: ROOMDISPLAY STANZA CHARSEND PUNTI CHARSEND ROOM @ PRINTNUMBER SPACE CHARSEND  ;

\(--- TEMPERATURA)
: TEMPFETCH TEMPERATURE II @ AREAD ;

\(---)
: TEMPDISPLAY GRADI CHARSEND PUNTI CHARSEND TEMPERATURE ROOM @ AREAD PRINTNUMBER SPACE CHARSEND  ;

\(--- UMIDITA)
: HUMFETCH HUMIDITY II @ AREAD ;

\(---)
: HUMDISPLAY HUM CHARSEND PUNTI CHARSEND HUMIDITY ROOM @ AREAD PRINTNUMBER ;

\(---)
: DISPLAY ROOMDISPLAY TEMPDISPLAY HUMDISPLAY ;

\(---)
: SHOW DISPLAYCLEAR 1000 DELAY DISPLAY ;

\PAROLA PER VERIFICARE CHE TEMPERATURA E UMIDITA' RIENTRANO NEI VALORI DI SOGLIA
\(--- BOOL)
: CHECK HUMFETCH DUP MIN_H > SWAP MAX_H < AND TEMPFETCH DUP MIN_T > SWAP MAX_T < AND AND ; \ DA VERIFICARE PASSO PASSO 

\PAROLA CHE MODIFICA IL VALORE DI ROOM ( LA STANZA SI CUI SI VOGLIONO LEGGERE LE INFORMAZIONI SUL DISPLAY) OGNI 5 SECONDI
\ ( -- )
: CHANGEROOM TIMESTAMP TI4 @ - 5000000 >=  IF ROOM @ 1 + NROOMS MOD ROOM ! -1 INITTI4 ELSE 0 THEN ;


\( -- )
: RESET INITC LCDINIT BEGIN COUNTER @ WHILE COUNTER @ WHITE SETCOLOR 
                                            COUNTER @ OFF RING 
                                            COUNTER @ APRI FIREDOOR  
                                            1 COUNTER DECC REPEAT 0 ROOM ! 0 II ! INITTI4 ; \0 POWER_FLAG ! ;
                              
                                            
\(---) 
: MAINA RESET BEGIN  
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
                                                              1 II ADDC                                                                                                     
                        REPEAT
                CHANGEROOM IF SHOW ELSE THEN                 
            AGAIN ;



