; this file is about the second project of supinfo
; use the 0B800H screen to finish a game which hero find keys to open the door
; last change : 2019/3/27 15:01
;////////////////////////////////////////////////////////////////////
;//                          _ooOoo_                               //
;//                         o8888888o                              //
;//                         88" . "88                              //
;//                         (| ^_^ |)                              //
;//                         O\  =  /O                              //
;//                      ____/`---'\____                           //
;//                    .'  \\|     |//  `.                         //
;//                   /  \\|||  :  |||//  \                        //
;//                  /  _||||| -:- |||||-  \                       //
;//                  |   | \\\  -  /// |   |                       //
;//                  | \_|  ''\---/''  |   |                       //
;//                  \  .-\__  `-`  ___/-. /                       //
;//                ___`. .'  /--.--\  `. . ___                     //
;//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
;//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
;//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
;//      ========`-.____`-.___\_____/___.-`____.-'========         //
;//                           `=---='                              //
;//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
;//         佛祖保佑       永无BUG     永不修改                    //
;////////////////////////////////////////////////////////////////////

assume cs:codesg, ds:datasg, ss:stacksg

stacksg segment
	db 256 dup(0)
stacksg ends

datasg segment
    ; when you win the game
	STR DB "You win, enter the command!$"

	; size of the window
	ROW_OF_GAME dw 320
	COL_OF_GAME dw 200
	
	; size of a rect of the game
	ROW_OF_RECT dw 5
	COL_OF_RECT dw 8
	
	; size of a brick
	LENGTH_OF_BRICK dw 40 
	HEIGHT_OF_BRICK dw 40
	
	; position of the hero
	ROW_OF_HERO dw 0
	COL_OF_HERO dw 0 
	
	; cmp 
	ORDER dw 0
	
	READY_MOVE_ROW dw 0
	READY_MOVE_COL dw 0
	
	; the wall of the game, use 0-9 and A-F(16)
	WALL_ROW_1 dw 40
	WALL_COL_1 dw 0
	
	WALL_ROW_2 dw 40
	WALL_COL_2 dw 40
	
	WALL_ROW_3 dw 40
	WALL_COL_3 dw 80
	
	WALL_ROW_4 dw 40
	WALL_COL_4 dw 160
	
	WALL_ROW_5 dw 120
	WALL_COL_5 dw 40
	
	WALL_ROW_6 dw 120
	WALL_COL_6 dw 80
	
	WALL_ROW_7 dw 120
	WALL_COL_7 dw 120
	
	WALL_ROW_8 dw 120
	WALL_COL_8 dw 160
	
	WALL_ROW_9 dw 160
	WALL_COL_9 dw 120
	
	WALL_ROW_A dw 200
	WALL_COL_A dw 40
	
	WALL_ROW_B dw 240
	WALL_COL_B dw 40
	
	WALL_ROW_C dw 240
	WALL_COL_C dw 120
	
	WALL_ROW_D dw 240
	WALL_COL_D dw 160
	
	WALL_ROW_E dw 280
	WALL_COL_E dw 40
	
	; the door of the game
	NUM_OF_DOOR dw 0
	
	DOOR_ROW_1  dw 40
	DOOR_COL_1  dw 120
	DOOR_INIT_1 dw 1
	
	DOOR_ROW_2  dw 80
	DOOR_COL_2  dw 0
	DOOR_INIT_2 dw 1
	
	DOOR_ROW_3  dw 160
	DOOR_COL_3  dw 40
	DOOR_INIT_3 dw 1
	
	DOOR_ROW_4  dw 240
	DOOR_COL_4  dw 80
	DOOR_INIT_4 dw 1
	
	DOOR_ROW_5  dw 160
	DOOR_COL_5  dw 160
	DOOR_INIT_5 dw 1
	
	; the key of the game
	NUM_OF_KEY dw 0
	
	KEY_ROW_1 dw 0
	KEY_COL_1 dw 160
	
	KEY_ROW_2 dw 80
	KEY_COL_2 dw 160
	
	KEY_ROW_3 dw 200
	KEY_COL_3 dw 0
	
	KEY_ROW_4 dw 160
	KEY_COL_4 dw 80
	
	KEY_ROW_5 dw 280
	KEY_COL_5 dw 160
	
	; valiable for the function
	; Draw_Brick
	BRICK_ROW_POSITION  dw 0
	BRICK_COL_POSITION  dw 0
	BRICK_ROW_LENGTH    dw 0
	BRICK_COL_LENGTH    dw 0
	BRICK_COLOR          db 0
	
	; Test_Wall
	Wall_Row dw 0
	Wall_Col dw 0
	Hero_Row dw 0
	Hero_Col dw 0
	
	; Open_Door
	Key_Row dw 0
	Key_Col dw 0
	
	; music
	MUS_FREG1 DW 330,294,262,294,3 DUP (330)
	DW 3 DUP (294),330,392,392
	DW 330,294,262,294,4 DUP (330)
	DW 294,294,330,294,262,-1
	MUS_TIME1 DW 6 DUP (25),50
	DW 2 DUP (25,25,50)
	DW 12 DUP (25),100
	
