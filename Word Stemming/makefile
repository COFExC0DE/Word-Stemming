NOMBRE = cant_palabras


all: $(NOMBRE)


$(NOMBRE): $(NOMBRE).o
	ld -o $(NOMBRE) $(NOMBRE).o


$(NOMBRE).o: $(NOMBRE).asm
	nasm -f elf64 -o $(NOMBRE).o $(NOMBRE).asm


clean:
	rm $(NOMBRE)
	rm $(NOMBRE).o
