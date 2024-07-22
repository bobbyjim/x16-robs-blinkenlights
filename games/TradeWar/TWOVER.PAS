(************************************
 *          TradeWars II/QP         *
 *  Included and overlay procedures *
 *     Last updated on 4/22/88      *
 *  for WWIV 4 by  Dan Wright       *
 * Nassau Xpress (619) 433-9777     *
 ************************************)

OVERLAY PROCEDURE INIT;

  VAR 
      L   : INTEGER;
      DONE : BOOLEAN;
BEGIN
  ASSIGN(USERF,FS);
  ASSIGN(MSGER,'TWOPENG.DAT');
  RESET(MSGER);
  APPEND(MSGER);
  ASSIGN(SMG,'TWSMF.DAT');
  ENDED := FALSE;
  ASSIGN(USERF,'TWDATA.DAT');
  RESET(USERF);
  READIN(1,USERR);
  WITH USERR DO
    BEGIN
      AY := FC;
      TT := FD;
      LP := FE;
      LS := FF;
      LT1 := FG;
      LL1 := FO;
    END;
  GETDATE;
  IF USERR.FL < D THEN
    MAINT;
  NL;
  NL;
  ANSIC(3);
  PRINTFILE('gfiles\twhello.msg');
  NL;
  PRINTFILE('GFILES\TWNEWMOD.MSG');
  PAUSESCR;
  CLS;
  ANSIC(4);
  PRINTFILE('TWOPENG.DAT');
  APPEND(MSGER);
  ANSIC(6);
  NL;
  PRINT('Initializing...');
  PD := D;
  NL;
  PRINT('Welcome '+THISUSER.NAME+'!');
  PRINT('Searching my records for your name.');
  L := 2;
  DONE := FALSE;
  REPEAT
    READIN(L,USERR);
    IF USERR.FA=THISUSER.NAME THEN
      BEGIN
        PN := L;
        DONE := TRUE;
      END;
    L := L+1;
  UNTIL DONE OR (L>LP) OR HANGUP;
  IF NOT DONE THEN
    BEGIN
      PRINT(
       'I can''t find your record, so I am assuming you are a new trainee.');
      NL;
      PRINT('Entering a new trainee...');
      PN := 2;
      DONE := FALSE;
      REPEAT
        READIN(PN,USERT);
        IF USERT.FM < 1 THEN
          DONE := TRUE;
        PN := PN+1;
      UNTIL DONE OR (PN>LP);
      PN := PN-1;
      IF NOT DONE THEN
        BEGIN
          PRINT('I''m sorry but the game is full.');
          PRINT('Please leave a message for the Emperor so');
          PRINT('he can save a space for you when one opens up.');
          SYSOPLOG(TIME+' '+DATE+' '+THISUSER.NAME+
                   ': New player not allowed - TW game full.');
          ENDED := TRUE;
        END
      ELSE
        BEGIN
          READIN(1,USERT);
          NL;
          PRINT('Notice: If you don''t use the simulator for '+CSTR(USERT.FK)
             +' days, you will');
          PRINT('be.....removed to make room for someone else.');
          NL;
          INITSHIP;
          READIN(PN,USERR);
          USERR.FA := THISUSER.NAME;
          USERR.FM := LENGTH(THISUSER.NAME);
          USERR.FR := PN;
          WRITEOUT(PN,USERR);
          SYSOPLOG(TIME+' '+DATE+' '+USERR.FA+
                   '('+CSTR(PN)+'): New TW Player logged on');
          INSTRUCT;
        END;
    END
    ELSE
      BEGIN
        PNN := USERR.FA;
        NL;
        SYSOPLOG(TIME+' '+DATE+' '+PNN+'('+CSTR(PN)+'): TradeWars/QP.');
        READIN(PN,USERR);
        A := USERR.FB;
        DONE := FALSE;
        IF A>PD THEN
          BEGIN
            PRINT('you won''t be allowed on for another'+CSTR(A-PD)+' day(s)');
            ENDED := TRUE;
          END;
        IF ((A=PD) AND (USERR.FC<>-99)) THEN
          BEGIN
            ANSIC(6);
            PRINT('You have been on today.');
            IF USERR.FD<1 THEN
              BEGIN
                ANSIC(8);
                PRINT('You don''t have any turns left today.'+
                      ' You will be allowed to play tomorrow.');
                ENDED := TRUE;
                ANSIC(1);
              END;
            IF USERR.FC=PN THEN
              BEGIN
                PRINT('Qu''vatlh!!  You killed yourself today! '+
                 'With some reserve, tho, you will be allowed on tomorrow.');
                ENDED := TRUE;
              END;
          END;
        IF (A<PD) OR ((A=PD) AND (NOT ENDED) AND (USERR.FC<>99)) THEN
          BEGIN
            READMSG;
            IF USERR.FC=0 THEN
              BEGIN
                IF (USERR.FD<=TT) AND (USERR.FB<PD) THEN
                  BEGIN
                    USERR.FD := TT;
                    USERR.FB := PD;
                    WRITEOUT(PN,USERR);
                  END;
                DONE := TRUE;
                NL;
                PRINT('You have '+CSTR(USERR.FD)+' turns this Stardate.');
              END;
          END;
        IF (NOT ENDED) AND (NOT DONE) THEN
          BEGIN
            A := USERR.FC;
            IF A=-99 THEN
              INITSHIP
            ELSE
              BEGIN
                IF A=-98 THEN
                  PRINT('You have been destroyed by a person '+
                        'who has been...removed from the game.');
                IF A=-1 THEN
                  PRINT('You have been ambushed by the Romulans!');
                IF A=PN THEN
                  BEGIN
                    NL;
                    PRINT(
                     'You managed to Q''est'' yourself on your last time on.');
                  END;
                IF (A>1) AND (A<=LP) THEN
                  BEGIN
                    READIN(A,USERT);
                    PRINT(USERT.FA+' destroyed your ship!');
                  END;
                INITSHIP;
              END;
          END;
      END;
END;

