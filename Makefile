.PHONY: all clean
all: testrom.rom
clean:
	rm -f *~ *.hlr *.lst *.map *.rel *.rom *.rst *.s19 *.sym

%.rom: %.s19
	srec_cat -Output $@ -Binary $< -offset -0x8000

testrom.s19: testrom.rel
	aslink -mosu $@ $^

%.rel: %.asm
	as6500 -los $<
