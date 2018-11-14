%{
    #include <stdio.h>
	#include "zjs.h"
	int yyerror(const char* err);
	int colorErrorCheck(int a, int b, int c);
%}
 
%union {
  int iVal;
  float fVal;
  char* sval;
}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT

%%

program:	statement_list END
		;

statement_list:	  statement
		| statement_list statement
		;

statement:	LINE INT INT INT INT END_STATEMENT { line($2, $3, $4, $5); }
		|	POINT INT INT END_STATEMENT { point($2, $3); }
		|	CIRCLE INT INT INT END_STATEMENT { circle($2, $3, $4); }
		|	RECTANGLE INT INT INT INT END_STATEMENT { rectangle($2, $3, $4, $5); }
		|	SET_COLOR INT INT INT END_STATEMENT { if(colorErrorCheck($2, $3, $4)){ set_color($2, $3, $4); } }
		;
%%

int main(int argc, char** argv){
	setup();
	yyparse();
	finish();
}

int yyerror(const char* err){
	printf("%s\n", err);
}

int colorErrorCheck(int a, int b, int c){
	if(a > 255 || a < 0 || b > 255 || b < 0 || c > 255 || c < 0){
		printf("COLOR VALUE ERROR\n");
		return 0;
	} else {
		return 1;
	}
}
