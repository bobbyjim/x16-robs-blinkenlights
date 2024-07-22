(***************************************************
 *         TradeWars II - QuixPlus Version         *
 *                                                 *
 *      Original BASIC code by Chris Sherrick      *
 *       Pascal conversions by Lord Darkseid       *
 *                                                 *
 *            Further modifications by             *
 *             Sorcerer, Supreme Dalek,            *
 *        The Omega Man, and Preston Stroud        *
 *                                                 *
 *            Last modified on 10/20/87 by         *
 *               Quixotic Software, CA             *
 *                                                 *
 ***************************************************)

PROGRAM tw2;

(*$C-*) (*$v-*)
(*$I COMMON.PAS*)
CONST
      fs = 'TWDATA.DAT';
      p  : ARRAY[1..3] OF STR =
                                ('Ore.......','Organics..','Equipment.');
      b  : ARRAY[1..3] OF INTEGER =
                                    (10,20,35);

TYPE
     users = RECORD
               fa                   : STRING[41];
               fb,fc,fd,fe,ff,fg    : INTEGER;
               fh,fi,fj,fk,fl,fr,fp : INTEGER;
               fm,fo,fq,ft,fv       : INTEGER;
               newcash              : real;
             END;

VAR
    smg          : FILE OF smr;
    pnn          : STRING[41];
    y,a,mo,d,go,pn,pd,s2,st,g2,prr   : INTEGER;
    ay,tt,lp,ls,lt1,ll1 : INTEGER;
    userf        : FILE OF users;
    userr,usert  : users;
    e            : ARRAY[1..6] OF INTEGER;
    m,n,pub,c1,h : ARRAY[0..3] OF REAL;
    s            : ARRAY[0..200,0..1] OF INTEGER;
    srr          : ARRAY[0..3,0..1] OF REAL;
    g            : ARRAY[0..9,0..1]   OF INTEGER;
    ended,done   : BOOLEAN;
    aim          : STR;
    msger        : TEXT;

FUNCTION sgn(i:INTEGER): INTEGER;
BEGIN
  IF i>0 THEN
    sgn := 1
  ELSE
    IF i<0 THEN
      sgn := -1
    ELSE
      sgn := 0;
END;

PROCEDURE readin(i:INTEGER;VAR user:users);
BEGIN
  SEEK(userf,i);
  READ(userf,user);
END;

PROCEDURE writeout(i:INTEGER;user:users);
BEGIN
  SEEK(userf,i);
  WRITE(userf,user);
END;

PROCEDURE getdate;

  VAR 
      a,code    : INTEGER;
      datea : STR;
BEGIN
  datea := date;
  VAL(COPY(datea,7,4),y,code);
  VAL(COPY(datea,1,2),mo,code);
  VAL(COPY(datea,4,2),d,code);
  IF (y/4=INT(y/4)) AND (mo>2) THEN
    d := d+1;
  IF mo=2 THEN
    d := d+31
  ELSE
    IF mo=3 THEN
      d := d+59
    ELSE
      IF mo=4 THEN
        d := d+90;
  IF mo=5 THEN
    d := d+120
  ELSE
    IF mo=6 THEN
      d := d+151
    ELSE
      IF mo=7 THEN
        d := d+181;
  IF mo=8 THEN
    d := d+212
  ELSE
    IF mo=9 THEN
      d := d+243
    ELSE
      IF mo=10 THEN
        d := d+273;
  IF mo=11 THEN
    d := d+304
  ELSE
    IF mo=12 THEN
      d := d+334;
  IF y<ay THEN
    y := y+100;
  IF y<>ay THEN
    FOR a:=ay TO y-1 
      DO
      BEGIN
        d := d+365;
        IF a/4=INT(a/4) THEN
          d := d+1;
      END;
END;

PROCEDURE ssm(dest:INTEGER; s:STR);

VAR 
    x: smr;
    e,cp,t: INTEGER;
    u: userrec;
BEGIN
  (*$I-*)
  RESET(smg);(*$I+*)
  IF IORESULT<>0 THEN
    REWRITE(smg);
  e := FILESIZE(smg);
  IF e=0 THEN
    cp := 0
  ELSE
    BEGIN
      t := e-1;
      SEEK(smg,t);
      READ(smg,x);
      WHILE (t>0) AND (x.destin=-1) DO
        BEGIN
          t := t-1;
          SEEK(smg,t);
          READ(smg,x);
        END;
      cp := t+1;
    END;
  SEEK(smg,cp);
  x.msg := s;
  x.destin := dest;
  WRITE(smg,x);
  CLOSE(smg);
  IF (dest=pn) THEN
    thisuser.option := thisuser.option+[smw];
