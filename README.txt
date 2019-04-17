---------------------------------THE MAZE AND HERO--------------------------------------------
version 1.0
running in intel 8086 written by assembly language
compile with masm 3.0 or upper vision
with window xp's debug or dosbox for window 7 and 10
(my computer is window 10 so i install dosbox ensue the program can running in my computer)


in this project, we make a game with assembly language
this game is about a hero finding key to open door so he can escape the maze

this game shows image with 320 * 200 in the debug window
we use "int 10H" to draw a pix on the screen
so we write a function named "Draw_Brick" to draw a rect on the screen
this function receive five value: row, col, length, height, color, discribe the brick
with this function we can draw variety of different birck on the screen

basic logic:
firstly, there are a 320 * 200 white brick draw on the screen, being the background
secondly, we draw the walls, keys, doors on the screen, being the map of the game
thirdly, we receive the command from the keyboard, store it on the two values
forthly, we judge if the command is reasonable, if so, hero moves, if not, hero won't moves
fifthly, we judge if the key or the door is touched, if so, add the key or open the door
sixthly, we judge if the game is end, if so, end the game, if not, jump to the first

