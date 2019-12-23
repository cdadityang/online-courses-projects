// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

@SCREEN
D=A
@i
M=D-1 // i = base address of SCREEN - 1

@KBD
D=A
@j
M=D // j = Base address of KBD = 24576

@i
D=M
@k
M=D // k = i

(LOOP) 
  @KBD
  D=M
  // Check for white or black and JMP
  @WHITE
  D;JEQ // if D==0, then jump to white
  @BLACK
  0;JMP

(BLACK)
  @j
  D=M
  @k
  D=D-M
  @LOOP
  D;JEQ // JUMP back to loop if the screen is already full black
  @k
  A=M
  M=-1
  @k
  M=M+1
  @LOOP
  0;JMP

(WHITE)
  @i
  D=M
  @k
  D=D-M
  @LOOP
  D;JEQ // JUMP back to loop if the screen is already full white
  @k
  M=M-1
  A=M
  M=0
  @LOOP
  0;JMP