datasg ends

codesg segment
; return 
Back:
	retf
	
; stop the program
Stop_Program:
	jmp Stop_Program

; end the program
End_Program:
	mov ax, 4C00H
	int 21H	
	
; set the map on the screen
Set_Map:
	mov ah, 0
	mov al, 4
	int 10H
	
	mov ah, 0BH
	mov bh, 0
	mov bl, 7
	int 10H
	
	mov ah, 0BH
	mov bh, 1
	mov bl, 0
	int 10H
	
	retf

Clear_Map:
	mov ax, 0
	mov BRICK_ROW_POSITION, ax
	mov BRICK_COl_POSITION, ax
	mov ax, 320
	mov BRICK_ROW_LENGTH, ax
	mov ax, 200
	mov BRICK_COL_LENGTH, ax
	mov BRICK_COLOR, 0
	call far ptr Draw_Brick
	
	jmp far ptr Show_Key
	
Draw_Brick:	
	mov dx, 0
	draw_row:
	mov cx, 0
	draw_col:
	mov ah, 0CH
	mov al, BRICK_COLOR
	add cx, BRICK_ROW_POSITION
	add dx, BRICK_COL_POSITION
	int 10H
	sub cx, BRICK_ROW_POSITION
	sub dx, BRICK_COL_POSITION
	inc cx
	cmp cx, BRICK_ROW_LENGTH
	jnz draw_col
	inc dx
	cmp dx, BRICK_COL_LENGTH
	jnz draw_row
	
	retf

Draw_Door:
	mov dx, 0
	draw_row_door1:
	mov cx, 0
	draw_col_door1:
	mov ah, 0CH
	mov al, BRICK_COLOR
	add cx, BRICK_ROW_POSITION
	add dx, BRICK_COL_POSITION
	int 10H
	sub cx, BRICK_ROW_POSITION
	sub dx, BRICK_COL_POSITION
	inc cx
	cmp cx, 40
	jnz draw_col_door1
	inc dx
	cmp dx, 40
	jnz draw_row_door1
	
	mov dx, 5
	draw_row_door2:
	mov cx, 5
	draw_col_door2:
	mov ah, 0CH
	mov al, 0
	add cx, BRICK_ROW_POSITION
	add dx, BRICK_COL_POSITION
	int 10H
	sub cx, BRICK_ROW_POSITION
	sub dx, BRICK_COL_POSITION
	inc cx
	cmp cx, 35
	jnz draw_col_door2
	inc dx
	cmp dx, 40
	jnz draw_row_door2
	
	retf
	
Draw_Key:
	mov dx, 0
	draw_row_key1:
	mov cx, 5
	draw_col_key1:
	mov ah, 0CH
	mov al, BRICK_COLOR
	add cx, BRICK_ROW_POSITION
	add dx, BRICK_COL_POSITION
	int 10H
	sub cx, BRICK_ROW_POSITION
	sub dx, BRICK_COL_POSITION
	inc cx
	cmp cx, 30
	jnz draw_col_key1
	inc dx
	cmp dx, 20
	jnz draw_row_key1
	
	mov dx, 20
	draw_row_key2:
	mov cx, 15
	draw_col_key2:
	mov ah, 0CH
	mov al, BRICK_COLOR
	add cx, BRICK_ROW_POSITION
	add dx, BRICK_COL_POSITION
	int 10H
	sub cx, BRICK_ROW_POSITION
	sub dx, BRICK_COL_POSITION
	inc cx
	cmp cx, 25
	jnz draw_col_key2
	inc dx
	cmp dx, 40
	jnz draw_row_key2
	
	retf