END;

PROCEDURE message(p,po,n,n1: INTEGER);
BEGIN
  IF po < 2 THEN
    ssm(p,'The Romulans destroyed '+cstr(n)+' of your fighters.')
  ELSE
    BEGIN
      readin(po,usert);
      IF n1=0 THEN
        WITH usert DO
          ssm(p,fa+' destroyed '+cstr(n)+' of your fighters.')
      ELSE
        WITH usert DO
          ssm(p,fa+' destroyed '+cstr(n1)+' armor points and '
              +cstr(n)+' of your fighters.');
    END;
END;

PROCEDURE pchat(p: INTEGER);

  VAR
      po        : INTEGER;
      pname,pmsg: str;
BEGIN
  ANSIC(3);
  PRINT('<Warming up the Chambers'' coil>');
  prompt('Send a message to player # ');

(*  WHILE NOT hangup DO
    BEGIN *)
      INPUT(pname,41);
      po := value(pname);
      IF (po>1) AND (po<lp) THEN
        BEGIN
          ANSIC(4);
          PRINT('Enter your message now, up to 160 characters, <CR> to end:');
          ANSIC(5);
          INPUTL(pmsg,160);
          readin(p,usert);
          ssm(po,'   '+usert.fa+' sent a message: ');
          ssm(po,pmsg);
          PRINT('Message Transmitted to '+pname);
        END
      ELSE
        PRINT('Not an active player');
(*    END; *)
END;

PROCEDURE removeship(p:INTEGER);

  VAR 
      r,b  : INTEGER;
      done : BOOLEAN;
BEGIN
  readin(p,usert);
  r := usert.ff;
  IF r<>0 THEN
      BEGIN
        readin(lp+r,usert);
        a := usert.fi;
        IF a<>0 THEN
            IF a=p THEN
              BEGIN
                readin(a,usert);
                b := usert.fo;
                readin(lp+r,usert);
                usert.fi := b;
                writeout(lp+r,usert);
              END
            ELSE
              BEGIN
                done := FALSE;
                readin(a,usert);
                REPEAT
                  IF usert.fo = p THEN
                    BEGIN
                      b := a;
                      done := TRUE;
                    END;
                  a := usert.fo;
                  readin(a,usert);
                UNTIL done;
                a := usert.fo;
                readin(b,usert);
                usert.fo := a;
                writeout(b,usert);
              END;
        readin(pn,userr);
      END;
END;

PROCEDURE rsm;

VAR 
    x: smr;
    i: INTEGER;
BEGIN
  (*$I-*)
  RESET(smg); (*$I+*)
  IF IORESULT=0 THEN
      BEGIN
        i := 0;
        REPEAT
          IF i<=FILESIZE(smg)-1 THEN
            BEGIN
              SEEK(smg,i);
              READ(smg,x);
            END;
          WHILE (i<FILESIZE(smg)-1) AND (x.destin<>pn) DO
            BEGIN
              i := i+1;
              SEEK(smg,i);
              READ(smg,x);
            END;
          IF (x.destin=pn) AND (i<=FILESIZE(smg)-1) THEN
            BEGIN
              print(x.msg);
              SEEK(smg,i);
              x.destin := -1;
              WRITE(smg,x);
            END;
          i := i+1;
        UNTIL (i>FILESIZE(smg)-1) OR hangup;
        CLOSE(smg);
      END;
END;

PROCEDURE DELETE(p: INTEGER);

  VAR 
      l: INTEGER;
BEGIN
  readin(p,usert);
  print('Terminating '+usert.fa+' ('+cstr(p)+')...');
  removeship(p);
  readin(p,usert);
  usert.fm := 0;
  usert.fo := 0;
  writeout(p,usert);
  FOR l:=lp+1 TO ls DO
    BEGIN
      readin(l,usert);
      IF usert.fm=p THEN
        BEGIN
          usert.fm := -2;
          writeout(l,usert);
        END;
    END;
  pn := p;
  rsm;
  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      IF usert.fc=p THEN
        BEGIN
          usert.fc := -98;
          writeout(l,usert);
        END;
    END;
END;

OVERLAY PROCEDURE shortest(a,b: INTEGER);

  VAR 
      n,c,l,m : INTEGER;
      found   : BOOLEAN;
