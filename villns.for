C TROLLP-	TROLL FUNCTION
C
C COPYRIGHT 1980, INFOCOM COMPUTERS AND COMMUNICATIONS, CAMBRIDGE MA. 02142
C ALL RIGHTS RESERVED, COMMERCIAL USAGE STRICTLY PROHIBITED
C WRITTEN BY R. M. SUPNIK
C
C DECLARATIONS
C
	LOGICAL FUNCTION TROLLP(ARG)
	IMPLICIT INTEGER (A-Z)
	LOGICAL QHERE,PROB
	include 'parser.h'
	include 'gamestat.h'
	include 'objects.h'
	include 'oflags.h'
	include 'oindex.h'
	include 'verbs.h'
	include 'flags.h'
C TROLLP, PAGE 2
C
	TROLLP=.TRUE.
C						!ASSUME WINS.
	IF(PRSA.NE.FIGHTW) GO TO 1100
C						!FIGHT?
	IF(OCAN(AXE).EQ.TROLL) GO TO 10
C						!GOT AXE?  NOTHING.
	I=433
C						!ASSUME CANT GET.
	IF(.NOT.QHERE(AXE,HERE)) GO TO 1050
C						!HERE?
	I=434
C						!YES, RECOVER.
	CALL NEWSTA(AXE,0,0,TROLL,0)
1050	IF(QHERE(TROLL,HERE)) CALL RSPEAK(I)
C						!IF PLAYER HERE.
	RETURN
C
1100	IF(PRSA.NE.DEADXW) GO TO 1200
C						!DEAD?
	TROLLF=.TRUE.
C						!PERMIT EXITS.
	RETURN
C
1200	IF(PRSA.NE.OUTXW) GO TO 1300
C						!OUT?
	TROLLF=.TRUE.
C						!PERMIT EXITS.
	OFLAG1(AXE)=IAND(OFLAG1(AXE), not(VISIBT))
	ODESC1(TROLL)=435
C						!TROLL OUT.
	RETURN
C
1300	IF(PRSA.NE.INXW) GO TO 1400
C						!WAKE UP?
	TROLLF=.FALSE.
C						!FORBID EXITS.
	OFLAG1(AXE)=IOR(OFLAG1(AXE),VISIBT)
	ODESC1(TROLL)=436
C						!TROLL IN.
	IF(QHERE(TROLL,HERE)) CALL RSPEAK(437)
	RETURN
C
1400	IF(PRSA.NE.FRSTQW) GO TO 1500
C						!FIRST ENCOUNTER?
	TROLLP=PROB(33,66)
C						!33% TRUE UNLESS BADLK.
	RETURN
C
1500	IF((PRSA.NE.MOVEW).AND.(PRSA.NE.TAKEW).AND.(PRSA.NE.MUNGW)
     &	.AND.(PRSA.NE.THROWW).AND.(PRSA.NE.GIVEW)) GO TO 2000
	IF(OCAPAC(TROLL).GE.0) GO TO 1550
C						!TROLL OUT?
	OCAPAC(TROLL)=-OCAPAC(TROLL)
C						!YES, WAKE HIM.
	OFLAG1(AXE)=IOR(OFLAG1(AXE),VISIBT)
	TROLLF=.FALSE.
	ODESC1(TROLL)=436
	CALL RSPEAK(437)
C
1550	IF((PRSA.NE.TAKEW).AND.(PRSA.NE.MOVEW)) GO TO 1600
	CALL RSPEAK(438)
C						!JOKE.
	RETURN
C
1600	IF(PRSA.NE.MUNGW) GO TO 1700
C						!MUNG?
	CALL RSPEAK(439)
C						!JOKE.
	RETURN
C
1700	IF(PRSO.EQ.0) GO TO 10
C						!NO OBJECT?
	I=440
C						!ASSUME THROW.
	IF(PRSA.EQ.GIVEW) I=441
C						!GIVE?
	CALL RSPSUB(I,ODESC2(PRSO))
C						!TROLL TAKES.
	IF(PRSO.EQ.KNIFE) GO TO 1900
C						!OBJ KNIFE?
	CALL NEWSTA(PRSO,442,0,0,0)
C						!NO, EATS IT.
	RETURN
C
1900	CALL RSPEAK(443)
C						!KNIFE, THROWS IT BACK
	OFLAG2(TROLL)=IOR(OFLAG2(TROLL),FITEBT)
	RETURN
C
2000	IF(.NOT.TROLLF.OR.(PRSA.NE.HELLOW)) GO TO 10
	CALL RSPEAK(366)
C						!TROLL OUT.
	RETURN
C
10	TROLLP=.FALSE.
C						!COULDNT HANDLE IT.
	RETURN
	END
C CYCLOP-	CYCLOPS FUNCTION
C
C DECLARATIONS
C
	LOGICAL FUNCTION CYCLOP(ARG)
	IMPLICIT INTEGER (A-Z)
	include 'parser.h'
	include 'gamestat.h'
	include 'objects.h'
	include 'oflags.h'
	include 'oindex.h'
	include 'verbs.h'
	include 'flags.h'
