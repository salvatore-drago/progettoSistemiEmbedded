\ ( STANZA COLORE_LED -- )
0 CONSTANT GREEN
1 CONSTANT YELLOW
2 CONSTANT RED

: SETCOLOR 2DUP 0 = IF REDLEDS SWAP AREAD SETGPIO OVER BLULEDS SWAP AREAD SETGPIO OVER GREENLEDS SWAP AREAD CLRGPIO ELSE 
           DROP 2DUP 1 = IF BLULEDS SWAP AREAD SETGPIO OVER REDLEDS SWAP AREAD CLRGPIO OVER GREENLEDS SWAP AREAD CLRGPIO ELSE
           DROP 2DUP 2 = IF GREENLEDS SWAP AREAD SETGPIO OVER BLULEDS SWAP AREAD SETGPIO OVER REDLEDS SWAP AREAD CLRGPIO ELSE
           THEN 
           THEN 
           THEN DROP DROP ;