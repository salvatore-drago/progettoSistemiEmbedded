 
DECIMAL
39 CONSTANT ADDRSLAVE
100000 CONSTANT LCDWAIT1 \ ATTENDERE 100 MS PRIMA DI COMUNICARE
6000 CONSTANT LCDWAIT2  \ ATTENDERE 6 MS DOPO LA PRIMA COMUNICAZIONE
300 CONSTANT LCDWAIT3   \ ATTENDERE 300 US DOPO LA SECONDA COMUNICAZIONE                  
48 CONSTANT DATAINIT    \ DATO DI INIZIALIZZAZIONE -- FUNCTION SELECT
70 CONSTANT GENERALWAIT \TEMPO DI ATTESA DOPO OGNI COMUNICAZIONE
8 CONSTANT DISPLAY_OFF
15 CONSTANT DISPLAY_ON
1 CONSTANT DISPLAY_CLEAR
7 CONSTANT ENTRY_MODE

: FUNCTIONSET ADDRSLAVE DATAINIT 1 I2C1 I2CSEND ;
: DISPLAYOFF GENERALWAIT DELAY ADDRSLAVE DISPLAY_OFF 1 I2C1 I2CSEND ;
: DISPLAYON GENERALWAIT DELAY ADDRSLAVE DISPLAY_ON 1 I2C1 I2CSEND ;
: DISPLAYCLEAR GENERALWAIT DELAY ADDRSLAVE DISPLAY_CLEAR  1 I2C1 I2CSEND 3500 DELAY ;
: ENTRYMODE GENERALWAIT DELAY ADDRSLAVE ENTRY_MODE 1 I2C1 I2CSEND  ;

: LCDINIT LCDWAIT1 DELAY FUNCTIONSET LCDWAIT2 DELAY FUNCTIONSET LCDWAIT3 DELAY FUNCTIONSET LCDWAIT3 DELAY FUNCTIONSET DISPLAYOFF DISPLAYCLEAR ENTRYMODE DISPLAYON  ;


\( DATA -- )
: SEND ADDRSLAVE SWAP 1 I2C1 I2CSEND ;




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
: LCD_INIT FUNCTION_SET 100 DELAY DISPLAY_ON ;