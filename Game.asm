brick struct
xaxis dw 0
yaxis dw 0
endxlimit dw 0
endylimit dw 0
color db 0
collision db 0
special db 0
brick ends

draw struct
xaxis dw 0
yaxis dw 0
endxlimit dw 0
endylimit dw 0
color db 0
draw ends

ball struct
xaxis dw 152
yaxis dw 179
endxlimit dw 6
endylimit dw 6
color db 0bh
ball ends

paddle struct
xaxis dw 125
yaxis dw 188
endxlimit dw 60
endylimit dw 3
color db 1110b
paddle ends

.model small
.stack 100h
.data
x dw 0A0h ; Starting axis for the drawing of rectangle
y dw 64h  ; Starting axis for the drawing of rectangle
size_ofball DW 06h
previous_time db 0
colour db 6 ; Colour of rectangle. Change it for different colours (0 - 15)
buffer db 50 dup ('$')  ;read data stored in it
fhandle dw 0 ;file address
fname db 'score.txt',0 ;file name
score db '90' ; variable from score will be written in file
over db "GAME OVER!$"
;menu variables
win db "YOU WIN!$"
titleStr db "BRICK BREAKER GAME!", '$'
usernamePrompt db "Username:", '$'
rulesConfirmprompt db "ENTER to go back",'$'
username db 20 dup(0)
hscore db "HIGH SCORE" , '$'
hscore1 db "Abdullah : 70" , '$'
hscore2 db "Daniyal : 60" , '$'
hscore3 db "Uzair : 50" , '$'
level db 1
ruleTitle db "Rules of the Game",'$'
welcome db "Welcome",'$'
rule1 db "1. Hit all the possible bricks.", '$'
rule2 db "2. Use keys to move the paddle", '$'
rule3 db "3. You have three lives", '$'
rule4 db "4. Press ESC to Exit", '$'
rule5 db "ENJOY!!! :)", '$'
choiceTitle db "BRICK BREAKER GAME",'$'
choiceprompt db "Your Choice : ",'$'
continuestr db "1. Continue$"
choice1 db "1. New Game",'$'
choice2 db "2. See Rules",'$'
choice3 db "3. View Highscore",'$'
choice4 db "4. EXIT" , '$'
scorestr db "Score: $"	
scoreCount dw 0
onezer0 db "0$"
Livestr db "Lives: $"
var dw 20
	d1 draw<>
	b1 ball<>
	p1 paddle<>
	br1 brick<91,54,30,12,10,1>
	br2 brick<124,54,30,12,10,1>
	br3 brick<157,54,30,12,10,1>
	br4 brick<91,68,30,12,10,1>
	br5 brick<124,68,30,12,10,1>
	br6 brick<157,68,30,12,10,1>
	br7 brick<190,68,30,12,10,1>
	br8 brick<190,54,30,12,10,1>
	br9 brick<91,82,30,12,10,1>
	br10 brick<124,82,30,12,10,1>
	br11 brick<157,82,30,12,10,1>
	br12 brick<190,82,30,12,10,1>
	br13 brick<190,110,30,12,10,1>
	br14 brick<91,96,30,12,10,1>
	br15 brick<124,96,30,12,10,1>
	br16 brick<157,96,30,12,10,1>
	br17 brick<190,96,30,12,10,1>
	br18 brick<124,110,30,12,10,1>
	br19 brick<157,110,30,12,10,1>
	br20 brick<91,110,30,12,10,1>
	
	ballLeft dw 0
	ballUp dw 0
	exDelay db 0
	begin db 0
	ballspeed dw 1
	paddlespeed dw 10
	livecount db 3
	collision db 0
	count db 0
	onethird_paddlde dw 0
.code
	mov ax,@data
	mov ds,ax
	mov ax,0
	call displayTitle
	call choiceboard
BrickColorChange macro bk
	inc bk.color
	drawbrick bk
endm	
BrickBreaker macro brr
	mov brr.color,0h
	drawbrick brr
endm
	