Step_Back:
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Wall:
	mov ax, Hero_Col
	cmp ax, Wall_Col
	je Step_Back
	retf
Test_Row_Wall:
	mov ax, Hero_Row
	cmp ax, Wall_Row
	je Test_Col_Wall
	retf
Test_Wall:
	jmp far ptr Test_Row_Wall

; door1 
BREAK_DOOR_1:
	inc NUM_OF_DOOR
	retf
Step_Back1:
	mov ax, NUM_OF_KEY
	cmp ax, 1
	je BREAK_DOOR_1
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Door1:
	mov ax, Hero_Col
	cmp ax, DOOR_COL_1
	je Step_Back1
	retf
Test_Row_DOOR1:
	mov ax, Hero_Row
	cmp ax, DOOR_ROW_1
	je Test_Col_Door1
	retf
Test_Door_1:
	jmp far ptr Test_Row_DOOR1

; door2 
BREAK_DOOR_2:
	inc NUM_OF_DOOR
	retf
Step_Back2:
	mov ax, NUM_OF_KEY
	cmp ax, 2
	je BREAK_DOOR_2
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Door2:
	mov ax, Hero_Col
	cmp ax, DOOR_COL_2
	je Step_Back2
	retf
Test_Row_DOOR2:
	mov ax, Hero_Row
	cmp ax, DOOR_ROW_2
	je Test_Col_Door2
	retf
Test_Door_2:
	jmp far ptr Test_Row_DOOR2
	
; door3
BREAK_DOOR_3:
	inc NUM_OF_DOOR
	retf
Step_Back3:
	mov ax, NUM_OF_KEY
	cmp ax, 3
	je BREAK_DOOR_3
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Door3:
	mov ax, Hero_Col
	cmp ax, DOOR_COL_3
	je Step_Back3
	retf
Test_Row_DOOR3:
	mov ax, Hero_Row
	cmp ax, DOOR_ROW_3
	je Test_Col_Door3
	retf
Test_Door_3:
	jmp far ptr Test_Row_DOOR3
	
; door4
BREAK_DOOR_4:
	inc NUM_OF_DOOR
	retf
Step_Back4:
	mov ax, NUM_OF_KEY
	cmp ax, 4
	je BREAK_DOOR_4
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Door4:
	mov ax, Hero_Col
	cmp ax, DOOR_COL_4
	je Step_Back4
	retf
Test_Row_DOOR4:
	mov ax, Hero_Row
	cmp ax, DOOR_ROW_4
	je Test_Col_Door4
	retf
Test_Door_4:
	jmp far ptr Test_Row_DOOR4
	
; door5
BREAK_DOOR_5:
	inc NUM_OF_DOOR
	retf
Step_Back5:
	mov ax, NUM_OF_KEY
	cmp ax, 5
	je BREAK_DOOR_5
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	retf
Test_Col_Door5:
	mov ax, Hero_Col
	cmp ax, DOOR_COL_5
	je Step_Back5
	retf
Test_Row_DOOR5:
	mov ax, Hero_Row
	cmp ax, DOOR_ROW_5
	je Test_Col_Door5
	retf
Test_Door_5:
	jmp far ptr Test_Row_DOOR5
	
; draw the first key
Draw_First_Key:
	mov ax, KEY_ROW_1
	mov BRICK_ROW_POSITION, ax
	mov ax, KEY_COL_1
	mov BRICK_COL_POSITION, ax
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COL_LENGTH, 40
	mov BRICK_COLOR, 3
	call far ptr Draw_Key
	
	jmp far ptr Show_Door

; draw the first key
Draw_Second_Key:
	mov ax, KEY_ROW_2
	mov BRICK_ROW_POSITION, ax
	mov ax, KEY_COL_2
	mov BRICK_COL_POSITION, ax
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COL_LENGTH, 40
	mov BRICK_COLOR, 1
	call far ptr Draw_Key
	
	jmp far ptr Show_Door

