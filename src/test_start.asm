%include 'lib.asm'

SECTION .data
ts:
  .test_welcome db "Welcome to the test suite!", 0h

  .running_test db "running test ", 0h
  .ellipsis     db "... ", 0h
  .error        db "[ERROR] ", 0h
  .failed       db " failed", 0h
  .failed_code  db " failed with exit code ", 0h
  .all_good     db "all tests passed", 0h
  .divider      db "--------------------------------", 0h

slen_zero_length:
  .name   db "slen_zero_length", 0h
  .should db "slen should be 0", 0h
  .result db "slen result is ", 0h

scmp_a_zero_length:
  .name   db "scmp_a_zero_length", 0h
  .should db "scmp should be 1", 0h
  .result db "scmp result is ", 0h

scmp_b_zero_length:
  .name   db "scmp_b_zero_length", 0h
  .should db "scmp should be 1", 0h
  .result db "scmp result is ", 0h

scmp_both_zero_length:
  .name   db "scmp_both_zero_length", 0h
  .should db "scmp should be 0", 0h
  .result db "scmp result is ", 0h

scmp_both_short_s:
  .name   db "scmp_both_short_s", 0h
  .should db "scmp should be 0", 0h
  .result db "scmp result is ", 0h

cases:
  .zero_length db 0h
  .short_s     db "1 short Test String!", 0h

numerals db "0123456789", 0h

SECTION .text
global _start

_start:
  mov eax, ts.test_welcome
  call sprintln

  mov eax, ts.divider
  call sprintln
  mov eax, slen_zero_length.name
  call sprintln
  call slen_zero_length_test

  mov eax, ts.divider
  call sprintln
  mov eax, scmp_a_zero_length.name
  call sprintln
  call scmp_a_zero_length_test

  mov eax, ts.divider
  call sprintln
  mov eax, scmp_b_zero_length.name
  call sprintln
  call scmp_b_zero_length_test

  mov eax, ts.divider
  call sprintln
  mov eax, scmp_both_zero_length.name
  call sprintln
  call scmp_both_zero_length_test

  mov eax, ts.divider
  call sprintln
  mov eax, scmp_both_short_s.name
  call sprintln
  call scmp_both_short_s_test

  mov eax, ts.divider
  call sprintln
  mov eax, ts.all_good
  call sprintln

  call exit

slen_zero_length_test:
  push eax

  mov eax, cases.zero_length
  call slen
  push eax
  mov eax, slen_zero_length.should
  call sprintln
  mov eax, slen_zero_length.result
  call sprint
  pop eax
  cmp eax, 0
  jnz slen_zero_length_test.failed
  add eax, numerals
  call bprintln

  pop eax
  ret

  .failed:
    mov ebx, slen_zero_length.name
    call failed_with_code

scmp_a_zero_length_test:
  push ebx
  push eax

  mov eax, cases.zero_length
  mov ebx, cases.short_s
  call scmp
  push eax
  mov eax, scmp_a_zero_length.should
  call sprintln
  mov eax, scmp_a_zero_length.result
  call sprint
  pop eax
  cmp eax, 1
  jnz scmp_a_zero_length_test.failed
  add eax, numerals
  call bprintln

  pop eax
  pop ebx
  ret

  .failed:
    mov ebx, scmp_a_zero_length.name
    call failed_with_code

scmp_b_zero_length_test:
  push ebx
  push eax

  mov eax, cases.short_s
  mov ebx, cases.zero_length
  call scmp
  push eax
  mov eax, scmp_b_zero_length.should
  call sprintln
  mov eax, scmp_b_zero_length.result
  call sprint
  pop eax
  cmp eax, 1
  jnz scmp_b_zero_length_test.failed
  add eax, numerals
  call bprintln

  pop eax
  pop ebx
  ret

  .failed:
    mov ebx, scmp_b_zero_length.name
    call failed_with_code

scmp_both_zero_length_test:
  push ebx
  push eax

  mov eax, cases.zero_length
  mov ebx, eax
  call scmp
  push eax
  mov eax, scmp_both_zero_length.should
  call sprintln
  mov eax, scmp_both_zero_length.result
  call sprint
  pop eax
  cmp eax, 0
  jnz scmp_both_zero_length_test.failed
  add eax, numerals
  call bprintln

  pop eax
  pop ebx
  ret

  .failed:
    mov ebx, scmp_both_zero_length.name
    call failed_with_code

scmp_both_short_s_test:
  push ebx
  push eax

  mov eax, cases.short_s
  mov ebx, eax
  call scmp
  push eax
  mov eax, scmp_both_short_s.should
  call sprintln
  mov eax, scmp_both_short_s.result
  call sprint
  pop eax
  cmp eax, 0
  jnz scmp_both_zero_length_test.failed
  add eax, numerals
  call bprintln

  pop eax
  pop ebx
  ret

  .failed:
    mov ebx, scmp_both_zero_length.name
    call failed_with_code

failed:
  mov eax, ts.ellipsis
  call sprintln
  mov eax, ts.error
  call sprint
  mov eax, ebx
  call sprint
  mov eax, ts.failed
  call sprint
  call exit

failed_with_code:
  push eax
  
  mov eax, ts.ellipsis
  call sprintln
  mov eax, ts.error
  call sprint
  mov eax, ebx
  call sprint
  mov eax, ts.failed_code
  call sprint
  pop eax
  add eax, numerals
  call bprintln
  call exit
