%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int errors;
    extern int lines;

    extern FILE *yyin;
    extern int yylex(void);

    void yyerror(const char *s) { printf("Line %d: %s\n", lines, s); }
%}

// Verbose errors output
%define parse.error verbose

// Values
%token CHARACTER
%token STRING
%token INTEGER 
%token REAL 
%token BOOLEAN

// Types
%token INT_T
%token STR_T
%token CHAR_T
%token FLOAT_T
%token BOOL_T

// Commands
%token IF 
%token ELSE 
%token WHILE 
%token FOR 
%token RETURN 
%token FUNC
%token RET_T 

// Identifier
%token ID

// Operators
%token PLUS
%token MINUS 
%token MULT 
%token DIV 
%token ASSIGN

// Logical
%token EQUAL
%token DIFF
%token LT
%token LTE
%token GT
%token GTE

// Separators
%token COMMA
%token SEMICOLON 
%token RPARENT 
%token LPARENT 
%token RBRACKET 
%token LBRACKET 
%token LKEY 
%token RKEY

// Start
%start func_def
%%

/* Function */
func_def:
    | FUNC ID LPARENT param_decl RPARENT RET_T type LKEY commands RETURN value SEMICOLON RKEY func_def
    ;

param_decl:
    | type ID
    | type ID COMMA param_decl
    ;

/* Commands */
commands:
    | command commands
    ;

command:
    declaration SEMICOLON
    | assignment SEMICOLON
    | conditional
    | loop
    ;

command_block:
    LKEY commands RKEY
    ;

/* Declaration */
declaration:
    type var_list
    ;

var_list:
    ID
    | var_list COMMA ID
    | assignment
    | var_list COMMA assignment
    ;

assignment:
    ID ASSIGN expression
    ;

expression:
    value
    | value operator expression
    ;

/* If Command */
conditional:
    IF LPARENT condition RPARENT command_block
    | IF LPARENT condition RPARENT command_block ELSE command_block
    ;

condition:
    expression
    | expression logic expression
    ;

/* Loop Command */
loop:
    while_loop
    for_loop
    ;

while_loop:
    WHILE LPARENT condition RPARENT command_block
    ;

for_loop:
    FOR LPARENT for_statement RPARENT command_block
    ;

// Multiplas variáveis na declaração, mas apenas uma no assign
for_statement:
    declaration SEMICOLON condition SEMICOLON assignment
    ;

/* Groups */
type:
    INT_T
    | STR_T
    | CHAR_T
    | FLOAT_T
    | BOOL_T
    ;

value:
    CHARACTER
    | STRING
    | INTEGER
    | REAL
    | BOOLEAN
    | ID
    ;

operator:
    PLUS
    | MINUS
    | MULT
    | DIV
    ;

logic:
    EQUAL
    | DIFF
    | LT
    | LTE
    | GT
    | GTE
    ;

%%

#if YYDEBUG == 1
    extern int yydebug;
    yydebug = 1;
#endif

int main(int argc, char **argv) {
    if ( argc > 0 )
        yyin = fopen(argv[1], "r" );
    else
        yyin = stdin;
    
    do {
        yyparse();
    } while (!feof(yyin));

    if (errors == 0)
        printf("Análise concluída com sucesso!\n");
    else
        printf("Análise falhou com %d erro(s).\n", errors);

    return 0; 
}
