%{
#define RESET   "\033[0m"
#define GREEN   "\033[32m"
#define RED     "\033[31m"

#define ERROR(t) printf(RED "Invalid Token in line %d: " RESET "%s" "\n", lines, t);

#ifdef PRINT
#define TOKEN(t) printf(GREEN "Token: " RESET #t "\n");
#else
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

{INT_T}         TOKEN(INT_T)
{STR_T}         TOKEN(STR_T)
{CHAR_T}        TOKEN(CHAR_T)
{FLOAT_T}       TOKEN(FLOAT_T)

{IF}            TOKEN(IF)
{ELSE}          TOKEN(ELSE)
{WHILE}         TOKEN(WHILE)
{FOR}           TOKEN(FOR)
{RETURN}        TOKEN(RETURN)

{PLUS}          TOKEN(PLUS)
{MINUS}         TOKEN(MINUS)
{MULT}          TOKEN(MULT)
{DIV}           TOKEN(DIV)
{ASSIGN}        TOKEN(ASSIGN)

{EQUAL}         TOKEN(EQUAL)
{DIFF}          TOKEN(DIFF)
{LT}            TOKEN(LT)
{LTE}           TOKEN(LTE)
{GT}            TOKEN(GT)
{GTE}           TOKEN(GTE)

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

{ID}            TOKEN(ID)
{DIGIT}{ID}	    { ERROR(yytext); errors++; }
\n              { lines++; }
.               { ERROR(yytext); errors++; }

%%

int yywrap();

    int main() {
    yylex();
    printf(RED "\nTotal Errors: %d\n" RESET, errors);

    if(errors == 0)
        printf(GREEN "Success. No Errors.\n" RESET);

    return 0;
}

int yywrap() {
    return 1;
}