OVERLAY PROCEDURE COMPUTER;

  VAR
      PRR,S2,N : INTEGER;
      I        : STR;

  PROCEDURE compmenu;
  BEGIN
    NL;
    PRINT('Computer commands:');
    NL;
    ANSIC(2);
    PRINT('C - <C>ommerce report');
    ANSIC(3);
    PRINT('F - <F>ind sector');
    ANSIC(4);
    PRINT('I - <I>nformation about your ship');
    ANSIC(5);
    PRINT('R - <R>ank players');
    ANSIC(6);
    PRINT('S - <S>end a message to another ship');
    ANSIC(7);
    PRINT('Q - <Q>uit computer');
    ANSIC(1);
  END;

  PROCEDURE FINDSEC(PRR:INTEGER);

    VAR
        A,B,SUD   : INTEGER;
        I : STR;
  BEGIN
    A := PRR;
    PROMPT('What is your target sector? ');
    INPUT(I,3);
    IF I<>'' THEN
      BEGIN
        B := VALUE(I);
        IF (B<1) OR (B>LS-LP) THEN
          PRINT('Valid sector numbers are from 1 to '+CSTR(LS-LP)+'.')
        ELSE
          IF A=B THEN
            PRINT('You are already in that sector!')
          ELSE
            BEGIN
              NL;
              PRINT('Computing shortest path...');
              SHORTEST(A,B);
              IF S[A,1]=0 THEN
                PRINT('There was an error in computation between sectors.')
              ELSE
                BEGIN
                  NL;
                  PRINT('The shortest path from sector '
                        +CSTR(A)+' to sector '+CSTR(B)+' is:');
                  PROMPT(CSTR(A));
                  SUD := A;
                  REPEAT
                    SUD := S[SUD,1];
                    IF SUD<>0 THEN
                      PROMPT(' - '+CSTR(SUD))
                    ELSE
                      NL;
                  UNTIL SUD=0;
                  READIN(LP+PRR,USERT);
                  E[1] := USERT.FB;
                  E[2] := USERT.FC;
                  E[3] := USERT.FD;
                  E[4] := USERT.FE;
                  E[5] := USERT.FF;
                  E[6] := USERT.FG
                END;
            END;
      END;
  END;

  PROCEDURE REPORTSEC(S2:INTEGER);

    VAR
        I: STR;
        A,P: INTEGER;
  BEGIN
    PROMPT('What sector is the port in['+cstr(userr.ff)+']? ');
    INPUT(I,3);
    IF I='' THEN
      I:=cstr(userr.ff);
    IF I<>'' THEN
        BEGIN
          A := VALUE(I);
          IF (A<1) OR (A>LS-LP) THEN
            PRINT('The Empire only possesses sectors 1 to '+CSTR(LS-LP)+'.')
          ELSE
            BEGIN
              READIN(LP+A,USERT);
              P := USERT.FH;
              IF (P=0) OR ((USERT.FL>0) AND (USERT.FM<>PN)) THEN
                BEGIN
                  NL;
                  PRINT('I have no information about that port.');
                END
              ELSE
                IF P<>1 THEN
                  BEGIN
                    UPPORT(LP+A);
                    OTHERPORT(P+LS);
                  END
                ELSE
                  PORT1;
            END;
        END;
  END;

  PROCEDURE RANKINGS;

    VAR
        P,R        : INTEGER;
        ABORT,NEXT : BOOLEAN;
  BEGIN
    ANSIC(3);
    PRINT('Ranking players...');
    RANK(P);
    NL;
    PRINT('Player Rankings: '+DATE+' '+TIME);
    NL;
    ANSIC(5);
    PRINT('Rank     Value      Player');
    PRINT('~~~~  ~~~~~~~~~~~~  ~~~~~~');
    R := 1;
    ANSIC(2);
    ABORT := FALSE;
    REPEAT
      READIN(P,USERT);
      IF P=PN THEN ANSIC(2);
      PRINTACR(ADDBLANK(CSTR(R),4)+ADDBLANK(CSTR(USERT.FV),14)
               +'  '+USERT.FA+' #'+CSTR(P),ABORT,NEXT);
      P := USERT.FT;
      R := R+1;
    UNTIL (P=-1) OR ABORT;
  END;

BEGIN
  ANSIC(8);
  PRINT('<Computer>');
  NL;
  ANSIC(2);
  PRINT('<Computer activated>');
  ANSIC(1);
  DONE := FALSE;
  READIN(PN,USERR);
  PRR := USERR.FF;
  S2 := PRR+LP;
  WHILE (NOT HANGUP) AND (NOT DONE) DO
    BEGIN
      DUMP;
      TLEFT;
      NL;
      PROMPT('Computer Command  (C,F,I,R,S,Q,?): ');
      MMKEY(I);
      IF I='' THEN
        PRINT('? = Help');
      CASE I[1] OF
        '?' : COMPMENU;
        'C' : REPORTSEC(S2);
        'F' : FINDSEC(PRR);
        'I' : INFO(PN);
        'R' : RANKINGS;
        'S' : PCHAT(PN);
        'Q' : DONE := TRUE;
        ' ' : DONE := TRUE;
      END;
    END;
  NL;
  PRINT('<Computer deactivated>');
END;

OVERLAY PROCEDURE PORT;

  VAR
      ST,R,P2,C2,F2,L2,M2,A,NUH : INTEGER;
      DONEIT                    : BOOLEAN;

PROCEDURE IDUNNO;
BEGIN
  READIN(P2,USERT);
  IF L2=1 THEN
    USERT.FD := TRUNC(N[1]-NUH)
  ELSE
    IF L2=2 THEN
      USERT.FE := TRUNC(N[2]-NUH)
    ELSE
      USERT.FF := TRUNC(N[3]-NUH);
  WRITEOUT(P2,USERT);
END;

PROCEDURE DUNNO2;

  VAR
      S : INTEGER;
BEGIN
  S := SGN(TRUNC(C1[L2]));
  USERR.FL := M2-S*A;
  IF L2=1 THEN
    USERR.FI := TRUNC(H[1]+S*NUH)
  ELSE
    IF L2=2 THEN
      USERR.FJ := TRUNC(H[2]+S*NUH)
    ELSE
      USERR.FK := TRUNC(H[3]+S*NUH);
  WRITEOUT(PN,USERR);
  IDUNNO;
  H[L2] := H[L2]+S*NUH;
END;

