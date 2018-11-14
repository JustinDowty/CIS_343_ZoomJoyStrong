%{
#include <stdio.h>
#include "zjs.tab.h"
void printError();
%}

%option nounput yylineno

%%

point { return POINT;  }
line { return LINE;  }
circle { return CIRCLE; }
rectangle {return RECTANGLE; }
set_color {return SET_COLOR;  }
[0-9]+ {yylval.iVal = atoi(yytext);return INT; }
[0-9]+?\.[0-9]+? { return FLOAT;  }
"end;" { return END; }
";" { return END_STATEMENT; }
[ |\t|\r|\n]+ ;
.		{printError();}

%%

void printError(){
printf("ERROR: %s on line %d\n"
, yytext, yylineno);
}
