# Elevator simulator

## Key bindings
`1-4` = floor requests, moving up
`5-8` = floor requests, moving down (5 = floor 1, 8 = floor 4)
`q` = Emergency alert
`esc` = Exit the program

## Connecting to the keyboard

1. Click on `tools` on top menu bar
2. Select `Keyboard and Display MMO Simulator`

   <img src="./assets/tools.jpg" alt="tools" />

3. Once open compile the `main.asm` to start the program
4. Select `Connect to MIPS`
   <img src="./assets/connect.jpg" alt="connect" />
   
5. Set run speed at top right = 30inst/sec
6. Run `main.asm`
7. In the opened keyboard window, click the bottom white space above `connect to mips` button to begin typing.
8. Just type.

## Coding conventions

1. Writing a procedure:

```asm
fx:
  add $t0, $0, $t1
  ...
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
  ...
  push $ra
  ...
  pop $ra
  ...
endMain:
```
