TTFORM
 Q

;
; TTFORM data structure
;
;  TF("TITLE")="TITLE"
;  TF("ITEMS",n,"NAME")="field name"
;  TF("ITEMS",n,"LABEL")="Field label"
;  TF("ITEMS",n,"LABEL","TOP")=n
;  TF("ITEMS",n,"LABEL","LEFT")=n
;  TF("ITEMS",n,"FIELD","ONFOCUS")="CODE"
;  TF("ITEMS",n,"FIELD","ONBLUR")="CODE"
;  TF("ITEMS",n,"FIELD","MAXLENGTH")=n
;  TF("ITEMS",n,"FIELD","TOP")=n
;  TF("ITEMS",n,"FIELD","LEFT")=n
;  TF("ITEMS",n,"FIELD","REQUIRED")=1
;  TF("ITEMS",n,"FIELD","VALUE")="initial value"
;
GO(FA,CAPTION)
 N ITEM S ITEM=""
 N NAME,LABEL,LLEFT,LTOP,ONFOCUS,ONBLUR
 N MAXLENGTH,TOP,LEFT,REQUIRED,VALUE,CURRENT,COUNT
 S COUNT=0
 F  S ITEM=$O(FA("ITEMS",ITEM)) Q:ITEM=""  D
 . I ITEM>COUNT S COUNT=ITEM
 S ITEM=""
 S CURRENT=1
 S DUMMYFLG=0
 S SUBFLG=0
REDISPLAY 
 G:SUBFLG=1 SUBMIT
 D INIT^TT
 U $P:(ESCAPE:TERMINATOR=$C(9,13))
 I $G(CAPTION,"")="" D CAPTION^TTUI(FA("TITLE"))
 I $G(CAPTION,"")'="" D CAPTION^TTUI(CAPTION)
 F  S ITEM=$O(FA("ITEMS",ITEM)) Q:ITEM=""  D
 . S LLEFT=FA("ITEMS",ITEM,"LABEL","LEFT")
 . S LTOP=FA("ITEMS",ITEM,"LABEL","TOP")
 . S LEFT=FA("ITEMS",ITEM,"FIELD","LEFT")
 . S TOP=FA("ITEMS",ITEM,"FIELD","TOP")
 . S NAME=FA("ITEMS",ITEM,"NAME")
 . S LABEL=FA("ITEMS",ITEM,"LABEL")
 . S ONFOCUS=$G(FA("ITEMS",ITEM,"FIELD","ONFOCUS"))
 . S ONBLUR=$G(FA("ITEMS",ITEM,"FIELD","ONBLUR"))
 . S MAXLENGTH=$G(FA("ITEMS",ITEM,"FIELD","MAXLENGTH"))
 . S REQUIRED=$G(FA("ITEMS",ITEM,"FIELD","REQUIRED"),0)
 . S VALUE=$G(FA("ITEMS",ITEM,"FIELD","VALUE"),"")
 . S ERROR=$G(FA("ITEMS",ITEM,"FIELD","ERROR"))
 . D SETCOLOR^TTRNSI("GREEN","BLACK")
 . D LOCATE^TTRNSI(LTOP,LLEFT) W LABEL
 . D LOCATE^TTRNSI(TOP,LEFT)
 . D SETCOLOR^TTRNSI("BLACK","GREEN")
 . F I=1:1:MAXLENGTH W " "
 . I $G(FA("ITEMS",ITEM,"FIELD","VALUE"))'="" D
 . . D LOCATE^TTRNSI(TOP,LEFT)
 . . W $E(FA("ITEMS",ITEM,"FIELD","VALUE"),1,MAXLENGTH)
 . I REQUIRED D LOCATE^TTRNSI(TOP,LEFT+MAXLENGTH) D SETCOLOR^TTRNSI("RED","BLACK") W "*"
 . I ERROR'="" D LOCATE^TTRNSI(TOP+1,LEFT) D SETCOLOR^TTRNSI("RED","BLACK") W ERROR
 . S FA("ITEMS",ITEM,"FIELD","ERROR")=""
 D LOCATE^TTRNSI(23,1),SETCOLOR^TTRNSI("GREEN","BLACK")
 F I=1:1:80 W "-"
 D LOCATE^TTRNSI(24,1),SETCOLOR^TTRNSI("MAGENTA","BLACK")
 W "TAB TO NAVIGATE; F2 SUBMITS "
 I DUMMYFLG=0 S CURRENT=$$INPUT(.FA,CURRENT,COUNT) G REDISPLAY
 I DUMMYFLG=1 S CURRENT=$$DUMMYINPUT(.FA,CURRENT,COUNT) G REDISPLAY
