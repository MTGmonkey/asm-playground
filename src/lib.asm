; ***************************
; slen : String -> Int
; calculates length of string
; ***************************

slen:
  push ebx
  mov ebx, eax

  .loop:
    cmp byte [eax], 0
    jz .fin
    inc eax
    jmp .loop

  .fin:
    sub eax, ebx
    pop ebx
    ret

; *********************
; clear_bss : BSS -> IO
; clears memory block
; *********************

clear_bss:
  cmp byte [eax], 0
  jz .fin
  mov [eax], byte 0
  inc eax
  jmp clear_bss

  .fin:
    ret

; *******************************
; scmp : String -> String -> Bool
; compares 2 strings exactly
; *******************************

scmp:
  push ecx

  .loop:
    mov cl, byte [ebx]
    cmp byte [eax], cl
    jnz .bad
    cmp byte [eax], 0
    jz .good
    inc eax
    inc ebx
    jmp .loop

  .good:
    mov eax, 0
    jmp .fin

  .bad:
    mov eax, 1

  .fin:
    pop ecx
    ret

; ************************
; sdecprint : String -> IO
; prints string 1 shorter
; ************************

sdecprint:
  push edx
  push ecx
  push ebx
  push eax
  call slen
  dec eax

  mov edx, eax
  pop eax
  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  int 80h

  pop ebx
  pop ecx
  pop edx
  ret

; *********************
; sprint : String -> IO
; prints string
; *********************

sprint:
  push edx
  push ecx
  push ebx
  push eax
  call slen

  mov edx, eax
  pop eax
  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  int 80h

  pop ebx
  pop ecx
  pop edx
  ret

; ***********************
; sprintln : String -> IO
; prints string + 0Ah
; ***********************

sprintln:
  call sprint
  push eax    ; initial

  mov eax, 0Ah
  push eax     ; linefeed
  mov eax, esp ; esp is stack pointer
  call sprint

  pop eax ; linefeed
  pop eax ; initial
  ret

; *******************
; bprint : Byte -> IO
; prints 1 byte
; *******************

bprint:
  push edx
  push ecx
  push ebx
  push eax

  mov edx, 1
  pop eax
  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  int 80h

  pop ebx
  pop ecx
  pop edx
  ret

; *********************
; bprintln : Byte -> IO
; prints 1 byte + 0Ah
; *********************

bprintln:
  call bprint
  push eax
  mov eax, 0Ah
  push eax
  mov eax, esp
  call bprint
  pop eax
  pop eax
  ret

; ************
; exit : IO
; exit program
; ************

exit:
  mov ebx, 0
  mov eax, 1
  int 80h
  ret