BallBrickCollision macro brk   
	mov collision,0
	.if brk.color != 00h && collision == 0
		mov ax,b1.yaxis
		add ax,b1.endylimit
		mov bx,brk.yaxis
		sub bx,5
		.if ax >= bx && ax < brk.yaxis
			mov bx,brk.xaxis
			mov ax,b1.xaxis
			add ax,b1.endxlimit
			.if ax >= bx
				add bx,brk.endxlimit
				.if b1.xaxis <= bx
					sub brk.collision,1
					.if brk.collision == 0 && brk.color != 6
						call beep
						.if brk.special == 1  
							call specialbrick 
							add scoreCount,4
						.endif
						BrickBreaker brk
						mov ballUp,1
						mov collision,1
						inc scoreCount
						call drawScoreBar
						.if scoreCount == 20
							call Level2
						.endif	
						.if scoreCount == 40
							call Level3
						.endif
						.if scoreCount == 60
							call gamewin
						.endif
					.endif	
					.if brk.collision > 0 && brk.color != 6
						BrickColorChange brk
						mov ballUp,1
						mov collision,1
					.endif
					.if brk.color == 6
						mov ballUp,1
					.endif	
				.endif
			.endif
		.endif	
	.endif	
	
	.if brk.color != 00h && collision == 0
		mov ax,brk.yaxis
		add ax,brk.endylimit
		add ax,5
		mov bx,brk.yaxis
		add bx,brk.endylimit
		.if b1.yaxis <= ax && b1.yaxis > bx
			mov bx,brk.xaxis
			mov ax,b1.xaxis
			add ax,b1.endxlimit
			.if ax >= bx
				add bx,brk.endxlimit
				.if b1.xaxis <= bx
					sub brk.collision,1
					.if brk.collision == 0 && brk.color != 6
						call beep
						.if brk.special == 1  
							call specialbrick 
							add scoreCount,4
						.endif
						BrickBreaker brk
						mov ballUp,0
						mov collision,1
						inc scoreCount
						call drawScoreBar
						.if scoreCount == 20
							call Level2
						.endif	
						.if scoreCount == 40
							call Level3
						.endif
						.if scoreCount == 60
							call gamewin
						.endif
					.endif	
					.if brk.collision > 0 && brk.color != 6
						BrickColorChange brk
						mov ballUp,0
						mov collision,1
					.endif
					.if brk.color == 6
						mov ballUp,0
					.endif	
				.endif
			.endif	
		.endif
	.endif	
	
	.if brk.color != 00h && collision == 0
		mov ax,b1.xaxis
		add ax,b1.endxlimit
		mov bx,brk.xaxis
		sub bx,5
		.if ax >= bx && ax < brk.xaxis
			mov bx,brk.yaxis
			mov ax,b1.yaxis
			add ax,b1.endylimit
			.if ax >= bx
				add bx,brk.endylimit
				.if b1.yaxis <= bx
					sub brk.collision,1
					.if brk.collision == 0 && brk.color != 6
						call beep
						.if brk.special == 1  
							call specialbrick 
							add scoreCount,4
						.endif
						BrickBreaker brk
						mov ballLeft,1
						mov collision,1
						inc scoreCount
						call drawScoreBar
						.if scoreCount == 20
							call Level2
						.endif	
						.if scoreCount == 40
							call Level3
						.endif
						.if scoreCount == 60
							call gamewin
						.endif
					.endif	
					.if brk.collision > 0 && brk.color != 6
						BrickColorChange brk
						mov ballLeft,1
						mov collision,1
					.endif
					.if brk.color == 6
						mov ballLeft,1
					.endif	
				.endif
			.endif
		.endif
	.endif

	.if brk.color != 00h && collision == 0
		mov ax,brk.xaxis
		add ax,brk.endxlimit
		add ax,5
		mov bx,brk.xaxis
		add bx,brk.endxlimit
		.if b1.xaxis <= ax && b1.xaxis > bx 
			mov bx,brk.yaxis
			mov ax,b1.yaxis
			add ax,b1.endylimit
			.if ax >= bx
				add bx,brk.endylimit
				.if b1.yaxis <= bx
					sub brk.collision,1
					.if brk.collision == 0 && brk.color != 6
						call beep
						.if brk.special == 1  
							call specialbrick
							add scoreCount,4	
						.endif
						BrickBreaker brk					
						mov ballLeft,0
						mov collision,1
						inc scoreCount
						call drawScoreBar
						.if scoreCount == 20
							call Level2
						.endif	
						.if scoreCount == 40
							call Level3
						.endif
						.if scoreCount == 60
							call gamewin
						.endif
					.endif	
					.if brk.collision > 0 && brk.color != 6
						BrickColorChange brk
						mov ballLeft,0
						mov collision,1
					.endif
					.if brk.color == 6
						mov ballLeft,0
					.endif	
				.endif
			.endif
		.endif
	.endif	
endm

   	
drawbrick macro br
	.if br.xaxis != 0 && br.yaxis != 0
		mov ax,br.xaxis
		mov d1.xaxis,ax
		mov ax,br.yaxis
		mov d1.yaxis,ax
		mov ax,br.endylimit
		mov d1.endylimit,ax
		mov ax,br.endxlimit
		mov d1.endxlimit,ax
		mov al,br.color
		mov d1.color,al
		call drawf
	.endif
