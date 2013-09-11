TTACCOUNT
 N MA
TOP
 S MA("TITLE")="GENERAL LEDGER SYSTEM"
 ;S MA("ITEMS","IMPORT DATA FROM CSV")="D ICSVACCT^TTIMPORT"
 ;S MA("ITEMS","IMPORT DATA FROM CSV","KEY")="XKGLS:M"
 S MA("ITEMS","COMBINED JOURNAL")="D COMBINED^TTJOURNAL"
 S MA("ITEMS","COMBINED JOURNAL","KEY")="XKGLS:M"
 S MA("ITEMS","ADD ACCOUNT")="D ADD^TTACCOUNT"
 S MA("ITEMS","JOURNAL")="D INITJOURNAL^TTACCOUNT"
 S MA("ITEMS","BALANCE SHEET")="D INITBALSHEET^TTACCOUNT"
 S MA("ITEMS","TRANSACTION SEARCH")="D ITRNSRCH^TTACCOUNT"
 S MA("ITEMS","TRANSACTION SEARCH","KEY")="XKGLS:V"
 ;S MA("ITEMS","CLOSE BOOKS")="D ICLSBOOK^TTACCOUNT"
 ;S MA("ITEMS","CLOSE BOOKS","KEY")="XKGLS:M"
 ;S MA("ITEMS","TRIAL BALANCE")="D TRIALBAL^TTACCOUNT"
 S MA("ITEMS","ADD NEW ACCOUNTING PERIOD")="D ADDPERIOD^TTACCOUNT"
 S MA("ITEMS","SET CURRENT ACCOUNTING PERIOD")="D SETCURRENTPERIOD^TTACCOUNT"
 S MA("ITEMS","POST MANUAL TRANSACTION")="D INITPOST^TTACCOUNT"
 S MA("ITEMS","CHART OF ACCOUNTS")="D COA^TTACCOUNT"
 S MA("ITEMS","INCOME STATEMENT")="D INITINCOMESTMT^TTACCOUNT"
 S MA("ITEMS","ADD ACCOUNT","KEY")="XKGLS:M"
 S MA("ITEMS","JOURNAL","KEY")="XKGLS:V"
 S MA("ITEMS","BALANCE SHEET","KEY")="XKGLS:V"
 ;S MA("ITEMS","TRIAL BALANCE","KEY")="XKGLS:V"
 S MA("ITEMS","ADD NEW ACCOUNTING PERIOD","KEY")="XKGLS:M"
 S MA("ITEMS","SET CURRENT ACCOUNTING PERIOD","KEY")="XKGLS:M"
 S MA("ITEMS","POST MANUAL TRANSACTION","KEY")="XKGLS:M"
 S MA("ITEMS","CHART OF ACCOUNTS","KEY")="XKGLS:V"
 S MA("ITEMS","INCOME STATEMENT","KEY")="XKGLS:V"
 S MA("ITEMS","QUIT TO MAIN MENU")="D ^TT"
 D GO^TTMENU(.MA)
 G TOP
 Q

ITRNSRCH
 N FA
 S FA("TITLE")="TRANSACTION SEARCH"
 S FA("ITEMS",1,"NAME")="TERMS"
 S FA("ITEMS",1,"LABEL")="SEARCH TERMS: "
 S FA("ITEMS",1,"LABEL","TOP")=8
 S FA("ITEMS",1,"LABEL","LEFT")=40-$L(FA("ITEMS",1,"LABEL"))
 S FA("ITEMS",1,"FIELD","TOP")=8
 S FA("ITEMS",1,"FIELD","LEFT")=40
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=35
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 D GO^TTFORM(.FA)
 N TERMS S TERMS=$$GETEXTVAL^TTFORM(.FA,"TERMS")
 N RESULTS,PATSRCH,RM,MCNT,SUB S MCNT=0,SUB=""
 S PATSRCH=$$CONFIRM^TTUI("IS THIS A PATTERN SEARCH?")
 D INIT^TT,CAPTION^TTUI("SEARCH RESULTS")
 S MCNT=$$TRANSRCH(TERMS,PATSRCH,.RESULTS)
 D VIEW^TTJOURNAL(.RESULTS,"TRANSACTION SEARCH RESULTS")
 Q

TRANSRCH(TERMS,PATSRCH,RESULTS)
 N JSEQ,MCNT S JSEQ="",MCNT=0
 F  S JSEQ=$O(^TT("JNL",JSEQ)) Q:JSEQ=""  D
 . I PATSRCH="Y" D
 . . I ^TT("JNL",JSEQ)?TERMS D
 . . . S MCNT=MCNT+1,RESULTS(JSEQ)=^TT("JNL",JSEQ)
 . E  D
 . . I ^TT("JNL",JSEQ)[TERMS D
 . . . S MCNT=MCNT+1,RESULTS(JSEQ)=^TT("JNL",JSEQ) 
 Q MCNT

 ;
 ; 1) Close revenue accounts to income summary
 ; 2) Close expense accounts to income summary
 ; 3) Close income summary to owner's equity account
 ; 4) Close draw account to owner's equity account
 ;