C CYCLOP, PAGE 2
C
	CYCLOP=.TRUE.
C						!ASSUME WINS.
	IF(.NOT.CYCLOF) GO TO 100
C						!ASLEEP?
	IF((PRSA.NE.ALARMW).AND.(PRSA.NE.MUNGW).AND.(PRSA.NE.HELLOW).AND.
     &	(PRSA.NE.BURNW).AND.(PRSA.NE.KILLW).AND.(PRSA.NE.ATTACW))
     &	 GO TO 10
	CYCLOF=.FALSE.
C						!WAKE CYCLOPS.
	CALL RSPEAK(187)
C						!DESCRIBE.
	RVCYC=IABS(RVCYC)
	OFLAG2(CYCLO)=IAND(IOR(OFLAG2(CYCLO),FITEBT),not(SLEPBT))
	RETURN
C
100	IF((PRSA.EQ.FIGHTW).OR.(PRSA.EQ.FRSTQW)) GO TO 10
	IF(IABS(RVCYC).LE.5) GO TO 200
C						!ANNOYED TOO MUCH?
	RVCYC=0
C						!RESTART COUNT.
	CALL JIGSUP(188)
C						!YES, EATS PLAYER.
	RETURN
C
200	IF(PRSA.NE.GIVEW) GO TO 500
C						!GIVE?
	IF((PRSO.NE.FOOD).OR.(RVCYC.LT.0)) GO TO 300
C						!FOOD WHEN HUNGRY?
	CALL NEWSTA(FOOD,189,0,0,0)
C						!EATS PEPPERS.
	RVCYC=MIN0(-1,-RVCYC)
C						!GETS THIRSTY.
	RETURN
C
300	IF(PRSO.NE.WATER) GO TO 400
C						!DRINK WHEN THIRSTY?
	IF(RVCYC.GE.0) GO TO 350
	CALL NEWSTA(PRSO,190,0,0,0)
C						!DRINKS AND
	CYCLOF=.TRUE.
C						!FALLS ASLEEP.
	OFLAG2(CYCLO)=IAND(IOR(OFLAG2(CYCLO),SLEPBT),not(FITEBT))
	RETURN
C
350	CALL RSPEAK(191)
C						!NOT THIRSTY.
10	CYCLOP=.FALSE.
C						!FAILS.
	RETURN
C
400	I=192
C						!ASSUME INEDIBLE.
	IF(PRSO.EQ.GARLI) I=193
C						!GARLIC IS JOKE.
450	CALL RSPEAK(I)
C						!DISDAIN IT.
	IF(RVCYC.LT.0) RVCYC=RVCYC-1
	IF(RVCYC.GE.0) RVCYC=RVCYC+1
	IF(.NOT.CYCLOF) CALL RSPEAK(193+IABS(RVCYC))
	RETURN
C
500	I=0
C						!ASSUME NOT HANDLED.
	IF(PRSA.EQ.HELLOW) GO TO 450
C						!HELLO IS NO GO.
	IF((PRSA.EQ.THROWW).OR.(PRSA.EQ.MUNGW)) I=200+RND(2)
	IF(PRSA.EQ.TAKEW) I=202
	IF(PRSA.EQ.TIEW) I=203
	IF(I) 10,10,450
C						!SEE IF HANDLED.
C
	END
C THIEFP-	THIEF FUNCTION
C
C DECLARATIONS
C
	LOGICAL FUNCTION THIEFP(ARG)
	IMPLICIT INTEGER (A-Z)
	LOGICAL QHERE,PROB
	include 'parser.h'
	include 'gamestat.h'
C
C ROOMS
	include 'rindex.h'
	include 'objects.h'
	include 'oflags.h'
	include 'oindex.h'
	include 'clock.h'

	include 'villians.h'
	include 'verbs.h'
	include 'flags.h'
C THIEFP, PAGE 2
C
	THIEFP=.TRUE.
C						!ASSUME WINS.
	IF(PRSA.NE.FIGHTW) GO TO 100
C						!FIGHT?
	IF(OCAN(STILL).EQ.THIEF) GO TO 10
C						!GOT STILLETTO?  F.
	IF(QHERE(STILL,THFPOS)) GO TO 50
C						!CAN HE RECOVER IT?
	CALL NEWSTA(THIEF,0,0,0,0)
C						!NO, VANISH.
	IF(QHERE(THIEF,HERE)) CALL RSPEAK(498)
C						!IF HERO, TELL.
	RETURN
C
50	CALL NEWSTA(STILL,0,0,THIEF,0)
C						!YES, RECOVER.
	IF(QHERE(THIEF,HERE)) CALL RSPEAK(499)
C						!IF HERO, TELL.
	RETURN
C
100	IF(PRSA.NE.DEADXW) GO TO 200
C						!DEAD?
	THFACT=.FALSE.
