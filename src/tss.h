/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#ifndef __TSS_H__
#define __TSS_H__

#include "stdint.h"
#include "defines.h"
#include "i386.h"
#include "gdt.h"
#include "mmu.h"


void tss_init_gdt(uint32_t i, uint32_t cr3);
void tss_idle_initial();

typedef struct str_tss {
    uint16_t  ptl;
    uint16_t  unused0;
    uint32_t    esp0;
    uint16_t  ss0;
    uint16_t  unused1;
    uint32_t    esp1;
    uint16_t  ss1;
    uint16_t  unused2;
    uint32_t    esp2;
    uint16_t  ss2;
    uint16_t  unused3;
    uint32_t    cr3;
    uint32_t    eip;
    uint32_t    eflags;
    uint32_t    eax;
    uint32_t    ecx;
    uint32_t    edx;
    uint32_t    ebx;
    uint32_t    esp;
    uint32_t    ebp;
    uint32_t    esi;
    uint32_t    edi;
    uint16_t  es;
    uint16_t  unused4;
    uint16_t  cs;
    uint16_t  unused5;
    uint16_t  ss;
    uint16_t  unused6;
    uint16_t  ds;
    uint16_t  unused7;
    uint16_t  fs;
    uint16_t  unused8;
    uint16_t  gs;
    uint16_t  unused9;
    uint16_t  ldt;
    uint16_t  unused10;
    uint16_t  dtrap;
    uint16_t  iomap;
} __attribute__((__packed__, aligned (8))) tss;

void tss_inicializar(tss* tss_task, uint32_t jugador);
void tss_set_attr(tss* tss_task, uint32_t pila0);
extern tss tss_initial;
extern tss tss_idle;
extern tss tss_A0;
extern tss tss_A1;
extern tss tss_A2;
extern tss tss_A3;
extern tss tss_A4;
extern tss tss_A5;
extern tss tss_A6;
extern tss tss_A7;
extern tss tss_A8;
extern tss tss_A9;

extern tss tss_B0;
extern tss tss_B1;
extern tss tss_B2;
extern tss tss_B3;
extern tss tss_B4;
extern tss tss_B5;
extern tss tss_B6;
extern tss tss_B7;
extern tss tss_B8;
extern tss tss_B9;

void tss_init();

#endif  /* !__TSS_H__ */
