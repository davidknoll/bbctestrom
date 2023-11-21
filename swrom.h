/* Sideways ROM entry points */
extern void __fastcall__ language(struct regs *regs);
extern void __fastcall__ service(struct regs *regs);

/* MOS calls */
#define OSRDRM 0xFFB9
#define VDUCHR 0xFFBC
#define OSEVEN 0xFFBF
#define GSINIT 0xFFC2
#define GSREAD 0xFFC5
#define NVRDCH 0xFFC8
#define NVWRCH 0xFFCB
#define OSFIND 0xFFCE
#define OSGBPB 0xFFD1
#define OSBPUT 0xFFD4
#define OSBGET 0xFFD7
#define OSARGS 0xFFDA
#define OSFILE 0xFFDD
#define OSRDCH 0xFFE0
#define OSASCI 0xFFE3
#define OSNEWL 0xFFE7
#define OSWRCH 0xFFEE
#define OSWORD 0xFFF1
#define OSBYTE 0xFFF4
#define OSCLI  0xFFF7
