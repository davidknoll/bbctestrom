#include <6502.h>
#include <ctype.h>
#include <string.h>
#include "swrom.h"

static void outstr(const char *str)
{
    struct regs osregs;
    memset(&osregs, 0, sizeof osregs);

    while (*str) {
        if (*str == '\n') {
            osregs.pc = OSNEWL;
        } else {
            osregs.pc = OSWRCH;
        }
        osregs.a = *str++;
        _sys(&osregs);
    }
}

static unsigned char cmdmatch(const struct regs *regs, const char *cmd)
{
    const char *cmdline = *((char **) 0xF2);
    unsigned char y = regs->y, i = 0;

    while (1) {
        if (isgraph(cmdline[y]) && isgraph(cmd[i])) {
            // Both are printable characters
            if (toupper(cmdline[y]) == toupper(cmd[i])) {
                // Both are the same character, case-insensitively
                y++;
                i++;
            } else {
                // Both are different characters, strings don't match
                return 0;
            }
        } else if (!isgraph(cmdline[y]) && !isgraph(cmd[i])) {
            // Both strings ended at the same length, if we get here they match
            return 1;
        } else {
            // Only one string has ended, different lengths, no match
            return 0;
        }
    }
}

static void oscli(const char *cmd)
{
    struct regs osregs;
    memset(&osregs, 0, sizeof osregs);
    osregs.x = ((unsigned int) cmd);
    osregs.y = ((unsigned int) cmd) >> 8;
    osregs.pc = OSCLI;
    _sys(&osregs);
}

void __fastcall__ language(struct regs *regs)
{
    switch (regs->a) {
    case 0x01: // Enter language
        // I'm not a real language, use OSCLI to issue *BASIC
        oscli("BASIC\r");
        break;
    }
}

void __fastcall__ service(struct regs *regs)
{
    switch (regs->a) {
    case 0x04: // *command
        if (cmdmatch(regs, "TESTMEA")) {
            outstr("Please fondle my bum.\n");
            regs->a = 0;
        } else if (cmdmatch(regs, "TESTMEB")) {
            outstr("My nipples explode with delight!\n");
            regs->a = 0;
        } else if (cmdmatch(regs, "TESTME1")) {
            outstr("Drop your panties, Sir William, I cannot wait 'til lunchtime.\n");
            regs->a = 0;
        } else if (cmdmatch(regs, "TESTME2")) {
            outstr("I am no longer infected.\n");
            regs->a = 0;
        }
        break;

    case 0x09: // *HELP
        if (cmdmatch(regs, "MONTY")) {
            outstr("\nDirty Hungarian Phrasebook\n  TESTMEA\n  TESTMEB\n  TESTME1\n  TESTME2\n");
            regs->a = 0;
        } else if (cmdmatch(regs, "")) {
            outstr("\nHello, this is a test.\n  MONTY\n");
        }
        break;
    }
}
