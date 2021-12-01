;; Assemble: nasm -felf64 vector_method.asm -o vector.o
;; Link    : ld -o vector vector.o
;; Execute : ./vector
;; All together: nasm -felf64 vector_method.asm -o vector.o && ld -o vector vector.o && ./vector
;;======================================================

section .data
;------------
    ; Constant defines
    line_count      equ    15
    line_length     equ    2*line_count + 1
    line_center     equ    line_count - 1

    ; Message definition
    msg times (line_length+1) db ' '

section .bss
;-----------
    line_number     resb    1               ; Current line number

section .text
;------------
    global _start

_start:
    push rbx

    ; Make the last char an end line
    mov byte[msg + line_length] , 0xA

    ; For each line in line count
    mov  r8  , line_count

EachLine:
    ; Make the center + n and center - n chars an asterix

    ; Upper index
    mov   rbx , msg
    add   rbx , line_center
    movzx rax , byte[line_number]
    add   rbx , rax
    mov   byte[rbx] , '*'

    ; Lower index
    mov   rdx , 2
    mul   rdx
    sub   rbx , rax
    mov   byte[rbx] , '*'

    ; Print the line
    push cx
    mov edx, line_length + 1
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop cx

    ; Loop variables
    inc byte[line_number]
    dec r8
    jnz EachLine

    pop rbx
    mov eax, 1      ; sys_exit
    int 0x80        ; call kernel with exit command