endm
	
MyGame PROC
	
	;video mode (graphic) 
	mov ah, 0
	mov al, 0Dh    ;320x200
	int 10h
	call drawScoreBar
	call drawLives
	call drawlifeCount
	call topBoundary
	call bottomBoundary
	call leftBoundary
	call rightBoundary
	call drawBall
	call drawpaddle
	drawbrick br1
	drawbrick br2
	drawbrick br3
	drawbrick br4
	drawbrick br5
	drawbrick br6
	drawbrick br7
	drawbrick br8
	drawbrick br9
	drawbrick br10
	drawbrick br11
	drawbrick br12
	drawbrick br13
	drawbrick br14
	drawbrick br15
	drawbrick br16
	drawbrick br17
	drawbrick br18
	drawbrick br19
	drawbrick br20

	
	call Game
	
	
MyGame ENDP
	

specialbrick proc
	call randombrick
	call randombrick
	call randombrick
	call randombrick
	call randombrick
	ret
specialbrick endp

randombrick proc
	int 1ah             
	mov ax,dx            
	mov dx,0
	mov bx,var          
	div bx                             
	
	.if dx == 1
			call randombrick
	.elseif dx == 2
		.if br2.color != 0
			BrickBreaker br2
		.else
			call randombrick
		.endif
	.elseif dx == 3
		.if br3.color != 0
			BrickBreaker br3
		.else
			call randombrick
		.endif
	.elseif dx == 4
		.if br4.color != 0
			BrickBreaker br4
		.else
			call randombrick
		.endif
	.elseif dx == 5
		.if br5.color != 0
			BrickBreaker br5
		.else
			call randombrick
		.endif
	.elseif dx == 6
		.if br6.color != 0
			BrickBreaker br6
		.else
			call randombrick
		.endif
	.elseif dx == 7
		.if br7.color != 0
			BrickBreaker br7
		.else
			call randombrick
		.endif
	.elseif dx == 8
		call randombrick
	.elseif dx == 9
		.if br9.color != 0
			BrickBreaker br9
		.else
			call randombrick
		.endif
	.elseif dx == 10
		.if br10.color != 0
			BrickBreaker br10
		.else
			call randombrick
		.endif
	.elseif dx == 11
		.if br11.color != 0
			BrickBreaker br11
		.else
			call randombrick
		.endif
	.elseif dx == 12
		.if br12.color != 0
			BrickBreaker br12
		.else
			call randombrick
		.endif
	.elseif dx == 13
		call randombrick
	.elseif dx == 14
		.if br14.color != 0
			BrickBreaker br14
		.else
			call randombrick
		.endif
	.elseif dx == 15
		.if br15.color != 0
			BrickBreaker br15
		.else
			call randombrick
		.endif
	.elseif dx == 16
		.if br16.color != 0
			BrickBreaker br16
		.else
			call randombrick
		.endif
	.elseif dx == 17
		.if br17.color != 0
			BrickBreaker br17
		.else
			call randombrick
		.endif
	.elseif dx == 18
		.if br18.color != 0
			BrickBreaker br18
		.else
			call randombrick
		.endif
	.elseif dx == 19
		.if br19.color != 0
			BrickBreaker br19
		.else
			call randombrick
		.endif
	.elseif dx == 20
		call randombrick
	.endif
	ret
randombrick endp

beep proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 400        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

        pop dx
        pop cx
        pop bx
        pop ax

ret
beep endp


Level1 proc
	mov count,0
	mov livecount,3
	mov scoreCount,0
	mov ballspeed,1
	mov paddlespeed,10
	mov p1.endxlimit,60
	
	mov b1.xaxis,152
	mov b1.yaxis,179

	mov p1.xaxis,125
	mov p1.yaxis,188
	
	mov br1.xaxis,91
	mov br1.yaxis,54
	mov br1.color,10
	mov br1.collision,1
	
	mov br2.color,10
	mov br2.collision,1
	
	mov br3.color,10
	mov br3.collision,1
	
	mov br4.color,10
	mov br4.collision,1
	
	mov br5.color,10
	mov br5.collision,1
	
	mov br6.color,10
	mov br6.collision,1
	
	mov br7.color,10
	mov br7.collision,1
	
	mov br8.xaxis,190
	mov br8.yaxis,54
	mov br8.color,10
	mov br8.collision,1
	
	mov br9.color,10
	mov br9.collision,1
	
	mov br10.color,10
	mov br10.collision,1
	
	mov br11.color,10
	mov br11.collision,1
	
	mov br12.color,10
	mov br12.collision,1
	
	mov br13.xaxis,190
	mov br13.yaxis,110
	mov br13.color,10
	mov br13.collision,1
	
	mov br14.color,10
	mov br14.collision,1
	
	mov br15.color,10
	mov br15.collision,1
	
	mov br16.color,10
	mov br16.collision,1
	
	mov br17.color,10
	mov br17.collision,1
	
	mov br18.color,10
	mov br18.collision,1
	
	mov br19.color,10
	mov br19.collision,1
	
	mov br20.xaxis,91
	mov br20.yaxis,110
	mov br20.color,10
	mov br20.collision,1
	
	call MyGame
	
	
