section .data
    msg db "Hello, world!", 0xa
    len equ $ - msg
    
section .text
    global _start

_start:
    mov r9,  msg    ; test for 64 bit compatibility
    mov edx, len    ; store message length in edx
    mov rcx, r9     ; store the message pointer in ecx
    mov ebx, 1      ; stdout
    mov eax, 4      ; sys_write
    int 0x80        ; call kernel with write command

    mov eax, 1      ; sys_exit
    int 0x80        ; call kernel again with exit command
