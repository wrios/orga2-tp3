/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "stdint.h"
#include "screen.h"
#include "tss.h"


#define cant_tareas 20
#define tam_tablero 50
#define Non 10
#define Playe 20
#define Opp 30
#define Fruta 40

void sched_init();
int16_t sched_nextTask();
uint32_t frutaEn(int i, int j);


typedef struct coordenada{
  int x, y;
} coord;

typedef struct scheduler{
  
  uint8_t ya_jugo[cant_tareas];
  uint8_t muertas[cant_tareas];
  
  int peso_por_tarea[cant_tareas];
  
  int cant_llamadas_a_read_por_tarea[cant_tareas];
  
  coord coordenadas_actuales[cant_tareas];
  coord coordenadas_siguientes[cant_tareas];

  /* 10 None, 20 Player, 30 Opp, 16/32/64 Fruta */
  int tablero[tam_tablero][tam_tablero];

  uint32_t tareas_pilas0[20];

  uint32_t puntosA;
  uint32_t puntosB;

  uint32_t termino_el_juego;
  uint32_t debug_mode;

} schedu;

void updateScreen();
void screenInit();

uint32_t chequear_vision_C(int32_t eax, int32_t ebx);
uint32_t read_C(int32_t eax, int32_t ebx);
uint32_t move_actualizar_C(uint32_t distancia, uint32_t dir);
uint32_t checkear_poder_div_C();
uint32_t copiar_tarea_C();

extern schedu scheduler;
#endif	/* !__SCHED_H__ */
