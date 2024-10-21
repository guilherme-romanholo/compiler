%{
#define RESET   "\033[0m"
#define GREEN   "\033[32m"
#define RED     "\033[31m"

#define ERROR(t) printf(RED "Invalid Token, line %d: " RESET "%s" "\n", lines, t);

#ifdef PRINT
#define TOKEN(t) printf(GREEN "Token: " RESET #t "\n");
#else
#include "parser.tab.h"
#define TOKEN(t) return(t);
#endif

int errors = 0;
int lines = 1;
%}

LETTER       [a-zA-Z_@]
DIGIT        [0-9]

CHARACTER    \'({LETTER}|{DIGIT})\'
STRING       \".*\"
INTEGER      {DIGIT}+
REAL         {DIGIT}+[.]{DIGIT}+
ID           {LETTER}({LETTER}|{DIGIT})*

INT_T        int
STR_T        string
CHAR_T       char
FLOAT_T      float

IF           if
ELSE         else
WHILE        while
FOR          for
RETURN       return

PLUS         "+"
MINUS        "-"
MULT         "*"
DIV          "/"
ASSIGN       "="

EQUAL        "=="
DIFF         "!="
LT           "<"
LTE          "<="
GT           ">"
GTE          ">="

SPACE        [ \t]
COLON        ","
SEMICOLON    ";"
RPARENT      "("
LPARENT      ")"
RBRACKET     "["
LBRACKET     "]"
RKEY         "{"
LKEY         "}"
COMMENT      #.*\n

%%

{CHARACTER}     TOKEN(CHARACTER)
{STRING}        TOKEN(STRING)
{INTEGER}       TOKEN(INTEGER)
{REAL}          TOKEN(REAL)

{INT_T}         TOKEN(TYPE)
{STR_T}         TOKEN(TYPE)
{CHAR_T}        TOKEN(TYPE)
{FLOAT_T}       TOKEN(TYPE)

{IF}            TOKEN(IF)
{ELSE}          TOKEN(ELSE)
{WHILE}         TOKEN(WHILE)
{FOR}           TOKEN(FOR)
{RETURN}        TOKEN(RETURN)

{PLUS}          TOKEN(OPERATOR)
{MINUS}         TOKEN(OPERATOR)
{MULT}          TOKEN(OPERATOR)
{DIV}           TOKEN(OPERATOR)
{ASSIGN}        TOKEN(ASSIGN)

{EQUAL}         TOKEN(LOGIC)
{DIFF}          TOKEN(LOGIC)
{LT}            TOKEN(LOGIC)
{LTE}           TOKEN(LOGIC)
{GT}            TOKEN(LOGIC)
{GTE}           TOKEN(LOGIC)

{SPACE}
{COLON}         TOKEN(COLON)
{SEMICOLON}     TOKEN(SEMICOLON)
{RPARENT}       TOKEN(RPARENT)
{LPARENT}       TOKEN(LPARENT)
{RBRACKET}      TOKEN(RBRACKET)
{LBRACKET}      TOKEN(LBRACKET)
{LKEY}          TOKEN(RBRACKET)
{RKEY}          TOKEN(LBRACKET)
{COMMENT}       { lines++; }

\n              { lines++; }

{ID}            TOKEN(ID)
{DIGIT}+{ID}    { ERROR(yytext); errors++; }
.               { ERROR(yytext); errors++; }

%%

int yywrap() {
    return 1;
}
