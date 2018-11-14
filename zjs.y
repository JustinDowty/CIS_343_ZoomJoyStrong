%{
    #include <stdio.h>
	#include "zjs.h"
	int yyerror(const char* err);
	int colorErrorCheck(int a, int b, int c);
	int checkXBounds(int x);
	int checkYBounds(int y);
	int yylineno;
%}
 
%union {
  int iVal;
  float fVal;
  char* sval;
}

// Tokens from zjs.lex
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
						    // Line checks x and y of each point
statement:	LINE INT INT INT INT END_STATEMENT { if(checkXBounds($2)&&checkYBounds($3)&&checkXBounds($4)&&checkYBounds($5)){ 
                                                      	line($2, $3, $4,$5); } else { printf("LINE ERROR\n"); } }

						     // Point checks x and y
		|	POINT INT INT END_STATEMENT { if(checkXBounds($2)&&checkYBounds($3)){ 
								point($2, $2); } else { printf("POINT ERROR\n"); } }

							  // Circle checks outer points of circle
		|	CIRCLE INT INT INT END_STATEMENT { if(checkXBounds($2+$4)&& checkYBounds($3+$4)&&checkXBounds($2-$4)&&checkYBounds($3-$4)){ 
                                                      		circle($2, $3, $4); } else { printf("CIRCLE ERROR\n"); } }

								 // Rectangle checks x and y as well as x + width and y + height
		|	RECTANGLE INT INT INT INT END_STATEMENT{ if(checkXBounds($2)&&checkYBounds($3)&&checkXBounds($2+$4)&&checkYBounds($3+$5)){ 
                                                     		rectangle($2, $3, $4,$5); }else { printf("RECTANGLE ERROR\n"); } }

								 // Color checks for values 0 - 255
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

// Checks to make sure color is within range 0 - 255
int colorErrorCheck(int a, int b, int c){
	if(a > 255 || a < 0 || b > 255 || b < 0 || c > 255 || c < 0){
		printf("COLOR VALUE ON LINE %d\n", yylineno);
		return 0;
	} else {
		return 1;
	}
}

// Checks to make sure x values are within bounds, uses width declared in zjs.h
int checkXBounds(int x){
	if(x < 0 || x > WIDTH){
		printf("X OUT OF BOUNDS ERROR ON LINE %d ", yylineno);
		return 0;
	} else {
		return 1;
	}
}

// Checks to make sure y values are within bounds, uses height declared in zjs.h
int checkYBounds(int y){
	if(y < 0 || y > HEIGHT){
		printf("Y OUT OF BOUNDS ERROR ON LINE %d ", yylineno);
		return 0;
	} else {
		return 1;
	}
}
