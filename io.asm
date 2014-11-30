.xlist
option casemap :none
include C:\RadASM\Masm\Projects\iotest\masm32rt.inc
includelib C:\RadASM\Masm\Projects\iotest\iolib.lib

_outstr PROTO
_outint	PROTO 
_inint	PROTO
_inch	PROTO
system	PROTO c :dword

.data
	_temp db ?
.code

; SERVICE MACRO

same	macro	name,variants,ans

	ans=0
	IRP	v,<variants>
	IFIDN	<name>,<v>
	ans=1
	EXITM
	ENDIF
	ENDM

endm

;======================================================================
;======================= STRING AND CHAR MACRO ========================
;======================================================================

	; PRINT
print	macro	Name:VARARG
	LOCAL quot
	LOCAL reg?
	LOCAL temp
	push edx
	push ecx
	push eax
	
	IFDIF <Name>,<NULL>
		IFNB <Name>
			quot SUBSTR <Name>,1,1	
			IFIDN quot,<">
				printc Name
			ELSE	
				same Name,<al,AL,Al,aL,ah,AH,Ah,aH,bl,BL,Bl,bL,bh,BH,Bh,bH,cl,CL,Cl,cL,ch,CH,Ch,cH,dl,DL,Dl,dL,dh,DH,Dh,dH>, reg?
				IF reg?
					.data
						temp db ?, 0
					.code
					mov temp,Name
					lea edx, temp 
					call	_outstr
				ELSE
					lea edx, Name
					call	_outstr			   
				ENDIF
			ENDIF
		ELSE
			call wait_key
		ENDIF
	ENDIF
	
	pop	eax
	pop	ecx
	pop	edx
endm

	; PRINT LINE
println macro Name
	print Name
	print "\n"
endm

	; READ

read macro Name
    LOCAL bool
    same <Name>,<al,AL,Al,aL>, bool
    IF bool
        push ecx
        push edx
       
        getkey
        mov Name, al
        
        pop edx
        pop ecx
    ELSE
    same <Name>,<ah,AH,Ah,aH>, bool
    IF bool
        push ecx
        push edx
      
        xchg ah, al
        getkey
        xchg ah, al
        
        pop edx
        pop ecx
    ELSE
    same <Name>,<bl,BL,Bl,bL,bh,BH,Bh,bH>, bool
    IF bool
        push ecx
        push edx
        push eax
       
        getkey
        mov Name, al  
            
        pop eax
        pop edx
        pop ecx        
    ELSE
    same <Name>,<cl,CL,Cl,cL,ch,CH,Ch,cH,dl,DL,Dl,dL,dh,DH,Dh,dH>, bool
    IF bool  
        push eax
        push edx
        push ecx
      
        getkey
        pop ecx
        pop edx
        mov Name, al
      
        pop eax 
    ELSE
        push ecx
        push edx
        push eax
       
        getkey
        mov Name, al  
            
        pop eax
        pop edx
        pop ecx
    ENDIF     
    ENDIF
    ENDIF
    ENDIF
     
    print Name
endm
comment *
read macro Name
	LOCAL	regax?
	same	<Name>,<ah,AH,Ah,aH>,regax?
	IF	regax?
		XCHG	AH,AL
		getkey
		XCHG	AH,AL
	ELSE
		same	<Name>,<al,AL,Al,aL>,regax?
		IF	regax?
			getkey
		ELSE
			PUSH	AX
			getkey
			MOV	Name,AL
			POP	AX
		ENDIF
	ENDIF
	print Name
endm*

	; READ LINE
readln macro Name, text
	read Name, text
	print "\n"
endm

;======================================================================
;============================ NUMBER MACRO ============================
;======================================================================

outint macro Name
    LOCAL reg?
    same	<Name>,<eax,eaX,eAx,eAX,Eax,EaX,EAx,EAX,ebx,ebX,eBx,eBX,Ebx,EbX,EBx,EBX,ecx,ecX,eCx,eCX,Ecx,EcX,ECx,ECX,edx,edX,eDx,eDX,Edx,EdX,EDx,EDX>,reg?
    IF reg?
        outint32 Name
    ELSE
    IFE TYPE Name - 4
        outint32 Name
    ELSE
        push eax
        movsx eax, Name
        outint32 eax
        pop eax
    ENDIF
    ENDIF
endm