SUBMIT
 N ERRCT S ERRCT=0
 S ITEM=""
 F  S ITEM=$O(FA("ITEMS",ITEM)) Q:ITEM=""  D
 . I $G(FA("ITEMS",ITEM,"FIELD","REQUIRED"))=1 D 
 . . I $L($G(FA("ITEMS",ITEM,"FIELD","VALUE")))=0 D
 . . . S ERRCT=ERRCT+1
 . . . S FA("ITEMS",ITEM,"FIELD","ERROR")="INPUT REQUIRED"
 I ERRCT>0 S SUBFLG=0,CURRENT=1 G REDISPLAY
 N MA
 S MA("TITLE")="CONFIRM SUBMISSION"
 S MA("ITEMS","A. SUBMIT FORM")="S (SUBFLG,CANFLG)=0,RETRFLG=0"
 S MA("ITEMS","B. EDIT FORM")="S (SUBFLG,CANFLG)=0,RETRFLG=1"
 S MA("ITEMS","C. CANCEL")="S CANFLG=1,(SUBFLG,RETRFLG)=0"
 D GO^TTMENU(.MA)
 G:RETRFLG=1 REDISPLAY
 Q

INPUT(FA,CURRENT,COUNT)
 N RETVAL,TMP
 U $P:(ESCAPE:TERMINATOR=$C(9,13))
 D LOCATE^TTRNSI(FA("ITEMS",CURRENT,"FIELD","TOP"),FA("ITEMS",CURRENT,"FIELD","LEFT"))
 D SETCOLOR^TTRNSI("BLACK","GREEN")
 I $G(FA("ITEMS",CURRENT,"FIELD","ONFOCUS"))="" D
 . R TMP#FA("ITEMS",CURRENT,"FIELD","MAXLENGTH") S ZB=$ZB
 . I $G(%IOKB(ZB))="KEY_F2" S SUBFLG=1
 . I $G(%IOKB(ZB))'="KEY_F2" S SUBFLG=0
 . I TMP'="" S FA("ITEMS",CURRENT,"FIELD","VALUE")=TMP
 . S DUMMYFLG=0
 I $G(FA("ITEMS",CURRENT,"FIELD","ONFOCUS"))'="" D 
 . X FA("ITEMS",CURRENT,"FIELD","ONFOCUS")
 . S SUBFLG=0
 . S FA("ITEMS",CURRENT,"FIELD","VALUE")=EXTVAL
 . S FA("ITEMS",CURRENT,"FIELD","INTVAL")=INTVAL
 . S CURRENT=CURRENT-1
 . S DUMMYFLG=1
 I CURRENT=COUNT S RETVAL=1
 I CURRENT<COUNT S RETVAL=CURRENT+1
 Q RETVAL
 
DUMMYINPUT(FA,CURRENT,COUNT)
 N RETVAL,TMP,NEXTFLG S NEXTFLG=0
 D LOCATE^TTRNSI(FA("ITEMS",CURRENT,"FIELD","TOP"),FA("ITEMS",CURRENT,"FIELD","LEFT"))
 D SETCOLOR^TTRNSI("BLACK","GREEN")
 R *TMP S ZB=$ZB
 I $G(%IOKB(ZB))="KEY_F2" S SUBFLG=1
 I $G(%IOKB(ZB))'="KEY_F2" S SUBFLG=0
 I CURRENT=COUNT S RETVAL=1
 I CURRENT<COUNT S RETVAL=CURRENT+1
 S DUMMYFLG=0
 Q RETVAL
 
GETEXTVAL(FA,FIELDNAME)
 N ITEM,RETVAL S (ITEM,RETVAL)=""
 F  S ITEM=$O(FA("ITEMS",ITEM)) Q:ITEM=""  D
 . I FA("ITEMS",ITEM,"NAME")=FIELDNAME S RETVAL=$G(FA("ITEMS",ITEM,"FIELD","VALUE"))
 Q RETVAL

GETINTVAL(FA,FIELDNAME)
 N ITEM,RETVAL S (ITEM,RETVAL)=""
 F  S ITEM=$O(FA("ITEMS",ITEM)) Q:ITEM=""  D
 . I FA("ITEMS",ITEM,"NAME")=FIELDNAME S RETVAL=$G(FA("ITEMS",ITEM,"FIELD","INTVAL"))
 Q RETVAL