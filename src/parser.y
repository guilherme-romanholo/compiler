%{
    #include <stdio.h>
    #include <stdlib.h>

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
%start comandos
%%

/* A gramática da sua linguagem vai aqui */
/*programa:
    declaracoes comandos
    ;

/*declaracoes:
    /* Regras para declarações de variáveis, por exemplo */
    /*| declaracao declaracoes
    ;*/


comandos: 
    comando comandos 
    | comando
    |
    ;

comando:
    declaracao SEMICOLON
    | atribuicao SEMICOLON
    | condicional
    ;

declaracao:
    TYPE lista_var
    ;

lista_var:
    ID 
    | lista_var COLON ID 
    | atribuicao 
    | lista_var COLON atribuicao
    ;

atribuicao:
    ID ASSIGN expressao
    ;

condicional:
    IF RPARENT condicao LPARENT bloco_comandos
    ;

condicao:
    expressao LOGIC expressao
    ;

bloco_comandos:
    RKEY comandos LKEY
    ;

expressao:
    INTEGER
    | REAL
    | ID
    | expressao OPERATOR expressao
    ;

%%

void yyerror(const char *s) {
    printf("Erro: %s\n", s);
}

int main(int argc, char **argv) {

    #if YYDEBUG == 1
    extern int yydebug;
    yydebug = 1;
    #endif

    if ( argc > 0 )
        yyin = fopen(argv[1], "r" );
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