inint macro Name
    LOCAL reg?
    same	<Name>,<al,aL,Al,AL,ah,aH,Ah,AH,bl,bL,Bl,BL,bh,bH,Bh,BH,cl,cL,Cl,CL,ch,cH,Ch,CH,dl,dL,Dl,DL,dh,dH,Dh,DH>,reg?
    IF reg?
        inint8 Name
    ELSE
    same	<Name>,<ax,aX,Ax,AX,bx,bX,Bx,BX,cx,cX,Cx,CX,dx,dX,Dx,DX>,reg?
    IF reg?
        inint16 Name
    ELSE
    same	<Name>,<eax,eaX,eAx,eAX,Eax,EaX,EAx,EAX,ebx,ebX,eBx,eBX,Ebx,EbX,EBx,EBX,ecx,ecX,eCx,eCX,Ecx,EcX,ECx,ECX,edx,edX,eDx,eDX,Edx,EdX,EDx,EDX>,reg?
    IF reg?
        inint32 Name
    ELSE
    IFE TYPE Name - 1
        inint8 Name
    ELSE
    IFE TYPE Name - 2
        inint16 Name
    ELSE   
        inint32 Name
    ENDIF
    ENDIF 
    ENDIF
    ENDIF
    ENDIF
endm

	; OUTINT 32 BIT
outint32 macro	num, digits := <0>
	push	eax
	push	ecx
	push	edx
	push	num
	pop	eax
	push	digits
	pop	ecx
	call	_outint
	pop	edx
	pop	ecx
	pop	eax
endm
	
	; OUTINT 16 BIT
outint16	macro	num, digits := <0>
	push	eax
	push	ebx
	mov	ebx, eax
	mov	eax, 0
	mov	ax, bx
	pop	ebx
	movsx	eax, num
	outint32 eax, digits
	pop	eax
endm
	
	; OUTINT 8 BIT
outint8		macro	num, digits := <0>
	push	eax
	push	ebx
	mov	ebx, eax
	mov	eax, 0
	mov	ax, bx
	pop	ebx
	movsx	eax, num
	outint32 eax, digits
	pop	eax
endm

	; ININT 32 BIT
inint32 macro	x
	LOCAL	regeax?
	same	<x>,<eax,eAX,eAx,eaX,Eax,EAX,EAx,EaX>,regeax?
	IF	regeax?
	CALL	_inint
	ELSE
	PUSH	EAX
	CALL	_inint
	MOV	x, EAX
	POP	EAX
	ENDIF
endm

	; ININT 32 BIT
inint16 macro	x
	LOCAL	regeax?
	same	<x>,<ax,AX,Ax,aX>,regeax?
	IF	regeax?
	push	ebx
	push	eax
	CALL	_inint
	mov	ebx, eax
	pop	eax
	mov	ax, bx
	pop	ebx
	ELSE
	PUSH	EAX
	CALL	_inint
	MOV	x, ax
	POP	EAX
	ENDIF
endm

	; ININT 32 BIT
inint8	macro	x
	LOCAL	regax?
	same	<x>,<ah,AH,Ah,aH>,regax?
	IF	regax?
		push	ebx
		push	eax
		CALL	_inint
		mov	ebx, eax
		pop	eax
		mov	ah, bl
		pop	ebx
	ELSE
		same	<x>,<al,AL,Al,aL>,regax?
		IF	regax?
			push	ebx
			push	eax
			CALL	_inint
			mov	ebx, eax
			pop	eax
			mov	al, bl
			pop	ebx
		ELSE
			PUSH	eax
			CALL	_inint
			MOV	x,AL
			POP	eax
		ENDIF
	ENDIF
endm

;======================================================================
;===================== OLD MACRO (for compatibility) ==================
;======================================================================

	; INCH
inch	macro	x
	read x
endm

	; OUTCH
outch macro x
	print x
endm

	; NEWLINE
newline	macro
	print "\n"
endm

	; INKEY (macros.asm copy)
inkey macro string
pusha
IFDIF <string>,<NULL> 
        IFNB <string>                     
          print string                    
        ELSE                                    
          print "Press any key to continue." 
        ENDIF
      ENDIF
      call wait_key
      print chr$(13,10)
	  popa
endm
	
	; OUTSTR
outstr	macro string
	push	edx
	push	eax
	push	ecx
	mov edx, string  ; lea for using without offset
	call	_outstr
	pop	ecx
	pop	eax
	pop	edx
endm

	; OUTSTR LINE
outstrln macro string
	push	edx
	push	eax
	push	ecx
	mov edx, string ; lea for using without offset
	call	_outstr
	printc	"\n"
	pop	ecx
	pop	eax
	pop	edx
endm

.list