BEGIN
  n := 1;
  c := b;
  IF a=b THEN
    BEGIN
      s[0,0] := a;
      s[0,1] := 0;
      s[a,1] := 0;
    END
  ELSE
      BEGIN
        FOR l:=1 TO 200 DO
          FOR m:=0 TO 1 DO
            s[l,m] := 0;
        s[a,1] := 1;
        found := FALSE;
        REPEAT
          l := 1;
          REPEAT
            IF s[l,1]=n THEN
              BEGIN
                readin(l+lp,usert);
                e[1] := usert.fb;
                e[2] := usert.fc;
                e[3] := usert.fd;
                e[4] := usert.fe;
                e[5] := usert.ff;
                e[6] := usert.fg;
                FOR m:=1 TO 6 DO
                  IF e[m]<>0 THEN
                    IF s[e[m],1]=0 THEN
                      BEGIN
                        s[e[m],1] := n+1;
                        s[e[m],0] := l;
                        IF e[m]=b THEN
                          found := TRUE;
                      END;
              END;
            l := l+1;
          UNTIL found OR (l>200);
          IF NOT found THEN
            n := n+1;
        UNTIL found OR (n=9999);
        IF NOT found THEN
            BEGIN
            sysoplog('*** Error - Sector path not found - from sector'
                     +cstr(a)+' to sector'+cstr(b));
            print('*** Error - Sector path not found - from sector'+cstr(a)+
                  ' to sector'+cstr(b));
            s[a,1] := 0;
            ended := TRUE;
          END
        ELSE
          REPEAT
            s[s[c,0],1] := c;
            c := s[c,0];
            IF s[c,0]=0 THEN
              s[b,1] := 0;
          UNTIL s[c,0]=0;
      END;
END;

OVERLAY PROCEDURE picksec(VAR v: INTEGER);
BEGIN
  v := RANDOM(3)+1;
    IF v<>1 THEN
      v := RANDOM(99)+1
    ELSE
      BEGIN
        v := RANDOM(6)+1;
        IF v=1 THEN
          v := 80;
        IF v=2 THEN
          v := 81;
        IF v=3 THEN
          v := 84;
        IF v=4 THEN
          v := 82;
        IF v=5 THEN
          v := 71;
        IF v=6 THEN
          v := 86;
      END;
END;

OVERLAY PROCEDURE rank(VAR p: INTEGER);

  VAR 
      l,g0,h0,f0,n,o,j0,k0,l0,v,c : INTEGER;
      done                        : BOOLEAN;
BEGIN
  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      IF usert.fm=0 THEN
        BEGIN
          usert.fv := -1;
          writeout(l,usert);
        END
      ELSE
        IF usert.fc<>0 THEN
          BEGIN
            usert.fv := 0;
            writeout(l,usert);
          END
        ELSE
          BEGIN
            g0 := usert.fg + usert.fe;
            h0 := usert.fh;
            f0 := usert.fi;
            j0 := usert.fj;
            k0 := usert.fk;
            l0 := usert.fl;
            v := g0*2+h0*25+ROUND(f0*2.5)+j0*5+ROUND(k0*8.75)+ROUND(l0/20);
            usert.fv := v;
            writeout(l,usert);
          END;
    END;
  FOR l:=lp+1 TO ls DO
    BEGIN
      readin(l,usert);
      IF (usert.fl<>0) AND (usert.fm>=2) THEN
        BEGIN
          a := usert.fl;
          p := usert.fm;
          readin(p,usert);
          usert.fv := usert.fv+a*10;
          writeout(p,usert);
        END;
    END;
  p := 0;
  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      v := usert.fv;
      IF v<>-1 THEN
          BEGIN
            n := p;
            o := 0;
            done := FALSE;
            IF p=0 THEN
              BEGIN
                p := l;
                usert.ft := -1;
                writeout(l,usert);
              END
            ELSE
              REPEAT
                readin(n,usert);
                IF (v>usert.fv) AND (o=0) THEN
                  BEGIN
                    readin(l,usert);
                    usert.ft := p;
                    writeout(l,usert);
                    p := l;
                    done := TRUE;
                  END
                ELSE
                  IF v>usert.fv THEN
                    BEGIN
                      readin(o,usert);
                      c := usert.ft;
                      usert.ft := l;
                      writeout(o,usert);
                      readin(l,usert);
                      usert.ft := c;
                      writeout(l,usert);
                      done := TRUE;
                    END
                  ELSE
                    IF usert.ft=-1 THEN
                      BEGIN
                        readin(n,usert);
                        usert.ft := l;
                        writeout(n,usert);
                        readin(l,usert);
                        usert.ft := -1;
                        writeout(l,usert);
                        done := TRUE;
                      END
                    ELSE
                      BEGIN
                        o := n;
                        n := usert.ft;
                      END;
              UNTIL done;
          END;
    END;
END;

PROCEDURE killed(pn,p: INTEGER);

  VAR 
      l : INTEGER;
