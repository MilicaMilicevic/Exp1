;lab05 (2015).

SECTION .data
format		db	'%d',0
format_p	db	'Invalid input',10,0
three		dd	3
two		dd	2
k		dd	1
prev		dd	0

SECTION .bss
n	resd	1
first	resd	1
res	resd	1

SECTION .text
extern scanf,printf
global main
main:

;store val. reg
push ebp
mov ebp,esp
push ebx
push esi
push edi

get_input:
  push	n
  push format
  call scanf
  add esp,8

check_input:
  cmp byte[n],2
  jl	invalid_input
  cmp byte[n],10
  jg	invalid_input
  jmp calculate

invalid_input:
  push format_p
  call printf
  add esp,4
  jmp end

calculate:
  fild	dword[n]	;Sto=n
  fimul	dword[n]	;sto=n*n
  fild	dword[three]	;sto=3.0,st1=n*n
  fild	dword[n]	;n,3,n*n
  fsubr			;in sto is n-3
  fmul 			;sto=n*n-(n-3) ; IMPORTANT:cannot use fimul!
  fld1			;load zero
  fild	dword[n]
  fyl2x			;call function
  fmul
  fstp	dword[first]
  
  fldz	;initial value of sum!

  iterate:
  mov eax,dword[k]
  cmp eax,dword[n]
  ja continue
  	
  fild	dword[k]	;sto=k
  fimul	dword[k]	;sto=k*k
  fild	dword[n]	;n,k*k
  fild	dword[two]	;2,n,k*k
  fmul			;2*n,k*k
  fadd			;2*n+k*k
  fadd	dword[prev]
  fstp	dword[prev]	
  inc 	dword[k]
  jmp 	iterate
  
continue: 
  fld	dword[prev]
  fld	dword[first]
  fdivr			;sto/st1	
  fsqrt
  fstp	dword[res]	;in eax is result
  mov eax,dword[res]

end:
;load reg. values
  pop edi
  pop esi
  pop ebx
  mov esp,ebp
  pop ebp
  ret