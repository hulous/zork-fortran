C GDT- GAME DEBUGGING TOOL
C
C COPYRIGHT 1980, INFOCOM COMPUTERS AND COMMUNICATIONS, CAMBRIDGE MA. 02142
C ALL RIGHTS RESERVED, COMMERCIAL USAGE STRICTLY PROHIBITED
C WRITTEN BY R. M. SUPNIK
C
C DECLARATIONS
C
	SUBROUTINE GDT
	IMPLICIT INTEGER (A-Z)
	CHARACTER*2 DBGCMD(38),CMD
	INTEGER ARGTYP(38)
	LOGICAL VALID1,VALID2,VALID3
	character*2 ldbgcmd(38)
	include 'parser.h'
	include 'gamestat.h'
	include 'state.h'
	include 'screen.h'
	include 'puzzle.h'
C
C MISCELLANEOUS VARIABLES
C
	COMMON /STAR/ MBASE,STRBIT
	include 'io.h'
	include 'mindex.h'
	include 'debug.h'
	include 'rooms.h'
	include 'rindex.h'
	include 'exits.h'
	include 'objects.h'
	include 'oindex.h'
	include 'clock.h'
	include 'villians.h'
	include 'advers.h'
	include 'flags.h'
C
C FUNCTIONS AND DATA
C
	VALID1(A1,L1)=(A1.GT.0).AND.(A1.LE.L1)
	VALID2(A1,A2,L1)=VALID1(A1,L1).AND.VALID1(A2,L1).AND.
     &	(A1.LE.A2)
	VALID3(A1,L1,A2,L2)=VALID1(A1,L1).AND.VALID1(A2,L2)
	DATA CMDMAX/38/
	DATA DBGCMD/'DR','DO','DA','DC','DX','DH','DL','DV','DF','DS',
     &	'AF','HE','NR','NT','NC','ND','RR','RT','RC','RD',
     &	'TK','EX','AR','AO','AA','AC','AX','AV','D2','DN',
     &	'AN','DM','DT','AH','DP','PD','DZ','AZ'/
	DATA ldbgcmd/'dr','do','da','dc','dx','dh','dl','dv','df','ds',
     &	'af','he','nr','nt','nc','nd','rr','rt','rc','rd',
     &	'tk','ex','ar','ao','aa','ac','ax','av','d2','dn',
     &	'an','dm','dt','ah','dp','pd','dz','az'/
	DATA ARGTYP/  2 ,  2 ,  2 ,  2 ,  2 ,  0 ,  0 ,  2 ,  2 ,  0 ,
     &	  1 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,
     &	  1 ,  0 ,  3 ,  3 ,  3 ,  3 ,  1 ,  3 ,  2 ,  2 ,
     &	  1 ,  2 ,  1 ,  0 ,  0 ,  0 ,  0 ,  1 /
C GDT, PAGE 2
C
C FIRST, VALIDATE THAT THE CALLER IS AN IMPLEMENTER.
C
	FMAX=46
C						!SET ARRAY LIMITS.
	SMAX=22
C
	IF(GDTFLG.NE.0) GO TO 2000
C						!IF OK, SKIP.
	WRITE(OUTCH,100)
C						!NOT AN IMPLEMENTER.
	RETURN
C						!BOOT HIM OFF
C
100	FORMAT(' You are not an authorized user.')
c GDT, PAGE 2A
C
C HERE TO GET NEXT COMMAND
C
2000	WRITE(OUTCH,200)
C						!OUTPUT PROMPT.
	READ(INPCH,210) CMD
C						!GET COMMAND.
	IF(CMD.EQ.'  ') GO TO 2000
C						!IGNORE BLANKS.
	DO 2100 I=1,CMDMAX
C						!LOOK IT UP.
	  IF(CMD.EQ.DBGCMD(I)) GO TO 2300
C						!FOUND?
C	  check for lower case command, as well
	  if(cmd .eq. ldbgcmd(i)) go to 2300
2100	CONTINUE
2200	WRITE(OUTCH,220)
C						!NO, LOSE.
	GO TO 2000