BEGIN
  removeship(p);                     (* P is dead guy, PN is killer *)
  readin(p,usert);
  usert.fc := pn;
  usert.ff := 0;
  writeout(p,usert);
  FOR l:=lp+1 TO ls DO
    BEGIN
      readin(l,usert);
      IF usert.fm=p THEN
        BEGIN
          usert.fm := -2;
          writeout(l,usert);
        END;
    END;
END;

(*$I TWMAINT.PAS *)

PROCEDURE mmkey(VAR i:STR);

VAR
    c: CHAR;
BEGIN
  REPEAT
    REPEAT
      getkey(c);
      skey(c);
    UNTIL (((c>=' ') AND (c<CHR(127))) OR (c=CHR(13))) OR hangup;
    c := UPCASE(c);
    outkey(c);
    thisline := thisline+c;
    IF (c='/') OR (c='1') THEN
      BEGIN
        i := c;
        REPEAT
          getkey(c);
          skey(c);
        UNTIL ((c>=' ')AND(c<=CHR(127))) OR (c=CHR(13)) OR (c=CHR(8)) OR
              hangup;
        c := UPCASE(c);
        IF c<>CHR(13) THEN
          BEGIN
            outkey(c);
            thisline := thisline+c;
          END;
        IF (c=CHR(8)) OR (c=CHR(127)) THEN
          prompt(' '+c);
        IF c='/' THEN
          INPUT(i,20)
        ELSE
          IF c<>CHR(13) THEN
            i := i+c;
      END
    ELSE
      i := c;
  UNTIL (c<>CHR(8)) AND (c<>CHR(127)) OR hangup;
  nl;
END;

PROCEDURE addmsg(i:STR);
BEGIN
  WRITELN(msger,i);
END;

PROCEDURE readmsg;
BEGIN
  ANSIC(5);
  print('The following happened to your ship since your last time on:');
  rsm;
END;

PROCEDURE addship(p:INTEGER);

  VAR
      r,b  : INTEGER;
      done : BOOLEAN;
BEGIN
  r := userr.ff;
  IF r<>0 THEN
    BEGIN
      readin(lp+r,usert);
      b := usert.fi;
      usert.fi := p;
      writeout(lp+r,usert);
      userr.fo := b;
      writeout(pn,userr);
    END;
END;

PROCEDURE instruct;
BEGIN
  IF NOT ended THEN
    BEGIN
      prompt('Do you want instructions (Y/N) [N]? ');
      IF yn THEN
        printfile('TWINSTR.DOC');
    END;
END;

PROCEDURE initship;

  VAR
      b,c : INTEGER;
BEGIN
  nl;
  ansic(8);
  print('Your ship is being initialized.');
  ansic(1);
  removeship(pn);
  readin(1,usert);
  a := usert.fh;
  b := usert.fi;
  c := usert.fj;
  readin(pn,userr);
  WITH userr DO
    BEGIN
      fb := pd;
      fc := 0;
      fd := tt;
      fe := 0;
      ff := 1;
      fg := a;
      fh := c;
      fi := 0;
      fj := 0;
      fk := 0;
      fl := b;
      fm := 1;
    END;
  writeout(pn,userr);
  addship(pn);
END;

PROCEDURE warped;

  VAR 
      lee,l : INTEGER;
BEGIN
  prompt('Warp Lanes lead to: ');
  IF e[1]<>0 THEN
    BEGIN
      prompt(cstr(e[1]));
      lee := 2;
    END
  ELSE
    IF e[2]<>0 THEN
      BEGIN
        prompt(cstr(e[2]));
        lee := 3;
      END
    ELSE
      IF e[3]<>0 THEN
        BEGIN
          prompt(cstr(e[3]));
          lee := 4;
        END
      ELSE
        IF e[4]<>0 THEN
          BEGIN
            prompt(cstr(e[4]));
            lee := 5;
          END
        ELSE
          IF e[5]<>0 THEN
            BEGIN
              prompt(cstr(e[5]));
              lee := 6;
            END
          ELSE
            lee := 7;
  FOR l:=lee TO 6 DO
    IF e[l]<>0 THEN
      prompt(','+cstr(e[l]));
  nl;
END;

PROCEDURE showroom;

  VAR 
      l,lee : INTEGER;
