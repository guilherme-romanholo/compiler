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

// Types
%token INT_T
%token STR_T
%token CHAR_T
%token FLOAT_T

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
%token OPERATOR 
%token ASSIGN
%token LOGIC

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

func_def:
    | FUNC ID LPARENT param_decl RPARENT RET_T type LKEY commands RETURN value SEMICOLON RKEY func_def
    ;

param_decl:
    | type ID
    | type ID COMMA param_decl
    ;

type:
    INT_T
    | STR_T
    | CHAR_T
    | FLOAT_T
    ;

value:
    CHARACTER
    | STRING
    | INTEGER
    | REAL
    | ID
    ;

commands:
    | command commands
    ;

command:
    declaration SEMICOLON
    | assignment SEMICOLON
    ;

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
    | value OPERATOR expression
    ;

// condicional:
//     IF RPARENT condicao LPARENT bloco_comandos
//     ;
// 
// condicao:
//     expressao LOGIC expressao
//     ;
// 
// bloco_comandos:
//     RKEY comandos LKEY
//     ;

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
