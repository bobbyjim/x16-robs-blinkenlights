10 R=20 :C=20
100 DIM G(2,R,C)
110 FOR I=0 TO R
120 FOR J=0 TO C
130 G(0,I,J)=RND(1)*256
140 NEXT : NEXT
150 REM
160 REM --------------------------
170 REM
199 X=0 : CLS
200 LOCATE 1,1
210 FORI=0TOR:FORJ=0TOC
230 G=G(X,I,J):G(1-X,I,J)=G
240 COLOR G/16:?"{RVS} ";
250 NEXT:?:NEXT
260 REM
270 REM --------------------------
280 REM
300 FORI=1TOR-1:FORJ=1TOC-1
310 G(1-X,I,J)=(G(X,I-1,J)+G(X,I+1,J)+G(X,I,J-1)+G(X,I,J+1))/4
330 NEXT:NEXT
340 X=1-X
350 GOTO 200