ICLSBOOK
 N ISUMACCT,DRAWACCT,EQTYACCT,ODRWACCT,TMP,NEXTPER,CONF,CURPER
 D INIT^TT,CAPTION^TTUI("CLOSE BOOKS")
 S CURPER=^TT("COMPANY","CURRENTPERIOD")
 S ISUMACCT=$$CHOOSE(.TMP,"CHOOSE INCOME SUMMARY ACCOUNT")
 S EQTYACCT=$$CHOOSE(.TMP,"CHOOSE OWNER EQUITY ACCOUNT")
 S ODRWACCT=$$CHOOSE(.TMP,"CHOOSE OWNER DRAW ACCOUNT")
 S NEXTPER=$$CHOOSEPERIOD
 S CONF=$$CONFIRM^TTUI("ARE YOU SURE YOU WISH TO CLOSE BOOKS?")
 I CONF="Y" D 
 . D CLSBOOKS(NEXTPER,ISUMACCT,EQTYACCT,ODRWACCT)
 . D MSGBOX^TTUI("ACCOUNTING PERIOD "_CURPER_" HAS BEEN CLOSED.",0,"CLOSE BOOKS") 
 Q

CLSBOOKS(NEXTPER,ISUMACCT,EQTYACCT,ODRWACCT)
 N REVACCTS,EXPACCTS,CURPER,ANUM,CLSDATE
 N REVBAL,EXPBAL S (REVBAL,EXPBAL)=0
 N EQTYBAL,ODRWBAL
 S CURPER=^TT("COMPANY","CURRENTPERIOD")
 S EQTYBAL=$$BALANCE(EQTYACCT,CURPER)
 S ODRWBAL=$$BALANCE(ODRWACCT,CURPER)
 S CLSDATE="12/31/"_CURPER
 D BYTYPE("REVENUE",.REVACCTS)
 D BYTYPE("EXPENSE",.EXPACCTS)
 M ^TT("BACKUPS","ACCT",$H)=^TT("ACCT")
 ; CLOSE REVENUE ACCOUNTS TO INCOME SUMMARY ACCOUNT
 S ANUM=""
 F  S ANUM=$O(REVACCTS(ANUM)) Q:ANUM=""  D
 . S REVBAL=$$BALANCE(ANUM,CURPER)
 . D POST(CLSDATE,REVBAL,ISUMACCT,ANUM,CURPER,"CLOSING ENTRY","CLOSING")
 ; CLOSE EXPENSE ACCOUNTS TO INCOME SUMMARY ACCOUNT
 S ANUM=""
 F  S ANUM=$O(EXPACCTS(ANUM)) Q:ANUM=""  D
 . S EXPBAL=$$BALANCE(ANUM,CURPER)
 . D POST(CLSDATE,EXPBAL,ANUM,ISUMACCT,CURPER,"CLOSING ENTRY","CLOSING")
 ; CLOSE INCOME SUMMARY ACCOUNT TO OWNER'S EQUITY ACCOUNT
 N INCBAL S INCBAL=$$BALANCE(ISUMACCT,CURPER)
 D POST(CLSDATE,INCBAL,EQTYACCT,ISUMACCT,CURPER,"CLOSING ENTRY","CLOSING")
 ; CLOSE DRAW ACCOUNT TO OWNER'S EQUITY ACCOUNT
 D POST(CLSDATE,ODRWBAL,ODRWACCT,EQTYACCT,CURPER,"CLOSING ENTRY","CLOSING")
 Q  

ATYPE(ACCOUNT)
 Q $G(^TT("ACCT",ACCOUNT,"TYPE"))

OPER(ACCOUNT,ACTION)
 N ATYPE
 S ATYPE=^TT("ACCT",ACCOUNT,"TYPE")
 Q ^TT("ALKP",ATYPE,ACTION) 

ISCREDIT(CREDOP,AMOUNT)
 N RET S RET=""
 N SIGN S SIGN=""
 I AMOUNT<0 S SIGN="-"
 I AMOUNT>0 S SIGN="+"
 I SIGN=CREDOP S RET=1
 I SIGN'=CREDOP S RET=0
 Q RET

ISDEBIT(DEBOP,AMOUNT)
 N RET S RET=""
 N SIGN S SIGN=""
 I AMOUNT<0 S SIGN="-"
 I AMOUNT>0 S SIGN="+"
 I SIGN=DEBOP S RET=1
 I SIGN'=DEBOP S RET=0
 Q RET

COA
 N ANUM,FILE S ANUM=""
 D OPENTEMP^TTIO(.FILE)
 W !,"CHART OF ACCOUNTS"
 W !,"=================",!,!
 W "ACCT",?8,"DESCRIPTION",?49,"TYPE",?69,"BALANCE",!
 F I=1:1:80 W "-"
 W !
 F  S ANUM=$O(^TT("ACCT",ANUM)) Q:ANUM=""  D
 . W ANUM,?8
 . W $E(^TT("ACCT",ANUM),1,39),?49
 . W $E(^TT("ACCT",ANUM,"TYPE"),1,29),?69
 . W "$",$J($$BALANCE^TTACCOUNT(ANUM,^TT("COMPANY","CURRENTPERIOD")),10,2),!
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,"CHART OF ACCOUNTS")
 Q

