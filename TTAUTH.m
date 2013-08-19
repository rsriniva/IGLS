TTAUTH
 N MA
TOP
 S MA("TITLE")="AUTHENTICATION MANAGEMENT"
 S MA("ITEMS","ADD USER")="D ADD^TTAUTH"
 S MA("ITEMS","SHOW USER")="D SHOW^TTAUTH"
 S MA("ITEMS","GRANT KEYS")="D GRANT^TTAUTH"
 S MA("ITEMS","QUIT TO MAIN MENU")="D ^TT"
 D GO^TTMENU(.MA)
 G TOP
 Q

SHOW
 Q

CHOOSEUSER(CHOSEN,CAPTION)
 N MA,USR S USR=""
 N FIRSTNAME,LASTNAME,ITM
 S MA("TITLE")="USER"
 F  S USR=$O(^TT("USERS",USR)) Q:USR=""  D
 . S FIRSTNAME=^TT("USERS",USR,"FIRSTNAME")
 . S LASTNAME=^TT("USERS",USR,"LASTNAME")
 . S ITM=FIRSTNAME_" "_LASTNAME_" ("_USR_")"
 . S MA("ITEMS",ITM)="S CUSR="""_USR_""""
 D GO^TTMENU(.MA,$G(CAPTION,""))
 M CHOSEN=^TT("USERS",CUSR)
 S INTVAL=CUSR,EXTVAL=^TT("USERS",CUSR,"FIRSTNAME")_" "_^TT("USERS",CUSR,"LASTNAME")
 Q CUSR

CHOOSEKEY(CHOSEN,CAPTION)
 N MA,KEY,KEYNAME,ITM S (ITM,KEYNAME,KEY)=""
 S MA("TITLE")="KEY"
 F  S KEY=$O(^TT("XKEYS",KEY)) Q:KEY=""  D
 . S KEYNAME=^TT("XKEYS",KEY)
 . S ITM=KEYNAME_" ("_KEY_")"
 . S MA("ITEMS",ITM)="S CKEY="""_KEY_""""
 D GO^TTMENU(.MA,$G(CAPTION,""))
 M CHOSEN=^TT("XKEYS",CKEY)
 S INTVAL=CKEY,EXTVAL=^TT("XKEYS",CKEY)
 Q CKEY

CHOOSEGRANT(CAPTION)
 N MA
 S MA("TITLE")="GRANT"
 S MA("ITEMS","VIEW ONLY")="S GRT="""_"V"_""""
 S MA("ITEMS","VIEW & MODIFY")="S GRT="""_"VM"_""""
 D GO^TTMENU(.MA,$G(CAPTION,""))
 S (INTVAL,EXTVAL)=GRT
 Q GRT

GRANT
 N USER,KEY,GRANT,TMP,MSG
 S USER=$$CHOOSEUSER(.TMP,"SELECT USER")
 S KEY=$$CHOOSEKEY(.TMP,"SELECT KEY")
 S GRANT=$$CHOOSEGRANT("SELECT GRANT")
 S ^TT("GRANTS",USER,KEY)=GRANT
 S MSG="User "_USER_" granted "_GRANT_" access for key "_KEY_"."
 D MSGBOX^TTUI(MSG,0,"USER RIGHTS MANAGEMENT")
 Q


ADD
 N FA
 S FA("TITLE")="ADD USER"
 S FA("ITEMS",1,"NAME")="USERNAME"
 S FA("ITEMS",1,"LABEL")="USERNAME:"
 S FA("ITEMS",1,"LABEL","TOP")=4
 S FA("ITEMS",1,"LABEL","LEFT")=3
 S FA("ITEMS",1,"FIELD","TOP")=4
 S FA("ITEMS",1,"FIELD","LEFT")=14
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"NAME")="PASSWORD"
 S FA("ITEMS",2,"LABEL")="PASSWORD:"
 S FA("ITEMS",2,"LABEL","TOP")=6
 S FA("ITEMS",2,"LABEL","LEFT")=3
 S FA("ITEMS",2,"FIELD","TOP")=6
 S FA("ITEMS",2,"FIELD","LEFT")=14
 S FA("ITEMS",2,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",2,"FIELD","REQUIRED")=1
 S FA("ITEMS",3,"NAME")="EMPLNO"
 S FA("ITEMS",3,"LABEL")="EMPL. NO.:"
 S FA("ITEMS",3,"LABEL","TOP")=8
 S FA("ITEMS",3,"LABEL","LEFT")=3
 S FA("ITEMS",3,"FIELD","TOP")=8
 S FA("ITEMS",3,"FIELD","LEFT")=14
 S FA("ITEMS",3,"FIELD","MAXLENGTH")=5
 S FA("ITEMS",3,"FIELD","REQUIRED")=1
 S FA("ITEMS",4,"NAME")="FIRSTNAME"
 S FA("ITEMS",4,"LABEL")="FIRST NAME:"
 S FA("ITEMS",4,"LABEL","TOP")=4
 S FA("ITEMS",4,"LABEL","LEFT")=40
 S FA("ITEMS",4,"FIELD","TOP")=4
 S FA("ITEMS",4,"FIELD","LEFT")=56
 S FA("ITEMS",4,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",4,"FIELD","REQUIRED")=1
 S FA("ITEMS",5,"NAME")="MIDDLEINITIAL"
 S FA("ITEMS",5,"LABEL")="MIDDLE INITIAL:"
 S FA("ITEMS",5,"LABEL","TOP")=6
 S FA("ITEMS",5,"LABEL","LEFT")=40
 S FA("ITEMS",5,"FIELD","TOP")=6
 S FA("ITEMS",5,"FIELD","LEFT")=56
 S FA("ITEMS",5,"FIELD","MAXLENGTH")=1
 S FA("ITEMS",5,"FIELD","REQUIRED")=0
 S FA("ITEMS",6,"NAME")="LASTNAME"
 S FA("ITEMS",6,"LABEL")="LAST NAME:"
 S FA("ITEMS",6,"LABEL","TOP")=8
 S FA("ITEMS",6,"LABEL","LEFT")=40
 S FA("ITEMS",6,"FIELD","TOP")=8
 S FA("ITEMS",6,"FIELD","LEFT")=56
 S FA("ITEMS",6,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",6,"FIELD","REQUIRED")=1
 S FA("ITEMS",7,"NAME")="GROUPS"
 S FA("ITEMS",7,"LABEL")="GROUPS:"
 S FA("ITEMS",7,"LABEL","TOP")=15
 S FA("ITEMS",7,"LABEL","LEFT")=3
 S FA("ITEMS",7,"FIELD","TOP")=15
 S FA("ITEMS",7,"FIELD","LEFT")=14
 S FA("ITEMS",7,"FIELD","MAXLENGTH")=50
 S FA("ITEMS",7,"FIELD","REQUIRED")=0
 D GO^TTFORM(.FA)
 G:CANFLG=1 CANCELADD
 N USERNAME,PASSWORD,EMPLNO,FIRSTNAME,MIDDLEINITIAL,LASTNAME
 S USERNAME=$$GETEXTVAL^TTFORM(.FA,"USERNAME")
 S PASSWORD=$$GETEXTVAL^TTFORM(.FA,"PASSWORD")
 S EMPLNO=$$GETEXTVAL^TTFORM(.FA,"EMPLNO")
 S FIRSTNAME=$$GETEXTVAL^TTFORM(.FA,"FIRSTNAME")
 S MIDDLEINITIAL=$$GETEXTVAL^TTFORM(.FA,"MIDDLEINITIAL")
 S LASTNAME=$$GETEXTVAL^TTFORM(.FA,"LASTNAME")
 D CREATE(USERNAME,PASSWORD,EMPLNO,FIRSTNAME,MIDDLEINITIAL,LASTNAME)
 D MSGBOX^TTUI("User "_FIRSTNAME_" "_LASTNAME_" added.",0,"USERS")
CANCELADD
 Q

FAUTH
 N FA,RETVAL S RETVAL=0
 S FA("TITLE")="SECURITY VERIFICATION"
 S FA("ITEMS",1,"NAME")="USERNAME"
 S FA("ITEMS",1,"LABEL")="USERNAME:"
 S FA("ITEMS",1,"LABEL","TOP")=8
 S FA("ITEMS",1,"LABEL","LEFT")=30
 S FA("ITEMS",1,"FIELD","TOP")=8
 S FA("ITEMS",1,"FIELD","LEFT")=40
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"NAME")="PASSWORD"
 S FA("ITEMS",2,"LABEL")="PASSWORD:"
 S FA("ITEMS",2,"LABEL","TOP")=10
 S FA("ITEMS",2,"LABEL","LEFT")=30
 S FA("ITEMS",2,"FIELD","TOP")=10
 S FA("ITEMS",2,"FIELD","LEFT")=40
 S FA("ITEMS",2,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",2,"FIELD","REQUIRED")=1
 D GO^TTFORM(.FA)
 G:CANFLG=1 CANCELFAUTH
 N UN,PW 
 S UN=$$GETEXTVAL^TTFORM(.FA,"USERNAME")
 S PW=$$GETEXTVAL^TTFORM(.FA,"PASSWORD")
 S RETVAL=$$AUTH(UN,PW)
 I RETVAL=1 M TTUSER=^TT("USERS",UN) S TTAUTHED=1
 E  S TTUSER="",TTAUTHED=0 D MSGBOX^TTUI("Invalid username or password.",0,"ERROR")
CANCELFAUTH
 Q

AUTH(UN,PW)
 N RETVAL S RETVAL=0
 I ($G(^TT("USERS",UN))=UN)&($G(^TT("USERS",UN,"PASSWORD"))=PW) S RETVAL=1
 Q RETVAL

CREATE(UN,PW,EN,FN,MI,LN)
 TS
 S ^TT("USERS",UN)=UN
 S ^TT("USERS",UN,"PASSWORD")=PW
 S ^TT("USERS",UN,"EMPLNO")=EN
 S ^TT("USERS",UN,"FIRSTNAME")=FN
 S ^TT("USERS",UN,"MIDDLEINITIAL")=MI
 S ^TT("USERS",UN,"LASTNAME")=LN
 TC
 Q