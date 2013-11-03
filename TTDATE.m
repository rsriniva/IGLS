TTDATE
 Q

CHOOSE(INITDATE,CAPTION)
 N DM,FDOM,DATE,MONTH,DAY,YEAR,FDM,DIM,DX,DN,CDOW,CX,CY,MN,CFOC,ZB
 S (MONTH,DAY,YEAR)="",DATE=INITDATE,CFOC="MONTH"
 S DX(0)=30,DX(1)=33,DX(2)=36,DX(3)=39,DX(4)=42,DX(5)=45,DX(6)=48
 S DN(0)="SUNDAY",DN(1)="MONDAY",DN(2)="TUESDAY",DN(3)="WEDNESDAY"
 S DN(4)="THURSDAY",DN(5)="FRIDAY",DN(6)="SATURDAY"
 S MN(1)="JANUARY",MN(2)="FEBRUARY",MN(3)="MARCH",MN(4)="APRIL"
 S MN(5)="MAY",MN(6)="JUNE",MN(7)="JULY",MN(8)="AUGUST"
 S MN(9)="SEPTEMBER",MN(10)="OCTOBER",MN(11)="NOVEMBER",MN(12)="DECEMBER"
 S SUBFLG=0
REDISPLAY
 D INIT^TT 
 S MONTH=+$P(DATE,"/",1),DAY=+$P(DATE,"/",2),YEAR=+$P(DATE,"/",3)
 I $G(CAPTION,"")="" D CAPTION^TTUI("CHOOSE DATE")
 I $G(CAPTION,"")'="" D CAPTION^TTUI(CAPTION)
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 S (DM(1),DM(3),DM(5),DM(7),DM(8),DM(10),DM(12))=31
 S (DM(4),DM(6),DM(9),DM(11))=30,DM(2)=28
 I $$LEAPYEAR(YEAR)=1 S DM(2)=29
 S FDM=MONTH_"/1/"_YEAR,FDOM=$$DAYOFWEEK(FDM),DIM=DM(MONTH)
 D LOCATE^TTRNSI(7,31) W MN(MONTH)
 D LOCATE^TTRNSI(7,45) W YEAR
 F I=0:1:6  D
 . D LOCATE^TTRNSI(8,DX(I)) W $E(DN(I),1,2)
 S CDOW=FDOM,CX=DX(0),CY=9
 F I=1:1:DIM  D
 . I I=DAY D SETCOLOR^TTRNSI("WHITE","BLACK"),SETATTR^TTRNSI("REVERSE")
 . I I'=DAY D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 . S CX=DX(CDOW) 
 . D LOCATE^TTRNSI(CY,CX) W I D SETATTR^TTRNSI("RESET")
 . I CDOW=6 S CDOW=-1,CY=CY+1
 . S CDOW=CDOW+1
 U $P:(ESCAPE:TERMINATOR=$C(9,13))
 D SETATTR^TTRNSI("BRIGHT")
 I CFOC="MONTH" D LOCATE^TTRNSI(7,30) W "<" D LOCATE^TTRNSI(7,31+$L(MN(MONTH))) W ">"
 I CFOC="YEAR" D LOCATE^TTRNSI(7,44) W "<" D LOCATE^TTRNSI(7,49) W ">"
 I CFOC="DAY" D LOCATE^TTRNSI(10,28) W "<" D LOCATE^TTRNSI(10,51) W ">"
 D LOCATE^TTRNSI(24,1),SETCOLOR^TTRNSI("MAGENTA","BLACK")
 W "TAB TO NAVIGATE CALENDAR ELEMENTS, ARROWS TO CHANGE; F2 SUBMITS"
 D LOCATE^TTRNSI(22,1),SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("CYAN","BLACK") 
 W DN($$DAYOFWEEK(DATE))," ",MN(MONTH)," ",DAY,", ",YEAR
 U $P:ESC
 R *CHOICE S ZB=$ZB
 ; TAB
 I $ASCII(ZB)=9 D
 . I CFOC="MONTH" S CFOC="YEAR" G REDISPLAY
 . I CFOC="YEAR" S CFOC="DAY" G REDISPLAY
 . I CFOC="DAY" S CFOC="MONTH" G REDISPLAY
 ; UP
 I $G(%IOKB(ZB))="KEY_UP" D 
 . I CFOC="DAY" D
 . . I DAY>7 S DAY=DAY-7
 ; DOWN
 I $G(%IOKB(ZB))="KEY_DOWN" D 
 . I CFOC="DAY" D 
 . . I DAY'>(DM(MONTH)-7) S DAY=DAY+7
 ; LEFT
 I $G(%IOKB(ZB))="KEY_LEFT" D 
 . I CFOC="MONTH" D 
 . . I MONTH>1 S MONTH=MONTH-1
 . I CFOC="YEAR" S YEAR=YEAR-1
 . I CFOC="DAY" D 
 . . I DAY>1 S DAY=DAY-1  
 ; RIGHT
 I $G(%IOKB(ZB))="KEY_RIGHT" D 
 . I CFOC="MONTH" D
 . . I MONTH<12 S MONTH=MONTH+1
 . I CFOC="YEAR" S YEAR=YEAR+1
 . I CFOC="DAY" D
 . . I DAY<DM(MONTH) S DAY=DAY+1
 S DATE=MONTH_"/"_DAY_"/"_YEAR
 ; F2
 I $G(%IOKB(ZB))="KEY_F2" D
 . S (INTVAL,EXTVAL)=DATE
 . S SUBFLG=1 U $P:FLUSH
 G:SUBFLG=0 REDISPLAY