Level1 endp	

Level2 proc
	inc level
	mov ballspeed,2
	mov paddlespeed,17
	mov p1.endxlimit,45
	
	mov b1.xaxis,144
	mov b1.yaxis,179

	mov p1.xaxis,125
	mov p1.yaxis,188
	
	mov br1.xaxis,139
	mov br1.yaxis,40
	mov br1.color,10
	mov br1.collision,2
	
	mov br2.color,10
	mov br2.collision,2
	
	mov br3.color,10
	mov br3.collision,2
	
	mov br4.color,10
	mov br4.collision,2
	
	mov br5.color,10
	mov br5.collision,2
	
	mov br6.color,10
	mov br6.collision,2
	
	mov br7.color,10
	mov br7.collision,2
	
	mov br8.xaxis,58
	mov br8.yaxis,82
	mov br8.color,10
	mov br8.collision,2
	
	mov br9.color,10
	mov br9.collision,2
	
	mov br10.color,10
	mov br10.collision,2
	
	mov br11.color,10
	mov br11.collision,2
	
	mov br12.color,10
	mov br12.collision,2
	
	mov br13.xaxis,223
	mov br13.yaxis,82
	mov br13.color,10
	mov br13.collision,2
	
	mov br14.color,10
	mov br14.collision,2
	
	mov br15.color,10
	mov br15.collision,2
	
	mov br16.color,10
	mov br16.collision,2
	
	mov br17.color,10
	mov br17.collision,2
	
	mov br18.color,10
	mov br18.collision,2
	
	mov br19.color,10
	mov br19.collision,2
	
	mov br20.xaxis,139
	mov br20.yaxis,124
	mov br20.color,10
	mov br20.collision,2
	
	call MyGame
	
	
Level2 endp	
	
Level3 proc
	inc level
	mov ballspeed,3
	mov paddlespeed,22
	mov p1.endxlimit,45
	
	mov b1.xaxis,144
	mov b1.yaxis,179

	mov p1.xaxis,125
	mov p1.yaxis,188
	
	mov br1.xaxis,139
	mov br1.yaxis,40
	mov br1.color,6
	mov br1.collision,3
	
	mov br2.color,10
	mov br2.collision,3
	
	mov br3.color,10
	mov br3.collision,3
	
	mov br4.color,10
	mov br4.collision,3
	
	mov br5.color,10
	mov br5.collision,3
	
	mov br6.color,10
	mov br6.collision,3
	
	mov br7.color,10
	mov br7.collision,3
	
	mov br8.xaxis,58
	mov br8.yaxis,82
	mov br8.color,6
	mov br8.collision,3
	
	mov br9.color,10
	mov br9.collision,3
	
	mov br10.color,10
	mov br10.collision,3
	
	mov br11.color,10
	mov br11.collision,3
	
	mov br12.color,10
	mov br12.collision,3
	
	mov br13.xaxis,223
	mov br13.yaxis,82
	mov br13.color,6
	mov br13.collision,3
	
	mov br14.color,10
	mov br14.collision,3
	
	mov br15.color,10
	mov br15.collision,3
	
	mov br16.color,10
	mov br16.collision,3
	
	mov br17.color,9
	mov br17.collision,3
	mov br17.special,1
	
	mov br18.color,10
	mov br18.collision,3
	
	mov br19.color,10
	mov br19.collision,3
	
	mov br20.xaxis,139
	mov br20.yaxis,124
	mov br20.color,6
	mov br20.collision,3
	
	call delay
	call MyGame
	
	
Level3 endp	
	
drawpaddle proc
	mov ax,p1.xaxis
	mov d1.xaxis,ax
	mov ax,p1.yaxis
	mov d1.yaxis,ax
	mov ax,p1.endylimit
	mov d1.endylimit,ax
	mov ax,p1.endxlimit
	mov d1.endxlimit,ax
	mov al,p1.color
	mov d1.color,al
	call drawf
	ret
drawpaddle endp
	 