; draw the first key
Draw_Third_Key:
	mov ax, KEY_ROW_3
	mov BRICK_ROW_POSITION, ax
	mov ax, KEY_COL_3
	mov BRICK_COL_POSITION, ax
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COL_LENGTH, 40
	mov BRICK_COLOR, 2
	call far ptr Draw_Key
	
	jmp far ptr Show_Door

; draw the first key
Draw_Forth_Key:
	mov ax, KEY_ROW_4
	mov BRICK_ROW_POSITION, ax
	mov ax, KEY_COL_4
	mov BRICK_COL_POSITION, ax
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COL_LENGTH, 40
	mov BRICK_COLOR, 3
	call far ptr Draw_Key
	
	jmp far ptr Show_Door

; draw the first key
Draw_Fifth_Key:
	mov ax, KEY_ROW_5
	mov BRICK_ROW_POSITION, ax
	mov ax, KEY_COL_5
	mov BRICK_COL_POSITION, ax
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COL_LENGTH, 40
	mov BRICK_COLOR, 2
	call far ptr Draw_Key
	
	jmp far ptr Show_Door
	
Show_First_Door:
	mov ax, DOOR_ROW_1
	mov BRICK_ROW_POSITION, ax
	mov ax, DOOR_COL_1
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 3
	call far ptr Draw_Door
	
Show_Second_Door:
	mov ax, DOOR_ROW_2
	mov BRICK_ROW_POSITION, ax
	mov ax, DOOR_COL_2
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 1
	call far ptr Draw_Door

Show_Third_Door:	
	mov ax, DOOR_ROW_3
	mov BRICK_ROW_POSITION, ax
	mov ax, DOOR_COL_3
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 2
	call far ptr Draw_Door

Show_Forth_Door:
	mov ax, DOOR_ROW_4
	mov BRICK_ROW_POSITION, ax
	mov ax, DOOR_COL_4
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 3
	call far ptr Draw_Door

Show_Fifth_Door:	
	mov ax, DOOR_ROW_5
	mov BRICK_ROW_POSITION, ax
	mov ax, DOOR_COL_5
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 2
	call far ptr Draw_Door
	
	jmp far ptr Show_Wall

D1K:
	jmp far ptr Draw_First_Key	
D2K:
	jmp far ptr Draw_Second_Key
D3K:
	jmp far ptr Draw_Third_Key
D4K:
	jmp far ptr Draw_Forth_Key
D5K:
	jmp far ptr Draw_Fifth_Key
	
; show the map on the screen
Show_Key:
	; draw the key
	mov ax, NUM_OF_KEY
	cmp ax, 0 ; key id 1
	je D1K
	cmp ax, 1 ; key id 2
	je D2K
	cmp ax, 2 ; key id 3
	je D3K
	cmp ax, 3 ; key id 4
	je D4K
	cmp ax, 4 ; key id 5
	je D5K
	
	jmp far ptr Show_Door

Key_Add:
	inc NUM_OF_KEY
	retf
Test_Key_Col:
	mov ax, Key_Col
	cmp ax, Hero_Col
	je Key_Add
	retf
Test_Key_Row:
	mov ax, Key_Row
	cmp ax, Hero_Row
	je Test_Key_Col
	retf
Key_1:
	mov ax, KEY_ROW_1
	mov Key_Row, ax
	mov ax, KEY_COL_1
	mov Key_Col, ax
	jmp far ptr Test_Key_Row
	retf
Key_2:
	mov ax, KEY_ROW_2
	mov Key_Row, ax
	mov ax, KEY_COL_2
	mov Key_Col, ax
	jmp far ptr Test_Key_Row
	retf
Key_3:
	mov ax, KEY_ROW_3
	mov Key_Row, ax
	mov ax, KEY_COL_3
	mov Key_Col, ax
	jmp far ptr Test_Key_Row
	retf
Key_4:
	mov ax, KEY_ROW_4
	mov Key_Row, ax
	mov ax, KEY_COL_4
	mov Key_Col, ax
	jmp far ptr Test_Key_Row
	retf
Key_5:
	mov ax, KEY_ROW_5
	mov Key_Row, ax
	mov ax, KEY_COL_5
	mov Key_Col, ax
	jmp far ptr Test_Key_Row
	retf
Open_Door:
	mov ax, NUM_OF_KEY
	cmp ax, 0
	je Key_1
	cmp ax, 1
	je Key_2
	cmp ax, 2
	je Key_3
	cmp ax, 3
	je Key_4
	cmp ax, 4
	je Key_5
	
	retf
	
