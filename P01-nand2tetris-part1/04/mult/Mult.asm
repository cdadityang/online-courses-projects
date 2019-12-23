// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// Problem 1: Mult: a program performing R2 = R0 * R1.
// We have to run it with CPU Emulator. Hack Computer doesn't have multiplication operations.
// So how to do this? Hint: Use a loop to do it.
// We'll make a OS in Part 2, there we'll use Math library and this will have powerful operations
// including multiplications.

// Put your code here.

@R1
D=M
@n
M=D // n = R1
@i
M=1 // i = 1
@sum
M=0 // sum = 0
(LOOP)
  @i
  D=M // D = value inside i
  @n
  D=D-M
  @STOP
  D; JGT // if i > n goto STOP
  @sum
  D=M // D = value inside sum
  @R0
  D=D+M
  @sum
  M=D // sum = sum + R0
  @i
  M=M+1 // i = i + 1
  @LOOP
  0; JMP
(STOP)
  @sum
  D=M
  @R2
  M=D // R2 = sum
(END)
  @END
  0; JMP