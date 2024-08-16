%{
    int linhas = 1, erros = 0;
%}

RESERVED (int|float|char|string|if|else|for|while|switch|case|do|return)

ID[a-zA-Z][a-zA-Z0-9_@]*

INTEGER[0-9]+

REAL[0-9]+[.][0-9]+

MATH [+\-\*/%]|(\+=|\-=|>=|<=|==|!=|&&|\|\||\++)|[><]

SEPARATOR [,;(){}\[\]'"]

ESPACO [\t\r\ ]

%%

{ESPACO}

{RESERVED} {
    printf("Palavra reservada: %s\n", yytext);
}

{INTEGER}{ID} {
    printf("Identificador inválido: %s - ", yytext);
    erros++;
    printf("Linha: %d\n", linhas);
}

{ID} {
    printf("Identificador: %s\n", yytext);
}

{INTEGER} {
    printf("Inteiro: %s\n", yytext);
}

{REAL} {
    printf("Real: %s\n", yytext);
}

{SEPARATOR} {
    printf("Separador: %s\n", yytext);
}

{MATH} {
    printf("Operador aritmético: %s\n", yytext);
}

"=" {
    printf("Sinal de atribuição na linha %d\n", linhas);
}

"->" {
    printf("Tipo de retorno na linha %d\n", linhas);
}

"//"[^\n]* {
    printf("Comentários: %s\n", yytext);
}

\"[^\"]*\" {
    printf("String: %s\n", yytext);
}

\n {
    linhas++;
}

. {
    printf("Token inválido: %s - ", yytext);
    erros++;
    printf("Linhas: %d\n", linhas);
}

%%

int yywrap();

int main() {
    yylex();
    printf("Total de erros encontrados: %d\n", erros);

    if(erros == 0)
        printf("Código analisado com sucesso\n");

    return 0;
}

int yywrap() {
    return 1;
}