TTMATH
 Q

ROUNDUP(NUMBER,MULTIPLE)
 N RETVAL,REMAINDER S (RETVAL,REMAINDER)=0
 I MULTIPLE=0 S RETVAL=NUMBER
 S REMAINDER=NUMBER#MULTIPLE
 I REMAINDER=0 S RETVAL=NUMBER G RNDDONE
 S RETVAL=NUMBER+MULTIPLE-REMAINDER
RNDDONE
 Q RETVAL