SETUP
 I $G(^TT("COMPANY","JSEQ"))="" S ^TT("COMPANY","JSEQ")=100
 S ^TT("ALKP","ASSET","CREDIT")="-"
 S ^TT("ALKP","ASSET","DEBIT")="+"
 S ^TT("ALKP","LIABILITY","CREDIT")="+"
 S ^TT("ALKP","LIABILITY","DEBIT")="-"
 S ^TT("ALKP","REVENUE","CREDIT")="+"
 S ^TT("ALKP","REVENUE","DEBIT")="-"
 S ^TT("ALKP","EXPENSE","CREDIT")="-"
 S ^TT("ALKP","EXPENSE","DEBIT")="+"
 S ^TT("ALKP","EQUITY","CREDIT")="+"
 S ^TT("ALKP","EQUITY","DEBIT")="-"
 Q

INITINCOMESTMT
 N FROM,TO,FILE
 D CHOOSE^TTDATE($ZDATE($H),"FROM DATE")
 S FROM=INTVAL
 D CHOOSE^TTDATE($ZDATE($H),"TO DATE")
 S TO=INTVAL
 D OPENTEMP^TTIO(.FILE)
 D INCOMESTMT^TTACCOUNT(FROM,TO)
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,"INCOME STATEMENT")
 Q

INCOMESTMT(FROMDATE,TODATE)
 N REVACCTS,EXPACCTS,CURPERIOD
 N TOTREV,TOTEXP,ANUM S (TOTREV,TOTEXP)=0,ANUM=""
 S CURPERIOD=^TT("COMPANY","CURRENTPERIOD")
 D BYTYPE("REVENUE",.REVACCTS)
 D BYTYPE("EXPENSE",.EXPACCTS)
 W !,"INCOME STATEMENT",!
 W "FROM ",FROMDATE," TO ",TODATE,!
 F I=1:1:80 W "-"
 W !,!
 W "REVENUES & GAINS",!
 W "----------------",!
 N TBAL
 F  S ANUM=$O(REVACCTS(ANUM)) Q:ANUM=""  D
 . S TBAL=$$BALANCE(ANUM,CURPERIOD)
 . S TOTREV=TOTREV+TBAL
 . W ?2,^TT("ACCT",ANUM),?30,"$",$J(TBAL,10,2),!
 W ?4,"TOTAL REVENUES",?30,"$",$J(TOTREV,10,2)
 W !,!
 W "EXPENSES & LOSSES",!
 W "-----------------",!
 N TBAL
 F  S ANUM=$O(EXPACCTS(ANUM)) Q:ANUM=""  D
 . S TBAL=$$BALANCE(ANUM,CURPERIOD)
 . S TOTEXP=TOTEXP+TBAL
 . W ?2,^TT("ACCT",ANUM),?30,"$",$J(TBAL,10,2),!
 W ?4,"TOTAL EXPENSES",?30,"$",$J(TOTEXP,10,2),!,!
 W "NET INCOME",?30,"$",$J(TOTREV-TOTEXP,10,2),!,!
 Q

ADD
 N FA
 S FA("TITLE")="ADD ACCOUNT"
 S FA("ITEMS",1,"NAME")="NUMBER"
 S FA("ITEMS",1,"LABEL")="NUMBER:"
 S FA("ITEMS",1,"LABEL","TOP")=4
 S FA("ITEMS",1,"LABEL","LEFT")=32
 S FA("ITEMS",1,"FIELD","TOP")=4
 S FA("ITEMS",1,"FIELD","LEFT")=40
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=10
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"NAME")="NAME"
 S FA("ITEMS",2,"LABEL")="NAME:"
 S FA("ITEMS",2,"LABEL","TOP")=6
 S FA("ITEMS",2,"LABEL","LEFT")=34
 S FA("ITEMS",2,"FIELD","TOP")=6
 S FA("ITEMS",2,"FIELD","LEFT")=40
 S FA("ITEMS",2,"FIELD","MAXLENGTH")=30
 S FA("ITEMS",2,"FIELD","REQUIRED")=1
 S FA("ITEMS",3,"NAME")="TYPE"
 S FA("ITEMS",3,"LABEL")="TYPE:"
 S FA("ITEMS",3,"LABEL","TOP")=8
 S FA("ITEMS",3,"LABEL","LEFT")=34
 S FA("ITEMS",3,"FIELD","TOP")=8
 S FA("ITEMS",3,"FIELD","LEFT")=40
 S FA("ITEMS",3,"FIELD","MAXLENGTH")=10
 S FA("ITEMS",3,"FIELD","REQUIRED")=1
 S FA("ITEMS",3,"FIELD","ONFOCUS")="D PICKTYPE^TTACCOUNT"
 S FA("ITEMS",4,"NAME")="PERSISTENCE"
 S FA("ITEMS",4,"LABEL")="PERSISTENCE:"
 S FA("ITEMS",4,"LABEL","TOP")=10
 S FA("ITEMS",4,"LABEL","LEFT")=27
 S FA("ITEMS",4,"FIELD","TOP")=10
 S FA("ITEMS",4,"FIELD","LEFT")=40
 S FA("ITEMS",4,"FIELD","MAXLENGTH")=10
 S FA("ITEMS",4,"FIELD","REQUIRED")=1
 S FA("ITEMS",4,"FIELD","ONFOCUS")="D PICKPERS^TTACCOUNT"
 D GO^TTFORM(.FA)
 G:CANFLG=1 CANCELADD
 N NUM,NAME,TYPE,PERS,ISCHECKING S ISCHECKING="N"
 S NUM=$$GETEXTVAL^TTFORM(.FA,"NUMBER")
 S NAME=$$GETEXTVAL^TTFORM(.FA,"NAME")
 S TYPE=$$GETINTVAL^TTFORM(.FA,"TYPE")
 S PERS=$$GETINTVAL^TTFORM(.FA,"PERSISTENCE")
 S ISCHECKING=$$CONFIRM^TTUI("IS THIS A CHECKING ACCOUNT?")
 D CREATE^TTACCOUNT(NUM,NAME,TYPE,PERS,ISCHECKING) 
