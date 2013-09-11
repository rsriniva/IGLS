TTCUST
 N MA
TOP
 S MA("TITLE")="CUSTOMER MANAGEMENT"
 S MA("ITEMS","ADD CUSTOMER")="D ADD^TTCUST"
 S MA("ITEMS","SHOW CUSTOMER")="D SHOW^TTCUST"
 S MA("ITEMS","INTEGRATE CUSTOMER TO ACCOUNTING MODULE")="D IINTACTC^TTCUST"
 S MA("ITEMS","ADD CUSTOMER","KEY")="XKCST:M"
 S MA("ITEMS","SHOW CUSTOMER","KEY")="XKCST:V"
 S MA("ITEMS","INTEGRATE CUSTOMER TO ACCOUNTING MODULE","KEY")="XKCST:M"
 S MA("ITEMS","QUIT TO MAIN MENU")="D ^TT"
 D GO^TTMENU(.MA)
 G TOP
 Q

ADD
 N FA
 S FA("TITLE")="ADD CUSTOMER"
 S FA("ITEMS",1,"NAME")="CODE"
 S FA("ITEMS",1,"LABEL")="CODE:"
 S FA("ITEMS",1,"LABEL","TOP")=4
 S FA("ITEMS",1,"LABEL","LEFT")=2
 S FA("ITEMS",1,"FIELD","TOP")=4
 S FA("ITEMS",1,"FIELD","LEFT")=9
 S FA("ITEMS",1,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",1,"FIELD","REQUIRED")=1
 S FA("ITEMS",2,"NAME")="NAME"
 S FA("ITEMS",2,"LABEL")="NAME:"
 S FA("ITEMS",2,"LABEL","TOP")=6
 S FA("ITEMS",2,"LABEL","LEFT")=2
 S FA("ITEMS",2,"FIELD","TOP")=6
 S FA("ITEMS",2,"FIELD","LEFT")=9
 S FA("ITEMS",2,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",2,"FIELD","REQUIRED")=1
 S FA("ITEMS",3,"NAME")="POC"
 S FA("ITEMS",3,"LABEL")="POC:"
 S FA("ITEMS",3,"LABEL","TOP")=8
 S FA("ITEMS",3,"LABEL","LEFT")=2
 S FA("ITEMS",3,"FIELD","TOP")=8
 S FA("ITEMS",3,"FIELD","LEFT")=9
 S FA("ITEMS",3,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",3,"FIELD","REQUIRED")=1
 S FA("ITEMS",4,"NAME")="STREET"
 S FA("ITEMS",4,"LABEL")="STREET:"
 S FA("ITEMS",4,"LABEL","TOP")=10
 S FA("ITEMS",4,"LABEL","LEFT")=2
 S FA("ITEMS",4,"FIELD","TOP")=10
 S FA("ITEMS",4,"FIELD","LEFT")=9
 S FA("ITEMS",4,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",4,"FIELD","REQUIRED")=1
 S FA("ITEMS",5,"NAME")="CITY"
 S FA("ITEMS",5,"LABEL")="CITY:"
 S FA("ITEMS",5,"LABEL","TOP")=12
 S FA("ITEMS",5,"LABEL","LEFT")=2
 S FA("ITEMS",5,"FIELD","TOP")=12
 S FA("ITEMS",5,"FIELD","LEFT")=9
 S FA("ITEMS",5,"FIELD","MAXLENGTH")=20
 S FA("ITEMS",5,"FIELD","REQUIRED")=1
 S FA("ITEMS",6,"NAME")="STATE"
 S FA("ITEMS",6,"LABEL")="STATE:"
 S FA("ITEMS",6,"LABEL","TOP")=14
 S FA("ITEMS",6,"LABEL","LEFT")=2
 S FA("ITEMS",6,"FIELD","TOP")=14
 S FA("ITEMS",6,"FIELD","LEFT")=9
 S FA("ITEMS",6,"FIELD","MAXLENGTH")=2
 S FA("ITEMS",6,"FIELD","REQUIRED")=1
 S FA("ITEMS",7,"NAME")="POSTCODE"
 S FA("ITEMS",7,"LABEL")="POSTAL CODE:"
 S FA("ITEMS",7,"LABEL","TOP")=14
 S FA("ITEMS",7,"LABEL","LEFT")=13
 S FA("ITEMS",7,"FIELD","TOP")=14
 S FA("ITEMS",7,"FIELD","LEFT")=26
 S FA("ITEMS",7,"FIELD","MAXLENGTH")=5
 S FA("ITEMS",7,"FIELD","REQUIRED")=1
 S FA("ITEMS",8,"NAME")="EMAIL"
 S FA("ITEMS",8,"LABEL")="E-MAIL ADDRESS:"
 S FA("ITEMS",8,"LABEL","TOP")=4
 S FA("ITEMS",8,"LABEL","LEFT")=40
 S FA("ITEMS",8,"FIELD","TOP")=5
 S FA("ITEMS",8,"FIELD","LEFT")=40
 S FA("ITEMS",8,"FIELD","MAXLENGTH")=40
 S FA("ITEMS",8,"FIELD","REQUIRED")=0
 S FA("ITEMS",9,"NAME")="RATEHOUR"
 S FA("ITEMS",9,"LABEL")="RATE/HOUR:"
 S FA("ITEMS",9,"LABEL","TOP")=8
 S FA("ITEMS",9,"LABEL","LEFT")=40
 S FA("ITEMS",9,"FIELD","TOP")=8
 S FA("ITEMS",9,"FIELD","LEFT")=56
 S FA("ITEMS",9,"FIELD","MAXLENGTH")=8
 S FA("ITEMS",9,"FIELD","REQUIRED")=1
 S FA("ITEMS",10,"NAME")="TAXRATE"
 S FA("ITEMS",10,"LABEL")="TAX RATE:"
 S FA("ITEMS",10,"LABEL","TOP")=10
 S FA("ITEMS",10,"LABEL","LEFT")=40
 S FA("ITEMS",10,"FIELD","TOP")=10
 S FA("ITEMS",10,"FIELD","LEFT")=56
 S FA("ITEMS",10,"FIELD","MAXLENGTH")=4
 S FA("ITEMS",10,"FIELD","REQUIRED")=1
 D GO^TTFORM(.FA)
 G:CANFLG=1 CNCADDCST
 N CODE,NAME,POC,STREET,CITY,STATE,POSTCODE,EMAIL,RATEHOUR,TAXRATE
 S CODE=$$GETEXTVAL^TTFORM(.FA,"CODE")
 S NAME=$$GETEXTVAL^TTFORM(.FA,"NAME")
 S POC=$$GETEXTVAL^TTFORM(.FA,"POC")
 S STREET=$$GETEXTVAL^TTFORM(.FA,"STREET")
 S CITY=$$GETEXTVAL^TTFORM(.FA,"CITY")
 S STATE=$$GETEXTVAL^TTFORM(.FA,"STATE")
 S POSTCODE=$$GETEXTVAL^TTFORM(.FA,"POSTCODE")
 S EMAIL=$$GETEXTVAL^TTFORM(.FA,"EMAIL")
 S RATEHOUR=$$GETEXTVAL^TTFORM(.FA,"RATEHOUR")
 S TAXRATE=$$GETEXTVAL^TTFORM(.FA,"TAXRATE")
 D CREATE(CODE,NAME,POC,STREET,CITY,STATE,POSTCODE,EMAIL,RATEHOUR,TAXRATE)
 N CONF S CONF=$$CONFIRM^TTUI("INTEGRATE THIS CUSTOMER WITH ACCOUNTING SYSTEM?")
 I CONF="Y" D IINTACCT(CODE)
CNCADDCST
 Q

CREATE(CODE,NAME,POC,STREET,CITY,STATE,POSTCODE,EMAIL,RATEHOUR,TAXRATE)
 TS
 S ^TT("CUSTOMER",CODE)=NAME
 S ^TT("CUSTOMER",CODE,"POC")=POC
 S ^TT("CUSTOMER",CODE,"STREET")=STREET
 S ^TT("CUSTOMER",CODE,"CITY")=CITY
 S ^TT("CUSTOMER",CODE,"STATE")=STATE
 S ^TT("CUSTOMER",CODE,"POSTCODE")=POSTCODE
 S ^TT("CUSTOMER",CODE,"EMAIL")=EMAIL
 S ^TT("CUSTOMER",CODE,"RATEHOUR")=RATEHOUR
 S ^TT("CUSTOMER",CODE,"TAXRATE")=TAXRATE
 S ^TT("CUSTOMER",CODE,"ENTRIDX")=1
 TC
 Q

IINTACTC
 N CODE,CHOSEN
 S CODE=$$CHOOSE^TTCUST(.CHOSEN,"CHOOSE CUSTOMER")
 D IINTACCT(CODE)
 Q

IINTACCT(CODE)
 N TMP,INVDEB,INVCRED,PMTDEB,PMTCRED,CUSTCODE
 S CUSTCODE=CODE
 S INVDEB=$$CHOOSE^TTACCOUNT(.TMP,"ACCOUNT TO DEBIT ON INVOICE SUBMISSION")
 S INVCRED=$$CHOOSE^TTACCOUNT(.TMP,"ACCOUNT TO CREDIT ON INVOICE SUBMISSION")
 S PMTDEB=$$CHOOSE^TTACCOUNT(.TMP,"ACCOUNT TO DEBIT ON PAYMENT RECEIPT")
 S PMTCRED=$$CHOOSE^TTACCOUNT(.TMP,"ACCOUNT TO CREDIT ON PAYMENT RECEIPT")
 D INTACCT(CUSTCODE,INVDEB,INVCRED,PMTDEB,PMTCRED)
 Q

INTACCT(CUSTCODE,INVDEB,INVCRED,PMTDEB,PMTCRED) 
 TS
 S ^TT("CUSTOMER",CUSTCODE,"INVDEB")=INVDEB
 S ^TT("CUSTOMER",CUSTCODE,"INVCRED")=INVCRED
 S ^TT("CUSTOMER",CUSTCODE,"PMTDEB")=PMTDEB
 S ^TT("CUSTOMER",CUSTCODE,"PMTCRED")=PMTCRED
 S ^TT("CUSTOMER",CUSTCODE,"ACCTINTEG")="TRUE"
 TC
 Q

SHOW
 N CUSTCODE,CUSTREC,CUSTNAME,CNLEN,CUSTCITY,CUSTSTATE,CUSTZIP
 N CUSTPOC,CUSTSTREET,CUSTMAIL,CUSTTAX,CUSTRATE,ACCTINTEG
 N INVCRED,INVDEB,PMTCRED,PMTDEB,FILE
 N TOTINV,TOTPAID,TOTOWED S (TOTINV,TOTPAID,TOTOWED)=0
 S CUSTCODE=$$CHOOSE^TTCUST(.CUSTREC)
 D OPENTEMP^TTIO(.FILE)
 S CUSTNAME=^TT("CUSTOMER",CUSTCODE)
 S CNLEN=$L(CUSTNAME)
 S CUSTSTREET=^TT("CUSTOMER",CUSTCODE,"STREET")
 S CUSTCITY=^TT("CUSTOMER",CUSTCODE,"CITY")
 S CUSTSTATE=^TT("CUSTOMER",CUSTCODE,"STATE")
 S CUSTZIP=^TT("CUSTOMER",CUSTCODE,"POSTCODE")
 S CUSTPOC=^TT("CUSTOMER",CUSTCODE,"POC")
 S CUSTMAIL=^TT("CUSTOMER",CUSTCODE,"EMAIL")
 S CUSTTAX=^TT("CUSTOMER",CUSTCODE,"TAXRATE")
 S CUSTRATE=^TT("CUSTOMER",CUSTCODE,"RATEHOUR")
 S INVCRED=$G(^TT("CUSTOMER",CUSTCODE,"INVCRED"),"")
 S INVDEB=$G(^TT("CUSTOMER",CUSTCODE,"INVDEB"),"")
 S PMTCRED=$G(^TT("CUSTOMER",CUSTCODE,"PMTCRED"),"")
 S PMTDEB=$G(^TT("CUSTOMER",CUSTCODE,"PMTDEB"),"")
 S ACCTINTEG=$G(^TT("CUSTOMER",CUSTCODE,"ACCTINTEG"),"FALSE")
 W !,!,CUSTNAME,!
 F I=1:1:CNLEN W "="
 W !,!
 W "STREET:    ",CUSTSTREET,?41,"POC:       ",CUSTPOC,!
 W "CITY:      ",CUSTCITY,?41,"EMAIL:     ",CUSTMAIL,!
 W "STATE:     ",CUSTSTATE,?41,"TAX RATE:  ",CUSTTAX,"%",!
 W "ZIP:       ",CUSTZIP,?41,"RATE/HOUR: $",CUSTRATE,!,!
 I ACCTINTEG="TRUE" D
 . W "INVOICING-ACCOUNTING INTEGRATION ENABLED",!
 . W " INVOICES DEBIT:",?41,^TT("ACCT",INVDEB),!
 . W " INVOICES CREDIT:",?41,^TT("ACCT",INVCRED),!
 . W " PAYMENTS DEBIT:",?41,^TT("ACCT",PMTDEB),!
 . W " PAYMENTS CREDIT: ",?41,^TT("ACCT",PMTCRED),!,!
 W "INVOICES",!
 W "========",!,!
 W "#",?8,"DATE",?20,"HOURS",?27,"TOTAL",!
 F I=1:1:80 W "-"
 W !
 N INVIDX S INVIDX=""
 F  S INVIDX=$O(^TT("CUSTOMER",CUSTCODE,"INV",INVIDX)) Q:INVIDX=""  D
 . W INVIDX
 . W ?8,^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"DATE")
 . W ?20,$J(^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"HOURS"),5,2)
 . W ?27,"$",$J(^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"TOTAL"),15,2)
 . W !
 . S TOTINV=TOTINV+^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"TOTAL")
 W !,"PAYMENTS",!
 W "========",!,!
 W "#",?8,"DATE",?20,"CHECK #",?29,"NMGRT TXBL",?41,"TOTAL",!
 F I=1:1:80 W "-"
 W !
 N PMTIDX S PMTIDX=""
 F  S PMTIDX=$O(^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX)) Q:PMTIDX=""  D
 . W PMTIDX
 . W ?8,^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"DATE")
 . W ?20,^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"CHKNUM")
 . W ?29,^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"NMGRTAMOUNT")
 . W ?41,^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"AMOUNT"),!
 . W "    ",^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"MEMO"),!
 . S TOTPAID=TOTPAID+^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"AMOUNT")
 W !,!
 S TOTOWED=TOTINV-TOTPAID
 N PRCPAID S PRCPAID=(TOTPAID*100)/TOTINV
 W ?3,"TOTAL INVOICED:  $",$J(TOTINV,20,2),!
 W ?3,"TOTAL PAID:      $",$J(TOTPAID,20,2),!
 W ?3,"TOTAL OWED:      $",$J(TOTOWED,20,2),!
 W ?3,"PERCENT PAID:     ",$J(PRCPAID,20,2),"%",!
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,CUSTNAME)
 Q

CHOOSE(CHOSEN,CAPTION)
 N MA,CUSTCODE S CUSTCODE=""
 S MA("TITLE")=$G(CAPTION,"CHOOSE CUSTOMER")
 S CUSTCODE=""
 F  S CUSTCODE=$O(^TT("CUSTOMER",CUSTCODE)) Q:CUSTCODE=""  D
 . S MA("ITEMS",^TT("CUSTOMER",CUSTCODE))="S CURRENTCUST="""_CUSTCODE_""""
 D GO^TTMENU(.MA)
 M CHOSEN=^TT("CUSTOMER",CURRENTCUST)
 S INTVAL=CURRENTCUST
 S EXTVAL=^TT("CUSTOMER",CURRENTCUST)
 Q CURRENTCUST
 