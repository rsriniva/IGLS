TTUI
 Q

;
; BA STRUCTURE
;
;  BA("TOP")=n
;  BA("LEFT")=n
;  BA("RIGHT")=n
;  BA("BOTTOM")=n
;  BA("TITLE")="text"
;  BA("LINES",n)="text"
ALERTBOX(BA)
 S BA("SCALEWIDTH")=BA("RIGHT")-BA("LEFT")-1
 S BA("SCALEHEIGHT")=BA("BOTTOM")-BA("TOP")-4
 S BA("CONTENTTOP")=BA("TOP")+3
 S BA("CONTENTLEFT")=BA("LEFT")+1
 S BA("CAPTIONTOP")=BA("TOP")+1
 S BA("CAPTIONLEFT")=BA("LEFT")+1
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(BA("TOP"),BA("LEFT"))
 W BOX("UL")
 F I=BA("LEFT")+1:1:BA("RIGHT")-1  D
 . D LOCATE^TTRNSI(BA("TOP"),I) W BOX("H")
 W BOX("UR")
 D LOCATE^TTRNSI(BA("TOP")+1,BA("LEFT")) W BOX("V")
 D LOCATE^TTRNSI(BA("TOP")+1,BA("RIGHT")) W BOX("V")
 D LOCATE^TTRNSI(BA("TOP")+2,BA("LEFT")) W BOX("LT")
 D LOCATE^TTRNSI(BA("TOP")+2,BA("RIGHT")) W BOX("RT")
 F I=BA("LEFT")+1:1:BA("RIGHT")-1  D
 . D LOCATE^TTRNSI(BA("TOP")+2,I) W BOX("H")
 D LOCATE^TTRNSI(BA("BOTTOM"),BA("LEFT")) W BOX("LL")
 D LOCATE^TTRNSI(BA("BOTTOM"),BA("RIGHT")) W BOX("LR")
 F I=BA("LEFT")+1:1:BA("RIGHT")-1  D
 . D LOCATE^TTRNSI(BA("BOTTOM"),I) W BOX("H")
 F ROW=BA("TOP")+3:1:BA("BOTTOM")-1  D
 . D LOCATE^TTRNSI(ROW,BA("LEFT")) W BOX("V")
 . D LOCATE^TTRNSI(ROW,BA("RIGHT")) W BOX("V")
 D LOCATE^TTRNSI(BA("CAPTIONTOP"),BA("CAPTIONLEFT"))
 D SETATTR^TTRNSI("REVERSE")
 F I=BA("CAPTIONLEFT"):1:BA("RIGHT")-1  D
 . D LOCATE^TTRNSI(BA("CAPTIONTOP"),I) W " "
 D LOCATE^TTRNSI(BA("CAPTIONTOP"),BA("CAPTIONLEFT")) W BA("TITLE")
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 F I=BA("CONTENTTOP"):1:BA("BOTTOM")-1  D
 . D LOCATE^TTRNSI(I,BA("CONTENTLEFT"))
 . F J=1:1:BA("SCALEWIDTH") W " "
 N CL,LINE S CL=BA("CONTENTTOP"),LINE=""
 F  S LINE=$O(BA("LINES",LINE)) Q:LINE=""  D
 . D LOCATE^TTRNSI(CL,BA("CONTENTLEFT"))
 . W $E(BA("LINES",LINE),1,BA("SCALEWIDTH"))
 . S CL=CL+1
 N BR S BR=((BA("SCALEWIDTH")/2)-5)+BA("LEFT")+1
 S BR=$P(BR,".",1)
 D LOCATE^TTRNSI(BA("BOTTOM")-2,BR)
 W SHADOW D SETATTR^TTRNSI("REVERSE") W "   OK   "
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK") W SHADOW
 D HOME^TTRNSI
 R *TMP
 Q

MSGBOX(PROMPT,BUTTONS,TITLE)
 N TOP,LEFT,RIGHT,BOTTOM,BA,WIDTH
 S TOP=((24/2)-(11/2))
 S TOP=$P(TOP,".",1)
 S WIDTH=$L(PROMPT)+4,LEFT=(80/2)-(WIDTH/2)
 S WIDTH=$P(WIDTH,".",1)
 S LEFT=$P(LEFT,".",1)
 S RIGHT=LEFT+WIDTH
 S RIGHT=$P(RIGHT,".",1)
 S BOTTOM=TOP+11
 S BA("TOP")=TOP,BA("LEFT")=LEFT,BA("RIGHT")=RIGHT
 S BA("BOTTOM")=BOTTOM
 S BA("TITLE")=TITLE
 S BA("LINES",1)="",BA("LINES",2)=" "_PROMPT
 S BA("LINES",3)=""
 D ALERTBOX(.BA)
 Q

CAPTION(CAPTEXT)
 N CAPLEFT
 S CAPLEFT=(%IOCAP("COLUMNS")/2)-($L(CAPTEXT)/2)
 S CAPLEFT=$P(CAPLEFT,".",1)
 D LOCATE^TTRNSI(1,CAPLEFT)
 D SETCOLOR^TTRNSI("WHITE","BLACK"),SETATTR^TTRNSI("BRIGHT")
 W CAPTEXT
 D SETATTR^TTRNSI("RESET")
 Q

CONFIRM(CAPTION)
 N KEY,EV,CAPLEFT,CURSEL,QUITFLG
 S CURSEL="N",QUITFLG=0
CONFREDISP
 D LOCATE^TTRNSI(%IOCAP("ROWS"),1)
 D ERASETOEOL^TTRNSI
 D SETCOLOR^TTRNSI("MAGENTA","BLACK")
 D SETATTR^TTRNSI("BRIGHT")
 D LOCATE^TTRNSI(%IOCAP("ROWS"),1) W CAPTION
 D LOCATE^TTRNSI(%IOCAP("ROWS"),%IOCAP("COLUMNS")-20)
 I CURSEL="Y" D 
 . D SETATTR^TTRNSI("REVERSE")
 . D SETCOLOR^TTRNSI("MAGENTA","BLACK")
 . D SETATTR^TTRNSI("BRIGHT")
 E  D 
 . D SETATTR^TTRNSI("RESET")
 . D SETCOLOR^TTRNSI("MAGENTA","BLACK")
 . D SETATTR^TTRNSI("BRIGHT")
 D LOCATE^TTRNSI(%IOCAP("ROWS"),%IOCAP("COLUMNS")-20) W "YES"
 I CURSEL="N" D 
 . D SETATTR^TTRNSI("REVERSE")
 . D SETCOLOR^TTRNSI("MAGENTA","BLACK")
 . D SETATTR^TTRNSI("BRIGHT")
 E  D 
 . D SETATTR^TTRNSI("RESET")
 . D SETCOLOR^TTRNSI("MAGENTA","BLACK")
 . D SETATTR^TTRNSI("BRIGHT")
 D LOCATE^TTRNSI(%IOCAP("ROWS"),%IOCAP("COLUMNS")-10) W "NO"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("MAGENTA","BLACK")
 D SETATTR^TTRNSI("BRIGHT")
 D HOME^TTRNSI
 S KEY=$$GETCH^%TERMIO(.EV),QUITFLG=0
 I KEY="KEY_LEFT" D
 . I CURSEL="N" S CURSEL="Y",QUITFLG=0
 I KEY="KEY_RIGHT" D
 . I CURSEL="Y" S CURSEL="N",QUITFLG=0
 I KEY="KEY_ENTER" S QUITFLG=1
 G:QUITFLG=0 CONFREDISP
 Q CURSEL