drawBall proc
	mov ax,b1.xaxis
	mov d1.xaxis,ax
	mov ax,b1.yaxis
	mov d1.yaxis,ax
	mov ax,b1.endylimit
	mov d1.endylimit,ax
	mov ax,b1.endxlimit
	mov d1.endxlimit,ax
	mov al,b1.color
	mov d1.color,al
	mov si,0
	mov di,0
	mov cx,d1.xaxis   
	mov dx,d1.yaxis   
	.while si < d1.endylimit
		mov di, 0
		.while di < d1.endxlimit
			mov al, d1.color  
			mov ah, 0CH 
			int 10H
			
			inc cx
			inc di
		.ENDW
		mov cx, d1.xaxis
		inc dx
		inc si
	.ENDW
	mov cx,b1.xaxis
	mov dx,b1.yaxis
	mov al,0
	mov ah,0ch											
	int 10h	
	
	add cx,5
	mov al,0
	mov ah,0ch											
	int 10h	
	
	add dx,5
	mov al,0
	mov ah,0ch											
	int 10h	
	
	sub cx,5
	mov al,0
	mov ah,0ch											
	int 10h
	
	ret
drawBall endp
	
topBoundary proc
	mov d1.xaxis,10
	mov d1.yaxis,20
	mov d1.endylimit,3
	mov d1.endxlimit,300
	mov d1.color,04h
	call drawf
	ret
topBoundary endp
bottomBoundary proc
	mov d1.xaxis,10
	mov d1.yaxis,195
	mov d1.endylimit,3
	mov d1.endxlimit,300
	mov d1.color,04h
	call drawf
	ret
bottomBoundary endp
leftBoundary proc
	mov d1.xaxis,10
	mov d1.yaxis,20
	mov d1.endylimit,175
	mov d1.endxlimit,3
	mov d1.color,04h
	call drawf
	ret
leftBoundary endp
rightBoundary proc
	mov d1.xaxis,310
	mov d1.yaxis,20
	mov d1.endylimit,178
	mov d1.endxlimit,3
	mov d1.color,04h
	call drawf
	ret
rightBoundary endp
	
drawf proc
	mov si,0
	mov di,0
	mov cx,d1.xaxis   
	mov dx,d1.yaxis   
	.while si < d1.endylimit
		mov di, 0
		.while di < d1.endxlimit
			mov al, d1.color  
			mov ah, 0CH 
			int 10H
			
			inc cx
			inc di
		.ENDW
		mov cx, d1.xaxis
		inc dx
		inc si
	.ENDW
	ret
drawf endp
	
	
drawScoreBar proc
	pop si
	mov ah, 02h
    mov dh, 1
    mov dl, 2
    int 10h
	
	mov dx, offset scorestr
    mov ah, 09h
    int 21h
	
	mov bx,0
	
	mov ax,scoreCount
	.while ax != 0
		mov dx,0
		mov bx,10
		div bx
		push dx
	.endw	
	.if scoreCount == 0
		mov ah, 02h
		mov dh, 1
		mov dl, 8
		int 10h
		
		mov dx, offset onezer0
		mov ah, 09h
		int 21h
	.elseif scoreCount > 0 && scoreCount <= 9
		mov ah, 02h
		mov dh, 1
		mov dl, 8
		int 10h
		
		mov dx,0
		pop dx
		
		add dl,48
		mov ah,02h
		int 21h
	.elseif scoreCount > 9 
		mov ah, 02h
		mov dh, 1
		mov dl, 8
		int 10h
		
		mov dx,0
		pop dx
		
		add dl,48
		mov ah,02h
		int 21h
		
		mov ah, 02h
		mov dh, 1
		mov dl, 9
		int 10h
		
		mov dx,0
		pop dx
		
		add dl,48
		mov ah,02h
		int 21h	
	.endif
	
	mov ah, 02h
	mov dh, 1
	mov dl, 17
	int 10h
	
	mov dx, offset username
    mov ah, 09h
    int 21h
	
	push si
	ret
drawScoreBar endp

drawLives proc
	pop si
	mov ah, 02h
    mov dh, 1
    mov dl, 28
    int 10h
	
	mov dx, offset Livestr
    mov ah, 09h
    int 21h
	push si
	ret
