        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start

main:   ;;VALORES A SEREM DIVIDIDOS E MULTIPLICADOS
        MOV R8, #9
        MOV R9, #2
        ;;VALORES SENDO TRADUZIDOS PARA OS REGISTRADORES USADOS NAS SUBROTINAS
        MOV R0, R8
        MOV R1, R9
        
        BL Mul8b
        BL Div8b

loop:   B main


;;SUBROTINA DE MULTIPLICAÇÃO EM 8 BITS
;; R2 := R0 x R1
Mul8b:  MOV R5, R1      
        ;;R5 FUNCIONA COMO REGISTRADOR AUXILIAR
LoopM:  CBZ R5, FimM
        SUB R5, R5, #1
        ADD R2, R0
        B LoopM
FimM:   MOV R10, R2
        ;;LIMPANDO O REG PARA USO FUTURO
        MOV R2, #0 
        MOV R5, #0
        BX LR 
        
;;SUBROTINA DE DIVISÃO EM 8 BITS
;;R0 / R1 = R2 & R3 RESTO      
Div8b:  MOV R3, R0
LoopD:  CMP R3, R1
        BLO FimD
        SUB R3, R1
        ADD R2, #1
        B LoopD
FimD:   MOV R11, R2
        MOV R12, R3
        ;;LIMPANDO OS REGS PARA USO FUTURO
        MOV R2, #0
        MOV R3, #0
        BX LR
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
