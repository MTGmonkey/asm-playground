; ***************************
; slen : String -> Int
; calculates length of string
; ***************************

slen:
  push ebx
  mov ebx, eax

slen_nextchar:
  cmp byte [eax], 0
  jz slen_finished
  inc eax
  jmp slen_nextchar

slen_finished:
  sub eax, ebx
  pop ebx
  ret

; *********************
; clear_bss : BSS -> IO
; clears memory block
; *********************

clear_bss:
  cmp byte [eax], 0
  jz clear_bss_finished
  mov [eax], byte 0
  inc eax
  jmp clear_bss

clear_bss_finished:
  ret

; *******************************
; scmp : String -> String -> Bool
; compares 2 strings exactly
; *******************************

scmp:
  push ecx

scmp_nextchar:
  mov cl, byte [ebx]
  cmp byte [eax], cl
  jnz scmp_bad
  cmp byte [eax], 0
  jz scmp_good
  inc eax
  inc ebx
  jmp scmp_nextchar

scmp_good:
  mov eax, 0
  jmp scmp_finished

scmp_bad:
  mov eax, 1

scmp_finished:
  pop ecx
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

; ************
; exit : IO
; exit program
; ************

exit:
  mov ebx, 0
  mov eax, 1
  int 80h
  ret
