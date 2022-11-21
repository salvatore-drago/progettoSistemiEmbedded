 
 DECIMAL

 \: DONE 1 1 LSHIFT I2C1 S SEL12C ENABLE;
: CLEAR 1 5 LSHIFT I2C1 C SELI2C ENABLE ;
\( DATALEN -- )
: DATALEN I2C1 DLEN SELI2C ENABLE ;
\( DATA -- )
: DATA I2C1 FIFO SELI2C ENABLE ;

\W_TRANSFER --> NON SI CAPISCE PERCHè UTILIZZARE QUESTI BIT CHE TRALALTRO SONO RISERVATI #FFFFFFFE OR #4294967294 
: W_TRANSFER  I2C1 C SELI2C DUP @ 4294967294  AND SWAP ! ;

\ STAMPA UN VALORE NEGATIVO #-442503144 NON VA BENE 

\ ( ADDR_SLAVE -- )
: SLAVE 39 I2C1 A SELI2C ENABLE ;
: START 1 7 LSHIFT I2C1 C SELI2C ENABLE ;
: DONE BEGIN I2C1 S SELI2C @ 1 1 LSHIFT AND 0 = WHILE 0 . REPEAT  ;

\( DATA -- )
: SEND CLEAR 1 DATALEN DATA SLAVE W_TRANSFER START DONE ;


: 4LSB 15 AND 4 LSHIFT ;
: 4MSB 240 AND ;
: SEND_CHAR DUP 4MSB DUP 13 + SEND 9 + SEND DUP 4LSB DUP 13 + SEND 9 + SEND DROP ;
: SEND_CMD DUP 4MSB DUP 12 + SEND 8 + SEND DUP 4LSB DUP 12 + SEND 8 + SEND DROP ;

: CLEAR_DISPLAY 01 SEND_CMD ;
: CUR_OFF 12 SEND_CMD ;
: CUR_ON 13 SEND_CMD ;
: LINE_1 3 SEND_CMD ;
: LINE_2 192 SEND_CMD ;


: FUNCTION_SET 44 SEND 40 SEND ;
: DISPLAY_ON 13 SEND_CMD ;
: DISPLAY_OFF 8 SEND_CMD ;
: LCD_INIT FUNCTION_SET 100 DELAY DISPLAY_ON DISPLAY_OFF ;