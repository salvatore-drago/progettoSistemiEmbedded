 
 DECIMAL

 \: DONE 1 1 LSHIFT I2C1 S SEL12C ENABLE;
 : CLEAR 1 5 LSHIFT I2C1 C SELI2C ENABLE;
\( DATALEN -- )
: DATALEN I2C1 DLEN SEL12C ENABLE ;
\( DATA -- )
: DATA I2C1 FIFO SEL12C ENABLE ;
\ ( ADDR_SLAVE -- )
: SLAVE I2C1 A SEL12C ENABLE ;
: START 1 7 LSHIFT I2C1 C SELI2C ENABLE;
: DONE BEGIN I2C1 S SEL12C @ 1 1 LSHIFT AND 1 - WHILE REPEAT  ;

\( DATA -- )
: SEND CLEAR 1 DATALEN DATA SLAVE START DONE ;

: 4LSB F AND 4 LSHIFT ;
: 4MSB F0 AND ;
: SEND_CHAR DUP 4MSB DUP D + SEND 9 + SEND DUP 4LSB DUP D + SEND 9 + SEND drop ;
: SEND_CMD DUP 4MSB DUP C + SEND 8 + SEND DUP 4LSB DUP C + SEND 8 + SEND drop ;