C
200	FORMAT(' GDT>',$)
210	FORMAT(A2)
220	FORMAT(' ?')
230	FORMAT(2I6)
240	FORMAT(I6)
225	FORMAT(' Limits:   ',$)
235	FORMAT(' Entry:    ',$)
245	FORMAT(' Idx,Ary:  ',$)
c
2300	GO TO (2400,2500,2600,2700),ARGTYP(I)+1
C						!BRANCH ON ARG TYPE.
	GO TO 2200
C						!ILLEGAL TYPE.
C
2700	WRITE(OUTCH,245)
C						!TYPE 3, REQUEST ARRAY COORDS.
	READ(INPCH,230) J,K
	GO TO 2400
C
2600	WRITE(OUTCH,225)
C						!TYPE 2, READ BOUNDS.
	READ(INPCH,230) J,K
	IF(K.EQ.0) K=J
	GO TO 2400
C
2500	WRITE(OUTCH,235)
C						!TYPE 1, READ ENTRY NO.
	READ(INPCH,240) J
2400	GO TO (10000,11000,12000,13000,14000,15000,16000,17000,18000,
     & 19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,
     & 29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,
     & 39000,40000,41000,42000,43000,44000,45000,46000,47000),I
	GO TO 2200
C						!WHAT???
C GDT, PAGE 3
C
C DR-- DISPLAY ROOMS
C
10000	IF(.NOT.VALID2(J,K,RLNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,300)
C						!COL HDRS.
	DO 10100 I=J,K
	  WRITE(OUTCH,310) I,(EQR(I,L),L=1,5)
10100	CONTINUE
	GO TO 2000
C
300	FORMAT(' RM#  DESC1  EXITS ACTION  VALUE  FLAGS')
310	FORMAT(1X,I3,4(1X,I6),1X,I6)
C
C DO-- DISPLAY OBJECTS
C
11000	IF(.NOT.VALID2(J,K,OLNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,320)
C						!COL HDRS
	DO 11100 I=J,K
	  WRITE(OUTCH,330) I,(EQO(I,L),L=1,14)
11100	CONTINUE
	GO TO 2000
C
320	FORMAT(' OB# DESC1 DESC2 DESCO ACT FLAGS1 FLAGS2 FVL TVL
     &  SIZE CAPAC ROOM ADV CON  READ')
330	FORMAT(1X,I3,3I6,I4,2I7,2I4,2I6,1X,3I4,I6)
C
C DA-- DISPLAY ADVENTURERS
C
12000	IF(.NOT.VALID2(J,K,ALNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,340)
	DO 12100 I=J,K
	  WRITE(OUTCH,350) I,(EQA(I,L),L=1,7)
12100	CONTINUE
	GO TO 2000
C
340	FORMAT(' AD#   ROOM  SCORE  VEHIC OBJECT ACTION  STREN  FLAGS')
350	FORMAT(1X,I3,6(1X,I6),1X,I6)
C
C DC-- DISPLAY CLOCK EVENTS
C
13000	IF(.NOT.VALID2(J,K,CLNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,360)
	DO 13100 I=J,K
	  WRITE(OUTCH,370) I,(EQC(I,L),L=1,2),CFLAG(I)
13100	CONTINUE
	GO TO 2000
C
360	FORMAT(' CL#   TICK ACTION  FLAG')
370	FORMAT(1X,I3,1X,I6,1X,I6,5X,L1)
C
C DX-- DISPLAY EXITS
C
14000	IF(.NOT.VALID2(J,K,XLNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,380)
C						!COL HDRS.
	DO 14100 I=J,K,10
C						!TEN PER LINE.
	  L=MIN0(I+9,K)
C						!COMPUTE END OF LINE.
	  WRITE(OUTCH,390) I,L,(TRAVEL(L1),L1=I,L)
14100	CONTINUE
	GO TO 2000
C
380	FORMAT('   RANGE   CONTENTS')
390	FORMAT(1X,I3,'-',I3,3X,10I7)
C
C DH-- DISPLAY HACKS
C
15000	WRITE(OUTCH,400) THFPOS,THFFLG,THFACT,SWDACT,SWDSTA
	GO TO 2000
C
400	FORMAT(' THFPOS=',I6,', THFFLG=',L2,',THFACT=',L2/
     &' SWDACT=',L2,', SWDSTA=',I2)
C
C DL-- DISPLAY LENGTHS
C
16000	WRITE(OUTCH,410) RLNT,XLNT,OLNT,CLNT,VLNT,ALNT,MLNT,R2LNT,
     &	MBASE,STRBIT
	GO TO 2000
C
410	FORMAT(' R=',I6,', X=',I6,', O=',I6,', C=',I6/
     &' V=',I6,', A=',I6,', M=',I6,', R2=',I5/
     &' MBASE=',I6,', STRBIT=',I6)
C
C DV-- DISPLAY VILLAINS
C
17000	IF(.NOT.VALID2(J,K,VLNT)) GO TO 2200
C						!ARGS VALID?
	WRITE(OUTCH,420)
C						!COL HDRS
	DO 17100 I=J,K
	  WRITE(OUTCH,430) I,(EQV(I,L),L=1,5)
17100	CONTINUE
	GO TO 2000
C
420	FORMAT(' VL# OBJECT   PROB   OPPS   BEST  MELEE')
430	FORMAT(1X,I3,5(1X,I6))
C
C DF-- DISPLAY FLAGS
C
18000	IF(.NOT.VALID2(J,K,FMAX)) GO TO 2200
C						!ARGS VALID?
	DO 18100 I=J,K
	  WRITE(OUTCH,440) I,FLAGS(I)
18100	CONTINUE
	GO TO 2000
C
440	FORMAT(' Flag #',I2,' = ',L1)
C
C DS-- DISPLAY STATE
C
19000	WRITE(OUTCH,450) PRSA,PRSO,PRSI,PRSWON,PRSCON
	WRITE(OUTCH,460) WINNER,HERE,TELFLG
	WRITE(OUTCH,470) MOVES,DEATHS,RWSCOR,MXSCOR,MXLOAD,LTSHFT,BLOC,
     &	MUNGRM,HS,EGSCOR,EGMXSC
	WRITE(OUTCH,475) FROMDR,SCOLRM,SCOLAC
	GO TO 2000
C
450	FORMAT(' Parse vector=',3(1X,I6),1X,L6,1X,I6)
460	FORMAT(' Play vector= ',2(1X,I6),1X,L6)
470	FORMAT(' State vector=',9(1X,I6)/14X,2(1X,I6))
475	FORMAT(' Scol vector= ',1X,I6,2(1X,I6))
C GDT, PAGE 4
C
C AF-- ALTER FLAGS
C
20000	IF(.NOT.VALID1(J,FMAX)) GO TO 2200
C						!ENTRY NO VALID?
	WRITE(OUTCH,480) FLAGS(J)
C						!TYPE OLD, GET NEW.
	READ(INPCH,490) FLAGS(J)
	GO TO 2000
C
480	FORMAT(' Old=',L2,6X,'New= ',$)
490	FORMAT(L1)
C
C 21000-- HELP
C
21000	WRITE(OUTCH,900)
	GO TO 2000
C
900	FORMAT(' Valid commands are:'/' AA- Alter ADVS'/
     &' AC- Alter CEVENT'/' AF- Alter FINDEX'/' AH- Alter HERE'/
     &' AN- Alter switches'/' AO- Alter OBJCTS'/' AR- Alter ROOMS'/
     &' AV- Alter VILLS'/' AX- Alter EXITS'/
     &' AZ- Alter PUZZLE'/' DA- Display ADVS'/
     &' DC- Display CEVENT'/' DF- Display FINDEX'/' DH- Display HACKS'/
     &' DL- Display lengths'/' DM- Display RTEXT'/
     &' DN- Display switches'/
     &' DO- Display OBJCTS'/' DP- Display parser'/
     &' DR- Display ROOMS'/' DS- Display state'/' DT- Display text'/
     &' DV- Display VILLS'/' DX- Display EXITS'/' DZ- Display PUZZLE'/
     &' D2- Display ROOM2'/' EX- Exit'/' HE- Type this message'/
     &' NC- No cyclops'/' ND- No deaths'/' NR- No robber'/
     &' NT- No troll'/' PD- Program detail'/
     &' RC- Restore cyclops'/' RD- Restore deaths'/
     &' RR- Restore robber'/' RT- Restore troll'/' TK- Take.')
C
C NR-- NO ROBBER
C
22000	THFFLG=.FALSE.
C						!DISABLE ROBBER.
	THFACT=.FALSE.
	CALL NEWSTA(THIEF,0,0,0,0)
C						!VANISH THIEF.
	WRITE(OUTCH,500)
	GO TO 2000
C
500	FORMAT(' No robber.')
C
C NT-- NO TROLL
C
23000	TROLLF=.TRUE.
	CALL NEWSTA(TROLL,0,0,0,0)
	WRITE(OUTCH,510)
	GO TO 2000
C
510	FORMAT(' No troll.')
C
C NC-- NO CYCLOPS
C
24000	CYCLOF=.TRUE.
	CALL NEWSTA(CYCLO,0,0,0,0)
	WRITE(OUTCH,520)
	GO TO 2000
C
520	FORMAT(' No cyclops.')
C
C ND-- IMMORTALITY MODE
C
25000	DBGFLG=1
	WRITE(OUTCH,530)
	GO TO 2000
C
530	FORMAT(' No deaths.')
C
C RR-- RESTORE ROBBER
C
26000	THFACT=.TRUE.
	WRITE(OUTCH,540)
	GO TO 2000
C
540	FORMAT(' Restored robber.')
C
C RT-- RESTORE TROLL
C
27000	TROLLF=.FALSE.
	CALL NEWSTA(TROLL,0,MTROL,0,0)
	WRITE(OUTCH,550)
	GO TO 2000
C
550	FORMAT(' Restored troll.')
C
C RC-- RESTORE CYCLOPS
C
28000	CYCLOF=.FALSE.
	MAGICF=.FALSE.
	CALL NEWSTA(CYCLO,0,MCYCL,0,0)
	WRITE(OUTCH,560)
	GO TO 2000
C
560	FORMAT(' Restored cyclops.')
C
C RD-- MORTAL MODE
C
29000	DBGFLG=0
	WRITE(OUTCH,570)
	GO TO 2000
C
570	FORMAT(' Restored deaths.')
C GDT, PAGE 5
C
C TK-- TAKE
C
30000	IF(.NOT.VALID1(J,OLNT)) GO TO 2200
C						!VALID OBJECT?
	CALL NEWSTA(J,0,0,0,WINNER)
C						!YES, TAKE OBJECT.
	WRITE(OUTCH,580)
C						!TELL.
	GO TO 2000
C
580	FORMAT(' Taken.')
C
C EX-- GOODBYE
C
31000	PRSCON=1
	RETURN
C
C AR--	ALTER ROOM ENTRY
C
32000	IF(.NOT.VALID3(J,RLNT,K,5)) GO TO 2200
C						!INDICES VALID?
	WRITE(OUTCH,590) EQR(J,K)
C						!TYPE OLD, GET NEW.
	READ(INPCH,600) EQR(J,K)
	GO TO 2000
C
590	FORMAT(' Old= ',I6,6X,'New= ',$)
600	FORMAT(I6)
C
C AO-- ALTER OBJECT ENTRY
C
33000	IF(.NOT.VALID3(J,OLNT,K,14)) GO TO 2200
C						!INDICES VALID?
	WRITE(OUTCH,590) EQO(J,K)
	READ(INPCH,600) EQO(J,K)
	GO TO 2000
C
C AA-- ALTER ADVS ENTRY
C
34000	IF(.NOT.VALID3(J,ALNT,K,7)) GO TO 2200
C						!INDICES VALID?
	WRITE(OUTCH,590) EQA(J,K)
	READ(INPCH,600) EQA(J,K)
	GO TO 2000
C
C AC-- ALTER CLOCK EVENTS
C
35000	IF(.NOT.VALID3(J,CLNT,K,3)) GO TO 2200
C						!INDICES VALID?
	IF(K.EQ.3) GO TO 35500
C						!FLAGS ENTRY?
	WRITE(OUTCH,590) EQC(J,K)
	READ(INPCH,600) EQC(J,K)
	GO TO 2000
C
35500	WRITE(OUTCH,480) CFLAG(J)
	READ(INPCH,490) CFLAG(J)
	GO TO 2000
C GDT, PAGE 6
C
C AX-- ALTER EXITS
C
36000	IF(.NOT.VALID1(J,XLNT)) GO TO 2200
C						!ENTRY NO VALID?
	WRITE(OUTCH,610) TRAVEL(J)
	READ(INPCH,620) TRAVEL(J)
	GO TO 2000
C
610	FORMAT(' Old= ',I6,6X,'New= ',$)
620	FORMAT(I6)
C
C AV-- ALTER VILLAINS
C
37000	IF(.NOT.VALID3(J,VLNT,K,5)) GO TO 2200
C						!INDICES VALID?
	WRITE(OUTCH,590) EQV(J,K)
	READ(INPCH,600) EQV(J,K)
	GO TO 2000
C
C D2-- DISPLAY ROOM2 LIST
C
38000	IF(.NOT.VALID2(J,K,R2LNT)) GO TO 2200
	DO 38100 I=J,K
	  WRITE(OUTCH,630) I,RROOM2(I),OROOM2(I)
38100	CONTINUE
	GO TO 2000
C
630	FORMAT(' #',I2,'   Room=',I6,'   Obj=',I6)
C
C DN-- DISPLAY SWITCHES
C
39000	IF(.NOT.VALID2(J,K,SMAX)) GO TO 2200
C						!VALID?
	DO 39100 I=J,K
	  WRITE(OUTCH,640) I,SWITCH(I)
39100	CONTINUE
	GO TO 2000
C
640	FORMAT(' Switch #',I2,' = ',I6)
C
C AN-- ALTER SWITCHES
C
40000	IF(.NOT.VALID1(J,SMAX)) GO TO 2200
C						!VALID ENTRY?
	WRITE(OUTCH,590) SWITCH(J)
	READ(INPCH,600) SWITCH(J)
	GO TO 2000
C
C DM-- DISPLAY MESSAGES
C
41000	IF(.NOT.VALID2(J,K,MLNT)) GO TO 2200
C						!VALID LIMITS?
	WRITE(OUTCH,380)
	DO 41100 I=J,K,10
	  L=MIN0(I+9,K)
	  WRITE(OUTCH,650) I,L,(RTEXT(L1),L1=I,L)
41100	CONTINUE
	GO TO 2000
C
650	FORMAT(1X,I3,'-',I3,3X,10(1X,I6))
C
C DT-- DISPLAY TEXT
C
42000	CALL RSPEAK(J)
	GO TO 2000
C
C AH--	ALTER HERE
C
43000	WRITE(OUTCH,590) HERE
	READ(INPCH,600) HERE
	EQA(1,1)=HERE
	GO TO 2000
C
C DP--	DISPLAY PARSER STATE
C
44000	WRITE(OUTCH,660) ORP,LASTIT,PVEC,SYN
	GO TO 2000
C
660	FORMAT(' ORPHS= ',I7,I7,4I7/
     &' PV=    ',I7,4I7/' SYN=   ',6I7/15X,5I7)
C
C PD--	PROGRAM DETAIL DEBUG
C
45000	WRITE(OUTCH,610) PRSFLG
C						!TYPE OLD, GET NEW.
	READ(INPCH,620) PRSFLG
	GO TO 2000
C
C DZ--	DISPLAY PUZZLE ROOM
C
46000	DO 46100 I=1,64,8
C						!DISPLAY PUZZLE
	  WRITE(OUTCH,670) (CPVEC(J),J=I,I+7)
46100	CONTINUE
	GO TO 2000
C
670	FORMAT(2X,8I3)
C
C AZ--	ALTER PUZZLE ROOM
C
47000	IF(.NOT.VALID1(J,64)) GO TO 2200
C						!VALID ENTRY?
	WRITE(OUTCH,590) CPVEC(J)
C						!OUTPUT OLD,
	READ(INPCH,600) CPVEC(J)
	GO TO 2000
C
	END
