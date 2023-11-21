.PHONY: all clean
all: crom.rom testrom.rom
clean:
	rm -f *~ *.hlr *.lst *.map *.o *.rel *.rom *.rst *.s19 *.sym

crom.rom: crom.c crt0.s swrom.cfg swrom.h
	cl65 -t none -c crom.c -o crom.o
	cl65 -t none -c crt0.s -o crt0.o
	ld65 -C swrom.cfg -m crom.map -o crom.rom crt0.o crom.o --lib none.lib

%.rom: %.s19
	srec_cat -Output $@ -Binary $< -offset -0x8000

testrom.s19: testrom.rel
	aslink -mosu $@ $^

%.rel: %.asm
	as6500 -los $<