drawLives endp
drawlifeCount proc
	pop si
	mov ah, 02h
    mov dh, 1
    mov dl, 34
    int 10h
	
	mov cx,0
	.if livecount == 3
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,4h   ;Green color
		mov cl,livecount       ;repetition count
		mov ah,09h
		int 10h
		
	.elseif livecount == 2
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,4h   ;Green color
		mov cl,livecount       ;repetition count
		mov ah,09h
		int 10h
		
		mov ah, 02h
		mov dh, 1
		mov dl, 36
		int 10h
		
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,0h   ;Green color
		mov cl,1       ;repetition count
		mov ah,09h
		int 10h
		
	.elseif livecount == 1
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,4h   ;Green color
		mov cl,livecount       ;repetition count
		mov ah,09h
		int 10h
		
		mov ah, 02h
		mov dh, 1
		mov dl, 35
		int 10h
		
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,0h   ;Green color
		mov cl,2       ;repetition count
		mov ah,09h
		int 10h
		
	.elseif livecount == 0
		mov al,3    ;ASCII code of Character 
		mov bx,0
		mov bl,0h   ;Green color
		mov cl,3       ;repetition count
		mov ah,09h
		int 10h
		
	.endif	
	
	push si
	ret
drawlifeCount endp	
	
BallBoundaryCollision proc     
    
    mov bx, b1.xaxis
    mov cx, b1.yaxis
	
	.if cx < 25
	mov ballUp, 0
	.endif
	.if cx > 185 
	jmp reset1
	.endif
	.if bx < 15
	mov ballLeft, 0
	.endif
	.if bx > 301
	mov ballLeft, 1
	.endif
	ret
BallBoundaryCollision endp
	
	
BallPaddleCollision proc 
	mov dx,0
    mov ax,p1.endxlimit
	mov bx,3
	div bx
	mov onethird_paddlde,ax
	mov ax,p1.yaxis
	sub ax,5
	mov bx,b1.yaxis
	add bx,b1.endylimit
	.if bx >= ax
		mov bx,p1.xaxis
		mov ax,b1.xaxis
		add ax,b1.endxlimit
		.if ax > bx
			add bx,onethird_paddlde
			.if b1.xaxis < bx
				mov ballUp,1
				mov ballLeft,1
			.elseif b1.xaxis > bx
				add bx,onethird_paddlde
				.if b1.xaxis < bx
					mov ballUp,1
					mov ballLeft,2
				.elseif b1.xaxis > bx
					add bx,onethird_paddlde
					.if b1.xaxis < bx
						mov ballUp,1
						mov ballLeft,0
					.endif		
				.endif
			.endif
		.endif
	.endif	
    ret
BallPaddleCollision endp

BallOperation proc 
	
	mov b1.color,0h
	call drawBall
	
	mov ax,ballspeed
	.if ballLeft == 1
		sub b1.xaxis,ax
	.elseif ballLeft == 0 
		add b1.xaxis,ax
	.endif
	.if ballUp == 1
		sub b1.yaxis,ax
	.elseif ballUp == 0 
		add b1.yaxis,ax
	.endif
	
	mov b1.color,0bh
	call drawBall
	ret
	
BallOperation endp

delay proc
mov cx,111111111111111b 
delayloop:
loop delayloop
ret
delay endp

Inputchk proc
    mov ah,1h
    int 16h        
    jz return     
    mov ah,0h
    int 16h
	
	.if ah == 4Bh
		mov bx, 25
		.if p1.xaxis < bx
			ret
		.else
			mov p1.color,0
			call drawpaddle
			mov dx,paddlespeed
			sub  p1.xaxis, dx
			mov p1.color,1110b
			call drawpaddle
			.if begin == 0
				mov b1.color,0h
				call drawBall
				mov dx,paddlespeed
				sub b1.xaxis, dx
				mov b1.color,0bh
				call drawBall
				ret
			.else
				ret
			.endif
		.endif
	.endif	
	.if ah == 4Dh   
		mov bx, 300
		sub bx, p1.endxlimit
		.if p1.xaxis > bx
			ret
		.else
			mov p1.color,0
			call drawpaddle
			mov dx,paddlespeed
			add  p1.xaxis, dx
			mov p1.color,1110b
			call drawpaddle
			.if begin == 0
				mov b1.color,0h
				call drawBall
				mov dx,paddlespeed
				add b1.xaxis, dx
				mov b1.color,0bh
				call drawBall
				ret
			.else
				ret
			.endif
		.endif	
	.elseif al == 01bh
		inc count	
		call choiceboard
	.elseif al == 20h
		.if begin == 0
			mov begin,1
			ret
		.elseif begin == 1
				mov ax,0
			.while al != 20h
				mov ah,1h
				int 16h 
				mov ah, 0h
				int 16h
			.endw
		.endif
	.endif	
    
	return:
		ret
		
Inputchk endp
	
Game proc
	mov begin,0
