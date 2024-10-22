# Programs
CC    = gcc
LEX   = flex
YACC  = bison
FLAGS = -lfl

# Sources
LEX_SRC  = src/scanner.l
YACC_SRC = src/parser.y

# Outputs
BIN         = compiler
LEX_OUT     = lex.yy.c
YACC_OUT    = parser.tab.c
YACC_HEADER = parser.tab.h

# Debug
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	FLAGS += -DPRINT -DYYDEBUG
endif

# Rules
all: $(BIN)

$(BIN): $(LEX_OUT) $(YACC_OUT)
	$(CC) -o $(BIN) $(LEX_OUT) $(YACC_OUT) $(FLAGS)

$(LEX_OUT): $(LEX_SRC)
	$(LEX) $(LEX_SRC)

$(YACC_OUT): $(YACC_SRC)
	$(YACC) -d $(YACC_SRC)

run: all
	./$(BIN)

clean:
	@rm -f $(BIN) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER)
