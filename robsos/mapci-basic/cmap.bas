5 REM EMULATE TERMINAL
10 VLOAD "PETFONT.BIN",8,1,0
15 POKE $9F36,128
20 COLOR 5,0 :REM GREEN ON BLACK
25 ? CHR$(147)
30 A0$ = ">95/11/03 10:03 "
35 A0$ = A0$ + "*** SSR07BC INTL SUS SUPV - NO MODULE REPLACING!!! ***"
40 A2$ = "CI"
45 DIM A5$(11)
50 DIM A6$(19)
55 FOR X=0 TO 11
60    READ A5$(X)
65 NEXT
70 DATA "VOLUMES FOUND ON THE NODE CM:
75 DATA "-----------------------------
80 DATA "
85 DATA "NAME       TYPE      TOTAL       FREE TOTAL  OPEN  ITOC    LARGEST
90 DATA "                    BLOCKS     BLOCKS FILES FILES FILES  FREE SEGMENT
95 DATA "--------------------------------------------------------------------
100 DATA "S00DIMAGE   STD    1433439     252850    10     0     6     252850
105 DATA "S00DPMLOAD  STD     614239     475784   125     0     0     393087
110 DATA "S01DIMAGE   STD    1433439     252850    10     0     6     252850
115 DATA "S01DPMLOAD  STD     614239     368727   444     0     0     295724
120 DATA "
125 DATA "TOTAL NUMBER OF VOLUMES FOUND ON NODE CM : 4
130 FOR X=0 TO 19
135    READ A6$(X)
140 NEXT
145 DATA "FILE INFORMATION FOR VOLUME S00DIMAGE:
150 DATA "(NOTE:  1 BLOCK = 512 BYTES )
155 DATA "--------------------------------------------------------------------
160 DATA "FILE NAME            O R I O O V FILE   MAX    NUM OF    FILE   LAST
165 DATA "                     R E T P L L CODE   REC   RECORDS    SIZE MODIFY
170 DATA "                     G C O E D D        LEN        IN      IN   DATE
175 DATA "                         C N                     FILE  BLOCKS
180 DATA "--------------------------------------------------------------------
185 DATA "PURE.SS7.DTC0.MS     I F            0  1020      6697   13394 951128
190 DATA "PURE.SS7.DTC0.CM     I F            0  1020     65556  131112 951128
195 DATA "IDDD.GWY02.300       I F Y          0  1020     58210  116420 960126
200 DATA "300.250B.NEW.MS      I F Y          0  1020      6762   13524 951205
205 DATA "SSR06.ALL.MS         I F Y          0  1020      6697   13394 951115
210 DATA "FF.LISTAB.MS         I F            0  1020      6697   13394 960125
215 DATA "GWY02AF.CM           I F            0  1020     57170  114340 960125
220 DATA "FF.LISTAB.CM         I F            0  1020     66271  132542 960125
225 DATA "FF.M05.011796.MS     I F            0  1020      6762   13524 960117
230 DATA "FF.M03.100495.MS     I F            0  1020      6567   13134 951004
235 DATA "FF.M03.100495.CM     I F            0  1020     63411  126822 951004
240 DATA "FF.M05.011796.CM     I F            0  1020     66141  132282 960117
245 GOSUB 1035
250 REM -------------------------------------
255 REM
260 REM   MAIN LOOP
265 REM
270 REM -------------------------------------
275    GOSUB 980
280    I$ = ""
285    INPUT I$
290    IF I$ = "DISKUT" THEN A2$ = I$ 
295    IF I$ = "DISKUT" THEN ? "DISK UTILITY IS NOW ACTIVE."
300    IF LEFT$(I$,7) = "RESTART" THEN GOSUB 340
305    IF A2$ = "DISKUT" THEN GOSUB 490
310    GOTO 275
315 REM -------------------------------------
320 REM
325 REM   RESTART
330 REM
335 REM -------------------------------------
340 A3$ = "THIS WILL RESULT IN A CALL PROCESSING OUTAGE"
345 GOSUB 435
350 IF A4 = 0 THEN RETURN
355 IF RIGHT$(I$,6) = "RELOAD" THEN ZZ$ = "RELOADING SWITCH."
360 IF RIGHT$(I$,4) = "COLD"   THEN ZZ$ = "COLD BOOTING SWITCH."
365 IF RIGHT$(I$,4) = "WARM"   THEN ZZ$ = "WARM BOOTING SWITCH."
370 ? ">"
375 GOSUB 1150
380 GOSUB 1150
385 ?:?
390 ? "DMS RELEASED CONNECTION.
395 ? "PRESS ANY KEY TO CONTINUE..."
400 GET A$ :IF A$="" GOTO 400
405 END
410 REM -------------------------------------
415 REM
420 REM   CONFIRM
425 REM
430 REM -------------------------------------
435 ? A3$
440 ? "PLEASE CONFIRM ('YES', 'Y', 'NO', 'N'):"
445 INPUT ">"; R$
450 A4 = 0
455 IF LEFT$(R$,1) = "Y" THEN A4 = 1
460 RETURN
465 REM -------------------------------------
470 REM
475 REM   DISKUT
480 REM
485 REM -------------------------------------
490 IF LEFT$(I$,2) = "LV" THEN GOSUB 555
495 IF I$ = "LF S00DIMAGE" THEN GOSUB 625
500 IF I$ = "LISTFL S00DIMAGE" THEN GOSUB 625
505 IF LEFT$(I$,6) = "CBF S0" THEN GOSUB 685
510 IF LEFT$(I$,6) = "CLEARBOOTFL S0" THEN GOSUB 685
515 IF LEFT$(I$,6) = "SBF S0" THEN GOSUB 845
520 IF LEFT$(I$,6) = "SSETBOOTFL S0" THEN GOSUB 845
525 RETURN
530 REM -------------------------------------
535 REM
540 REM   LV 0
545 REM
550 REM -------------------------------------
555 ?:?
560 ? A5$(0)
565 ? A5$(1)
570 FOR X = 3 TO 11
575    ? A5$(X)
580    GOSUB 1165
585 NEXT
590 ?:?
595 RETURN
600 REM -------------------------------------
605 REM
610 REM   LF S00DIMAGE
615 REM
620 REM -------------------------------------
625 ?:?
630 FOR X = 0 TO 19
635    ? A6$(X)
640    GOSUB 1165
645 NEXT
650 ?:?
655 RETURN
660 REM -------------------------------------
665 REM
670 REM   CBF S00D
675 REM
680 REM -------------------------------------
685 IF MID$(I$,9,1) = " " THEN 710
690 ?
695 ? "VOLUME S00DIMAGEIMAGE EITHER UNAVAILABLE OR DOES NOT EXIST ON NODE CM."
700 ?
705 RETURN
710 IF RIGHT$(I$,3) = "ALL" THEN 735
715 ?
720 ? "UNDEFINED COMMAND (" I$ ")"
725 ?
730 RETURN
735 GOSUB 435
740 IF A4 = 0 THEN RETURN
745 LA$ = MID$(I$,10,2) :REM CM OR MS
750 REM THE ITOC FIELD IS AT COLUMN 26
755 REM IF COLUMN 49 IS A SPACE, IT'S AN MS LOAD!!
760 FOR X = 8 TO 19
765    LB$ = "CM"
770    IF MID$(A6$(X),49,1) = " " THEN LB$ = "MS"
775    IF LA$ <> LB$ GOTO 785
780    A6$(X) = LEFT$(A6$(X),25) + " " + MID$(A6$(X),27)
785 NEXT
790 ?
795 ? "THE WHOLE IMAGE TABLE OF CONTENTS FOR " LA$
800 ? " ON S00DIMAGE HAS BEEN CLEARED.
805 ?
810 RETURN
815 REM -------------------------------------
820 REM
825 REM   SBF S00DIMAGE BOOTFILE MS|CM 1
830 REM
835 REM -------------------------------------
840 REM THE ITOC FIELD IS AT COLUMN 26
845 LA$ = LEFT$(RIGHT$(I$,4),2) :REM CM OR MS
850 OK = 0
855 FOR X = 8 TO 19
860    REM FIND THE FILENAME LENGTH
865    FL = 20
870    FOR N = 8 TO 18
875       IF FL < N GOTO 885
880       IF MID$(A6$(X),N,1) = " " THEN FL = N
885    NEXT N
890    REM NOW COMPARE WITH I$ STARTING AT C15
895    REM ? ":" MID$(I$,15,FL), LEFT$(A6$(X),FL)
900    IF MID$(I$,15,FL) <> LEFT$(A6$(X),FL) GOTO 945
905    REM FOUND IT
910    A6$(X) = LEFT$(A6$(X),25) + "Y" + MID$(A6$(X),27)
915    ?
920    ? "FILE " LEFT$(A6$(X),FL) " IN VOLUME S00DIMAGE HAS BEEN"
925    ? "REGISTERED IN THE IMAGE TABLE OF CONTENTS FOR " LA$
930    ? "AS ENTRY NUMBER 1."
935    ?
940    OK = 1
945 NEXT
950 RETURN
955 REM -------------------------------------
960 REM
965 REM   PROMPT
970 REM
975 REM -------------------------------------
980 A1 = 1 - A1
985 IF A1 = 0 GOTO 1000
990 ? A0$ 
995 ? A2$ ":"
1000 ? ">";
1005 RETURN
1010 REM -------------------------------------
1015 REM
1020 REM   LOGIN
1025 REM
1030 REM -------------------------------------
1035 GOSUB 1150
1040 ? "INITIALIZING CMAP"
1045 ?:? "ATTEMPTING TO CONNECT TO '.MAP-X25.250B.BNRRICH-DMS'
1050 GOSUB 1150
1055 ?:? "CONNECTED TO 'HC1.MAP-X25.250B.BNRRICH-DMS'
1060 ?:? "  VIA GATEWAY 47.166.64.77 AND LINK CRCHH898_0
1065 ?:? "  AS DEVICE T019336
1070 ?:?:?
1075 GOSUB 1150
1080 ?:? "ENTER USERNAME AND PASSWORD
1085 ?:? "OR   LOG ON AUTOMATICALLY BY PRESSING RETURN
1090 INPUT A$
1095 Z = RND(-TI)
1100 C$ = "CMAP" + MID$(STR$(INT(RND(1)*20)),2)
1105 ? "TRYING " C$
1110 GOSUB 1150
1115 ? "BREAK KEY IS ^B (CONTROL-B). TYPE 'HELP' FOR ASSISTANCE\X11\X11"
1120 RETURN
1125 REM ---------------------------------------------
1130 REM
1135 REM   WAIT (LATENCY INDUCER FOR VERSIMILITUDE)
1140 REM
1145 REM ---------------------------------------------
1150 T=TI+INT(RND(1)*250)
1155 IF TI < T GOTO 1155
1160 RETURN
1165 T=TI+INT(RND(1)*25)
1170 IF TI < T GOTO 1170
1175 RETURN