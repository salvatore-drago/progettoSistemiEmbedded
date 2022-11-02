\ Sistemi Embedded 18/19
\ Daniele Peri - Universita' degli Studi di Palermo
\
\ Some definitions for ANS compliance
\
\ v. 20181215

: ':' [ CHAR : ] LITERAL ;
: ';' [ CHAR ; ] LITERAL ;
: '(' [ CHAR ( ] LITERAL ;
: ')' [ CHAR ) ] LITERAL ;
: '"' [ CHAR " ] LITERAL ;
: 'A' [ CHAR A ] LITERAL ;
: '0' [ CHAR 0 ] LITERAL ;
: '-' [ CHAR - ] LITERAL ;
: '.' [ CHAR . ] LITERAL ;

: ALIGNED 3 + 3 INVERT AND ;
: ALIGN HERE @ ALIGNED HERE ! ;
: C, HERE @ C! 1 HERE +! ;
: S" IMMEDIATE 
	STATE @ IF
		' LITS , HERE @ 0 ,
		BEGIN KEY DUP '"'
                <> WHILE C, REPEAT
		DROP DUP HERE @ SWAP - 4- SWAP ! ALIGN
	ELSE
		HERE @
		BEGIN KEY DUP '"'
                <> WHILE OVER C! 1+ REPEAT
		DROP HERE @ - HERE @ SWAP
	THEN ;

: JF-HERE   HERE ;
: JF-CREATE   CREATE ;
: JF-FIND   FIND ;
: JF-WORD   WORD ;

: HERE   JF-HERE @ ;
: ALLOT   HERE + JF-HERE ! ;

: [']   ' LIT , ; IMMEDIATE
: '   JF-WORD JF-FIND >CFA ; 

: CELL+  4 + ;

: ALIGN JF-HERE @ ALIGNED JF-HERE ! ;

\: DOES>CUT   LATEST @ >CFA @ DUP JF-HERE @ > IF JF-HERE ! ; 

: CREATE   JF-WORD JF-CREATE DOCREATE , ;
: (DODOES-INT)  ALIGN JF-HERE @ LATEST @ >CFA ! DODOES> ['] LIT ,  LATEST @ >DFA , ; 
: (DODOES-COMP)  (DODOES-INT) ['] LIT , , ['] FIP! , ; 
: DOES>COMP   ['] LIT , HERE 3 CELLS + , ['] (DODOES-COMP) , ['] EXIT , ;
: DOES>INT   (DODOES-INT) LATEST @ HIDDEN ] ;
: DOES>   STATE @ 0= IF DOES>INT ELSE DOES>COMP THEN ; IMMEDIATE