PROCEDURE TRADE(L2:INTEGER);

  VAR
      V,HUH,B,MUH : INTEGER;         (* NUH = # of units to trade *)
      DIM,EIM,I : STR;               (* HUH = # of empty cargo holds *)
BEGIN                                (* MUH =  *)
  M2 := USERR.FL;
  HUH := TRUNC(H[0]-H[1]-H[2]-H[3]);
  IF C1[L2]>0 THEN
    BEGIN
      DIM := 'buy';
      EIM := 'sell';
      B := -1;
    END
  ELSE
    BEGIN
      DIM := 'sell';
      EIM := 'buy' ;
      B := 0;
    END;
  IF B=-1 THEN
    BEGIN
      MUH := HUH;
      IF MUH > N[L2] THEN
        MUH := TRUNC(N[L2]);
    END;
  IF B=-1 THEN
    IF MUH*M[L2] > M2 THEN
      MUH := TRUNC(M2/M[L2]);
  IF B=0 THEN
    BEGIN
      MUH := TRUNC(N[L2]);
      IF MUH > TRUNC(H[L2]) THEN
        MUH := TRUNC(H[L2]);
    END;
  IF MUH<>0 THEN
    BEGIN
      DONE := FALSE;
      REPEAT
        NL;
        PRINT('You have '+CSTR(M2)+' credits and '+CSTR(HUH)+
        ' empty cargo holds.');
        NL;
        PRINT('We are '+EIM+'ing up to '+CSTR(ROUND(N[L2]))+
              '.  You have '+CSTR(ROUND(H[L2]))+' in your holds.');
        F2 := 1;
        PROMPT('How many holds of ');
        IF L2=1 THEN
          PROMPT('Ore')
        ELSE
          IF L2=2 THEN
            PROMPT('Organics')
          ELSE
            PROMPT('Equipment');
        PROMPT(' do you want to '+DIM+' ['+CSTR(MUH)+']? ');
        INPUT(I,4);
        IF I='' THEN
          NUH := MUH
        ELSE
          NUH := VALUE(I);
        IF NUH=0 THEN
          DONE := TRUE;
        IF NUH>=1 THEN
          IF (B=-1) AND (NUH>HUH) THEN
            PRINT('You don''t have enough cargo holds.')
          ELSE
            IF (B=-1) AND (NUH>N[L2]) THEN
              PRINT('They''re not selling that many.')
            ELSE
              IF (B=0) AND (NUH>N[L2]) THEN
                PRINT('They don''t want that many.')
              ELSE
                IF (B=0) AND (NUH>H[L2]) THEN
                  PRINT('You don''t have that many in your holds.')
                ELSE
                  DONE := TRUE;
      UNTIL HANGUP OR DONE;
      IF (NUH>=1) AND (NOT HANGUP) THEN
        BEGIN
          PRINT('Agreed, '+CSTR(NUH)+' units.');
          V := RANDOM(3)+1;
          R := 1;
          DONEIT := FALSE;
          REPEAT
            NL;
            IF R=V+1 THEN
              PROMPT('Our final offer is ')
            ELSE
              IF B=-1 THEN
                PROMPT('We''ll sell them for ')
              ELSE
                PROMPT('We''ll buy them for ');
            PRINT(CSTR(TRUNC(NUH*M[L2]*(1+C1[L2]/1000)+0.5))+' credits.');
            REPEAT
              DONE := TRUE;
              PROMPT('Your offer? ');
              INPUT(I,5);
              A := VALUE(I);
              if (A=0) then
                doneit := true;
              IF (B=-1) AND (userr.fl < M[L2]*NUH/10) THEN
                BEGIN
                  PRINT('You don''t have enough cash to backup this deal.');
                  DONE := TRUE;
                END
              ELSE
                IF (A<M[L2]*NUH/10) OR (A>M[L2]*NUH*10) THEN
                  BEGIN
                    NL;
                    PRINT('Imperial Intelligence frowns upon those who are');
                    PRINT('too flippant. Make a SERIOUS offer...');
                    DONE := FALSE;
                  END;
              IF (A>M2) AND (B=-1) THEN
                BEGIN
                  PRINT('  You only have '+CSTR(M2)+' credits!');
                  DONE := FALSE;
                END;
            UNTIL HANGUP OR DONE;
            IF (B=0) AND (A<=M[L2]*NUH) THEN
              BEGIN
                ANSIC(8);
                PRINT('Agreed!  We''ll PURCHASE them!');
                ANSIC(1);
                DUNNO2;
                DONEIT := TRUE;
              END
            ELSE
              IF (B=-1) AND (A>=M[L2]*NUH) THEN
                BEGIN
                  ANSIC(8);
                  PRINT('Sold!');
                  ANSIC(1);
                  DUNNO2;
                  DONEIT := TRUE;
                END
              ELSE
                BEGIN
                  T := TRUNC(NUH*M[L2]*(1-C1[L2]/250/R)+0.5);
                  IF (B=0) AND (A>T) THEN
                    BEGIN
                      IDUNNO;
                      ANSIC(7);
                      PRINT('Too high.  We''ll buy them from Orion Traders.');
                      ANSIC(1);
                      DONEIT := TRUE;
                    END
                  ELSE
                    IF (B=-1) AND (A<T) THEN
                      BEGIN
                        IDUNNO;
                        ANSIC(6);
                        NL;
                        PRINT('Too low.  We''ll scalp them to the Federation.');
                        ANSIC(1);
                        DONEIT := TRUE;
                      END;
                  M[L2] := 0.7*M[L2]+0.3*A/NUH;
                END;
            R := R+1;
          UNTIL HANGUP OR DONEIT OR (R>V+1);
        END;
    END;
END;
var I:str;
BEGIN
  ANSIC(8);
  PRINT('<Port>');
  ANSIC(3);
  NL;
  PRINT('Beginning docking procedure...');
  ANSIC(1);
  A := USERR.FD;
  IF A<1 THEN
    BEGIN
      ANSIC(8);
      PRINT('You don''t have any turns left.');
      ANSIC(1);
    END
  ELSE
    BEGIN
      READIN(S2,USERT);
      ST := USERT.FH;
      P2 := ST+LS;
      IF ST=0 THEN
        BEGIN
          ANSIC(5);
          PRINT('There are no ports in this sector.');
          ANSIC(1);
        END
      ELSE
        BEGIN
          USERR.FD := A-1;
          WRITEOUT(PN,USERR);
          ANSIC(6);
          PRINT('One turn deducted');
          ANSIC(1);
          READIN(P2,USERT);
          IF PRR<>1 THEN
            BEGIN
              UPPORT(USERR.FF+LP);
              H[0] := USERR.FH;
              H[1] := USERR.FI;
              H[2] := USERR.FJ;
              H[3] := USERR.FK;
              OTHERPORT(P2);
              NL;
              F2 := 0;
              FOR L2:=1 TO 3 DO      (* Sell all on the ship *)
                IF C1[L2]<0 THEN
                  TRADE(L2);
              FOR L2:=1 TO 3 DO      (* Buy all the ship will hold *)
                IF C1[L2]>0 THEN
                   TRADE(L2);
              IF F2=0 THEN
                PRINT('You don''t have anything they want, and they don''t '
                     +'have anything you can buy');
              NL;
              PRINT('You have '+CSTR(USERR.FL)+' credits and '+
                CSTR(TRUNC(H[0]-H[1]-H[2]-H[3]))+' empty cargo holds.');
            END
          ELSE
            BEGIN
              PORT1;
              C2 := USERR.FL;
              PRINT('You have '+CSTR(C2)+' credits.');
              NL;
              REPEAT
                DONE := TRUE;
                PROMPT('How many holds do you want to buy [0]? ');
                INPUT(I,2);
                A := TRUNC(VALUE(I));
                IF A<0 THEN
                  DONE := FALSE;
                IF M[1]*A>C2 THEN
                  BEGIN
                    ANSIC(4);
                    PRINT('You don''t have enough money. '+
                          'The maximum amount you can buy is '+CSTR(
                          TRUNC(C2/M[1]))+'.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
                IF A+USERR.FH>150 THEN
                  BEGIN
                    ANSIC(8);
                    PRINT('You are limited to 150 cargo holds.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
              UNTIL HANGUP OR DONE;
              USERR.FH := USERR.FH+A;
              C2 := C2-TRUNC(M[1]*A);
              USERR.FL := C2;
              WRITEOUT(PN,USERR);

              PRINT('You have '+CSTR(C2)+' credits.');
              NL;
              REPEAT
                DONE := TRUE;
                PROMPT('How many K-3A fighters do you want to buy [0]? ');
                INPUT(I,3);
                A := TRUNC(VALUE(I));
                IF A<0 THEN
                  DONE := FALSE;
                IF M[2]*A>C2 THEN
                  BEGIN
                    ANSIC(3);
                    PRINT('You don''t have enough money. '+
                    'The most you can buy is '+CSTR(TRUNC(C2/M[2]))+'.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
                IF A+USERR.FG>9999 THEN
                  BEGIN
                    ANSIC(8);
                    PRINT('Your squadron is limited to 9999 fighters.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
              UNTIL HANGUP OR DONE;
              USERR.FG := USERR.FG+A;
              C2 := C2-TRUNC(M[2]*A);
              USERR.FL := C2;
              WRITEOUT(PN,USERR);

              PRINT('You have '+CSTR(C2)+' credits.');
              NL;
              REPEAT
                DONE := TRUE;
                PROMPT('How many armor points do you want to buy [0]? ');
                INPUT(I,3);
                A := TRUNC(VALUE(I));
                IF A<0 THEN
                  DONE := FALSE;
                IF M[3]*A>C2 THEN
                  BEGIN
                    ANSIC(3);
                    PRINT('You don''t have enough money. '+
                      'The most you can buy is '+CSTR(TRUNC(C2/M[3]))+'.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
                IF A+USERR.FE>200 THEN
                  BEGIN
                    ANSIC(8);
                    PRINT('Your ship is structurally limited to 200 points.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
              UNTIL HANGUP OR DONE;
              USERR.FE := USERR.FE+A;
              C2 := C2-TRUNC(M[3]*A);
              USERR.FL := C2;
              WRITEOUT(PN,USERR);

              PRINT('You have '+CSTR(C2)+' credits.');
              NL;
              REPEAT
                DONE := TRUE;
                PROMPT('How many turns do you want to buy [0]? ');
                INPUT(I,2);
                A := TRUNC(VALUE(I));
                IF A<0 THEN
                  DONE := FALSE;
                IF 300*A > C2 THEN
                  BEGIN
                    ANSIC(2);
                    PRINT('You don''t have enough money. '+
                          'The most you can buy is '+CSTR(TRUNC(C2/300))+'.');
                    ANSIC(1);
                    DONE := FALSE;
                  END;
              UNTIL DONE OR HANGUP;
              USERR.FD := USERR.FD+A;
              C2 := C2-300*A;
              USERR.FL := C2;
              WRITEOUT(PN,USERR);
              PRINT('You have '+CSTR(C2)+' credits.');
              NL;

            END;
        END;
    END;
END;

OVERLAY PROCEDURE KILL;

  VAR
      P,N,E2,E3,F2,L1,LA,K1: INTEGER;
      I: STR;

PROCEDURE SALVAGE(PN,P:INTEGER);

  VAR
      B,C,D,E,F,G,H,I,L,V : INTEGER;
BEGIN
  READIN(P,USERT);
  A := TRUNC(USERT.FH/4)+1;
  IF A+USERR.FH > 150 THEN
    A := 150-USERR.FH;
  IF A<1 THEN
    BEGIN
      ANSIC(5);
      PRINT('Excellent kill!');
      ANSIC(3);
      PRINT('...In fact, TOO excellent!  You can''t salvage anything from it!');
      ANSIC(1);
    END
  ELSE
      BEGIN
        B := 0;
        C := 0;
        D := 0;
        E := 0;
        F := USERT.FI;
        G := USERT.FJ;
        H := USERT.FK;
        I := USERT.FH;
        FOR L:=1 TO A DO
          BEGIN
            V := RANDOM(I);
            IF V<F THEN
              BEGIN
                B := B+1;
                F := F-1
              END
            ELSE
              IF V<F+G THEN
                BEGIN
                  C := C+1;
                  G := G-1;
                END
              ELSE
                IF V<F+G+H THEN
                  BEGIN
                    D := D+1;
                    H := H-1
                  END
                ELSE
                  E := E+1;
            I := I-1;
          END;
        USERR.FH := USERR.FH+B+C+D+E;
        USERR.FI := USERR.FI+B;
        USERR.FJ := USERR.FJ+C;
        USERR.FK := USERR.FK+D;
        WRITEOUT(PN,USERR);
        PRINT('You destroyed the ship and salvaged these cargo holds:');
        IF E>0 THEN
          PRINT('   '+CSTR(E)+' empty');
        IF B<>0 THEN
          PRINT('   '+CSTR(B)+' with ore');
        IF C<>0 THEN
          PRINT('   '+CSTR(C)+' with organics');
        IF D<>0 THEN
          PRINT('   '+CSTR(D)+' with equipment');
      END;
END;

BEGIN
  ANSIC(8);
  PRINT('<Attack>');
  ANSIC(1);
  READIN(S2,USERT);
  A := USERT.FI;
  READIN(A,USERT);
  IF USERT.FO=0 THEN
    BEGIN
      ANSIC(8);
      PRINT('There are no ships here to attack.');
      ANSIC(1);
    END
  ELSE
    BEGIN
      F2 := USERR.FG;
      LA := A;
      IF F2<1 THEN
        BEGIN
          ANSIC(4);
          PRINT('You don''t have any fighters.');
          ANSIC(1);
        END
      ELSE
        BEGIN
          DONE := FALSE;
          A := USERT.FO;
          REPEAT
            READIN(A,USERT);
            PROMPT('Attack '+USERT.FA+' (Y/N)[N]? ');
            IF YN THEN
              BEGIN
                P := A;
                DONE := TRUE;
              END
            ELSE
              A := USERT.FO;
          UNTIL DONE OR (A=0) OR HANGUP;
          IF (NOT DONE) OR HANGUP THEN
            PRINT('There are no other ships in this sector.')
          ELSE
            BEGIN
              PROMPT('How many fighters do you wish to use [0]? ');
              INPUT(I,4);
              N := VALUE(I);
              IF (N>=1) AND (N<=9999) THEN
                BEGIN
                  READIN(P,USERT);
                  E2 := USERT.FG;    (* Enemy fighters on enemy ship *)
                  E3 := USERT.FE;    (* Enemy ship armor *)
                  L1 := 0;           (* Friendly fighters lost *)
                  K1 := 0;           (* Enemy fighters lost *)
                  F2 := USERR.FG;    (* Friendly fighters on board *)
                  IF N>F2 THEN
                    BEGIN
                      ANSIC(7);
                      PRINT('You don''t have that many fighters.');
                      ANSIC(1);
                    END
                  ELSE
                    BEGIN
                      IF usert.fe>0 THEN
                        PRINT('Your fighters encounter some armor &'
                             +' shielding as they attack the other ship.');
                      REPEAT
                        IF RANDOM(2)+1=1 THEN
                          L1 := L1+1
                        ELSE
                          BEGIN
                            IF e3>0 THEN  (* Check for armor on enemy ship *)
                              e3 := e3-1
                            ELSE
                              K1 := K1+1;
                          END;
                      UNTIL (L1>=N) OR (K1>E2);
                      IF (K1>0) OR (E3<usert.fe) THEN
                        MESSAGE(P,PN,K1,usert.fe-E3);
                      READIN(P,USERT);
                      USERR.FG := F2-L1;
                      USERT.FG := E2-K1;
                      USERT.FE := E3;
                      WRITEOUT(PN,USERR);
                      WRITEOUT(P,USERT);
                      NL;
                      PRINT('You lost '+CSTR(L1)+' fighter(s), '
                        +CSTR(F2-L1)+' remain.');
                      IF E2-K1>0 THEN
                        BEGIN
                          ANSIC(5);
                          PRINT('You destroyed '+CSTR(K1)+
                              ' enemy fighters,'+CSTR(E2-K1)+' remain.');
                          ANSIC(1);
                        END
                      ELSE
                        BEGIN
                          SALVAGE(PN,P);
                          KILLED(PN,P);
                        END
                    END;
                END;
            END;
        END;
    END;
END;



OVERLAY PROCEDURE PLANET;

 VAR
     T,L2,L,M : INTEGER;
     DONE     : BOOLEAN;
     I        : STR;


FUNCTION ADDBLANK(B:STR;L:INTEGER): STR;

  VAR
      I,J  : INTEGER;
      TEMP : STR;
BEGIN
  TEMP := '                   ';
  ADDBLANK := B;
  IF LENGTH(B) < L THEN
    BEGIN
      I := L-LENGTH(B);
      ADDBLANK := CONCAT(COPY(TEMP,1,I),B);
    END;
END;

overlay PROCEDURE UPPLANET(S2:INTEGER);

  VAR
      L,C,L2,MN : INTEGER;
      DIM       : REAL;
BEGIN
  READIN(S2,USERT);
  IF USERT.FO<>0 THEN
      BEGIN
        L2 := USERT.FO+LT1;
        H[0] := USERR.FH;
        H[1] := USERR.FI;
        H[2] := USERR.FJ;
        H[3] := USERR.FK;
        READIN(L2,USERT);
        N[1] := USERT.FF+USERT.FI/10000;
        N[2] := USERT.FG+USERT.FJ/10000;
        N[3] := USERT.FH+USERT.FK/10000;
        PUB[1] := USERT.FC;
        PUB[2] := USERT.FD;
        PUB[3] := USERT.FE;
        GETDATE;
        C := D;
        MN := VALUE(COPY(TIME,1,2))*60+VALUE(COPY(TIME,4,2));
        DIM := D-USERT.FB+(MN-USERT.FR)/1440;
        IF DIM< 0 THEN
          D := 0
        ELSE
          IF DIM>10 THEN
            DIM := 10.0;
        FOR L:=1 TO 3 DO
          BEGIN
            IF N[L] < PUB[L]*10 THEN
              N[L] := N[L]+PUB[L]*DIM;
            IF N[L] >= PUB[L]*10 THEN
              N[L] := N[L]+PUB[L]*DIM/10;
          END;
      END;
  READIN(L2,USERT);
  USERT.FB := C;
  USERT.FF := TRUNC(N[1]);
  USERT.FG := TRUNC(N[2]);
  USERT.FH := TRUNC(N[3]);
  FOR L:=1 TO 3 DO
    BEGIN
      SRR[L,0] := INT((N[L]-INT(N[L]))*10000+0.5);
      N[L] := INT(N[L]);
    END;
  USERT.FI := TRUNC(SRR[1,0]);
  USERT.FJ := TRUNC(SRR[2,0]);
  USERT.FK := TRUNC(SRR[3,0]);
  USERT.FR := MN;
  WRITEOUT(L2,USERT);
END;

overlay PROCEDURE HELPIT;
BEGIN
  NL;
  ANSIC(2);
  PRINT('1 - take ore');
  ANSIC(3);
  PRINT('2 - take organics');
  ANSIC(4);
  PRINT('3 - take eguipment');
  ANSIC(2);
  PRINT('4 - leave ore');
  ANSIC(3);
  PRINT('5 - leave organics');
  ANSIC(4);
  PRINT('6 - leave eguipment');
  ANSIC(5);
  PRINT('A - take <A>ll');
(*  ANSIC(3);     REMOVED UNTIL FIXED---DOESN'T RESET VARIABLES
    PRINT('C - activate <C>omputer');  *)
  ANSIC(1);
  PRINT('D - <D>estroy the planet');
  ANSIC(6);
  PRINT('I - <I>ncrease productivity');
  ANSIC(7);
  PRINT('L - <L>eave planet');
  ANSIC(2);
  PRINT('R - planet <R>eport');
  ANSIC(1);
END;

overlay PROCEDURE TAKEORE(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(2);
  PRINT('<Take ore>');
  ANSIC(1);
  PRINT('How much ['+CSTR(TRUNC(N[1]))+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := TRUNC(N[1])
  ELSE
    O := VALUE(I);
  IF O>N[1] THEN
    PRINT('They don''t have that many.')
  ELSE
    IF H[0]-H[1]-H[2]-H[3]<O THEN
      PRINT('You don''t have enough free cargo holds.')
    ELSE
      BEGIN
        USERR.FI := USERR.FI+O;
        WRITEOUT(PN,USERR);
        READIN(L2,USERT);
        USERT.FF := USERT.FF-O;
        WRITEOUT(L2,USERT);
        H[1] := H[1]+O;
        N[1] := N[1]-O;
      END;
END;

overlay PROCEDURE TAKEORG(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(3);
  PRINT('<Take organics>');
  ANSIC(1);
  PRINT('How much ['+CSTR(TRUNC(N[2]))+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := TRUNC(N[2])
  ELSE
    O := VALUE(I);
  IF O>N[2] THEN
    PRINT('They don''t have that many.')
  ELSE
    IF H[0]-H[1]-H[2]-H[3]<O THEN
      BEGIN
        ANSIC(8);
        PRINT('You don''t have enough free cargo holds.');
        ANSIC(1);
      END
    ELSE
      BEGIN
        USERR.FJ := USERR.FJ+O;
        WRITEOUT(PN,USERR);
        READIN(L2,USERT);
        USERT.FG := USERT.FG-O;
        WRITEOUT(L2,USERT);
        H[2] := H[2]+O;
        N[2] := N[2]-O;
      END;
END;

overlay PROCEDURE TAKEEQU(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(4);
  PRINT('<Take equipment>');
  ANSIC(1);
  PRINT('How much ['+CSTR(TRUNC(N[3]))+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := TRUNC(N[3])
  ELSE
    O := VALUE(I);
  IF O>N[3] THEN
    BEGIN
      ANSIC(8);
      PRINT('They don''t have that many.');
      ANSIC(1);
    END
  ELSE
    IF H[0]-H[1]-H[2]-H[3]<O THEN
      BEGIN
        ANSIC(8);
        PRINT('You don''t have enough free cargo holds.');
        ANSIC(1);
      END
    ELSE
      BEGIN
        USERR.FK := USERR.FK+O;
        WRITEOUT(PN,USERR);
        READIN(L2,USERT);
        USERT.FH := USERT.FH-O;
        WRITEOUT(L2,USERT);
        H[3] := H[3]+O;
        N[3] := N[3]-O;
      END;
END;

overlay PROCEDURE LEAVORE(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(2);
  PRINT('<Leave ore>');
  READIN(L2,USERT);
  ANSIC(1);
  PRINT('How much ['+CSTR(userr.fi)+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := userr.fi
  ELSE
    O := VALUE(I);
  IF O>userr.fi THEN
    PRINT('You don''t have that many.')
  ELSE
    BEGIN
      IF O<0 THEN
       O := 0;
      USERR.FI := USERR.FI-O;
      WRITEOUT(PN,USERR);
      USERT.FF := USERT.FF+O;
      WRITEOUT(L2,USERT);
      PRINT('You left '+cstr(O)+' units of ore on the planet surface.');
    END;
END;

overlay PROCEDURE LEAVORG(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(2);
  PRINT('<Leave organics>');
  READIN(L2,USERT);
  ANSIC(1);
  PRINT('How much ['+CSTR(userr.fj)+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := userr.fj
  ELSE
    O := VALUE(I);
  IF O>userr.fj THEN
    PRINT('You don''t have that many.')
  ELSE
    BEGIN
      IF O<0 THEN
      O := 0;
      USERR.FJ := USERR.FJ-O;
      WRITEOUT(PN,USERR);
      USERT.FG := USERT.FG+O;
      WRITEOUT(L2,USERT);
      PRINT('You left '+cstr(O)+' units of organics on the planet surface.');
    END;
END;

overlay PROCEDURE LEAVEQU(L2:INTEGER);

  VAR
      O: INTEGER;
      I: STR;
BEGIN
  ANSIC(2);
  PRINT('<Leave equipment>');
  READIN(L2,USERT);
  ANSIC(1);
  PRINT('How much ['+CSTR(userr.fk)+']? ');
  INPUT(I,3);
  IF I='' THEN
    O := userr.fk
  ELSE
    O := VALUE(I);
  IF O>userr.fk THEN
    PRINT('You don''t have that many.')
  ELSE
    BEGIN
      IF O<0 THEN
       O := 0;
      USERR.FK := USERR.FK-O;
      WRITEOUT(PN,USERR);
      USERT.FH := USERT.FH+O;
      WRITEOUT(L2,USERT);
      PRINT('You left '+cstr(O)+' units of equipment on the planet surface.');
    END;
END;

PROCEDURE TAKEALL(L2:INTEGER);

  VAR
      F,A: INTEGER;
BEGIN
  ANSIC(5);
  PRINT('<Take all>');
  F := TRUNC(H[0]-H[1]-H[2]-H[3]);
  ANSIC(1);
  A := TRUNC(N[3]);
  IF F=0 THEN
    BEGIN
      ANSIC(8);
      PRINT('You don''t have any free holds.');
      ANSIC(1);
    END
  ELSE
    BEGIN
      IF F<A THEN
        A := F;
      IF F<>0 THEN
        BEGIN
          F := F-A;
          H[3] := H[3]+A;
          N[3] := N[3]-A;
          USERR.FK := USERR.FK+A;
          WRITEOUT(PN,USERR);
          READIN(L2,USERT);
          USERT.FH := USERT.FH-A;
          WRITEOUT(L2,USERT);
          PRINT('You took '+CSTR(A)+' holds of equipment.');
          A := TRUNC(N[2]);
          IF F=0 THEN
            BEGIN
              ANSIC(5);
              PRINT('Your holds are filled.');
              ANSIC(1);
            END
          ELSE
            BEGIN
              IF F<A THEN
                A := F;
              IF F<>0 THEN
                BEGIN
                  F := F-A;
                  H[2] := H[2]+A;
                  N[2] := N[2]-A;
                  USERR.FJ := USERR.FJ+A;
                  WRITEOUT(PN,USERR);
                  READIN(L2,USERT);
                  USERT.FG := USERT.FG-A;
                  WRITEOUT(L2,USERT);
                  PRINT('You took '+CSTR(A)+' holds of organics.');
                  A := TRUNC(N[1]);
                  IF F=0 THEN
                    BEGIN
                      ANSIC(5);
                      PRINT('Your cargo holds are filled.');
                      ANSIC(1);
                    END
                  ELSE
                    BEGIN
                      IF F<A THEN
                        A := F;
                      IF F<>0 THEN
                        BEGIN
                          F := F-A;
                          H[1] := H[1]+A;
                          N[1] := N[1]-A;
                          USERR.FI := USERR.FI+A;
                          WRITEOUT(PN,USERR);
                          READIN(L2,USERT);
                          USERT.FF := USERT.FF-A;
                          WRITEOUT(L2,USERT);
                          PRINT('You took '+CSTR(A)+
                            ' holds of ore.');
                        END;
                    END;
                END;
            END;
        END;
    END;
END;

PROCEDURE DESTROY(L2:INTEGER);
BEGIN
  NL;
  ANSIC(8);
  PRINT('*** DESTROY THE PLANET ***');
  NL;
  ANSIC(6);
  PROMPT('Confirmed??? (Y/N)[N]? ');
  ANSIC(4);
  IF YN THEN
    PROMPT('Are you absolutely sure(Y/N)[N]? ');
    IF YN THEN
      IF userr.fg >= 50 THEN
        BEGIN
          READIN(L2,USERT);
          USERT.FM := 0;
          WRITEOUT(L2,USERT);
          READIN(S2,USERT);
          USERT.FO := 0;
          WRITEOUT(S2,USERT);
          SYSOPLOG('  -  '+USERR.FA+' destroyed the planet in sector '
            +CSTR(S2-LP));
          ssm(pn,'The Imperial Command for Interstellar Trade has sent this message:');
          ssm(pn,'   Do that again and we will dispatch War Rocket Ajax to bring');
          ssm(pn,'   back your body!');
          ANSIC(3);
          NL;
          PRINTFILE('gfiles\geneboom.msg');
          DONE := TRUE;
          userr.fg := userr.fg - 30;
          WRITEOUT(PN,userr);
          ANSIC(1);
        END
      ELSE
        BEGIN
          ANSIC(4);
          PRINT('Your computer has forcasted a loss of 25-40 K3-A fighters and');
          ANSIC(4);
          PRINT('has aborted the mission.');
          DONE := TRUE;
        END;
END;

PROCEDURE INCREASE(L2:INTEGER);

  VAR
      A1,B : INTEGER;
BEGIN
  ANSIC(8);
  PRINT('<Increase productivity>');
  NL;
  ANSIC(4);
  PRINT('You have '+CSTR(USERR.FL)+' credits.');
  ANSIC(1);
  PRINT('1 - mining Ore costs 500');
  ANSIC(2);
  PRINT('2 - growing Organics costs 700');
  ANSIC(3);
  PRINT('3 - heavy machinery & Equipment production costs 100.');
  ANSIC(5);
  PROMPT('Which one do you want to increase (1,2,3)? ');
  ANSIC(1);
  MMKEY(I);
  IF I<>'' THEN
    BEGIN
      A := VALUE(I);
      IF (A>=1) AND (A<=4) THEN
        BEGIN
          IF A=1 THEN
            IF PUB[1] > 9 THEN
              PRINT('It''s at its maximum value.')
            ELSE
              BEGIN
                PROMPT('Ore: Increase by how many units? ');
                INPUT(I,3);
                IF I<>'' THEN
                  BEGIN
                    A1 := VALUE(I);
                    IF A1>=1 THEN
                      IF A1+PUB[1]>10 THEN
                        PRINT('The most it can be is 10 units.')
                      ELSE
                        BEGIN
                          B := USERR.FL;
                          IF A1*500>B THEN
                            PRINT('You''re too poor.  You only have '
                                +CSTR(USERR.FL)+' credits.')
                          ELSE
                            BEGIN
                              USERR.FL := B-500*A1;
                              WRITEOUT(PN,USERR);
                              READIN(L2,USERT);
                              USERT.FC := USERT.FC+A1;
                              WRITEOUT(L2,USERT);
                            END;
                        END;
                  END;
              END;
          IF A=2 THEN
            IF PUB[2] > 19 THEN
              PRINT('It''s at its maximum value.')
            ELSE
              BEGIN
                PROMPT('Organics: Increase by how many units? ');
                INPUT(I,3);
                IF I<>'' THEN
                  BEGIN
                    A1 := VALUE(I);
                    IF A1>=1 THEN
                      IF A1+PUB[2]>20 THEN
                        PRINT('The most it can be is 20 units.')
                      ELSE
                        BEGIN
                          B := USERR.FL;
                          IF A1*700>B THEN
                            PRINT('You''re too poor.  You only have '
                                  +CSTR(USERR.FL)+' credits.')
                          ELSE
                            BEGIN
                              USERR.FL := B-700*A1;
                              WRITEOUT(PN,USERR);
                              READIN(L2,USERT);
                              USERT.FD := USERT.FD+A1;
                              WRITEOUT(L2,USERT);
                            END;
                        END;
                  END;
              END;

          IF A=3 THEN
            IF PUB[3] > 29 THEN
              PRINT('It''s at its maximum value.')
            ELSE
              BEGIN
                PROMPT('Equipment: Increase by how many units? ');
                INPUT(I,3);
                IF I<>'' THEN
                  BEGIN
                    A1 := VALUE(I);
                    IF A1>=1 THEN
                      IF A1+PUB[3]>30 THEN
                        PRINT('The most it can be is 30 units.')
                      ELSE
                        BEGIN
                          B := USERR.FL;
                          IF A1*100>B THEN
                            PRINT('You''re too poor.  You only have '
                              +CSTR(USERR.FL)+' credits.')
                          ELSE
                            BEGIN
                              USERR.FL := B-100*A1;
                              WRITEOUT(PN,USERR);
                              READIN(L2,USERT);
                              USERT.FE := USERT.FE+A1;
                              WRITEOUT(L2,USERT);
                            END;
                        END;
                  END;
              END;
        END;
  END;
END;

PROCEDURE DISPLAY;

  VAR
      I : INTEGER;
BEGIN
  UPPLANET(S2);
  NL;
  READIN(L2,USERT);
  ANSIC(5);
  PRINT('Planet: '+USERT.FA);
  ANSIC(3);
  PRINT(' Item      Prod.  Amount  in holds');
  PRINT(' ~~~~      ~~~~~  ~~~~~~  ~~~~~~~~');
  FOR I:=1 TO 3 DO
    BEGIN
      ANSIC(4+I);
      PROMPT(P[I]);
      PROMPT(ADDBLANK(CSTR(TRUNC(PUB[I])),5));
      PROMPT(ADDBLANK(CSTR(TRUNC(N[I])),7));
      PRINT(ADDBLANK(CSTR(TRUNC(H[I])),8));
    END;
  PRINT('You have '+CSTR(TRUNC(H[0]-H[1]-H[2]-H[3]))+
        ' free cargo holds.');
END;

BEGIN
  PRINT('<Land on planet surface>');
  NL;
  PRINT('Beginning landing maneuvers...');
  PRR := USERR.FF;
  S2 := PRR+LP;
  PD := USERR.FB;
  READIN(S2,USERT);
  L := USERT.FO;
  IF L=0 THEN
    BEGIN
      ANSIC(4);
      PRINT('There isn''t a planet in this sector.');
      PRINT('You can create one with a Genesis Torpedo.');
      PRINT('Torpedoes cost 10,000 credits.');
      ANSIC(1);
      IF USERR.FL < 10000 THEN
        PRINT('You''re too poor to buy one.')
      ELSE
        BEGIN
          NL;
          PRINT('You have '+CSTR(USERR.FL)+' credits.');
          PROMPT('Do you wish to buy a torpedo (Y/N) [N]? ');
          IF YN THEN
            BEGIN
              DONE := FALSE;
              L := LT1+1;
              REPEAT
                READIN(L,USERT);
                IF USERT.FM=0 THEN
                  DONE := TRUE;
                L := L+1;
              UNTIL DONE OR (L>LL1);
              L := L-1;
              IF NOT DONE THEN
                BEGIN
                  NL;
                  PRINT('I''m  sorry, but not enough free matter exists.');
                  PRINT('One has to be destroyed before you can create one.');
                END
              ELSE
                BEGIN
                  ANSIC(2);
                  PRINTFILE('gfiles\genesis.msg');
                  ANSIC(1);
                  PROMPT(
                  'What do you want to name this planet? (41 chars. max)? ');
                  INPUTL(I,41);
                  READIN(L,USERT);
                  USERT.FA := I;
                  USERT.FM := LENGTH(I);
                  USERT.FC := 1;
                  USERT.FD := 1;
                  USERT.FE := 1;
                  USERT.FF := 1;
                  USERT.FG := 1;
                  USERT.FH := 1;
                  USERT.FI := 0;
                  USERT.FJ := 0;
                  USERT.FK := 0;
                  WRITEOUT(L,USERT);
                  READIN(S2,USERT);
                  USERT.FO := L-LT1;
                  WRITEOUT(S2,USERT);
                  GETDATE;
                  M := VALUE(COPY(TIME,1,2))*60+VALUE(COPY(TIME,4,2));
                  READIN(L,USERT);
                  USERT.FB := D;
                  USERT.FR := M;
                  WRITEOUT(L,USERT);
                  USERR.FL := USERR.FL-10000;
                  WRITEOUT(PN,USERR);
                  SYSOPLOG('  -  '+USERR.FA+' made a planet: '+I+
                           ' at sector: '+cstr(userr.ff));
                  NL;
                END
            END
        END
    END
  ELSE
    BEGIN
      L2 := L+LT1;
      DISPLAY;
      NL;
      DONE := FALSE;
      REPEAT
        PROMPT('Planet command (?=help)? ');
        MMKEY(I);
        IF I='' THEN I:='A';
        CASE I[1] OF
          'A' : TAKEALL(L2);
          'D' : DESTROY(L2);
          'I' : INCREASE(L2);
          '1' : TAKEORE(L2);
          '2' : TAKEORG(L2);
          '3' : TAKEEQU(L2);
          '4' : LEAVORE(L2);
          '5' : LEAVORG(L2);
          '6' : LEAVEQU(L2);
          'L' : DONE := TRUE;
          'R' : DISPLAY;
          '?' : HELPIT;
          ' ' : HELPIT;
        END;
      UNTIL DONE OR HANGUP;
      NL;
      ANSIC(5);
      PRINT('leaving Planet...');
      ANSIC(1);
    END;
END;

OVERLAY

PROCEDURE FIGHTERS;

  VAR
      D2,F2,N,L,B : INTEGER;
      I           : STR;
BEGIN
  ANSIC(8);
  PRINT('<Drop/Take Fighters>');
  ANSIC(1);
  IF PRR<2 THEN
    BEGIN
      ANSIC(4);
      PRINTFILE('gfiles\kentmad.msg');
      ANSIC(1);
      USERR.FH := USERR.FH-1;
      USERR.FG := TRUNC(USERR.FG*0.9);
    END
  ELSE
    BEGIN
      READIN(S2,USERT);
      D2 := USERT.FL;
      F2 := USERR.FG;
      ANSIC(2);
      PRINT('You have '+CSTR(F2+D2)+' fighters available.');
      ANSIC(1);
      PROMPT('How many fighters do you want defending this sector? ');
      INPUT(I,4);
      N := VALUE(I);
      IF N>=0 THEN
        BEGIN
          L := N;
          B := F2+D2-L;
          IF B<0 THEN
            BEGIN
              ANSIC(8);
              PRINT('You don''t have that many ships available');
              ANSIC(1);
            END
          ELSE
            IF B>9999 THEN
              PRINT('Too many ships in your fleet!  You are limited to 9999')
            ELSE
              BEGIN
                USERT.FL := L;
                USERT.FM := PN*SGN(L);
                WRITEOUT(S2,USERT);
                USERR.FG := B;
                WRITEOUT(PN,USERR);
                ANSIC(2);
                PRINT('Done. You have '+CSTR(B)+
                ' fighter(s) in close support.');
                ANSIC(1);
              END;
        END;
    END;
END;

OVERLAY

PROCEDURE HELPIT;
BEGIN
  ANSIC(8);
  PRINT('<Help>');
  NL;
  ANSIC(3);
  PRINT('A - <A>ttack enemy vessels');
  ANSIC(4);
  PRINT('C - <C>omputer');
  ANSIC(4);
  PRINT('D - re<D>isplay sector');
  ANSIC(3);
  PRINT('F - take or leave <F>ighters');
  ANSIC(5);
  PRINT('G - <G>amble with an odd Tera''ngan trader');
  ANSIC(4);
  PRINT('I - <I>nfo on your ship');
  ANSIC(5);
  PRINT('L - <L>and on surface of a planet.');
  ANSIC(3);
  PRINT('M - drop <M>ine');
  ANSIC(5);
  PRINT('P - dock at a space <P>ort (and trade)');
  ANSIC(6);
  PRINT('W - <W>arp to another sector');
  ANSIC(8);
  PRINT('Q - <Q>uit game');
  ANSIC(2);
  PRINT('Z - instructions');
END;

OVERLAY PROCEDURE STARTING;
BEGIN
  IF (USERR.FF<1) AND (NOT ENDED) THEN
    BEGIN
      PRINT('You are being moved to sector 1');
      USERR.FF := 1;
      USERR.FQ := 0;
      WRITEOUT(PN,USERR);
    END;
  IF USERR.FL>20000 THEN             (* higher than 32767 turns negative *)
    BEGIN
      NL;
      ANSIC(8);
      PRINT('Tax time!  You are being taxed 3000 credits to help support '+
            'the Federation');
      PRINT('and the struggle against the Romulan Empire.');
      ANSIC(1);
      USERR.FL := USERR.FL-3000;
      WRITEOUT(PN,USERR);
    END;
  ENTERROOM;
END;

OVERLAY PROCEDURE GAMBLE;

  VAR
      M,N,J,V : INTEGER;
      I   : STR;
BEGIN
  ANSIC(8);
  PRINT('<Gamble with.....Harcourt Fenton Mudd??>');
  ANSIC(1);
  M := USERR.FL;
  PRINT('You have '+CSTR(M)+' credits.');
  PROMPT('How much do you want to gamble at double or nothing (50-50 odds)[0]? ');
  INPUT(I,6);
  N := VALUE(I);
  IF N>0 THEN
    IF N>M THEN
      PRINT('You''re not that rich.')
    ELSE
      BEGIN
        PRINT('Tossing the Klin Zha Spindles...');
        FOR J:=1 TO 300 DO
          BEGIN
          END;
        V := RANDOM(2)+1;
        IF V=1 THEN
          BEGIN
            USERR.FL := M-N;
            WRITEOUT(PN,USERR);
            NL;
            PRINT('You lost. Mudd smiles as he takes away your wager...');
          END
        ELSE
          BEGIN
            USERR.FL := M+N;
            WRITEOUT(PN,USERR);
            ANSIC(8);
            PRINT('VICTORY! Mudd looks a bit grim...');
            ANSIC(1);
          END;
        PRINT('You now have '+CSTR(USERR.FL)+' credits.');
      END;
END;

OVERLAY PROCEDURE MINEDROP;

BEGIN
  readin(PN,userr);
  ANSIC(6);
  PROMPT('Do you really want to drop a mine in this sector?');
  IF YN THEN
    BEGIN
      nl;
      IF userr.ff>9 THEN             (* Outside sector 9 *)
        BEGIN
          IF (userr.fh<2) or (userr.fg<6) THEN
            PRINT('You don''t have enough resources aboard to build a mine.')
          ELSE
            BEGIN
              PRINTFILE('gfiles\twmine.msg');
              userr.fg := userr.fg-5;  (* use 5 fighters *)
              userr.fh := userr.fh-2;  (* use 2 cargo holds *)
              IF userr.fh < (userr.fi+userr.fj+userr.fk) THEN
                IF userr.fi > 1 THEN
                  userr.fi := userr.fi-2
                ELSE
                  IF userr.fj > 1 THEN
                    userr.fj := userr.fj-2
                  ELSE
                    IF userr.fk > 1 THEN
                      userr.fk := userr.fk-2;
              writeout(pn,userr);
              readin(userr.ff+LP,usert);
              usert.fp:=usert.fp+1;
              IF usert.fp > 20 THEN usert.fp:=20;
              writeout(userr.ff+LP,usert);
            END;
        END
      ELSE                           (* If inside sector 9 *)
        BEGIN
          PRINT('The Imperial Navy does not like people mining the home quadrant...');
        END;
    END;
END;
