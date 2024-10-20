CC = gcc
LEX = flex
BISON = bison

CFLAGS = -g -DPRINT
LDFLAGS = 

TARGET = compiler.out

LEX_SRC = src/scanner.l
LEX_OUT = lex.yy.c

all: 

scanner: $(TARGET)

$(TARGET): $(LEX_OUT)
	$(CC) $(CFLAGS) $(LEX_OUT) -o $(TARGET) $(LDFLAGS)

$(LEX_OUT): $(LEX_SRC)
	$(LEX) $(LEX_SRC)

clean:
	rm -f $(LEX_OUT) $(TARGET)

.PHONY: all clean