GameStart: 
  
   call Inputchk
   cmp begin,1
   jne GameStart
   
   call BallBoundaryCollision
   call BallPaddleCollision 
   BallBrickCollision br1
   BallBrickCollision br2
   BallBrickCollision br3
   BallBrickCollision br4
   BallBrickCollision br5
   BallBrickCollision br6
   BallBrickCollision br7
   BallBrickCollision br8
   BallBrickCollision br9
   BallBrickCollision br10
   BallBrickCollision br11
   BallBrickCollision br12
   BallBrickCollision br13
   BallBrickCollision br14
   BallBrickCollision br15
   BallBrickCollision br16
   BallBrickCollision br17
   BallBrickCollision br18
   BallBrickCollision br19
   BallBrickCollision br20
   
   
   call BallOperation 
   .if ballspeed == 2
		mov cx,100000000000000b 
		dloop:
		loop dloop
   .endif
   .if ballspeed == 3
		mov cx,111100000000000b 
		deloop:
		loop deloop
   .endif
   call delay
   jmp GameStart  
Game endp
   
   
reset1:
dec livecount
call drawlifeCount
.if livecount == 0
	call gameover
	jmp exit
.else	
	mov b1.color,0h
	call drawBall
	mov p1.color,0
	call drawpaddle
	.if level == 1
		mov b1.xaxis,152
		mov b1.yaxis,179

		mov p1.xaxis,125
		mov p1.yaxis,188
	.elseif level > 1
		mov b1.xaxis,144
		mov b1.yaxis,179

		mov p1.xaxis,125
		mov p1.yaxis,188
	.endif
	mov b1.color,0bh
	call drawBall
	mov p1.color,1110b
	call drawpaddle
		
	call Game
.endif	


displayTitle PROC uses ax bx cx dx si di
    call loadNewPage
    mov ah, 0Ch
    mov al, 04h
    mov bx, 0
    mov cx, 0
    mov dx, 0

    call drawBorder


    mov ah, 02h
    mov dh, 10
    mov dl, 10
    mov bx, 0
    int 10h

    mov dx, offset titleStr
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 15
    mov dl, 13
    mov bx, 0
    int 10h
	
    mov dx, offset usernamePrompt
    mov ah, 09h
    int 21h


    mov si, offset username

    .while (al != 13)
        mov ah,01h
        int 21h
        mov [si],al
        inc si
    .endw
    mov al, '$'
    mov [si], al


    ret
displayTitle endp

drawBorder PROC uses ax bx cx dx
    mov ah, 0Ch
    mov al, 04h
    mov bx, 1
    mov cx, 0
    mov dx, 0

;right vertical side
    MOV ah, 06h 
    MOV al, 0
    MOV cx, 39
    MOV dh, 40
    MOV dl, 40
    MOV bh, 0110b
    INT 10h

;left vertical side
    MOV ah, 06h
    MOV al, 0
    MOV cx, 0 
    MOV dh, 25
    MOV dl, 0
    MOV bh, 0110b
    INT 10h


    MOV ah, 06h
    MOV al, 1
    MOV cx, 0
    MOV dh, 60
    MOV dl, 55
    MOV bh, 0110b
    INT 10h


    MOV ah, 06h
    MOV al, 0
    MOV cx, 0
    MOV dh, 0
    MOV dl, 40
    MOV bh, 0110b
    int 10h

    ret
drawBorder endp

loadNewPage PROC uses ax bx cx dx si di

    mov ah, 00h
    mov al, 13h
    int 10h

    ret

loadNewPage endp

displayPlayerName PROC uses ax bx cx dx si di
    
    call loadNewPage
    mov ah, 02h
    mov dh, 0
    mov dl, 2
    mov bx, 0
    int 10h

    mov dx, offset welcome
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 2
    mov dl, 2
    mov bx, 0
    int 10h

    mov dx, offset username
    mov ah, 09h
    int 21h

    ret

displayPlayerName endp

gameover proc

	mov ah, 0
	mov al, 0Dh    ;320x200
	int 10h
	
	call drawBorder
	mov ah, 2
	mov dh, 12     ;row
	mov dl, 13    ;column
	int 10h
	
	mov dx, offset over
    mov ah, 09h
    int 21h
	
	mov ah, 2
	mov dh, 12     ;row
	mov dl, 23    ;column
	int 10h
	
	mov al,2    
	mov bx,0
	mov bl,1110b  
	mov cx,1       
	mov ah,09h
	int 10h
	
	.while al != 01bh
		mov ah,1h
		int 16h 
		mov ah, 0h
		int 16h
	.endw
	mov count,0	
	call choiceboard
	
gameover endp