Show_Wall:
	; draw the 14 walls 
	mov ax, WALL_ROW_1
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_1
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_2
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_2
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_3
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_3
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_4
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_4
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_5
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_5
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_6
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_6
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_7
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_7
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_8
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_8
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_9
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_9
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_A
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_A
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_B
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_B
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_C
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_C
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_D
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_D
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, WALL_ROW_E
	mov BRICK_ROW_POSITION, ax
	mov ax, WALL_COL_E
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick

	; draw the hero 
	mov ax, ROW_OF_HERO
	mov BRICK_ROW_POSITION, ax
	mov ax, COL_OF_HERO
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 40
	mov BRICK_ROW_LENGTH, 40
	mov BRICK_COLOR, 7
	call far ptr Draw_Brick
	
	mov ax, ROW_OF_HERO
	add ax, 8
	mov BRICK_ROW_POSITION, ax
	mov ax, COL_OF_HERO
	add ax, 8
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 8
	mov BRICK_ROW_LENGTH, 8
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, ROW_OF_HERO
	add ax, 24
	mov BRICK_ROW_POSITION, ax
	mov ax, COL_OF_HERO
	add ax, 8
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 8
	mov BRICK_ROW_LENGTH, 8
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	mov ax, ROW_OF_HERO
	add ax, 8
	mov BRICK_ROW_POSITION, ax
	mov ax, COL_OF_HERO
	add ax, 24
	mov BRICK_COL_POSITION, ax
	mov BRICK_COL_LENGTH, 8
	mov BRICK_ROW_LENGTH, 24
	mov BRICK_COLOR, 5
	call far ptr Draw_Brick
	
	jmp far ptr Back

D1D:
	jmp far ptr Show_First_Door
D2D:
	jmp far ptr Show_Second_Door
D3D:
	jmp far ptr Show_Third_Door
D4D:
	jmp far ptr Show_Forth_Door
D5D:
	jmp far ptr Show_Fifth_Door

; draw the door
Show_Door:
	cmp NUM_OF_DOOR, 0
	je D1D
	cmp NUM_OF_DOOR, 1
	je D2D
	cmp NUM_OF_DOOR, 2
	je D3D
	cmp NUM_OF_DOOR, 3
	je D4D
	cmp NUM_OF_DOOR, 4
	je D5D
	
	jmp far ptr Show_Wall

MOVE_A:
	mov READY_MOVE_ROW, -40
	mov READY_MOVE_COL, 0
	retf
MOVE_S:
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 40
	retf
MOVE_D:
	mov READY_MOVE_ROW, 40
	mov READY_MOVE_COL, 0
	retf
MOVE_W:
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, -40
	retf
GO_A:
	mov ax,  ROW_OF_HERO
	cmp ax, 0
	jne MOVE_A
	retf
GO_S:
	mov ax, COL_OF_HERO
	cmp ax, 160
	jne MOVE_S
	retf
GO_D:
	mov ax, ROW_OF_HERO
	cmp ax, 280
	jne MOVE_D 
	retf
GO_W:
	mov ax, COL_OF_HERO
	cmp ax, 0
	jne MOVE_W
	retf
	
;read the cin
Get_Cmp:
	mov ax, 0
	mov ORDER, ax
	mov ah, 1
	int 21H
	mov ah, 0
	mov ORDER, ax
	; no cmp
	cmp ax, 0
	je Get_Cmp	
	; cmp is ?
	cmp ax, 61H
	je GO_A
	cmp ax, 73H
	je GO_S
	cmp ax, 64H
	je GO_D
	cmp ax, 77H
	je GO_W
	
	retf
	
T1D:
	call far ptr Test_Door_1
T2D:
	call far ptr Test_Door_2
T3D:
	call far ptr Test_Door_3
T4D:
	call far ptr Test_Door_4
T5D:
	call far ptr Test_Door_5
	retf
Touch_Door:
	mov ax, NUM_OF_DOOR
	cmp ax, 0
	je T1D
	cmp ax, 1
	je T2D
	cmp ax, 2
	je T3D
	cmp ax, 3
	je T4D
	cmp ax, 4
	je T5D
	
	retf
	
	
