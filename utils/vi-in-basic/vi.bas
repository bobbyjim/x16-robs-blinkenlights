5 COLOR 8,0: ? CHR$(147)
10 B$=CHR$(19): REM + 59 DOWN CURSOR
15 FOR X=1 TO 59: B$=B$+CHR$(17) :NEXT
20 A0    = 1
25 A4$ = "XVI  "
30 DIM A1$(256)
35 REM --------------
40 REM
45 REM  MODE SWITCH
50 REM 
55 REM --------------
60 ? B$ "                  ";
65 ON A0 GOTO 130, 190
70 REM --------------
75 REM
80 REM  STATUS LINE
85 REM 
90 REM --------------
95 ? "\X0A" B$ "XVI  " SPC(50) "INPUT     \X5F COMMAND MODE" CHR$(19) CHR$(146);
100 RETURN
105 REM --------------
110 REM
115 REM  EDIT MODE
120 REM 
125 REM --------------
130 GOSUB 95
135 GET A$ :IF A$="" GOTO 135
140 IF A$=CHR$(95) THEN A0=2 :GOTO 60
145 IF A$=CHR$($14) THEN BF$=LEFT$(LEN(BF$)-1) :GOTO 155
150 BF$=BF$+A$
155 ? BF$;
160 GOTO 130
165 REM --------------
170 REM
175 REM  COMMAND MODE
180 REM 
185 REM --------------
190 ? B$ "           ";
195 ? "                                                                    ";
200 ? B$ "XVI: ";
205 AC$=""
210 GET A$: IF A$="" GOTO 210
215 IF A$=CHR$(13) THEN GOSUB 250 :GOTO 60
220 ? A$; :AC$=AC$+A$ :GOTO 210
225 REM -------------------
230 REM
235 REM COMMAND INTERPRETER
240 REM
245 REM -------------------
250 IF LEFT$(AC$,2)="VI" THEN A0=1
255 IF LEFT$(AC$,1)="E"  THEN A0=1
260 IF LEFT$(AC$,1)="Q"  THEN END
265 IF LEFT$(AC$,1)="S"  THEN GOSUB 300
270 RETURN
275 REM -------------------
280 REM
285 REM SAVE
290 REM
295 REM -------------------
300 IF MID$(AC$,2,1)<>" " THEN A2$ = "INPUT (ERR)":A0=1:RETURN
305 A3$ = ""
310 P=2
315 IF MID$(AC$,P,1)=" " THEN P=P+1 :GOTO 315
320 Q=P+1
325 A3$ = MID$(AC$,P)
330 ? "FILENAME: " A3$
335 END
