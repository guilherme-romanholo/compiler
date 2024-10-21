# Definição dos arquivos
LEXER = lex.yy.c
PARSER = parser.tab.c
PARSER_HEADER = parser.tab.h
EXEC = analisador
LEX = src/scanner.l  # Nome do arquivo Flex
YACC = src/parser.y  # Nome do arquivo Bison

# Flags de compilação
CFLAGS = -g

# Regras principais
all: $(EXEC)

# Regra para gerar o executável
$(EXEC): $(LEXER) $(PARSER)
	@gcc $(CFLAGS) -o $(EXEC) $(LEXER) $(PARSER) -lfl -DYYDEBUG

# Regra para gerar o arquivo léxico com o Flex
$(LEXER): $(LEX)
	@flex $(LEX) 

# Regra para gerar os arquivos do parser com o Bison
$(PARSER): $(YACC)
	@bison -d $(YACC)

# Limpeza dos arquivos gerados
clean:
	@rm -f $(LEXER) $(PARSER) $(PARSER_HEADER) $(EXEC)