BEGIN
  prr := userr.ff;
  s2 := prr+lp;
  nl;
  ansic(3);
  print('Sector: '+cstr(prr));
  readin(s2,usert);
  st := usert.fh;
  IF st<>0 THEN
    BEGIN
      readin(st+ls,usert);
      ansic(4);
      print('Ports: '+usert.fa+', class '+cstr(usert.fb));
    END
  ELSE
    BEGIN
      ansic(4);
      print('Ports: None');
    END;
  readin(s2,usert);
  a := usert.fo;
  IF a<>0 THEN
    BEGIN
      readin(a+lt1,usert);
      ansic(5);
      print('Planet: '+usert.fa);
      readin(s2,usert);
    END;
  g2 := 0;
  prompt('Other Ships: ');
  ansic(6);
  a := usert.fi;
  IF a=0 THEN
    print('None')
  ELSE
    BEGIN
      REPEAT
        readin(a,usert);
        IF a<>pn THEN
          BEGIN
            nl;
            prompt('   '+usert.fa+' with '+cstr(usert.fg)+' fighters in a ');
            if usert.fh > 125 then
              prompt('very ');
            if usert.fh < 50 then
              prompt('small ');
            if (usert.fh > 90) then
              prompt('large ');
            prompt('merchant ship');
            g2 := 1;
          END;
        a := usert.fo;
      UNTIL a=0;
      IF g2=0 THEN
        print('None')
      ELSE
        nl;
      ansic(1);
    END;
  readin(s2,usert);
  prompt('Fighters in sector: ');
  ansic(7);
  IF usert.fl=0 THEN
    print('None')
  ELSE
    BEGIN
      aim := cstr(usert.fl);
      IF usert.fm=-2 THEN
        print(aim+' (Rogue mercenaries)')
      ELSE
        IF usert.fm<1 THEN
          print(aim+' (Romulans)')
        ELSE
          IF usert.fm=pn THEN
            print(aim+' (yours)')
          ELSE
            BEGIN
              readin(usert.fm,usert);
              print(aim+' (belong to '+usert.fa+')');
            END;
      ansic(1);
    END;
  warped;
END;

PROCEDURE quitit;
BEGIN
  ansic(8);
  print('<Quit>');
  ansic(5);
  prompt('Confirmed? (Y/N)? ');
  IF yn THEN
    ended := TRUE;
END;

PROCEDURE destroyed;
BEGIN
  print('Your ship has been destroyed!');
  nl;
  print('You will start over tomorrow with a new ship.');
  killed(pn,pn);
  ended := TRUE;
  done := TRUE;
END;

PROCEDURE info(pn:INTEGER);

  VAR 
      a: REAL;
      b,c : INTEGER;
BEGIN
  readin(pn,usert);
  nl;
  ansic(1);
  print('Name: '+usert.fa);
  ansic(2);
  print('Sector: '+cstr(usert.ff)+'    Turns left: '+cstr(usert.fd));
  ansic(3);
  print('Fighters: '+cstr(usert.fg)+'    Armor points: '+cstr(usert.fe));
  ansic(4);
  print('Cargo Holds: '+cstr(usert.fh));
  ansic(3);
  print('  Ore: '+cstr(usert.fi)+'  Org: '+cstr(usert.fj)+'  Eqp: '+cstr(
       usert.fk)+'   Empty holds: '+cstr(usert.fh-usert.fi-usert.fj-usert.fk));
  ansic(2);
  print('Credits: '+cstr(usert.fl));
  ansic(1);
  nl;
END;

PROCEDURE helpme;
BEGIN
  ansic(6);
  print('Help');
  nl;
  ansic(1);
  print('A - <A>ttack');
  ansic(2);
  print('D - re<D>isplay sector');
  ansic(3);
  print('I - <I>nformation about your ship');
  ansic(4);
  print('Q - <Q>uit the game');
  ansic(8);
  print('R - <R>etreat');
  ansic(5);
  print('S - <S>end a distress call to another player');
  ansic(1);
END;

OVERLAY PROCEDURE retreat;

  VAR
      lr : INTEGER;
BEGIN
  ansic(8);
  print('<Retreat>');
  ansic(1);
  lr := userr.fq;
  WHILE (lr=0) OR (lr=prr) DO
    lr := e[RANDOM(6)+1];
  IF userr.fg >=1 THEN
    BEGIN
      ansic(7);
      print('Your fighter pilots make a valiant attempt to stall the oncoming'+
            ' horde.');
      print('You have '+cstr(userr.fg-1)+' K3-A fighter(s) left.');
      removeship(pn);
      userr.fg := userr.fg-1;
      userr.ff := lr;
      userr.fq := prr;
      writeout(pn,userr);
      addship(pn);
      lr := a;
      done := TRUE;
    END
  ELSE
    IF userr.fe>4 THEN
      BEGIN
        ansic(7);
        print('The on-coming horde is fast & powerful, but your ship armor held...');
        ansic(8);
        print('...this time...');
        removeship(pn);
        userr.fe := userr.fe-5;
        userr.ff := lr;
        userr.fq := prr;
        writeout(pn,userr);
        addship(pn);
        lr := a;
        done := TRUE;
      END
    ELSE
      IF RANDOM(2)+1=1 THEN
        BEGIN
          ansic(7);
          print('Lucky guy!  You escaped by the hair on your chinny-chin-chin!');
          ansic(1);
          removeship(pn);
          userr.fe := 0;
          userr.ff := lr;
          userr.fq := prr;
          writeout(pn,userr);
          addship(pn);
          lr := a;
          done := TRUE;
        END
      ELSE
        BEGIN
          ansic(6);
          print('A fitting fate for you, coward: you didn''t escape!');
          ansic(1);
          destroyed;
        END;
  prr := userr.ff;
  s2 := prr+lp;
  readin(s2,usert);
  e[1] := usert.fb;
  e[2] := usert.fc;
  e[3] := usert.fd;
  e[4] := usert.fe;
  e[5] := usert.ff;
  e[6] := usert.fg;
  nl;
