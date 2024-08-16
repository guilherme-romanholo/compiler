CC = gcc
LEX = flex
CFLAGS = -Wall -g
LDFLAGS = 
TARGET = compiler
LEX_SRC = src/analex.l
LEX_OUT = lex.yy.c

all: $(TARGET)

$(TARGET): $(LEX_OUT)
	$(CC) $(CFLAGS) $(LEX_OUT) -o $(TARGET) $(LDFLAGS)

$(LEX_OUT): $(LEX_SRC)
	$(LEX) $(LEX_SRC)

clean:
	rm -f $(LEX_OUT) $(TARGET)

.PHONY: all clean
