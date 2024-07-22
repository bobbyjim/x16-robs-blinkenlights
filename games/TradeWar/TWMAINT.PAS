(*********************************
 *        TradeWars II/QP        *
 *   Daily Maintinance Program   *
 *     Last modified 9/25/87     *
 *********************************)

OVERLAY PROCEDURE cattack(go,p,f:INTEGER);

  VAR 
      r,k,c13,r13,v,n,pn : INTEGER;
BEGIN
  IF f>g[go,1] THEN
    f := g[go,1];
  IF (p>=1) AND (p<=lp) THEN
      BEGIN
        c13 := g[go,0]+lp;
        readin(c13,usert);
        IF (usert.fm=1) AND (f>=1) THEN
          BEGIN
            readin(p,usert);
            IF usert.ff=c13-lp THEN
              BEGIN
                r := 0;
                k := 0;
                REPEAT
                  picksec(v);
                  IF v=1 THEN
                    r := r+1
                  ELSE
                    k := k+1;
                UNTIL (r>usert.fg) OR (k>=f);
                g[go,1] := g[go,1]-k;
                readin(c13,usert);
                usert.fl := g[go,1];
                writeout(c13,usert);
                IF g[go,1]<1 THEN
                  BEGIN
                    usert.fm := 0;
                    usert.fl := 0;
                    writeout(c13,usert);
                    g[go,0] := 0;
                    g[go,1] := 0;
                  END;
                readin(p,usert);
                f := usert.fg-r;
                n := r;
                r13 := r;
                pn := -1;
                message(p,pn,n,0);
                IF f>0 THEN
                  BEGIN
                    readin(p,usert);
                    usert.fg := f;
                    writeout(p,usert);
                  END
                ELSE
                  killed(pn,p);
                readin(p,usert);
                IF g[go,0]=0 THEN
                  sysoplog(usert.fa+': lost '+cstr(k)+
                    ', dstrd '+cstr(r13)+' (Roms wiped out)')
                ELSE
                  IF usert.fc=-1 THEN
                      sysoplog(usert.fa+': lost '+cstr(k)+
                        ', dstrd '+cstr(r13)+' (Player destroyed)');
              END;
          END;
      END;
END;

OVERLAY PROCEDURE movecabal(go,a,b:INTEGER);

(*35090/ MOVE GROUP CABAL (GROUP G) FROM SECTOR A TO SECTOR B (NEXT TO EACH OTHER)*)

  VAR
      n,p,v,k,l: INTEGER;
BEGIN
  IF (a>=1) AND (b>=1) AND (a<=ls-lp) AND (b<=ls-lp) AND (a<>b) THEN
      BEGIN
        n := g[go,1];
        readin(a+lp,usert);
        IF usert.fm<>-1 THEN
            BEGIN
              g[go,0] := 0;
              g[go,1] := 0;
            END
        ELSE
            BEGIN
              IF usert.fl<=n THEN
                BEGIN
                  n := usert.fl;
                  g[go,1] := n;
                  usert.fl := 0;
                  usert.fm := 0;
                  writeout(a+lp,usert);
                END
              ELSE
                IF usert.fl>n THEN
                  BEGIN
                    usert.fl := usert.fl-n;
                    writeout(a+lp,usert);
                  END;
              g[go,0] := b;
              readin(b+lp,usert);
              IF usert.fl=0 THEN
                  BEGIN
                    usert.fl := n;
                    usert.fm := -1;
                    writeout(b+lp,usert);
                  END
              ELSE
                BEGIN
                  p := usert.fm;
                  IF p=-1 THEN
                    BEGIN
                      usert.fl := usert.fl+n;
                      writeout(b+lp,usert);
                    END
                  ELSE
                    BEGIN
                      l := 0;
                      k := 0;
                      REPEAT
                        v := RANDOM(2)+1;
                        IF v=1 THEN
                          l := l+1
                        ELSE
                          k := k+1;
                      UNTIL (l>=usert.fl) OR (k>=g[go,1]);
                      readin(p,userr);
                      message(p,-1,l,0);
                      IF l<usert.fl THEN
                        BEGIN
                          g[go,0] := 0;
                          g[go,1] := 0;
                          usert.fl := usert.fl-l;
                          writeout(b+lp,usert);
                          sysoplog('      Group '+cstr(go)+' --> Sector'
                               +cstr(b)+'('+userr.fa+'):');
                          sysoplog(' lost '+cstr(k)+
                               ', dstrd '+cstr(l)+' (Rom ftrs lose battle)');
                        END
                      ELSE
                        BEGIN
                          usert.fl := n-k;
                          usert.fm := -1;
                          writeout(b+lp,usert);
                          n := n-k;
                          g[go,1] := n;
                          sysoplog('      Group '+cstr(go)+' --> Sector'
                               +cstr(b)+'('+userr.fa+'):');
                          sysoplog(' lost'+cstr(k)+
                               ', dstrd'+cstr(l)+' (Player ftrs lose battle)');
                        END;
                    END;
                END;
            END;
      END;