gamewin proc

	mov ah, 0
	mov al, 0Dh    ;320x200
	int 10h
	
	call drawBorder
	mov ah, 2
	mov dh, 12     ;row
	mov dl, 15    ;column
	int 10h
	
	mov dx, offset win
    mov ah, 09h
    int 21h
	
	mov ah, 2
	mov dh, 12     ;row
	mov dl, 23    ;column
	int 10h
	
	mov al,2    
	mov bx,0
	mov bl,1110b  
	mov cx,1       
	mov ah,09h
	int 10h
	
	.while al != 01bh
		mov ah,1h
		int 16h 
		mov ah, 0h
		int 16h
	.endw
	mov count,0	
	call choiceboard
	
gamewin endp


displayRules PROC uses ax bx cx dx si di
    
    call loadNewPage
    call drawBorder 

    mov ah, 02h
    mov dh, 4
    mov dl, 12
    mov bx, 0
    int 10h
    

    mov dx, offset ruleTitle
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 8
    mov dl, 5
    mov bx, 0
    int 10h

    mov dx, offset rule1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 10
    mov dl, 5
    mov bx, 0
    int 10h

    mov dx, offset rule2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 12
    mov dl, 5
    mov bx, 0
    int 10h

    mov dx, offset rule3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 14
    mov dl, 5
    mov bx, 0
    int 10h

    mov dx, offset rule4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 17
    mov dl, 16
    mov bx, 0
    int 10h

    mov dx, offset rule5
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 20
    mov dl, 9
    mov bx, 0
    int 10h

    mov dx, offset rulesConfirmprompt
    mov ah, 09h
    int 21h



    .while (al != 13)
        mov ah,01h
        int 21h
    .endw

    call choiceboard
    ret
displayRules endp

displayHighScore PROC uses ax bx cx dx si di
	call loadNewPage
    call drawBorder
	
	mov ah, 02h
    mov dh, 3
    mov dl, 14
    mov bx, 0
    int 10h
    

    mov dx, offset hscore 
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 8
    mov dl, 10
    mov bx, 0
    int 10h

    mov dx, offset hscore1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 10
    mov dl, 10
    mov bx, 0
    int 10h

    mov dx, offset hscore2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 12
    mov dl, 10
    mov bx, 0
    int 10h

    mov dx, offset hscore3
    mov ah, 09h
    int 21h


    mov ah, 02h
    mov dh, 20
    mov dl, 9
    mov bx, 0
    int 10h

    mov dx, offset rulesConfirmprompt
    mov ah, 09h
    int 21h



    .while (al != 13)
        mov ah,01h
        int 21h
    .endw

    call choiceboard
    ret
	displayHighScore ENDP




choiceboard PROC uses ax bx cx dx si di
    
    call loadNewPage
    call drawBorder 

    mov ah, 02h
    mov dh, 5
    mov dl, 10
    mov bx, 0
    int 10h
    

    mov dx, offset choiceTitle
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 8
    mov dl, 8
    mov bx, 0
    int 10h
	.if count > 0
		mov dx, offset continuestr
		mov ah, 09h
		int 21h
	.elseif count == 0
		mov dx, offset choice1
		mov ah, 09h
		int 21h
	.endif

    mov ah, 02h
    mov dh, 10
    mov dl, 8
    mov bx, 0
    int 10h

    mov dx, offset choice2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 12
    mov dl, 8
    mov bx, 0
    int 10h

    mov dx, offset choice3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 14
    mov dl, 8
    mov bx, 0
    int 10h

     mov dx, offset choice4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 16
    mov dl, 8
    mov bx, 0
    int 10h


    mov dx, offset choiceprompt
    mov ah, 09h
    int 21h

    mov AH, 0
    int 16H

    ;cmp ah,02H ; Play game
    ;je 
    
    .if ah == 02h
		.if count == 0
			call level1
		.endif	
		call MyGame
		RET
    .endif
    
    cmp ah,03H  ; View rules
    je displayRules
	
	cmp ah,04h
	je displayHighScore
	
	.IF ah == 5h
		jmp exit
	.ENDIF
	
    
 ;   cmp ah, 04H ; Highscore
 ;   je displayRules
    
    ret
choiceboard endp

DrawBoard PROC uses AX BX CX DX  ; Main function to Draw our Board
    ; Pushing and popping values to keep them safe
        mov Al, colour
        mov ah, 0
        push AX
        push x
        push y
        mov AL, 12H ; Function to clear screen and convert to graphics mode
        mov AH, 0
        int 10h
        mov AL, colour
        mov AH, 0
        push AX ; Pushing colour to preserve it

DrawBoard ENDP

clears PROC 
	mov ah,00h
	mov al,13h
	int 10h
	
	mov ah,0bh
	mov bh,00h
	mov bl,00h
	int 10h
	
	ret
clears ENDP		

exit:
	mov ah,4ch
	int 21h
	end