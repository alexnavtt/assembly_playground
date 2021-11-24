; Adaptation of a tutorial to print a triangle of asterix's to the terminal
; This will instead print a pyramid of asterix's defined by the line_count variable

section .data
;------------
line_count  db      25          ; The number of lines

section .bss
;-----------
msg         resb    1           ; stddout singe char message
aster_done  resb    1           ; finished printting asterixes?
max_chars   resb    1           ; maximum number of chars in a line
cur_chars   resb    1           ; current amount of chars in the line
cur_comp    resb    1           ; (max_chars - cur_chars)/2 (current complement)
line_no     resb    1           ; The current line number


section .text
;------------
    global _start
_start:

    ; Calculate the total number of characters we need per line (4*line_count + 2)
    mov     al,     [line_count]
    inc     al
    mov     cl,     2
    mul     cl
    dec     al
    mov byte[max_chars], al


; Loop until we have finished all the lines
print_line:
    ; Calculate how many asterixes we need
    mov     al,     [line_no]
    inc     al
    mov     cl,     2
    mul     cl
    dec     al
    mov [cur_chars], al

    ; Calculate how many spaces we need
    mov     al,     [max_chars]
    sub     al,     [cur_chars]
    mov     cl,     2
    div     cl
    mov [cur_comp], al

    ; Use r8b as the count variable
    mov r8b, 0

space:
    ; Check if cur_comp is zero (no spaces)
    cmp byte[cur_comp], 0
    je      asterix

    ; Print the initial spaces
    inc     r8b
    mov     byte[msg],   ' '
    call    printMsg
    cmp     r8b,         byte [cur_comp]
    jne     space

    ; Reset and check if we need to print asterixes
    mov     r8b,               0
    cmp     byte[aster_done],  0
    jne     line_finish

asterix:
    ; Print the asterixes
    inc     r8b
    mov     byte[msg], '*'
    call    printMsg
    cmp     r8b,        byte[cur_chars]
    jne     asterix

    ; Check if there are no spaces
    cmp byte[cur_comp], 0
    je  line_finish

    ; If we're done with asterixes, go back to spaces
    mov     r8b,              0
    mov     byte[aster_done], 1
    jmp     space

line_finish:

    ; Reset aster_done
    mov byte[aster_done], 0

    ; Print an end-line character
    mov byte[msg],  0xA
    call printMsg

    ; Test to see if we have done the last line
    inc byte [line_no]              ; Increment the counter
    mov al,  [line_no]
    cmp al,  [line_count]           ; Is it less than or equal to line_count?
    jne      print_line             ; If so then jump back and do again

    mov     eax,    1               ; sys_exit
    int     0x80                    ; call kernel again with exit command
    ret

; print the byte stored in msg
printMsg:
    mov edx, 1
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80
    ret
