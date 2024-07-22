5 REM ------------------------------------------------------------------
10 REM
15 REM   LUNAR - ORIGINALLY WRITTEN BY JIM STORER IN FOCAL IN THE 1960S
20 REM
25 REM ------------------------------------------------------------------
30 	REM EMULATE GREEN TERMINAL
35 	COLOR 5,0
40 	VLOAD "PETFONT.BIN",8,1,0
45 	POKE $9F36,128
50 	HR$=CHR$(192)
55 	FOR X = 1 TO 79:HR$=HR$+CHR$(192) :NEXT
60 	SC = 32 :REM SCREEN INDENT
65 	? CHR$(147) "\X11"
70 	? TAB(SC) "ROCKET"
75  	? HR$ TAB(SC/2) "      ORIGINAL AUTHOR: JIM STORER\X11\X11"
80         ? "   THIS IS A SIMULATION OF AN APOLLO LUNAR LANDING CAPSULE.\X11\X11
85 	? "   THE ON-BOARD COMPUTER HAS FAILED (IT WAS MADE BY MICROSOFT)
90 	? "   SO YOU HAVE TO LAND THE CAPSULE MANUALLY.\X11\X11"
95 	? "   SET BURN RATE OF RETRO ROCKETS TO ANY VALUE BETWEEN:\X11
100 	? "            0 (FREE FALL) AND
105 	? "          200 (MAXIMUM BURN) POUNDS PER SECOND.\X11
110         ? "   SET NEW BURN RATE EVERY 10 SECONDS.\X11\X11
115         M=33000 :N=16500
120         COLOR 14,0
125 	? "\X11   PLEASE SELECT THE LANDER'S TECHNOLOGY:
130 	? "      1 - 1970 (HARDER)
135 	? "      2 - 1990 (DEFAULT)
140 	? "      3 - 2010 (EASIER)
145         TL$="0"
150 	INPUT "   "; TL$
155         TL = VAL(TL$)
160 	IF TL = 1 THEN M=32500 :N=16000
165 	IF TL = 2 THEN M=33000 :N=16500
170 	IF TL = 3 THEN M=30000 :N=10000
175 	? "\X11   CAPSULE WEIGHT" M "LBS; FUEL WEIGHT" M-N "LBS.\X11\X11
180 	? "   GOOD LUCK!!!\X11\X11
185         COLOR 5,0
190 	L%=0 :REM SECONDS ELAPSED
195         COLOR 8,0
200 	? "\X11 SEC", " ALT(M)", " M/S", " FUEL", "BURN RATE\X11"
205         COLOR 5,0
210 	A=120 :V=1 :G=.001 :Z=1.8
215         KM$ = STR$(INT(1600000*A)/1000)
220         KM$ = MID$(KM$+"      ",1,8) 
225         MS  = INT(V*160900)/100
230 	? L%, KM$, MS,M-N,:INPUT K :T=10
235 	IF M-N<.001 GOTO 275
240 	IF T<.001   GOTO 215
245 	S=T :IF M>=N+S*K GOTO 255
250 	S=(M-N)/K
255 	GOSUB 385 :IF I<=0 GOTO 340
260 	IF V<=0 GOTO 270	
265 	IF J<0 GOTO 355
270 	GOSUB 335 :GOTO 235
275 	? "\X11FUEL OUT AT" L% "SECONDS" :S=(-V+SQR(V*V+2*A*G))/G
280 	V=V+G*S :L%=L%+S
285 	W=1609*V :? "\X11ON MOON AT" L% "SECONDS - IMPACT VELOCITY" INT(W) "M/S"
290 	IF W<=1.2 THEN ? "PERFECT LANDING!" :GOTO 400
295 	IF W<=10  THEN ? "GOOD LANDING (COULD BE BETTER)" :GOTO 400
300 	IF W>60 THEN 320
305 	? "\X11CRAFT DAMAGE... YOU'RE STRANDED HERE UNTIL A RESCUE"
310 	? "PARTY ARRIVES.  HOPE YOU HAVE ENOUGH OXYGEN!"
315 	GOTO 400
320 	? "\X11SORRY THERE WERE NO SURVIVORS.  YOU BLEW IT!!"
325 	? "IN FACT, YOU BLASTED A NEW LUNAR CRATER" W*.052768 "METERS DEEP!"
330 	GOTO 400
335 	L%=L%+S :T=T-S :M=M-S*K :A=I :V=J :RETURN
340 	IF S<.005 GOTO 285
345 	D = V + SQR(V*V+2*A*ABS(G-Z*K/M)) :S=2*A/D
350 	GOSUB 385 :GOSUB 335 :GOTO 340
355 	W=(1-M*G/(Z*K))/2 :S=M*V/(Z*K*(W+SQR(W*W+V/Z)))+0.5 :GOSUB 385
360 	REM W=(1-M*G/(Z*K))/2 :S=M*V/(Z*K*(W+SQR(W*Q+V/Z)))+0.5 :GOSUB 385
365 	IF I<=0 GOTO 340
370 	GOSUB 335 :IF J>0 GOTO 235
375 	IF V>0 GOTO 355
380 	GOTO 235
385 	Q=S*K/M :J=V+G*S+Z*(-Q-Q*Q/2-Q^3/3-Q^4/4-Q^5/5)
390 	 I=A-G*S*S/2 - V*S + Z*S*(Q/2 + Q*Q/6 + Q^3/12 + Q^4/20 + Q^5/30)
395 	RETURN
400 	? "\X11\X11\X11TRY AGAIN??\X11\X11" :GOTO 95