CANCELADD
 Q

PICKTYPE
 N MA S MA("TITLE")="ACCOUNT TYPE"
 S MA("ITEMS","ASSET")="S TYPE="""_"ASSET"_""""
 S MA("ITEMS","EQUITY")="S TYPE="""_"EQUITY"_""""
 S MA("ITEMS","LIABILITY")="S TYPE="""_"LIABILITY"_""""
 S MA("ITEMS","REVENUE/INCOME")="S TYPE="""_"REVENUE"_""""
 S MA("ITEMS","EXPENSE")="S TYPE="""_"EXPENSE"_""""
 D GO^TTMENU(.MA)
 S (INTVAL,EXTVAL)=TYPE
 Q

PICKPERS
 N MA S MA("TITLE")="ACCOUNT PERSISTENCE"
 S MA("ITEMS","TEMPORARY ACCOUNT")="S PERS="""_"TEMPORARY"_""""
 S MA("ITEMS","PERMANENT (REAL) ACCOUNT")="S PERS="""_"PERMANENT"_""""
 D GO^TTMENU(.MA)
 S (INTVAL,EXTVAL)=PERS
 Q

CHOOSE(CHOSEN,CAPTION)
 ;
 ; INITIALIZE ONE-TIME DATA STRUCTURES
 ;
 N TYPES,CUREL,CURTYPE,ACCTS,CURPAGE,TOTPAGES,TOTACCTS
 N PA,PGIDX,PGNUM,CURACCT,OIDX
 N ANUM,ANAME,SEQ,BALANCE
 N EVENT,KEY
 S CUREL="TYPES",CURTYPE=4,CURPAGE=1,CURACCT=1
 S TYPES(4)="ASSET"
 S TYPES(5)="EQUITY"
 S TYPES(6)="EXPENSE"
 S TYPES(7)="LIABILITY"
 S TYPES(8)="REVENUE"
 S TYPES(9)="CLEARING"
REDISPLAY
 K PA
 K ACCTS
 ;
 ; GET THE ACCOUNTS FOR THE CURRENTLY SELECTED ACCOUNT TYPE
 ;
 D BYTYPE(TYPES(CURTYPE),.ACCTS)
 S (TOTPAGES,TOTACCTS)=0,ANUM=""
 F  S ANUM=$O(ACCTS(ANUM)) Q:ANUM=""  D
 . S TOTACCTS=TOTACCTS+1
 S TOTPAGES=TOTACCTS/19
 I $L(TOTPAGES,".")>1 S TOTPAGES=$P(TOTPAGES,".",1)+1
 ;
 ; DIVIDE THE RETURNED ACCOUNTS INTO PAGES 
 ;
 S (PGIDX,PGNUM)=1,ANUM="",OIDX=1
 F  S ANUM=$O(ACCTS(ANUM)) Q:ANUM=""  D
 . S PA(PGNUM,OIDX)=ANUM
 . I PGIDX=19 S PGNUM=PGNUM+1,PGIDX=1 E  S PGIDX=PGIDX+1
 . S OIDX=OIDX+1
 ;
 ; SET UP THE UI FRAMES
 ; 
 D INIT^TT
 I $G(CAPTION)="" D 
 . D CAPTION^TTUI("SELECT ACCOUNT")
 E  D
 . D CAPTION^TTUI(CAPTION)
 F I=3:1:22  D
 . D SETCOLOR^TTRNSI("GREEN","BLACK")
 . D LOCATE^TTRNSI(I,15) 
 . W BOX("V")
 D LOCATE^TTRNSI(2,15) W BOX("TT")
 D LOCATE^TTRNSI(23,15) W BOX("BT")
 ;
 ; DRAW THE ACCOUNT TYPES LIST 
 ;
 D LOCATE^TTRNSI(3,1),SETCOLOR^TTRNSI("BLACK","GREEN")
 W " ACCOUNT TYPE " D SETCOLOR^TTRNSI("GREEN","BLACK")
 F I=4:1:9  D
 . D LOCATE^TTRNSI(I,3)
 . I CURTYPE=I D
 . . D SETCOLOR^TTRNSI("GREEN","BLACK")
 . . I CUREL="TYPES" D SETATTR^TTRNSI("BRIGHT")
 . E  D
 . . D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 . W TYPES(I) 
 . I CURTYPE=I D
 . . D LOCATE^TTRNSI(I,1) W ">>" 
 ;
 ; DRAW THE LIST OF ACCOUNTS
 ;
 D LOCATE^TTRNSI(3,16),SETCOLOR^TTRNSI("BLACK","GREEN"),ERASETOEOL^TTRNSI
 D LOCATE^TTRNSI(3,18) W "NUM"
 D LOCATE^TTRNSI(3,24) W "NAME"
 D LOCATE^TTRNSI(3,62) W "SEQ NO." 
 D LOCATE^TTRNSI(3,72) W "BALANCE"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 S OIDX="",LINE=4
 F  S OIDX=$O(PA(CURPAGE,OIDX)) Q:OIDX=""  D
 . S ANUM=PA(CURPAGE,OIDX) 
 . S NAME=^TT("ACCT",ANUM)
 . S SEQ=^TT("ACCT",ANUM,"SEQ")
 . S BALANCE=$$BALANCE(ANUM,"")
 . I CUREL="ACCOUNTS" D
 . . I OIDX=CURACCT D SETCOLOR^TTRNSI("GREEN","BLACK"),SETATTR^TTRNSI("BRIGHT")
 . . I OIDX'=CURACCT D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 . I OIDX=CURACCT D 
 . . D LOCATE^TTRNSI(LINE,16) W ">>"
 . D LOCATE^TTRNSI(LINE,18) W ANUM
 . D LOCATE^TTRNSI(LINE,24) W NAME
 . D LOCATE^TTRNSI(LINE,62) W SEQ
 . D LOCATE^TTRNSI(LINE,72) W BALANCE
 . S LINE=LINE+1
 I TOTACCTS=0 D
 . D LOCATE^TTRNSI(12,35) W "NO ACCOUNTS OF THIS TYPE"
 ;
 ; DRAW THE FOOTER
 ;
 D LOCATE^TTRNSI(24,1),SETCOLOR^TTRNSI("MAGENTA","BLACK"),SETATTR^TTRNSI("BRIGHT")
 W "TAB TO SWITCH ELEMENTS; F2 SUBMITS"
 D SETATTR^TTRNSI("RESET")
 D HOME^TTRNSI
 ;
 ; PROCESS INPUT
 ;
 S QUITFLG=0
 S KEY=$$GETCH^%TERMIO(.EVENT)
 I KEY="KEY_DOWN" D
 . I CUREL="TYPES" D
 . . I CURTYPE<9 S CURTYPE=CURTYPE+1,CURACCT=1
 . I CUREL="ACCOUNTS" D
 . . I CURACCT<TOTACCTS S CURACCT=CURACCT+1
 I KEY="KEY_UP" D
 . I CUREL="TYPES" D
 . . I CURTYPE>4 S CURTYPE=CURTYPE-1,CURACCT=1
 . I CUREL="ACCOUNTS" D
 . . I CURACCT>1 S CURACCT=CURACCT-1
 I KEY="KEY_LEFT" D
 . I CURPAGE>1 S CURPAGE=CURPAGE-1
 I KEY="KEY_RIGHT" D
 . I CURPAGE<TOTPAGES S CURPAGE=CURPAGE+1
 I KEY="KEY_ENTER" D
 . S (INTVAL,EXTVAL)=CURACCT,QUITFLG=1
 I KEY="KEY_F2" D
 . S INTVAL=PA(CURPAGE,CURACCT),QUITFLG=1
 . S EXTVAL=^TT("ACCT",INTVAL)
 I KEY="KEY_TAB" D
 . I CUREL="TYPES" D
 . . S CUREL="ACCOUNTS"
 . E  D
 . . S CUREL="TYPES"
 G:QUITFLG=0 REDISPLAY
 M CHOSEN=^TT("ACCT",INTVAL)
 Q INTVAL

BYTYPE(TYPE,RETURNARR)
 N NUM S NUM=""
 N OA
 F  S NUM=$O(^TT("ACCT",NUM)) Q:NUM=""  D
 . I ^TT("ACCT",NUM,"TYPE")=TYPE S RETURNARR(NUM)=""
 Q

INITJOURNAL
 N ACCOUNT,PERIOD,TMP,FILE
 S ACCOUNT=$$CHOOSE^TTACCOUNT(.TMP)
 S PERIOD=$$CHOOSEPERIOD^TTACCOUNT
 D OPENTEMP^TTIO(.FILE)
 D JOURNAL(FILE,ACCOUNT,PERIOD)
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,"JOURNAL")
 Q

JOURNAL(FILE,ACCOUNT,PERIOD)
 N SEQ,JNL,JSEQ,DATE,CREDOP,DEBOP,CHKNUM S (SEQ,JNL,JSEQ)=""
 N DEBIT,CREDIT,BAL,AMT S (DEBIT,CREDIT,BAL,AMT)=0
 S (CREDIT,DEBIT)=""
 U FILE
 W !,!
 W "SEQ",?7,"DATE",?18,"JOURNAL",?47,"DEBIT",?59,"CREDIT",?69,"CHECK #",!
 F I=1:1:80 W "-"
 W !
 F  S SEQ=$O(^TT("ACCT",ACCOUNT,PERIOD,SEQ)) Q:SEQ=""  D
 . S JSEQ=^TT("ACCT",ACCOUNT,PERIOD,SEQ,"JSEQ")
 . S AMT=^TT("ACCT",ACCOUNT,PERIOD,SEQ)
 . S JNL=$E(^TT("JNL",JSEQ),1,27)
 . S CHKNUM=$G(^TT("ACCT",ACCOUNT,PERIOD,SEQ,"CHKNUM"))
 . S DATE=^TT("ACCT",ACCOUNT,PERIOD,SEQ,"DATE")
 . S CREDOP=$$OPER^TTACCOUNT(ACCOUNT,"CREDIT")
 . S DEBOP=$$OPER^TTACCOUNT(ACCOUNT,"DEBIT")
 . W SEQ,?7,DATE,?18,JNL,?47
 . I $$ISDEBIT(DEBOP,AMT)=1 S DEBIT=AMT E  S DEBIT=""
 . I $$ISCREDIT(CREDOP,AMT)=1 S CREDIT=-AMT E  S CREDIT=""
 . W DEBIT,?59,CREDIT,?69,CHKNUM,!
 . S (DEBIT,CREDIT)=""
 C FILE
 U $P
 Q

INITBALSHEET
 N PERIOD,FILE S PERIOD=$$CHOOSEPERIOD^TTACCOUNT
 D OPENTEMP^TTIO(.FILE)
 D BALSHEET^TTACCOUNT(FILE,PERIOD)
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,"BALANCE SHEET")
 Q

BALSHEET(FILE,PERIOD)
 N ASSETS,LIABILITIES,EQUITY,ANUM S ANUM=""
 N TOTASS,TOTLIAB,TOTEQU,TBAL S (TOTASS,TOTLIAB,TOTEQU,TBAL)=0
 U FILE
 D BYTYPE^TTACCOUNT("ASSET",.ASSETS)
 D BYTYPE^TTACCOUNT("LIABILITY",.LIABILITIES)
 D BYTYPE^TTACCOUNT("EQUITY",.EQUITY)
 W ^TT("COMPANY","NAME"),!
 W "BALANCE SHEET AS OF "_$ZD($H),!
 F I=1:1:80 W "-"
 W !,!,!
 W "ASSETS",!
 W "------",!,!
 F  S ANUM=$O(ASSETS(ANUM)) Q:ANUM=""  D
 . N ANAME S ANAME=^TT("ACCT",ANUM)
 . S TBAL=$$BALANCE^TTACCOUNT(ANUM,PERIOD)
 . S TOTASS=TOTASS+TBAL
 . W ?4,ANAME,?60,"$",$J(TBAL,10,2),!
 W ?6,"TOTAL ASSETS",?60,"$",$J(TOTASS,10,2),!,!,!
 W "LIABILITIES",!
 W "-----------",!,!
 F  S ANUM=$O(LIABILITIES(ANUM)) Q:ANUM=""  D
 . N ANAME S ANAME=^TT("ACCT",ANUM)
 . S TBAL=$$BALANCE^TTACCOUNT(ANUM,PERIOD)
 . S TOTLIAB=TOTLIAB+TBAL
 . W ?4,ANAME,?60,"$",$J(TBAL,10,2),!
 W ?6,"TOTAL LIABILITIES",?60,"$",$J(TOTLIAB,10,2),!,!,!
 W "STOCKHOLDERS' EQUITY",!
 W "--------------------",!,!
 N OPEQU S OPEQU=TOTASS-TOTLIAB
 W ?4,"STOCKHOLDERS' EQUITY",?60,"$",$J(OPEQU,10,2),!
 S TOTEQU=OPEQU
 F  S ANUM=$O(EQUITY(ANUM)) Q:ANUM=""  D
 . N ANAME S ANAME=^TT("ACCT",ANUM)
 . S TBAL=$$BALANCE^TTACCOUNT(ANUM,PERIOD)
 . S TOTEQU=TOTEQU+TBAL
 . W ?4,ANAME,?60,"$",$J(TBAL,10,2),!
 ;W ?6,"TOTAL STOCKHOLDERS' EQUITY",?60,"$",$J(TOTEQU,10,2),!,!,!
 W "TOTAL LIABILITIES & STOCKHOLDER'S EQUITY",?60,"$",$J(OPEQU+TOTLIAB,10,2)
 C FILE
 U $P
 Q

BALANCE(ACCOUNT,PEROLD)
 N SEQ S SEQ=""
 N SUM S SUM=0
 N PERIOD S PERIOD=""
 F  S PERIOD=$O(^TT("ACCT",ACCOUNT,PERIOD)) Q:PERIOD=""  D
 . S SEQ=""
 . F  S SEQ=$O(^TT("ACCT",ACCOUNT,PERIOD,SEQ)) Q:SEQ=""  D
 . . S SUM=SUM+^TT("ACCT",ACCOUNT,PERIOD,SEQ)
 Q SUM

CREATE(NUM,NAME,TYPE,PERS,ISCHECKING)
 TS
 S ^TT("ACCT",NUM)=NAME
 S ^TT("ACCT",NUM,"TYPE")=TYPE
 S ^TT("ACCT",NUM,"CHECKING")=ISCHECKING
 S ^TT("ACCT",NUM,"SEQ")=100
 S ^TT("ACCT",NUM,"PERSISTENCE")=PERS
 TC
 Q

SETCURRENTPERIOD
 W "SET CURRENT ACCOUNTING PERIOD:",!
 S ^TT("COMPANY","CURRENTPERIOD")=$$CHOOSEPERIOD^TTACCOUNT
 Q

CHOOSEPERIOD()
 N MA,PNAME,CURNAME S PNAME=""
 S MA("TITLE")="ACCOUNTING PERIOD"
 S MA("DEFAULT")=^TT("COMPANY","CURRENTPERIOD")
 F  S PNAME=$O(^TT("ACCTPERIOD",PNAME)) Q:PNAME=""  D
 . S MA("ITEMS",PNAME)="S CURNAME="""_PNAME_""""
 D GO^TTMENU(.MA)
 S EXTVAL=CURNAME
 S INTVAL=CURNAME
 Q CURNAME

ADDPERIOD
 N PNAME
 W !,"RESPOND NEW ACCOUNTING PERIOD: "
 R PNAME
 S ^TT("ACCTPERIOD",PNAME)=""
 Q

INITPOST
 N FA,ANOTHER,CONFIRM
ANOTHERPOST
 S CONFIRM="N"
 S FA("TITLE")="POST MANUAL TRANSACTION"
 S FA("ITEMS",1,"NAME")="AMOUNT"
 S FA("ITEMS",1,"LABEL")="AMOUNT:"
 S FA("ITEMS",1,"LABEL","TOP")=4
 S FA("ITEMS",1,"LABEL","LEFT")=32
 S FA("ITEMS",1,"FIELD","TOP")=4
 S FA("ITEMS",1,"FIELD","LEFT")=40
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=15
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"NAME")="DATE"
 S FA("ITEMS",2,"LABEL")="TRANSACTION DATE:"
 S FA("ITEMS",2,"LABEL","TOP")=6
 S FA("ITEMS",2,"LABEL","LEFT")=22
 S FA("ITEMS",2,"FIELD","TOP")=6
 S FA("ITEMS",2,"FIELD","LEFT")=40
 S FA("ITEMS",2,"FIELD","MAXLENGTH")=10
 S FA("ITEMS",2,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"FIELD","ONFOCUS")="D CHOOSE^TTDATE($ZDATE($H),""CHOOSE TRANSACTION DATE"")"
 S FA("ITEMS",3,"NAME")="JOURNAL"
 S FA("ITEMS",3,"LABEL")="JOURNAL:"
 S FA("ITEMS",3,"LABEL","TOP")=8
 S FA("ITEMS",3,"LABEL","LEFT")=31
 S FA("ITEMS",3,"FIELD","TOP")=8
 S FA("ITEMS",3,"FIELD","LEFT")=40
 S FA("ITEMS",3,"FIELD","MAXLENGTH")=30
 S FA("ITEMS",3,"FIELD","REQUIRED")=1
 S FA("ITEMS",4,"NAME")="PERIOD"
 S FA("ITEMS",4,"LABEL")="ACCOUNTING PERIOD: "
 S FA("ITEMS",4,"LABEL","TOP")=10
 S FA("ITEMS",4,"LABEL","LEFT")=21
 S FA("ITEMS",4,"FIELD","TOP")=10
 S FA("ITEMS",4,"FIELD","LEFT")=40
 S FA("ITEMS",4,"FIELD","MAXLENGTH")=4
 S FA("ITEMS",4,"FIELD","REQUIRED")=1
 S FA("ITEMS",4,"FIELD","ONFOCUS")="S I=$$CHOOSEPERIOD^TTACCOUNT" 
 S FA("ITEMS",5,"NAME")="CREDIT"
 S FA("ITEMS",5,"LABEL")="CREDIT ACCOUNT:"
 S FA("ITEMS",5,"LABEL","TOP")=14
 S FA("ITEMS",5,"LABEL","LEFT")=24
 S FA("ITEMS",5,"FIELD","TOP")=14
 S FA("ITEMS",5,"FIELD","LEFT")=40
 S FA("ITEMS",5,"FIELD","MAXLENGTH")=30
 S FA("ITEMS",5,"FIELD","REQUIRED")=1
 S FA("ITEMS",5,"FIELD","ONFOCUS")="S I=$$CHOOSE^TTACCOUNT(.B,""CHOOSE CREDIT ACCOUNT"")"
 S FA("ITEMS",6,"NAME")="CHKNUM"
 S FA("ITEMS",6,"LABEL")="CHECK NUMBER:"
 S FA("ITEMS",6,"LABEL","TOP")=16
 S FA("ITEMS",6,"LABEL","LEFT")=40-$L(FA("ITEMS",6,"LABEL"))-1
 S FA("ITEMS",6,"FIELD","TOP")=16
 S FA("ITEMS",6,"FIELD","LEFT")=40
 S FA("ITEMS",6,"FIELD","MAXLENGTH")=10
 S FA("ITEMS",6,"FIELD","REQUIRED")=0
 S FA("ITEMS",7,"NAME")="DEBIT"
 S FA("ITEMS",7,"LABEL")="DEBIT ACCOUNT:"
 S FA("ITEMS",7,"LABEL","TOP")=18
 S FA("ITEMS",7,"LABEL","LEFT")=25
 S FA("ITEMS",7,"FIELD","TOP")=18
 S FA("ITEMS",7,"FIELD","LEFT")=40
 S FA("ITEMS",7,"FIELD","MAXLENGTH")=30
 S FA("ITEMS",7,"FIELD","REQUIRED")=1
 S FA("ITEMS",7,"FIELD","ONFOCUS")="S I=$$CHOOSE^TTACCOUNT(.B,""CHOOSE DEBIT ACCOUNT"")"
 D GO^TTFORM(.FA)
 G:CANFLG=1 CANCELPOST
 N CREDIT,DEBIT,DATE,AMT,JNL,PERIOD,CHKNUM
 S DATE=$$GETEXTVAL^TTFORM(.FA,"DATE")
 S AMT=$$GETEXTVAL^TTFORM(.FA,"AMOUNT")
 S CREDIT=$$GETINTVAL^TTFORM(.FA,"CREDIT")
 S DEBIT=$$GETINTVAL^TTFORM(.FA,"DEBIT")
 S PERIOD=$$GETEXTVAL^TTFORM(.FA,"PERIOD")
 S JNL=$$GETEXTVAL^TTFORM(.FA,"JOURNAL")
 S CHKNUM=$$GETEXTVAL^TTFORM(.FA,"CHKNUM")
 S CONFIRM=$$CONFIRM^TTUI("POST THIS TRANSACTION?")
 I CONFIRM="Y" D POST^TTACCOUNT(DATE,AMT,CREDIT,DEBIT,PERIOD,JNL,CHKNUM)
 S ANOTHER=$$CONFIRM^TTUI("POST ANOTHER TRANSACTION?")
 I ANOTHER="Y" K FA G ANOTHERPOST
CANCELPOST
 Q

POST(DATE,AMOUNT,CREDIT,DEBIT,PERIOD,JOURNAL,CHKNUM)
 N SSEQ S SSEQ=^TT("ACCT",CREDIT,"SEQ")
 N DSEQ S DSEQ=^TT("ACCT",DEBIT,"SEQ")
 N JSEQ S JSEQ=^TT("COMPANY","JSEQ")
 TS
 ; CREATE THE DOUBLE ENTRIES
 I $$OPER(CREDIT,"CREDIT")="-" S ^TT("ACCT",CREDIT,PERIOD,SSEQ)=-AMOUNT
 I $$OPER(CREDIT,"CREDIT")="+" S ^TT("ACCT",CREDIT,PERIOD,SSEQ)=AMOUNT
 I $$OPER(DEBIT,"DEBIT")="+" S ^TT("ACCT",DEBIT,PERIOD,DSEQ)=AMOUNT
 I $$OPER(DEBIT,"DEBIT")="-" S ^TT("ACCT",DEBIT,PERIOD,DSEQ)=-AMOUNT
 S ^TT("ACCT",CREDIT,PERIOD,SSEQ,"DATE")=DATE
 S ^TT("ACCT",DEBIT,PERIOD,DSEQ,"DATE")=DATE
 S ^TT("ACCT",CREDIT,PERIOD,SSEQ,"JSEQ")=JSEQ
 S ^TT("ACCT",DEBIT,PERIOD,DSEQ,"JSEQ")=JSEQ
 S ^TT("ACCT",CREDIT,PERIOD,SSEQ,"CHKNUM")=CHKNUM
 S ^TT("JNL",JSEQ)=JOURNAL
 S ^TT("JNL",JSEQ,"DATE")=DATE
 S ^TT("COMPANY","JSEQ")=JSEQ+1
 S ^TT("ACCT",CREDIT,"SEQ")=SSEQ+1
 S ^TT("ACCT",DEBIT,"SEQ")=DSEQ+1
 TC
 Q
 