CHOSEN
 Q

LEAPYEAR(YEAR)
 N RETVAL S RETVAL=0
 I YEAR#400=0 S RETVAL=1
 I YEAR#100=0 S RETVAL=0
 I YEAR#4=0 S RETVAL=1
 Q RETVAL

DATEWITHIN(INPUTDATE,DATE1,DATE2)
 D NORMALIZE(.INPUTDATE)
 D NORMALIZE(.DATE1)
 D NORMALIZE(.DATE2)
 N IDH,D1H,D2H S (IDH,D1H,D2H)=0
 S IDH=$$EDH(INPUTDATE),D1H=$$EDH(DATE1),D2H=$$EDH(DATE2)
 Q (IDH'<D1H)&(IDH'>D2H)

NORMALIZE(INPUTDATE)
 N YEAR,YR2DIG S YEAR=$P(INPUTDATE,"/",3) 
 I $L(YEAR)=4 S YR2DIG=$E(YEAR,3,4)
 E  S YR2DIG=YEAR
 S $P(INPUTDATE,"/",3)=YR2DIG
 Q

EDH(DATE)
 Q $$FUNC^%DATE(DATE) 

HOURS(HORO1,HORO2)
 N MIN1,MIN2,SEC1,SEC2,HRS1,HRS2
 S SEC1=$P(HORO1,",",2),SEC2=$P(HORO2,",",2)
 S MIN1=SEC1/60,MIN2=SEC2/60
 S HRS1=MIN1/60,HRS2=MIN2/60
 Q HRS2-HRS1

DAYOFWEEK(DATE)
 N MONTH,DAY,NEWYEAR,YEAR,CENT,DMY
 S MONTH=$P(DATE,"/","1")
 S DAY=$P(DATE,"/","2")
 S YEAR=$P(DATE,"/","3")
 I MONTH<3 S MONTH=MONTH+12,YEAR=YEAR-1
 S MONTH=MONTH+1
 S MONTH=MONTH*2.61
 S MONTH=$P(MONTH,".",1)
 S NEWYEAR=YEAR
 S YEAR=$E(NEWYEAR,3,4)
 S DMY=DAY+MONTH+YEAR
 S CENT=$E(NEWYEAR,1,2)
 S YEAR=YEAR/4
 S YEAR=$P(YEAR,".",1)
 S DMY=DMY+YEAR
 I CENT=18 S CENT=2
 I CENT=19 S CENT=0
 I CENT=20 S CENT=6
 I CENT=21 S CENT=4
 S DMY=DMY+CENT
 Q DMY#7

CURHOUR()
 Q $ZD($H,"12")

CURMIN()
 Q $ZD($H,"60")

CURSEC()
 Q $ZD($H,"SS")

CURAMPM() 
 Q $ZD($H,"AM")