END;

OVERLAY PROCEDURE attack(VAR s2,f2,e2:INTEGER);

  VAR 
      i : STR;
      n,l,k : INTEGER;
BEGIN                                (* S2=sector  F2=Friendly ftrs on board *)
  ansic(8);                          (* E2=Enemy ftrs in sector *)
  print('<Attack>');
  ansic(1);
  IF f2<1 THEN
    BEGIN
      ansic(6);
      print('You don''t have any fighters!');
      ansic(1);
    END
  ELSE
    BEGIN
      prompt('How many fighters do you wish to use? ['+cstr(f2)+'] ');
      INPUT(i,4);
      n := value(i);
      IF i='' THEN n := f2;
      IF (n>=1) AND (n<=9999) THEN
        BEGIN
          l := 0;                    (* L=Friendly lost *)
          k := 0;                    (* K=Enemy killed *)
          IF n>f2 THEN
            BEGIN
              nl;
              print('You don''t have that many fighters.')
            END
          ELSE
            BEGIN
              WHILE (l<n) AND (k<e2) DO
                IF RANDOM(2)+1=1 THEN
                  l := l+1           (* Current player loses *)
                ELSE
                  k := k+1;          (* Defending player loses *)
              f2 := f2-l;
              e2 := e2-k;
              userr.fg := f2;
              writeout(pn,userr);
              readin(s2,usert);      (* Saving reduced ftr count *)
              IF usert.fm>1 THEN
                ssm(usert.fm,userr.fa+' attacked '+cstr(k)+
                  ' of your fighters in sector '+cstr(userr.ff));
              usert.fl := e2;
              writeout(s2,usert);
              IF e2<1 THEN
                BEGIN
                  usert.fl := 0;
                  usert.fm := 0;
                  writeout(s2,usert);
                END;
              ansic(2);
              print('You lost '+cstr(l)+' fighter(s)');
              ansic(7);
              print('You destroyed '+cstr(k)+' enemy fighters.');
              ansic(1);
              IF e2<=0 THEN
                BEGIN
                  ansic(7);
                  print('You destroyed all the fighters.');
                  ansic(1);
                  done := TRUE;
                END;
            END;
        END;
    END;
END;

PROCEDURE enterroom;

  VAR 
      f2,e2,r1 : INTEGER;
      i        : STR;

  OVERLAY PROCEDURE inclear;
  BEGIN
    IF prr<>85 THEN
      showroom
    ELSE
        BEGIN
          nl;
          nl;
          ansic(7);
          print('COWABUNGA!!!  You''ve defeated the Romulan Invasion fleet and recieved');
          print('an Imperial Commendation, as well as a cash bonus!');
          ansic(4);
          print(
           'Unfortunately, the Roms are too stupid to know they''re beaten...');
          readin(s2,usert);
          userr.fl := userr.fl+2500;
          writeout(pn,userr);
          usert.fl := 2000;
          usert.fm := -1;
          writeout(s2,usert);
          ansic(1);
          addmsg('Congrats to '+pnn+' who smashed the Romulan Invasion Fleet on '
                +date);
          addmsg('and received an Imperial Commendation.');
        END;
  END;

