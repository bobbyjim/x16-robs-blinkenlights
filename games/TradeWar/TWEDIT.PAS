
PROGRAM twedit;

(**********************************
 *     TradeWars II/QP Editor     *
 *     Updated 9-26-87...by JC    *
 **********************************)

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
               doorpts              : real;
             END;

VAR 
    smg         : FILE OF smr;
    pnn         : STRING[41];
    y,a,mo,d,go,pn,pd,s2,st,g2,prr   : INTEGER;
    ay,tt,lp,ls,lt1,ll1 : INTEGER;
    userf       : FILE OF users;
    userr,usert : users;
    e           :  ARRAY[1..6] OF INTEGER;
    m,n,pub,c1,h : ARRAY[0..3] OF REAL;
    s           : ARRAY[0..200,0..1] OF INTEGER;
    srr         : ARRAY[0..3,0..1] OF REAL;
    g           : ARRAY[0..9,0..1]   OF INTEGER;
    ended,done  : BOOLEAN;
    aim         : STR;
    msger       : TEXT;

procedure Mmkey(var i:str);
  var c:char;
  begin
    repeat
      repeat
        getkey(c);
      until (((c>=' ') and (c<chr(127))) or (c=chr(13))) or hangup;
      c:=upcase(c);
      outkey(c);
      thisline:=thisline+c;
      if (c='/') or (c='1') then begin
        i:=c;
        repeat
          getkey(c);
        until ((c>=' ')and(c<=chr(127))) or (c=chr(13)) or (c=chr(8)) or hangup;
        c:=upcase(c);
        if c<>chr(13) then begin outkey(c); thisline:=thisline+c; end;
        if (c=chr(8)) or (c=chr(127)) then prompt(' '+c);
        if c='/' then input(i,20) else if c<>chr(13) then i:=i+c;
      end else i:=c;
    until (c<>chr(8)) and (c<>chr(127)) or hangup;
    nl;
  end;

FUNCTION sgn(i:INTEGER): INTEGER;
  BEGIN
    IF i>0
      THEN
        sgn := 1
      ELSE
        IF i<0
          THEN
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
  IF (y/4=INT(y/4)) AND (mo>2)
    THEN
      d := d+1;
  IF mo=2
    THEN
      d := d+31
    ELSE
      IF mo=3
        THEN
          d := d+59
        ELSE
          IF mo=4
            THEN
              d := d+90;
  IF mo=5
    THEN
      d := d+120
    ELSE
      IF mo=6
        THEN
          d := d+151
        ELSE
          IF mo=7
            THEN
              d := d+181;
  IF mo=8
    THEN
      d := d+212
    ELSE
      IF mo=9
        THEN
          d := d+243
        ELSE
          IF mo=10
            THEN
              d := d+273;
  IF mo=11
    THEN
      d := d+304
    ELSE
      IF mo=12
        THEN
          d := d+334;
  IF y<ay
    THEN
      y := y+100;
  IF y<>ay
    THEN
      FOR a:=ay TO y-1 
        DO
        BEGIN
          d := d+365;
          IF a/4=INT(a/4)
            THEN
              d := d+1;
        END;
END;


