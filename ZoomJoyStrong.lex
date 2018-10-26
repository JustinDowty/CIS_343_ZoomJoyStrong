%{
#include <stdio.h>
void printLexeme();
int lineNum = 1;
%}

%%

(END) { printf("END\t"); printLexeme();}
\; { printf("END_STATEMENT\t"); printLexeme();}
(POINT) { printf("POINT\t"); printLexeme(); }
(LINE) { printf("LINE\t"); printLexeme(); }
(CIRCLE) { printf("CIRCLE\t"); printLexeme(); }
(RECTANGLE) { printf("RECTANGLE\t"); printLexeme(); }
(SET_COLOR) { printf("SET_COLOR\t"); printLexeme(); }
[0-9]+ { printf("INT"); printLexeme(); }
[0-9]+?\.[0-9]+? { printf("FLOAT"); printLexeme(); }
[ \t]+ ;
(\n) { lineNum++; }
. {printf("USER MESSED UP AT LINE %d", lineNum); 
	printLexeme(); } 

%%

void printLexeme(){
printf("(%s)\n"
, yytext);
}