; base on the cmp, move hero
Move_Hero:
	mov ax, READY_MOVE_ROW
	add ax, ROW_OF_HERO
	mov Hero_Row, ax
	mov ax, READY_MOVE_COL
	add ax, COL_OF_HERO
	mov Hero_Col, ax
	
	mov ax, WALL_ROW_1
	mov Wall_Row, ax
	mov ax, WALL_COL_1
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_2
	mov Wall_Row, ax
	mov ax, WALL_COL_2
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_3
	mov Wall_Row, ax
	mov ax, WALL_COL_3
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_4
	mov Wall_Row, ax
	mov ax, WALL_COL_4
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_5
	mov Wall_Row, ax
	mov ax, WALL_COL_5
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_6
	mov Wall_Row, ax
	mov ax, WALL_COL_6
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_7
	mov Wall_Row, ax
	mov ax, WALL_COL_7
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_8
	mov Wall_Row, ax
	mov ax, WALL_COL_8
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_9
	mov Wall_Row, ax
	mov ax, WALL_COL_9
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_A
	mov Wall_Row, ax
	mov ax, WALL_COL_A
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_B
	mov Wall_Row, ax
	mov ax, WALL_COL_B
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_C
	mov Wall_Row, ax
	mov ax, WALL_COL_C
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_D
	mov Wall_Row, ax
	mov ax, WALL_COL_D
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	mov ax, WALL_ROW_E
	mov Wall_Row, ax
	mov ax, WALL_COL_E
	mov Wall_Col, ax
	call far ptr Test_Wall
	
	call far ptr Touch_Door
	
	mov ax, 0
	add ax, READY_MOVE_ROW
	add ax, ROW_OF_HERO
	mov ROW_OF_HERO, ax
	
	mov ax, 0
	add ax, READY_MOVE_COL
	add ax, COL_OF_HERO
	mov COL_OF_HERO, ax
	
	mov READY_MOVE_ROW, 0
	mov READY_MOVE_COL, 0
	
	retf
	
;******************************************music
GENSOUND PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	MOV AL,0B6H
	OUT 43H,AL
	MOV DX,12H
	MOV AX,348ch
	DIV DI
	OUT 42H,AL
	MOV AL,AH
	OUT 42H,AL
	IN AL,61H
	MOV AH,AL
	OR AL,3
	OUT 61H,AL

WAIT1: 
	MOV CX,3314
	call waitf
DELAY1: 
	DEC BX
	JNZ WAIT1
	MOV AL,AH
	OUT 61H,AL
	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
GENSOUND ENDP
;********************************************
waitf proc near
	push ax
waitf1:
	in al,61h
	and al,10h
	cmp al,ah
	je waitf1
	mov ah,al
	loop waitf1
	pop ax
	ret
waitf endp

;*********************************************
MUSIC PROC NEAR
FREG: 
	MOV DI,[SI]
	CMP DI,-1
	JE END_MUS
	MOV BX,DS:[BP]
	CALL GENSOUND
	ADD SI,2
	ADD BP,2
	ret
END_MUS:
	LEA SI,MUS_FREG1
	LEA BP,DS:MUS_TIME1
	jmp FREG
MUSIC ENDP
	
; doing the game, the main process
Loop_Game:
	call far ptr Clear_Map
	
	call far ptr Get_Cmp
	
	call far ptr Move_Hero
	
	call far ptr Open_Door
	
	LEA SI,MUS_FREG1
	LEA BP,DS:MUS_TIME1
	call MUSIC
	
	; FOR DEBUG
	;jmp far ptr Stop_Program

End_Of_Loop:	
	mov ax, NUM_OF_DOOR
	cmp ax, 5
	jne Loop_Game
	
	retf
	
End_The_Game:
	jmp far ptr End_Program

; main function of the game
start:
	; move datasg to ds
	mov ax, datasg
	mov ds, ax
	
	MOV aH, 0
	MOV AL,00
	INT 10H
	
	; move stacksg to ss and set sp
	mov ax, stacksg
	mov ss, ax
	mov sp, 00F0H
	
	call far ptr Set_Map
	
	call far ptr Loop_Game
	
	; show the game was ended
	lea dx,STR
    mov ah,9
    int 21H
	
	jmp far ptr End_Program
	
codesg ends
end start