(*34110 REM **/ REMOVE SHIP P FROM PERSON-IN-SECTOR CHAIN /**)

PROCEDURE removeship(p:INTEGER);

  VAR
      r,b  : INTEGER;
      done : BOOLEAN;
BEGIN
  readin(p,usert);
  r := usert.ff;
  readin(lp+r,usert);
  a := usert.fi;
  IF a<>0
    THEN
      IF a=p
        THEN
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
              IF usert.fo = p
                THEN
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

(* 34230 REM **/ DELETE PLAYER P FROM GAME /**)

PROCEDURE DELETE(p: INTEGER);

  VAR
      l: INTEGER;
BEGIN
  readin(p,usert);
  print('Deleting '+usert.fa+'...');
  removeship(p);
  readin(p,usert);
  usert.fm := 0;
  writeout(p,usert);
  FOR l:=lp+1 TO ls DO
    BEGIN
      readin(l,usert);
      IF usert.fm=p
        THEN
          BEGIN
            usert.fm := 0;
            usert.fl := 0;
            writeout(l,usert);
          END;
    END;

(* DELETE MESSAGES TO HIM *)

  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      IF usert.fc=p
        THEN
          BEGIN
            usert.fc := -98;
            writeout(l,usert);
          END;
    END;
END;

(* 7500 REM **/ FIND SHORTEST ROUTE FROM A TO B IN S(200,1) /**)

PROCEDURE shortest(a,b: INTEGER);

  VAR
      n,c,l,m : INTEGER;
      found   : BOOLEAN;
BEGIN
  n := 1;
  c := b;
  IF a=b
    THEN
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
            IF s[l,1]=n
              THEN
                BEGIN
                  readin(l+lp,usert);
                  e[1] := usert.fb;
                  e[2] := usert.fc;
                  e[3] := usert.fd;
                  e[4] := usert.fe;
                  e[5] := usert.ff;
                  e[6] := usert.fg;
                  FOR m:=1 TO 6 DO
                    IF e[m]<>0
                      THEN
                        IF s[e[m],1]=0
                          THEN
                            BEGIN
                              s[e[m],1] := n+1;
                              s[e[m],0] := l;
                              IF e[m]=b
                                THEN
                                  found := TRUE;
                            END;
                END;
            l := l+1;
          UNTIL found OR (l>200);
          IF NOT found
            THEN
              n := n+1;
        UNTIL found OR (n=9999);
        IF NOT found
          THEN
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
              IF s[c,0]=0
                THEN
                  s[b,1] := 0;
            UNTIL s[c,0]=0;
      END;
END;


(*2500 RANK PLAYERS WITH FT$ AND FV$.  P = STARTING PERSON, 0=NO PLAYERS *)

PROCEDURE rank(VAR p: INTEGER);

  VAR 
      l,g0,h0,f0,n,o,j0,k0,l0,v,c : INTEGER;
      done                        : BOOLEAN;
BEGIN
  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      IF usert.fm=0
        THEN
          BEGIN
            usert.fv := -1;
            writeout(l,usert);
          END
        ELSE
          IF usert.fc<>0
            THEN
              BEGIN
                usert.fv := 0;
                writeout(l,usert);
              END
            ELSE
              BEGIN
                g0 := usert.fg;
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
      IF (usert.fl<>0) AND (usert.fm>=2)
        THEN
          BEGIN
            a := usert.fl;
            p := usert.fm;
            readin(p,usert);
            usert.fv := usert.fv+a*25;
            writeout(p,usert);
          END;
    END;
  p := 0;
  FOR l:=2 TO lp DO
    BEGIN
      readin(l,usert);
      v := usert.fv;
      IF v<>-1
        THEN
          BEGIN
            n := p;
            o := 0;
            done := FALSE;
            IF p=0
              THEN
                BEGIN
                  p := l;
                  usert.ft := -1;
                  writeout(l,usert);
                END
              ELSE
                REPEAT
                  readin(n,usert);
                  IF (v>usert.fv) AND (o=0)
                    THEN
                      BEGIN
                        readin(l,usert);
                        usert.ft := p;
                        writeout(l,usert);
                        p := l;
                        done := TRUE;
                      END
                    ELSE
                      IF v>usert.fv
                        THEN
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
                          IF usert.ft=-1
                            THEN
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


PROCEDURE addship(p:INTEGER);
(* 7000 **/ ADD SHIP P PERSON-IN-SECTOR CHAIN /**)

  VAR 
      r,b  : INTEGER;
      done : BOOLEAN;
BEGIN
  r := userr.ff;
  IF r<>0
    THEN
      BEGIN
        readin(lp+r,usert);
        b := usert.fi;
        usert.fi := p;
        writeout(lp+r,usert);
        userr.fo := b;
        writeout(pn,userr);
      END;
END;

PROCEDURE warped;

  VAR
      lee,l : INTEGER;
BEGIN
  prompt('Warp Lanes lead to: ');
  IF e[1]<>0
    THEN
      BEGIN
        prompt(cstr(e[1]));
        lee := 2;
      END
    ELSE
      IF e[2]<>0
        THEN
          BEGIN
            prompt(cstr(e[2]));
            lee := 3;
          END
        ELSE
          IF e[3]<>0
            THEN
              BEGIN
                prompt(cstr(e[3]));
                lee := 4;
              END
            ELSE
              IF e[4]<>0
                THEN
                  BEGIN
                    prompt(cstr(e[4]));
                    lee := 5;
                  END
                ELSE
                  IF e[5]<>0
                    THEN
                      BEGIN
                        prompt(cstr(e[5]));
                        lee := 6;
                      END
                    ELSE
                      lee := 7;
  FOR l:=lee TO 6 DO
    IF e[l]<>0
      THEN
        prompt(','+cstr(e[l]));
  nl;
END;

PROCEDURE init;

  VAR 
      l   : INTEGER;
      done : BOOLEAN;
BEGIN
  ASSIGN(userf,fs);
  ASSIGN(msger,'TWOPENG.DAT');
  RESET(msger);
  append(msger);
  ASSIGN(smg,'TWSMF.DAT');
  ended := FALSE;
  ASSIGN(userf,'TWDATA.DAT');
  RESET(userf);
  readin(1,userr);
  WITH userr DO
    BEGIN
      ay := fc;
      tt := fd;
      lp := fe;
      ls := ff;
      lt1 := fg;
      ll1 := fo;
    END;
  getdate;
END;


PROCEDURE showroom;
(**/ PRINT ROOM DESCRIPTION /**)

  VAR 
      l,lee : INTEGER;
BEGIN
  prr := userr.ff;
  s2 := prr+lp;
  nl;
  print('Sector: '+cstr(prr));
  readin(s2,usert);
  st := usert.fh;
  IF st<>0
    THEN
      BEGIN
        readin(st+ls,usert);
        print('Ports: '+usert.fa+', class '+cstr(usert.fb));
      END
    ELSE
      print('Ports: None');
  readin(s2,usert);
  a := usert.fo;
  IF a<>0
    THEN
      BEGIN
        readin(a+lt1,usert);
        print('Planet: '+usert.fa);
        readin(s2,usert);
      END;
  g2 := 0;
  prompt('Other Ships: ');
  a := usert.fi;
  IF a=0
    THEN
      print('None')
    ELSE
      BEGIN
        REPEAT
          readin(a,usert);
          IF a<>pn
            THEN
              BEGIN
                nl;
                prompt('   '+usert.fa+' with '+cstr(usert.fg)+' fighters');
                g2 := 1;
              END;
          a := usert.fo;
        UNTIL a=0;
        IF g2=0
          THEN
            print('None')
          ELSE
            nl;
      END;
  readin(s2,usert);
  prompt('Fighters in sector: ');
  IF usert.fl=0
    THEN
      print('None')
    ELSE
      BEGIN
        aim := cstr(usert.fl);
        IF usert.fm<1
          THEN
            print(aim+' (Romulans)')
          ELSE
            IF usert.fm=pn
              THEN
                print(aim+' (yours)')
              ELSE
                BEGIN
                  readin(usert.fm,usert);
                  print(aim+' (belong to '+usert.fa+')');
                END;
      END;
  warped;
END;


PROCEDURE helpit;
BEGIN
  nl;
  print('<TWEditor Commands>');
  nl;
  print(' <C>  Cabal editor');
  print(' <D>  Daily Message editor');
  print(' <G>  General info editor');
  print(' <L>  List ports and planets');
  print(' <P>  Port editor');
  print(' <R>  Report on players');
  print(' <S>  Sector editor');
  print(' <T>  Planet editor');
  print(' <U>  User editor');
  print(' <Q>  Quit back to BBS');
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
  IF dim>=0
    THEN
      BEGIN
        IF dim>10
          THEN
            dim := 10.0;
        FOR l:=1 TO 3 DO
          BEGIN
            n[l] := n[l]+pub[l]*dim;
            IF n[l]>pub[l]*10
              THEN
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
  print('Commerce report for '+usert.fa+': '+date+' '+time);
  nl;
  print(' Items     Status   # units  in holds');
  print(' ~~~~~     ~~~~~~   ~~~~~~~  ~~~~~~~~');
  FOR i:=1 TO 3 DO
    BEGIN
      prompt(p[i]);
      IF c1[i]<0.0
        THEN
          prompt(' Buying  ')
        ELSE
          prompt(' Selling ');
      prompt(addblank(cstr(ni[i]),7));
      print (addblank(cstr(HI[i]),9));
    END;
END;

PROCEDURE port1;

  VAR
      mi : ARRAY[0..3] OF INTEGER;
BEGIN
  m[1] := 60 * SIN(0.89756 * d);
  m[2] := 8 * SIN(0.89714 * d + 1.5707);
  nl;
  m[1] := m[1]+500;
  m[2] := m[2]+100;
  mi[1] := ROUND(m[1]);
  mi[2] := ROUND(m[2]);
  print('Commerce report for Sol: '+date+' '+time);
  print('  Cargo holds: '+cstr(mi[1])+' credits/hold');
  print('  Fighters   : '+cstr(mi[2])+' credits/fighter');
  print('  Turns      : 300 credits each.');
  nl;
END;

PROCEDURE reportsec(s2:INTEGER);

  VAR
      i: STR;
      a,p: INTEGER;
BEGIN
  prompt('What sector is the port in? ');
  INPUT(i,3);
  IF i<>''
    THEN
      BEGIN
        a := value(i);
        IF (a<1) OR (a>ls-lp)
          THEN
            print('Valid sector numbers are from 1 to '+cstr(ls-lp)+'.')
          ELSE
            BEGIN
              readin(lp+a,usert);
              p := usert.fh;
              IF (p=0) OR ((usert.fl>0) AND (usert.fm<>pn))
                THEN
                  BEGIN
                    nl;
                    print('I have no information about that port.');
                  END
                ELSE
                  IF p<>1
                    THEN
                      BEGIN
                        upport(lp+a);
                        otherport(p+ls);
                      END
                    ELSE
                      port1;
            END;
      END;
END;

PROCEDURE rankings;

  VAR
      p,r        : INTEGER;
      abort,next : BOOLEAN;
BEGIN
  nl;
  print('Ranking players...');
  rank(p);
  cls;
  print('Player Report: '+date+' '+time);
  print('Rank  Value   Sec   Ftrs   Armr     $    Holds  Player');
  print('~~~~ ~~~~~~~ ~~~~~ ~~~~~~ ~~~~~~ ~~~~~~~ ~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  r := 1;
  abort := FALSE;
  REPEAT
    readin(p,usert);
    printacr(addblank(cstr(r),4)+addblank(cstr(usert.fv),7)+
      addblank(cstr(usert.ff),6)+addblank(cstr(usert.fg),7)+
      addblank(cstr(usert.fe),7)+addblank(cstr(usert.fl),8)+
      addblank(cstr(usert.fh),6)+'   '+usert.fa+' #'+cstr(p),abort,next);
    p := usert.ft;
    r := r+1;
  UNTIL abort OR (p=-1);
END;


PROCEDURE getuser(VAR p:INTEGER; a:STR);
(*19000 GET P, A USER NUMBER FROM A$, A GIVEN AN NAME OR NUMBER.  P=0 = NONE*)

VAR
    found : BOOLEAN;
BEGIN
  found := FALSE;
  p := 2;
  IF a='' THEN
      p := 0
  ELSE
      IF value(a) <> 0 THEN
          p := value(a)
      ELSE
        BEGIN
          REPEAT
            readin(p,usert);
            IF usert.fa = a THEN
              found := TRUE;
            p := p+1;
          UNTIL (p>lp) OR found;
          p := p-1;
          IF NOT found THEN
            BEGIN
              print('Not found.');
              p := 0;
            END;
        END;
END;

PROCEDURE getport(VAR p:INTEGER; a:STR);
(*19000 GET P, A USER NUMBER FROM A$, A GIVEN AN NAME OR NUMBER.  P=0 = NONE*)

VAR
    found : BOOLEAN;
BEGIN
  found := FALSE;
  p := ls+1;
  IF a=''
    THEN
      p := 0
    ELSE
      IF value(a) <> 0
        THEN
          p := value(a)
        ELSE
          BEGIN
            REPEAT
              readin(p,usert);
              IF usert.fa = a
                THEN
                  found := TRUE;
              p := p+1;
            UNTIL (p>lt1) OR found;
            p := p-1;
            IF NOT found
              THEN
                BEGIN
                  print('Not found.');
                  p := 0;
                END;
          END;
END;

PROCEDURE uedit;

 VAR
     i : STR;
     p,e : INTEGER;
BEGIN
  nl;
  prompt('User Name or Number: ');
  INPUT(i,41);
  IF (i='')
    THEN done := TRUE;
  getuser(p,i);
  pn := p;
  IF p<>0
    THEN
      IF (pn<2) OR (pn>lp)
        THEN
          BEGIN
            print('Invalid player name or number.');
          END
      ELSE
          BEGIN
            cls;
            readin(pn,usert);
            print('Complete record storage for player number: '+cstr(pn));
            nl;
            prompt('<A> Name: ');
            IF usert.fm=0
              THEN
                print('<Player record not used>')
              ELSE
                print(usert.fa+' (#'+cstr(pn)+')');
            prompt('<B> Last day on: ');
            getdate;
            e := usert.fb;
            d := d-e;
            IF d=0
              THEN
                print(' today')
              ELSE
                IF d>0
                  THEN
                    print(cstr(d)+' days ago')
                  ELSE
                    print(' Will be allowed on in '+cstr(-d)+' days');
            a := usert.fc;
            prompt('<C> Killed by: ');
            IF a=0
              THEN
                print('<No one>')
              ELSE
                IF a=-99
                  THEN
                    BEGIN
                      print('<To be initialized>') ;
                      a := 0;
                    END
                  ELSE
                    IF a=-98
                      THEN
                        BEGIN
                          print('<A person who has been deleted>') ;
                          a := 0;
                        END;
            IF a<>0 THEN
              IF a=-1 THEN
                print('<Romulans>')
              ELSE
                IF a=-2 THEN
                  print('<Rogue fighters>')
                ELSE
                  IF (a<2) OR (a>lp) THEN
                    print('Unknown value: '+cstr(a))
                  ELSE
                    BEGIN
                      readin(a,userr);
                      print(userr.fa+' (#'+cstr(a)+')');
                    END;
            print('<D> Turns left: '+cstr(usert.fd));
            print('<E> Ship Armor: '+cstr(usert.fe));
            print('<F> K3-A Fighters: '+cstr(usert.fg));
            print('<G> Total cargo holds: '+cstr(usert.fh));
            print('  <H> Ore: '+cstr(usert.fi)+'   <I> Org: '+cstr(usert.fj)+
                 '   <J> Eqp: '+cstr(usert.fk));
            print('<K> Credits: '+cstr(usert.fl));
            print('<L> Last sector in: '+cstr(usert.fq));
            print('<M> Location: sector '+cstr(usert.ff));
            print('<O> Next Ship-in-sector chain value: '+cstr(usert.fo));
            print('??? USERT.FP: '+cstr(usert.fp));
            print('??? Player #(duh...): '+cstr(usert.fr));
            print('<Q> Return to Main Menu ');
            print('<!> Delete player ');
            print('<?> Print Command List ');
            nl;
            prompt('Command? ');
            INPUT(i,1);
            IF i=''
              THEN
                BEGIN
                END;
            IF i='?'
              THEN
                BEGIN
                END;
            IF i='A'
              THEN
                BEGIN
                  nl;
                  prompt('New name? ');
                  INPUT(i,41);
                  usert.fa := i;
                  usert.fm := LENGTH(usert.fa);
                  writeout(pn,usert);
                END;
            IF i='B'
              THEN
                BEGIN
                  nl;
                  prompt('Last Day On? ');
                  INPUT(i,3);
                  a := value(i);
                  getdate;
                  usert.fb := d-a;
                  writeout(pn,usert);
                END;
            IF i='C'
              THEN
                BEGIN
                  nl;
                  prompt('Killed by?  (-98 killer deleted, -99 TBInit) ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fc := a;
                  writeout(pn,usert);
                END;
            IF i='D'
              THEN
                BEGIN
                  nl;
                  prompt('Turns Left? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fd := a;
                  writeout(pn,usert);
                END;
            IF i='E' THEN
                begin
                  nl;
                  prompt('Ship armor? ');
                  input(i,3);
                  a := value(i);
                  if a > 200 then
                    print('Ship structure will not support more than 200.')
                  else
                    usert.fe := a;
                  writeout(pn,usert);
                END;
            IF i='F' THEN
                BEGIN
                  nl;
                  prompt('K3-A Fighters on board? ');
                  INPUT(i,4);
                  a := value(i);
                  usert.fg := a;
                  writeout(pn,usert);
                END;
            IF i='G' THEN
                BEGIN
                  nl;
                  prompt('Cargo holds? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fh := a;
                  writeout(pn,usert);
                  IF usert.fi+usert.fj+usert.fk > usert.fh
                    THEN
                      print('*** Warning *** Amount of cargo in holds '+
                            'is greater than to total cargo holds.');
                END;
            IF i='H'
              THEN
                BEGIN
                  nl;
                  prompt('Ore? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fi := a;
                  writeout(pn,usert);
                END;
            IF i='I'
              THEN
                BEGIN
                  nl;
                  prompt('Organics? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fj := a;
                  writeout(pn,usert);
                END;
            IF i='J'
              THEN
                BEGIN
                  nl;
                  prompt('Equipment? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fk := a;
                  writeout(pn,usert);
                END;
            IF i='K'
              THEN
                BEGIN
                  nl;
                  prompt('Credits? ');
                  INPUT(i,5);
                  a := value(i);
                  usert.fl := a;
                  writeout(pn,usert);
                END;
            IF i='L' THEN
                BEGIN
                  nl;
                  prompt('Last sector in? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.fq := a;
                  writeout(pn,usert);
                END;
            IF i='M'
              THEN
                BEGIN
                  nl;
                  prompt('Location? ');
                  INPUT(i,3);
                  a := value(i);
                  usert.ff := a;
                  writeout(pn,usert);
                END;
            IF i='O' THEN
                begin
                  nl;
                  prompt('Next ship in sector chain value? ');
                  input(i,3);
                  a := value(i);
                  usert.fo := a;
                  writeout(pn,usert);
                END;
            IF i='!'
              THEN
                DELETE(pn);
            IF i='Q'
              THEN
                done := TRUE;
          END;
END;

PROCEDURE cabal;

VAR
    r,b,go,l,m : INTEGER;
    im         : STR;
BEGIN
  FOR l:=1 TO 9 DO
    BEGIN
      readin(l+lp,usert);
      g[l,0] := usert.ft;
      g[l,1] := 0;
    END;
  FOR l:=1 TO 8 DO
    FOR m:=l+1 TO 9 DO
      IF g[l,0]=g[m,0]
        THEN
          g[m,0] := 0;
  go := 0;
  FOR l:=1 TO 9 DO
    IF g[l,0]<>0
      THEN
        BEGIN
          readin(g[l,0]+lp,usert);
          IF usert.fm=-1
            THEN
              g[l,1] := usert.fl;
        END;
  FOR l:=1 TO 9 DO
    BEGIN
      readin(l+lp,usert);
      usert.ft := g[l,0];
      writeout(l+lp,usert);
    END;
  nl;
  print('Group Location Size Goal Type');
  print('~~~~~ ~~~~~~~~ ~~~~ ~~~~ ~~~~');
  FOR b:=1 TO 9 DO
    BEGIN
      STR(b,im);
      prompt(addblank(im,5));
      readin(lp+b,usert);
      r := usert.ft;
      IF r=0
        THEN
          print('   <Does not exist>')
        ELSE
          BEGIN
            go := usert.fq;
            readin(lp+r,usert);
            STR(r,im);
            prompt(addblank(im,9));
            IF usert.fm<>-1
              THEN
                prompt(addblank('0',5))
              ELSE
                BEGIN;
                  STR(usert.fl,im);
                  prompt(addblank(im,5));
                END;
            IF go<>0
              THEN
                BEGIN
                  STR(go,im);
                  prompt(addblank(im,5));
                END
              ELSE
                prompt('     ');
            IF b<3
              THEN
                print(' Defense')
              ELSE
                IF b<6
                  THEN
                    print(' Wandering')
                  ELSE
                    IF b<9
                      THEN
                        print(' Attack')
                      ELSE
                        print(' Attack top player');
          END;
    END;
END;

PROCEDURE gedit;

  VAR
      a: INTEGER;
      i: STR;
BEGIN
  readin(1,usert);
  cls;
  print('Complete record storage for TW game stats');
  nl;
  print('     usert.fa: '+usert.fa+'    usert.fe: '+cstr(usert.fe));
  print('     usert.fb: '+cstr(usert.fb)+'    usert.ff: '+cstr(usert.ff));
  print('     usert.fc: '+cstr(usert.fc)+'    usert.fg: '+cstr(usert.fg));
  print(' <B> Turns per day: '+cstr(usert.fd));
  print(' <C> Initial fighters: '+cstr(usert.fh));
  print(' <D> Initial credits: '+cstr(usert.fi));
  print(' <E> Initial cargo holds: '+cstr(usert.fj));
  print(' <F> Days until an inactive player is deleted: '+cstr(usert.fk));
  prompt(' <G> Last day maintence run: ');
  getdate;
  a := usert.fl;
  IF d=a
    THEN
      print('Today')
    ELSE
      IF d-1=a
        THEN
          print('Yesterday')
        ELSE
          print(cstr(d-a)+' days ago');
  print('     usert.fm: '+cstr(usert.fm)+'    usert.fo: '+cstr(usert.fo));
  print('     usert.fp: '+cstr(usert.fp)+'    usert.fq: '+cstr(usert.fq));
  print(' <H> Cabal regeneration: '+cstr(usert.fr)+' ftrs/day');
  print('     usert.ft: '+cstr(usert.ft)+'    usert.fv: '+cstr(usert.fv));
  print('     Maximum number of players: '+cstr(lp-1));
  print('     Fixed number of sectors: '+cstr(ls-lp));
  print('     Fixed number of ports: '+cstr(lt1-ls));
  nl;
  prompt('General editor command (?=help)? ');
  INPUT(i,1);
  IF (i='') OR (i='Q') OR (i=' ')
    THEN
      done := TRUE;
  IF i='B'
    THEN
      BEGIN
        prompt('Turns/day? ');
        INPUT(i,2);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fd := a;
              writeout(1,usert);
              IF a<1
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Must be > 0');
                  END;
            END;
      END;
  IF i='C'
    THEN
      BEGIN
        prompt('# of ftrs? ');
        INPUT(i,4);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fh := a;
              writeout(1,usert);
              IF a<1
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Must be > 0');
                  END;
            END;
      END;
  IF i='D'
    THEN
      BEGIN
        prompt('# of credits? ');
        INPUT(i,5);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fi := a;
              writeout(1,usert);
              IF a<1
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Must be > 0');
                  END;
            END;
      END;
  IF i='E'
    THEN
      BEGIN
        prompt('# of holds? ');
        INPUT(i,2);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fj := a;
              writeout(1,usert);
              IF (a<1) OR (a>50)
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Range 0..50');
                  END;
            END;
      END;
  IF i='F'
    THEN
      BEGIN
        prompt('Days until deleted? ');
        INPUT(i,2);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fk := a;
              writeout(1,usert);
              IF (a<1)
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Must be > 0');
                  END;
            END;
      END;
  IF i='G'
    THEN
      BEGIN
        print('0=Today, 1=Yesterday, -4=won''t be run for another 4 days');
        prompt('Last Day Maintence run? ');
        INPUT(i,2);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              getdate;
              usert.fl := d-a;
              writeout(1,usert);
            END;
      END;
  IF i='H'
    THEN
      BEGIN
        prompt('Romulan fighter regeneration? ');
        INPUT(i,3);
        IF i<>''
          THEN
            BEGIN
              a := value(i);
              usert.fr := a;
              writeout(1,usert);
              IF (a<1)
                THEN
                  BEGIN
                    nl;
                    print('*** Warning ***  Must be > 0');
                  END;
            END;
      END;
END;

PROCEDURE sected;

  VAR
      i   : STR;
      a,b : INTEGER;
BEGIN
  NL;
  PRINT('Sector Editor');
  NL;
  PROMPT('What sector do you want displayed? ');
  INPUT(i,3);
  if i<>'' then
    BEGIN
    a:=value(i);
    IF (a>0) AND (a<(ls-lp)+1) THEN
      BEGIN
      a:=a+lp;
      readin(a,usert);
      cls;
      PRINT('Complete record storage for Sector #'+cstr(a-lp));
      nl;
      PRINT(' <A> Exit #1 : '+cstr(usert.fb));
      PRINT(' <B> Exit #2 : '+cstr(usert.fc));
      PRINT(' <C> Exit #3 : '+cstr(usert.fd));
      PRINT(' <D> Exit #4 : '+cstr(usert.fe));
      PRINT(' <E> Exit #5 : '+cstr(usert.ff));
      PRINT(' <F> Exit #6 : '+cstr(usert.fg));
      IF usert.fh <= 0 THEN
        Begin
          PRINT('     No port in this sector.')
        End
      ELSE
        Begin
          prompt(' <G> Port #'+cstr(usert.fh));
          Readin(ls+usert.fh,usert);
          print(', Port Name: '+usert.fa+', Port Type: '+cstr(usert.fb));
          Readin(a,usert);
        End;
      PRINT('     Last ship to enter sector: '+cstr(usert.fi));
      PRINT(' <H> Fighters in sector: '+cstr(usert.fl));
      If ((usert.fl > 0) AND (usert.fm < 0)) Then
        IF usert.fm = -2 THEN
          PRINT(' <I> Rogue mercenaries')
        ELSE
          print(' <I> Owned by the Romulan Empire');
      IF ((usert.fl > 0) AND (usert.fm > 0) ) THEN
        BEGIN
          Readin(usert.fm,usert);
          PROMPT(' <I> Owned by: '+usert.fa);
          Readin(a,usert);
          PRINT(' #'+cstr(usert.fm));
        END;
      IF usert.fo = 0 THEN
        PRINT(' <J> No planet in this sector')
      ELSE
        Begin
          PROMPT(' <J> Planet #'+cstr(usert.fo));
          Readin(lt1+usert.fo,usert);
          print(', Name: '+usert.fa);
          Readin(a,usert);
        End;
      IF (a-lp)<10 THEN
        BEGIN
          PRINT('* Romulan Stats of Unknown Origin *');
          PRINT('     Usert.fp: '+cstr(usert.fp));
        END
      ELSE
        PRINT(' <K> Number of mines in sector: '+cstr(usert.fp));
      PRINT('     Usert.fq: '+cstr(usert.fq));
      PRINT('     Usert.fr: '+cstr(usert.fr));
      PRINT('     Usert.ft: '+cstr(usert.ft));
      PRINT('     Usert.fv: '+cstr(usert.fv));
      END
    ELSE
      PRINT('Sectors are numbered 1 to '+cstr(ls-lp));
    END
  ELSE
    DONE:=TRUE;
  nl;
  PROMPT('Sector editor command: ');
  mmkey(i);
  if length(i)=1 then case i[1] of

       'A' : BEGIN
               PRINT('Exit #1 currently points to: '+cstr(usert.fb)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.fb:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                   (* Modified stats saved in record a, sector a-lp*)
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'B' : BEGIN
               PRINT('Exit #2 currently points to: '+cstr(usert.fc)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.fc:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'C' : BEGIN
               PRINT('Exit #3 currently points to: '+cstr(usert.fd)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.fd:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'D' : BEGIN
               PRINT('Exit #4 currently points to: '+cstr(usert.fe)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.fe:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'E' : BEGIN
               PRINT('Exit #5 currently points to: '+cstr(usert.ff)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.ff:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'F' : BEGIN
               PRINT('Exit #6 currently points to: '+cstr(usert.fg)+'.');
               PROMPT('Where should it point to? (0 = No Exit) ');
               INPUT(i,3);
               b:=value(i);
               IF (b>=0) AND (b < (ls-lp)) THEN
                 BEGIN
                   usert.fg:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid sector-try again');
             END;

       'G' : BEGIN
               PRINT('Port # is currently: '+cstr(usert.fh)+'.');
               PROMPT('Enter desired port #: ');
               INPUT(i,2);
               b:=value(i);
               IF (b>=0) AND (b < (lt1-ls+1)) THEN
                 BEGIN
                   usert.fh:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid port # ');
             END;

       'H' : BEGIN
               PRINT('There are currently '+cstr(usert.fl)+
                     ' fighters in this sector.');
               PROMPT('Enter new number of fighters: ');
               INPUT(i,4);
               b:=value(i);
               IF (b>=0) AND (b<=9999) THEN
                 BEGIN
                   usert.fl:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid # of fighters ');
             END;

       'I' : BEGIN
               PRINT('The fighters here are owned by player'+
                     ' number: '+cstr(usert.fm)+'.');
               PROMPT('Enter player number of new owner: ');
               INPUT(i,3);
               b:=value(i);
               IF (b=-1) OR (b=-2) OR ((b>=1) AND (b<=lp)) THEN
                 BEGIN
                   usert.fm:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid player number ');
             END;

       'J' : BEGIN
               PRINT('The planet in this sector is: '+cstr(usert.fo)+'.');
               PROMPT('New planet number: ');
               INPUT(i,2);
               b:=value(i);
               IF (b>=0) THEN
                 BEGIN
                   usert.fo:=b;
                   writeout(a,usert);
                   print(' Modified stats saved');
                 END
               ELSE PRINT('Invalid planet number ');
             END;
       'K' : BEGIN
               IF (a-lp) < 10 THEN
                 PRINT('The Imperial navy will not allow mines here.')
               ELSE
                 BEGIN
                   PRINT('The number of mines in this sector is: '+cstr(usert.fp)+'.');
                   PROMPT('Number of mines in sector: ');
                   INPUT(i,2);
                   b:=value(i);
                   IF (b>=0) AND (b<=20) THEN
                     BEGIN
                       usert.fp:=b;
                       writeout(a,usert);
                       print(' Modified stats saved');
                     END
                   ELSE PRINT('Invalid number of mines!');
                 END;
             END;

       'Q' : done:=true;
  END;
END;


PROCEDURE ported;

  VAR
        i : STR;
      a,b : INTEGER;
BEGIN
  NL;
  PRINT('Port Editor');
  NL;
  PROMPT('What port do you want displayed? ');
  INPUT(i,3);
  if i<>'' then
    BEGIN
    a:=value(i);
    IF (a>0) AND (a<(lt1-ls)) THEN
      BEGIN
      a:=a+ls;
      readin(a,usert);
      cls;
      PRINT('Complete record storage for Port #'+cstr(a-ls));
      nl;
      PRINT(' <A> Port name: '+usert.fa+', Port type: '+cstr(usert.fb));
      PRINT('     Usert.fc: '+cstr(usert.fc));
      PRINT(' <B> Ore to trade: '+cstr(usert.fd));
      PRINT(' <C> Organics to trade: '+cstr(usert.fe));
      PRINT(' <D> Equipment to trade: '+cstr(usert.ff));
      PRINT('     Usert.fg: '+cstr(usert.fg)+
      '     Usert.fh: '+cstr(usert.fh));
      PRINT('     Usert.fi: '+cstr(usert.fi)+
      '     Usert.fj: '+cstr(usert.fj));
      PRINT('     Usert.fk: '+cstr(usert.fk)+
      '     Usert.fl: '+cstr(usert.fl));
      PRINT('     Usert.fm: '+cstr(usert.fm)+
      '     Usert.fo: '+cstr(usert.fo));
      PRINT('     Usert.fp: '+cstr(usert.fp)+
      '     Usert.fq: '+cstr(usert.fq));
      PRINT('     Usert.fr: '+cstr(usert.fr)+
      '     Usert.ft: '+cstr(usert.ft));
      PRINT('     Usert.fv: '+cstr(usert.fv));
      END
    ELSE
      PRINT('Ports are numbered 1 to '+cstr(lt1-ls)+'.');
    END
  ELSE
    DONE:=TRUE;
END;

Procedure Planeted;

var
      i : str;
    a,b : integer;

Begin
  nl;
  print('(Planet Editor)');
  nl;
  prompt('Which planet do you want displayed? ');
  input(i,2);
  IF i<>'' THEN
    Begin
    a:=value(i);
    if (a>0) AND (a<=50) THEN
      Begin
        a:= a+lt1;
        Readin(a,usert);
        cls;
        print('Complete record storage for Planet #'+cstr(a-lt1));
        nl;
        print(' <A> Planet Name: '+usert.fa);
        print('     usert.fb: '+cstr(usert.fb));
        print('     usert.fc: '+cstr(usert.fc));
        print('     usert.fd: '+cstr(usert.fd));
        print('     usert.fe: '+cstr(usert.fe));
        print(' <B> Ore on surface: '+cstr(usert.ff));
        print(' <C> Org on surface: '+cstr(usert.fg));
        print(' <D> Eqp on surface: '+cstr(usert.fh));
        print('     usert.fi: '+cstr(usert.fi)+
        '     usert.fj: '+cstr(usert.fj));
        print('     usert.fk: '+cstr(usert.fk)+
        '     usert.fl: '+cstr(usert.fl));
        print('     Length of name: '+cstr(usert.fm));
        print('     usert.fo: '+cstr(usert.fo)+
        '     usert.fp: '+cstr(usert.fp));
        print('     usert.fq: '+cstr(usert.fq)+
        '     usert.fr: '+cstr(usert.fr));
        print('     usert.ft: '+cstr(usert.ft)+
        '     usert.fv: '+cstr(usert.fv));
      END
    Else
        begin
          nl;
          print('Sorry, Charlie, but planets are numbered 1-50.');
        end;
    End
  Else
    Done := TRUE;
End;


PROCEDURE mainmenu;

  VAR
      i: STR;
      INT : INTEGER;
                                     (* 22000 *)
BEGIN
  dump;
  tleft;
  nl;
  prompt('TWEditor Command: ');
  mmkey(i);
  If length(i)=1 then
      CASE i[1] OF
        'C' : Cabal;                 (* Romulan Cabal report *)

        'D' : Begin                  (* Daily Message Editor *)
                print(' ** This shouldn''t be too much trouble to do **');
              End;

        'G' : BEGIN                  (* General Game editor *)
                done := FALSE;
                REPEAT
                  gedit
                UNTIL done or hangup;
              END;

        'L' : Begin                  (* List Ports and Planets *)
                Print(' ** This will produce a list of Port and Planet');
                print('    numbers and their corresponding names and');
                print('    current locations. **');
              End;

        'P' : BEGIN                  (* Port editor *)
                done := FALSE;
                REPEAT
                  ported
                UNTIL done or hangup;
              END;

        'R' : RANKINGS;

        'S' : BEGIN                  (* Sector editor *)
                done := FALSE;
                REPEAT
                  sected
                UNTIL done or hangup;
              END;

        'T' : Begin                  (* Planet Editor *)
                done := false;
                Repeat
                  planeted
                until done or hangup;
              End;

        'U' : BEGIN                  (* User editor *)
                done := FALSE;
                REPEAT
                  uedit
                UNTIL done or hangup;
              END;

        'Q' : ended := TRUE;         (* Quits to BBS *)

        '?' : helpit;                (* Command List *)

        ' ' : helpit;

        else
          Begin
            helpit;
          End;

      END;
  END;

BEGIN
  iport;
  ended := FALSE;
  IF NOT hangup
    THEN
      init;
  WHILE (NOT ended) AND (NOT hangup) DO
    mainmenu;
  CLOSE(userf);
  CLOSE(msger);
  CLOSE(smg);
  ret := 200;
  return;
END.