BEGIN
  removeship(pn);
  addship(pn);
  prr := userr.ff;
  s2 := prr+lp;
  readin(s2,usert);
  e[1] := usert.fb;
  e[2] := usert.fc;
  e[3] := usert.fd;
  e[4] := usert.fe;
  e[5] := usert.ff;
  e[6] := usert.fg;
  nl;
  IF (S2>9) and (usert.fp > 0) THEN
    BEGIN
      r1 := RANDOM(10)+1;
      IF usert.fp-r1>=0 THEN
        BEGIN
          usert.fp := usert.fp-1;    (* Reduce mine count in sector *)
          writeout(s2,usert);
          r1 := RANDOM(5)+18;        (* Mine damage 18 to 22 *)
          userr.fe:=userr.fe-r1;     (* Ship Armor knocked down *)
          ANSIC(8);
          PRINT('A space mine detonates near you!');
          PRINT('The console reports damages of '+cstr(r1)+' battle points!');
          IF userr.fe > -1 THEN      (* Can Armor handle it? *)
            BEGIN
              ANSIC(7);
              PRINT('Your ship armor absorbs the brunt of the explosion!');
            END
          ELSE
            BEGIN                    (* Armor can't handle it all *)
              r1:=(-userr.fe);       (* damage less the armor *)
              IF r1>userr.fg THEN    (* Not enough K3-As to handle the rest *)
                BEGIN
                  ANSIC(8);
                  PRINT('Life support knocked out!  Energy Generation shut down!');
                  nl;
                  ANSIC(3);
                  PRINT('In space, there''s no one to hear you scream...');
                  destroyed;
                END
              ELSE
                BEGIN                (* Some K3-As destroyed *)
                  ANSIC(7);
                  PRINT(cstr(r1)+' K3-A Fighters destroyed by the impact!');
                  userr.fe:=0;
                  userr.fg := userr.fg - r1;
                END;
            END;
        END;
    END;
  writeout(pn,userr);
  IF usert.fm<>pn THEN
       IF usert.fl<>0 THEN
           BEGIN
             showroom;
             nl;
             ansic(6);
             print(
              'You have to destroy the fighters before entering this sector.');
             f2 := userr.fg;
             readin(s2,usert);
             e2 := usert.fl;
             nl;
             ansic(1);
             print('Fighters: '+cstr(f2)+' /'+cstr(e2));
             done := FALSE;
             WHILE (NOT done) AND (NOT hangup) DO
               BEGIN
                 dump;
                 tleft;
                 prompt('Option? (A,D,I,Q,R,S,?):? ');
                 mmkey(i);
                 IF i='' THEN
                   print('? =<Help>');
                 CASE i[1] OF
                   'R' : retreat;
                   'D' : BEGIN
                           print('<Display>');
                           showroom;
                         END;
                   'A' : attack(s2,f2,e2);
                   'Q' : BEGIN
                           quitit;
                           IF ended THEN
                             done := TRUE;
                         END;
                   'I' : BEGIN
                           print('<Info>');
                           info(pn);
                         END;
                   'S' : pchat(pn);
                   '?' : helpme;
                 END;
               END;
           END
         ELSE
           inclear
    ELSE
      inclear;
END;


PROCEDURE moveit;

  VAR
      t2,l,t,lee : INTEGER;
      i    : STR;
      done : BOOLEAN;
BEGIN
  print('<Warp to another sector>');
  t2 := userr.fd;
  IF t2<1 THEN
    BEGIN
      ansic(8);
      print('You don''t have any turns left.');
      ansic(1);
    END
  ELSE
      BEGIN
        warped;
        prompt('To which Sector? ');
        INPUT(i,3);
        t := value(i);
        IF (t<1) OR (t>9999) THEN
          print('Illegal number.')
        ELSE
            BEGIN
              done := FALSE;
              FOR l:=1 TO 6 DO
                IF e[l]=t THEN
                  done := TRUE;
              IF NOT done THEN
                BEGIN
                  nl;
                  print('That Warp Lane is currently closed.');
                END
              ELSE
                BEGIN
                  t2 := t2-1;
                  removeship(pn);
                  userr.ff := t;
                  userr.fq := prr;
                  userr.fd := t2;
                  writeout(pn,userr);
                  addship(pn);
                  IF (t2=10) OR (t2<6) THEN
                    BEGIN
                      nl;
                      print('You have '+cstr(t2)+' turns left.');
                    END;
                  enterroom;
                END;
            END;
      END;
END;

FUNCTION addblank(b:STR;l:INTEGER): STR;
BEGIN
  WHILE LENGTH(b)< l DO
    b := ' '+b;
  addblank := b;
END;

PROCEDURE upport(s2:INTEGER);

  VAR
      p2,c,l,code,mn : INTEGER;
      temp,dim           : REAL;
BEGIN
  readin(s2,usert);
  p2 := usert.fh+ls;
  readin(p2,usert);
  n[1] := usert.fd+usert.fr/10000;
  n[2] := usert.fe+usert.fo/10000;
  n[3] := usert.ff+usert.fp/10000;
  pub[1] := usert.fg;
  pub[2] := usert.fh;
  pub[3] := usert.fi;
  c1[1] := usert.fj;
  c1[2] := usert.fk;
  c1[3] := usert.fl;
  getdate;
  c := d;
  mn := value(COPY(time,1,2))*60+value(COPY(time,4,2));
  dim := d-usert.fc+(mn-usert.fq)/1440;
  IF dim>=0 THEN
    BEGIN
      IF dim > 10 THEN
        dim := 10.0;
      FOR l:=1 TO 3 DO
        BEGIN
          n[l] := n[l]+pub[l]*dim;
          IF n[l] > pub[l]*10 THEN
             n[l] := pub[l]*10;
        END;
    END;
  FOR l:=1 TO 3 DO
    m[l] := INT(b[l]*(1-c1[l]*n[l]/pub[l]/1000)+0.5);
  readin(p2,usert);
  usert.fc := c;
  usert.fd := TRUNC(n[1]);
  usert.fe := TRUNC(n[2]);
  usert.ff := TRUNC(n[3]);
  FOR l:=1 TO 3 DO
    BEGIN
      srr[l,0] := INT((n[l]-INT(n[l]))*10000+0.5);
      n[l] := INT(n[l]);
    END;
  usert.fr := TRUNC(srr[1,0]);
  usert.fo := TRUNC(srr[2,0]);
  usert.fp := TRUNC(srr[3,0]);
  usert.fq := mn;
  writeout(p2,usert);
END;

PROCEDURE otherport(p2:INTEGER);

  VAR
      i: INTEGER;
      ni,HI : ARRAY[0..3] OF INTEGER;
BEGIN
  h[0] := userr.fh;
  h[1] := userr.fi;
  h[2] := userr.fj;
  h[3] := userr.fk;
  FOR i:=1 TO 3 DO
    BEGIN
      ni[i] := TRUNC(n[i]);
      HI[i] := TRUNC(h[i]);
    END;
  readin(p2,usert);
  nl;
  ansic(3);
  print('Commerce report for '+usert.fa+': '+date+' '+time);
  nl;
  ansic(5);
  print(' Items     Status   # units  in holds');
  print(' ~~~~~     ~~~~~~   ~~~~~~~  ~~~~~~~~');
  ansic(1);
  FOR i:=1 TO 3 DO
    BEGIN
      prompt(p[i]);
      IF c1[i]<0.0 THEN
        prompt(' Buying  ')
      ELSE
        prompt(' Selling ');
      prompt(addblank(cstr(ni[i]),7));
      print (addblank(cstr(HI[i]),9));
    END;
END;

PROCEDURE port1;

  VAR
      mi : ARRAY[0..4] OF INTEGER;
BEGIN
  m[1] := 50 * SIN(0.89756 * d);
  m[2] := 8 * SIN(0.89714 * d + 1.5707);
  nl;
  m[1] := m[1]+500;
  m[2] := m[2]+100;
  m[3] := 200-m[2];
  mi[1] := ROUND(m[1]);
  mi[2] := ROUND(m[2]);
  mi[3] := ROUND(m[3]);
  ansic(3);
  print('Commerce report for Sol: '+date+' '+time);
  ansic(5);
  print('  Cargo holds : '+cstr(mi[1])+' credits/hold');
  ansic(2);
  print('  Fighters    : '+cstr(mi[2])+' credits/fighter');
  ansic(2);
  print('  Armor points: '+cstr(mi[3])+' credits/point');
  ansic(4);
  print('  Turns       : 300 credits each.');
  nl;
  ansic(1);
END;

(*$I TWOVER.PAS *)

PROCEDURE mainmenu;

  VAR
      i: STR;
      INT : INTEGER;
(* 22000 *)
BEGIN
  dump;
  tleft;
  nl;
  prompt('Command (?=Help)? ');
  mmkey(i);
  IF i='' THEN
    print('? = Help');
  CASE i[1] OF
    'A' : kill;
    'C' : computer;
    'D' : BEGIN
            print('<Display>');
            showroom;
          END;
    'F' : fighters;
    'G' : gamble;
    'I' : BEGIN
            print('<Info>');
            info(pn);
          END;
    'L' : planet;
    'M' : BEGIN
            ANSIC(8);
            print('<Drop Mine in sector>');
            minedrop;
          END;
    'P' : PORT;
    'W' : moveit;
    'Z' : BEGIN
            print('<Instructions>');
            instruct;
          END;
    'Q' : quitit;
    '?' : helpit;
    ' ' : helpit;
  END;

END;

BEGIN                                (* This is real program of TW *)
  iport;
  ended := FALSE;
  IF NOT hangup THEN
    init;
  IF (NOT ended) AND (NOT hangup) THEN
    starting;
  WHILE (NOT ended) AND (NOT hangup) DO
    mainmenu;
  CLOSE(userf);
  CLOSE(msger);
  CLOSE(smg);
  ret := 200;
  return;
END.
