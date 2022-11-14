 
 DECIMAL

 \: DONE 1 1 LSHIFT I2C1 S SEL12C ENABLE;
: CLEAR 1 5 LSHIFT I2C1 C SELI2C ENABLE ;
\( DATALEN -- )
: DATALEN I2C1 DLEN SELI2C ENABLE ;
\( DATA -- )
: DATA I2C1 FIFO SELI2C ENABLE ;
\ ( ADDR_SLAVE -- )
: SLAVE I2C1 A SELI2C ENABLE ;
: START 1 7 LSHIFT I2C1 C SELI2C ENABLE ;
: DONE BEGIN I2C1 S SELI2C @ 1 1 LSHIFT AND 0 <> WHILE 0 . REPEAT  ;

\( DATA -- )
: SEND CLEAR 1 DATALEN DATA SLAVE START DONE ;


: 4LSB 15 AND 4 LSHIFT ;
: 4MSB 240 AND ;
: SEND_CHAR DUP 4MSB DUP 13 + SEND 9 + SEND DUP 4LSB DUP 13 + SEND 9 + SEND DROP ;
: SEND_CMD DUP 4MSB DUP 12 + SEND 8 + SEND DUP 4LSB DUP 12 + SEND 8 + SEND DROP ;

: CLEAR_DISPLAY 01 SEND_CMD ;
: CUR_OFF 12 SEND_CMD ;
: LINE_1 3 SEND_CMD ;
: LINE_2 192 SEND_CMD ;

