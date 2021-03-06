; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start

extern print_videokernel

extern sched_task_offset
extern sched_task_selector

extern create_tss_descriptores

extern GDT_DESC
extern IDT_DESC
extern print
extern pintar_pantalla
extern idt_init

extern pic_reset
extern pic_enable
extern pic_disable

extern _isr32
extern _isr33

extern mmu_mappear4mbKernel
extern mmu_init
extern mmu_initKernelDir
extern mmu_initTaskDir
extern test_mmu_initTaskDir
extern test_copyHomework

extern tss_idle_initial

extern game_init

extern sched_init

;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida
    ;print_text_rm start_rm_msg, start_rm_len, 0x07, 0, 0    
    
    ; Habilitar A20
    call A20_enable
    ; Cargar la GDT
    lgdt [GDT_DESC]
    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ; Saltar a modo protegido

    jmp 0xb0:MP 
    ; Pasamos a modo protegido, 8*22 = 0xb0
    ; posicion 22 de la gdt, el descriptor del segmento codigo kernel

MP:
    ; Establecer selectores de segmentos
BITS 32
    xor eax, eax
    mov ax, 0xB8 ; Indice de la GDT 23*8 (bytes) - segmento de data de kernel
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov ss, ax    
    mov ax, 0xD0 ; Indice de nuestro segmento de video para el kernel 26*8 (bytes)
    mov fs, ax
    ; Establecer la base de la pila
    mov ebp, 0x27000
    mov esp, 0x27000
    ; Imprimir mensaje de bienvenida
    call print_videokernel
    ;call pintar_pantalla    
    ; Inicializar pantalla
    
    ; Inicializar el manejador de memoria
    ; Inicializar el directorio de paginas
    call mmu_init
    ; Cargar directorio de paginas
    call mmu_mappear4mbKernel
    mov eax, 0x00027000; page_directory
    mov cr3, eax
    ; Habilitar paginacion
    mov eax, cr0
    or eax, 0x80000000 ;habilito Unidad de paginación
    mov cr0, eax
    ; Inicializar tss de la tarea Idle
    call create_tss_descriptores
    call tss_idle_initial
    ; Inicializar la IDT
    call idt_init
    ; Cargar IDT
    lidt [IDT_DESC]
    ; Configurar controlador de interrupciones
    call pic_reset 
    call pic_enable    
    ;despues de remapear el PIC y habilitarlo, tenemos que la interrupción
    ;de reloj está mapeada a la interrupción 32 y el  teclado a la 33
    ;Leemos del teclado a través del puerto 0x60(in al, 0x60)    
    ; Inicializar el scheduler
    call sched_init
    call game_init
    ; Saltar a la primera tarea: Idle
    ; Cargar indice de la tarea inicial
    mov ax, 27<<3;[0..1]RPL = 00, [2] = 0(GDT), 11001 = 1B
    ltr ax
    sti
    mov ax, 28<<3;[0..1]RPL = 0, [2] = 0(GDT), 11100 = 1C
    mov [sched_task_selector], ax
    jmp far [sched_task_offset]
    
    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $
;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