C						!DISABLE DEMON.
	OFLAG1(CHALI)=IOR(OFLAG1(CHALI),TAKEBT)
	J=0
	DO 125 I=1,OLNT
C						!CARRYING ANYTHING?
125	  IF(OADV(I).EQ.-THIEF) J=500
	CALL RSPEAK(J)
C						!TELL IF BOOTY REAPPEARS.
C
	J=501
	DO 150 I=1,OLNT
C						!LOOP.
	  IF((I.EQ.CHALI).OR.(I.EQ.THIEF).OR.(HERE.NE.TREAS)
     &	.OR. .NOT.QHERE(I,HERE)) GO TO 135
	  OFLAG1(I)=IOR(OFLAG1(I),VISIBT)
	  CALL RSPSUB(J,ODESC2(I))
C						!DESCRIBE.
	  J=502
	  GO TO 150
C
135	  IF(OADV(I).EQ.-THIEF) CALL NEWSTA(I,0,HERE,0,0)
150	CONTINUE
	RETURN
C
200	IF(PRSA.NE.FRSTQW) GO TO 250
C						!FIRST ENCOUNTER?
	THIEFP=PROB(20,75)
	RETURN
C
250	IF((PRSA.NE.HELLOW).OR.(ODESC1(THIEF).NE.504))
     &	GO TO 300
	CALL RSPEAK(626)
	RETURN
C
300	IF(PRSA.NE.OUTXW) GO TO 400
C						!OUT?
	THFACT=.FALSE.
C						!DISABLE DEMON.
	ODESC1(THIEF)=504
C						!CHANGE DESCRIPTION.
	OFLAG1(STILL)=IAND(OFLAG1(STILL),not(VISIBT))
	OFLAG1(CHALI)=IOR(OFLAG1(CHALI),TAKEBT)
	RETURN
C
400	IF(PRSA.NE.INXW) GO TO 500
C						!IN?
	IF(QHERE(THIEF,HERE)) CALL RSPEAK(505)
C						!CAN HERO SEE?
	THFACT=.TRUE.
C						!ENABLE DEMON.
	ODESC1(THIEF)=503
C						!CHANGE DESCRIPTION.
	OFLAG1(STILL)=IOR(OFLAG1(STILL),VISIBT)
	IF((HERE.EQ.TREAS).AND.QHERE(CHALI,HERE))
     &	OFLAG1(CHALI)=IAND(OFLAG1(CHALI),not(TAKEBT))
	RETURN
C
500	IF(PRSA.NE.TAKEW) GO TO 600
C						!TAKE?
	CALL RSPEAK(506)
C						!JOKE.
	RETURN
C
600	IF((PRSA.NE.THROWW).OR.(PRSO.NE.KNIFE).OR.
     &	(IAND(OFLAG2(THIEF),FITEBT).NE.0)) GO TO 700
	IF(PROB(10,10)) GO TO 650
C						!THREW KNIFE, 10%?
	CALL RSPEAK(507)
C						!NO, JUST MAKES
	OFLAG2(THIEF)=IOR(OFLAG2(THIEF),FITEBT)
	RETURN
C
650	J=508
C						!THIEF DROPS STUFF.
	DO 675 I=1,OLNT
	  IF(OADV(I).NE.-THIEF) GO TO 675
C						!THIEF CARRYING?
	  J=509
	  CALL NEWSTA(I,0,HERE,0,0)
675	CONTINUE
	CALL NEWSTA(THIEF,J,0,0,0)
C						!THIEF VANISHES.
	RETURN
C
700	IF(((PRSA.NE.THROWW).AND.(PRSA.NE.GIVEW)).OR.(PRSO.EQ.0).OR.
     &	(PRSO.EQ.THIEF)) GO TO 10
	IF(OCAPAC(THIEF).GE.0) GO TO 750
C						!WAKE HIM UP.
	OCAPAC(THIEF)=-OCAPAC(THIEF)
	THFACT=.TRUE.
	OFLAG1(STILL)=IOR(OFLAG1(STILL),VISIBT)
	ODESC1(THIEF)=503
	CALL RSPEAK(510)
C
750	IF((PRSO.NE.BRICK).OR.(OCAN(FUSE).NE.BRICK).OR.
     &	(CTICK(CEVFUS).EQ.0)) GO TO 800
	CALL RSPEAK(511)
C						!THIEF REFUSES BOMB.
	RETURN
C
800	CALL NEWSTA(PRSO,0,0,0,-THIEF)
C						!THIEF TAKES GIFT.
	IF(OTVAL(PRSO).GT.0) GO TO 900
C						!A TREASURE?
	CALL RSPSUB(512,ODESC2(PRSO))
	RETURN
C
900	CALL RSPSUB(627,ODESC2(PRSO))
C						!THIEF ENGROSSED.
	THFENF=.TRUE.
	RETURN
C
10	THIEFP=.FALSE.
	RETURN
	END
