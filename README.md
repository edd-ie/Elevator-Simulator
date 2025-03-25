# Elevator simulator

## Coding conventions
1. Writing a procedure:
```asm
fx:
  add $t0, $0, $t1
endFx:
jr $ra
```

2. Printing, check `macro.asm` if a function exists
3. writing a loop:
```asm
main:
  ...
  loop:
    ori $t0, $0, 12
    ...
  bne $t1, $t2, loop
  ...
endMain:
```
4. Pushing and poping to stack, check `macro.asm`
```asm
main:
  pop $ra
  pop $ra
endMain:
```
