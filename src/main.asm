%include 'lib.asm'

SECTION .data
welcome_message db 'Welcome to this test program! It is experimental and very subject to change.', 0h
prompt          db 'Enter a string to print: ', 0h
exit_str        db 'exit', 0Ah, 0h

SECTION .bss
; resb ; 0001 byte
; resw ; 0010 word
; resd ; 0100 double word
; resq ; 1000 quad word
; rest ; 1010 ten bytes
sinput: resb 255 ; 255 bytes

SECTION .text
global _start

_start:
  pop ecx ; number of arguments

  pop eax ; dispose of first value, the exe
  dec ecx

  mov eax, welcome_message
  call sprintln

next_arg:
  cmp ecx, 0h
  jz prompt_loop
  pop eax
  call sprintln
  dec ecx
  jmp next_arg

prompt_loop:
  mov eax, prompt
  call sprint

  mov eax, sinput
  call clear_bss

  mov edx, 255    ; max bytes to read
  mov ecx, sinput ; buffer
  mov ebx, 0      ; (STDIN) where to read from
  mov eax, 3      ; (SYS_READ)
  int 80h

  mov eax, sinput
  mov ebx, exit_str
  call scmp
  cmp byte eax, 0
  jz done

  mov eax, sinput
  call sprint

  jmp prompt_loop

done:
  call exit
