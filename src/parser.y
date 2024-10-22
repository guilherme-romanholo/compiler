%{
    #include <stdio.h>
    #include <stdlib.h>
   // #include "lex.yy.c"

    extern int yylex(void);  // Declaração do lexer
    extern int errors;
    extern FILE *yyin;
    void yyerror(const char *s);  // Função para tratar erros
%}

/* Definindo os tokens */
%token CHARACTER STRING INTEGER REAL TYPE IF ELSE WHILE FOR RETURN ID
%token OPERATOR ASSIGN
%token LOGIC
%token COLON SEMICOLON RPARENT LPARENT RBRACKET LBRACKET LKEY RKEY
%%

/* A gramática da sua linguagem vai aqui */
/*programa:
    declaracoes comandos
    ;

/*declaracoes:
    /* Regras para declarações de variáveis, por exemplo */
    /*| declaracao declaracoes
    ;*/

declaracao:
    TYPE lista_var SEMICOLON
    ;

lista_var:
    ID | ID COLON lista_var
    ;

/*comandos:
    /* Regras para os comandos da linguagem */
  /*  | comando comandos
    ;

comando:
    VAR '=' expressao SEPARATOR
    ;

expressao:
    INTEGER
    | REAL
    | VAR
    | expressao MATH expressao
    ; */

%%

void yyerror(const char *s) { printf("Erro: %s\n", s); }

int main(int argc, char **argv) {

#if YYDEBUG == 1
    extern int yydebug;
    yydebug = 1;
#endif

    if ( argc > 0 )
        yyin = fopen(argv[1], "r");
    else
        yyin = stdin;
    
    do {
        yyparse();
    } while (!feof(yyin));

    // Verificar se houve erros
    if (errors == 0)
        printf("Análise concluída com sucesso!\n");
    else
        printf("Análise falhou com %d erro(s).\n", errors);

    return 0; 
}