END;

overlay PROCEDURE maint;

VAR
    i,p,l,m,a,l2,e1,v,s1,r,go,b1,g1,sc1,t1 : INTEGER;
    done,done1       : BOOLEAN;
    x                : smr;
    smg2             : FILE OF smr;
BEGIN
  ansic(5);
  print('You''re the first player today!');
  nl;
  nl;
  ansic(2);
  print('TradeWars II/QP Daily Maintence program');
  nl;
  sysoplog(time+' '+date+':  TW Maintence program ran');
  readin(1,usert);
  l2 := usert.fk;
  nl;
  ansic(5);
  print('Now...''Removing'' inactive players');
  ansic(1);
  getdate;
  l2 := d-l2;
  FOR p:=2 TO lp DO
    BEGIN
      readin(p,usert);
      IF usert.fb<=l2 THEN
        IF (usert.fc<>0) AND (usert.fm>0) THEN
          BEGIN
            DELETE(p);
            sysoplog('  - '+usert.fa+' deleted from game');
          END;
    END;

  ASSIGN(smg2,'twsmf2.dat');
  REWRITE(smg2);
  (*$I-*)
  RESET(smg); (*$I+*)
  IF IORESULT=0 THEN
    BEGIN
      i := 0;
      IF i<=FILESIZE(smg)-1 THEN
        BEGIN
          SEEK(smg,i);
          READ(smg,x);
        END;
      WHILE (i<FILESIZE(smg)-1) DO
        BEGIN
          IF x.destin<>-1 THEN
            WRITE(smg2,x);
          i := i+1;
          SEEK(smg,i);
          READ(smg,x);
        END;
      IF x.destin<>-1 THEN
        WRITE(smg2,x);
      CLOSE(smg);
    END;
  CLOSE(smg2);
  ERASE(smg);
  RENAME(smg2,'twsmf.dat');

  nl;
  ansic(8);
  print('Romulans advance across the Disputed Zone... ');
  ansic(1);
  sysoplog('   Romulan report:');
  FOR l:=1 TO 9 DO
    BEGIN
      readin(l+lp,usert);
      g[l,0] := usert.ft;
      g[l,1] := 0;
    END;
  FOR l:=1 TO 8 DO
    FOR m:=l+1 TO 9 DO
      IF g[l,0]=g[m,0] THEN
        g[m,0] := 0;
  go := 0;
  FOR l:=1 TO 9 DO
    IF g[l,0]<>0 THEN                (* IF LOCATION <> 0 *)
      BEGIN
        readin(g[l,0]+lp,usert);     (* READ IN SECTOR OF GROUP *)
        IF usert.fm=-1 THEN          (* IF CABAL FIGHTERS *)
          BEGIN
            go := go+usert.fl;
            g[l,1] := usert.fl;
          END;
        (*  GO:+GO+# OF FIGHTERS. G(GROUP,1)=# OF FIGHTERS *)
      END;
  readin(1,usert);
  r := usert.fr;
  IF go<2000-r THEN
    e1 := r
  ELSE
    BEGIN
      e1 := 2000-go;
      IF e1<0 THEN
        e1 := 0;
    END;                             (* FIND HOW MANY TO ADD. *)
  movecabal(2,83,85);                (* 'MOVE GROUP 2 TO SECTOR 85'*)
  readin(85+lp,usert);
  IF usert.fm<>-1 THEN
    BEGIN
      g[1,1] := 1000;
      usert.fm := -1;
      usert.fl := 1000;
      writeout(85+lp,usert);
    END;
  a := usert.fl;
  usert.fl := usert.fl+e1;
  writeout(85+lp,usert);
  s1 := g[1,1]+g[2,1]+e1;
  IF s1<1500 THEN
    e1 := 1
  ELSE
    e1 := 0;
  IF s1<1000 THEN
    BEGIN
      g[1,1] := s1;
      g[2,0] := 0;
      g[2,1] := 0;
    END
  ELSE
    BEGIN
      g[1,1] := 1000;
      g[2,1] := s1-1000;
      g[2,0] := 85;
    END;
  movecabal(2,85,83);                (* ' MOVE GROUP 2 TO SECTOR 83 *)
  FOR g1:=3 TO 5  DO                 (* ' MOVE GROUP TYPE II FIGHTERS *)
    BEGIN
      WRITELN(g1);
      done := FALSE;
      done1 := FALSE;
      REPEAT
        IF ((g[g1,1]<>0) AND (g[g1,0]<>0)) OR done1 THEN
            BEGIN
              done := TRUE;
              REPEAT
                readin(g1+lp,usert);
                IF (g[g1,0]=usert.fq) OR (usert.fq=0) THEN
                  BEGIN
                    picksec(v);
                    usert.fq := v;
                    writeout(g1+lp,usert);
                  END;
              UNTIL (g[g1,0]<>usert.fq) AND (usert.fq<>0);
              IF (g[g1,1]<50) OR (g[g1,1]>100) THEN
                BEGIN
                  usert.fq := 83;
                  writeout(g1+lp,usert);
                END;
              IF e1=1 THEN
                BEGIN
                  usert.fq := 85;
                  writeout(g1+lp,usert);
                END;
              shortest(g[g1,0],usert.fq);
              IF s[g[g1,0],1]<>0 THEN
                  movecabal(g1,g[g1,0],s[g[g1,0],1]);
                                     (*' Move 1 step toward goal*)
            END
          ELSE
            IF g[2,1]>=600 THEN
              BEGIN
                g[g1,1] := 100;
                g[2,1] := g[2,1]-100;
                done1 := TRUE;
                g[g1,0] := 83;       (* ' Create a group II group*)
              END
            ELSE done := TRUE;
      UNTIL ((g[g1,0]<=0) OR (g[g1,0]>=8) OR (g[g1,1]=0)) AND done;
    END;
  rank(p);
  IF p<1 THEN
    BEGIN
      sc1 := 0;
      t1 := 0;
    END
  ELSE
    BEGIN
      t1 := p;
      readin(t1,usert);
      sc1 := usert.ff;
       IF usert.fv<2500 THEN
         BEGIN
           sc1 := 0;
           t1 := 0;
         END;
    END;
  IF (sc1=0) OR (t1=0) THEN
    BEGIN
      sc1 := 83;
      t1 := 0;
    END;

  FOR g1:=6 TO 9  DO                 (* ' Move group type III fighters *)
    BEGIN
      done := FALSE;
      done1 := FALSE;
      WRITELN(g1);
      WRITELN('Entering Repeat #1');
      REPEAT
        IF ((g[g1,1]<>0) AND (g[g1,0]<>0)) OR done THEN
          BEGIN
            IF g1 = 9 THEN
              b1 := sc1
            ELSE
              REPEAT                 (* This is where It hangs!?! *)
                WRITELN('Entering conditional Repeat #2');
                picksec(v);
                b1 := v;
              UNTIL (v<>g[g1,0]) AND (v>1);    (* This should stop hang...*)
            WRITELN('Left conditional Repeat #2');
            IF (g[g1,1]<20) OR (g[g1,1]>50) THEN
              b1 := 83;
            IF e1=1 THEN
              b1 := 85;
            shortest(g[g1,0],b1);
            done1 := FALSE;
            IF s[g[g1,0],1]<>0 THEN
              BEGIN
                REPEAT
                  IF (g[g1,1]<0) OR (g[g1,0]=0) THEN
                    BEGIN
                      g[g1,0] := 0;
                      g[g1,1] := 0;
                      done1 := TRUE;
                    END
                  ELSE
                    IF (g1<>9) OR (g[g1,0]<>sc1) THEN
                      BEGIN
                        movecabal(g1,g[g1,0],s[g[g1,0],1]);
                        IF (g[g1,1]<0) OR (g[g1,0]=0) THEN
                          BEGIN
                            g[g1,0] := 0;
                            g[g1,1] := 0;
                            done1 := TRUE;
                          END
                        ELSE
                          BEGIN
                            readin(g[g1,0]+lp,usert);
                            IF (g1<>9) AND (usert.fi<>0) THEN
                              BEGIN
                                p := usert.fi;
                                cattack(g1,p,20);
                              END;
                          END;
                      END;
                UNTIL (g[g1,0]=b1) OR done1;
                IF (t1<>0) AND (g1=9) AND (NOT done1) THEN
                  cattack(g1,t1,g[g1,1]);
                done1 := TRUE;
              END
              ELSE
                done1 := TRUE;
          END
        ELSE
          IF g[2,1]>=550 THEN
            BEGIN
              g[g1,1] := 50;
              g[2,1] := g[2,1]-50;
              g[g1,0] := 83;
              done := TRUE;
            END
          ELSE
            done1 := TRUE;
        IF (g[g1,0]>0) AND (g[g1,0]<8) AND (g[g1,1]<>0) THEN
          BEGIN
            s1 := 85;
            done := TRUE;
          END;
      UNTIL ((g[g1,0]<=0) OR (g[g1,0]>=8) OR (g[g1,1]=0)) AND done1;
    END;
  FOR l:=1 TO 9 DO
    BEGIN
      readin(lp+l,usert);
      usert.ft := g[l,0];
      writeout(lp+l,usert);
    END;
  readin(1,usert);
  usert.fl := d;
  writeout(1,usert);
END;
