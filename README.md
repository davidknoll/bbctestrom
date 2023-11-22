BBC Micro test ROMs
===================

Experiments with building sideways ROMs for the [BBC Micro](https://en.wikipedia.org/wiki/BBC_Micro). Type `make` to build it all.

`testrom.rom` requires [ASxxxx](https://shop-pdp.net/ashtml/asxxxx.php) and [srecord](https://srecord.sourceforge.net/) to build. It adds a line to the main `*HELP` listing, and two commands `*HELLO` and `*GOODBYE` that output messages.

`crom.rom` requires [cc65](https://www.cc65.org/) to build, and is a proof of concept for writing the majority of a language or service ROM in C. (Caveats: It uses zero page locations that it shouldn't, so may not coexist with languages other than BASIC, and it needs to be loaded into writable sideways RAM, not an actual ROM.) It adds a line to the main `*HELP` listing, a section `*HELP MONTY`, and some commands that output messages. It has a language entry point, but this just calls `*BASIC`.
