%include 'lib.asm'

SECTION .data
s:
  .welcome_message db 'Welcome to this test program! It is experimental and very subject to change.', 0h
  .prompt          db 'repl>', 0h
  .error           db '[ERROR] ', 0h
  .command         db 'command ', 0h
  .not_found       db ' not found', 0h

fn:
  .exit_name      db 'exit', 0Ah, 0h

  .help_name      db 'help', 0Ah, 0h
  .help_content   db 'this program has just 2 commands right now: help and exit', 0Ah, ' help - prints this message', 0Ah, ' exit - quits the program', 0Ah, 'Have fun!', 0h

SECTION .bss
; resb ; 0001 byte
; resw ; 0010 word
; resd ; 0100 double word
; resq ; 1000 quad word
; rest ; 1010 ten bytes
sinput: resb 255 ; 255 bytes

SECTION .text
start:
  pop ecx ; number of arguments

  pop eax ; dispose of first value, the exe
  dec ecx

  mov eax, s.welcome_message
  call sprintln

  .arg_loop:
    cmp ecx, 0h
    jz .repl
    pop eax
    call sprintln
    dec ecx
    jmp .arg_loop

  .repl:
    mov eax, s.prompt
    call sprint

    mov eax, sinput
    call clear_bss

    mov edx, 255    ; max bytes to read
    mov ecx, sinput ; buffer
    mov ebx, 0      ; (STDIN) where to read from
    mov eax, 3      ; (SYS_READ)
    int 80h

    mov eax, sinput
    mov ebx, fn.exit_name
    call scmp
    cmp byte eax, 0
    jz exit

    mov eax, sinput
    mov ebx, fn.help_name
    call scmp
    cmp byte eax, 0
    jz fn_help

    mov eax, s.error
    call sprint
    mov eax, s.command
    call sprint
    mov eax, sinput
    call sdecprint
    mov eax, s.not_found
    call sprintln

    jmp .repl

fn_help:
  push eax

  mov eax, fn.help_content
  call sprintln

  pop eax

  jmp start.repl
