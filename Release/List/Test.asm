
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _LoadA=R4
	.DEF _LoadB=R6
	.DEF _Freq_load=R8
	.DEF _Freq_INC_flag=R10
	.DEF _Freq_DEC_flag=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x46
_0x4:
	.DB  0xA
_0x5:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0x6:
	.DB  0x0,0x9,0x12,0x1B,0x23,0x2B,0x33,0x3B
	.DB  0x42,0x48,0x4E,0x53,0x58,0x5C,0x5F,0x61
	.DB  0x63,0x64,0x64,0x63,0x61,0x5F,0x5C,0x58
	.DB  0x53,0x4E,0x48,0x42,0x3B,0x33,0x2B,0x23
	.DB  0x1B,0x12,0x9
_0x7:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x12,0x1B,0x23
	.DB  0x2B,0x33,0x3B,0x42,0x48,0x4E,0x53,0x58
	.DB  0x5C,0x5F,0x61,0x63,0x64,0x64,0x63,0x61
	.DB  0x5F,0x5C,0x58,0x53,0x4E,0x48,0x42,0x3B
	.DB  0x33,0x2B,0x23,0x1B,0x12,0x9
_0x35:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x46,0x72,0x65,0x71,0x75,0x65,0x6E,0x63
	.DB  0x79,0x20,0x25,0x30,0x33,0x64,0x0,0x44
	.DB  0x75,0x74,0x79,0x20,0x63,0x79,0x63,0x6C
	.DB  0x65,0x20,0x25,0x30,0x33,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _Freq
	.DW  _0x3*2

	.DW  0x01
	.DW  _Duty
	.DW  _0x4*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x35*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
; /*************** Project information ******************
;Project : SPWM with variety frequency (5-120)
;Version : V1.0
;Date    : 8/27/2018
;Author  : Tran Minh Thuan
;Suppoted: Nguyen Duc Quyen
;Company : Khuon May Viet
;*******************************************************/
;
;/****************Requirement documentations************
;Create a Sine signal with changable frequency (5-150Hz)
;Use: Timer0 to create delay function
;     Tier1  generate SPWM signal
;Operating:
;     Use Timer1 overflow interrupt, each time1 overflow
;change the duty cycle in order to create SPWM signal
;     Use Timer1 operating mode 14 - count from 0 to value in ICR1
;     ICR1 - Control the frequency of each pulse
;     OCA1 - Control the duty cycle of positive pole
;     OCB1 - Control the duty cycle of negative pole
;*******************************************************/
;
;/******************************************************
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <alcd.h>                   // Alphanumeric LCD functions
;#include <delay.h>
;/**************************************/
;#define Freq_INC PIND.0
;#define Freq_DEC PIND.1
;#define Duty_INC PIND.2
;#define Duty_DEC PIND.3
;#define Duty2_INC PIND.4
;#define Duty2_DEC PIND.5
;#define SW1 PINB.1
;#define SW2 PINB.2
;#define SW3 PORTB.3
;#define SW4 PORTB.0
;#define STR PORTC.2
;#define CLK PORTB.3
;#define SDI PORTC.4
;/**************************************/
;#define F_CPU 8000000
;#define PB0 PORTB.0
;#define PB2 PORTB.2
;#define F1  20000
;
;unsigned long Freq=70;

	.DSEG
;unsigned int  LoadA=0, LoadB=0;
;unsigned int  Freq_load=0;
;unsigned int  Freq_INC_flag=0,Freq_DEC_flag=0;
;unsigned int  Duty_INC_flag=0,Duty_DEC_flag=0;
;unsigned int  tick_duty_inc=0,tick_duty_dec=0;
;unsigned int  tick_freq_inc=0,tick_freq_dec=0;
;unsigned int  Duty=10;
;unsigned int  Low_line,High_line;
;unsigned int  T_delay=0;
;unsigned char MA_7SEG[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};
;unsigned char Sine1[70]={0, 9, 18, 27, 35, 43, 51, 59, 66, 72, 78, 83, 88, 92, 95, 97, 99, 100, 100, 99, 97, 95, 92, 88, 83, 78, 72, 66, 59, 51, 43, 35, 27, 18, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
;unsigned char Sine2[70]={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 9, 18, 27, 35, 43, 51, 59, 66, 72, 78, 83, 88, 92, 95, 97, 99, 100, 100, 99, 97, 95, 92, 88, 83, 78, 72, 66, 59, 51, 43, 35, 27, 18, 9};
;unsigned int numb=0;
;unsigned char Chuoi[16]={0};
;
;void ADC_Init(void);
;unsigned int ADC_Read(unsigned int channel);
;void Timer0_Init();
;void Timer1_Init();
;void GPIO_Init();
;void CheckSW(void);                     //Doc gia tri nut nhan
;void Update_Timer1(void);
;void Update_value(void);
;void Delay_100us(unsigned int Time);
;void Display(void);
;
;void main(void){
; 0000 0052 void main(void){

	.CSEG
_main:
; 0000 0053     GPIO_Init();                        // GPIO Initialization
	RCALL _GPIO_Init
; 0000 0054     ADC_Init();
	RCALL _ADC_Init
; 0000 0055     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0056     Timer0_Init();                      // Timer0 Initialization
	RCALL _Timer0_Init
; 0000 0057     Timer1_Init();                      // Timer1 Initialization
	RCALL _Timer1_Init
; 0000 0058     #asm("sei")                         // Global enable interrupts
	sei
; 0000 0059 while (1)
_0x8:
; 0000 005A       {
; 0000 005B             Update_value();
	RCALL _Update_value
; 0000 005C             Delay_100us(1);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL _Delay_100us
; 0000 005D             Display();
	RCALL _Display
; 0000 005E       }
	RJMP _0x8
; 0000 005F }
_0xB:
	RJMP _0xB
;
;void Display(void){
; 0000 0061 void Display(void){
_Display:
; 0000 0062         sprintf(Chuoi,"Frequency %03d",Freq);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 0063         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 0064         lcd_puts(Chuoi);
	RCALL SUBOPT_0x2
	RCALL _lcd_puts
; 0000 0065         sprintf(Chuoi,"Duty cycle %03d",Duty);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,15
	RCALL SUBOPT_0x1
	LDS  R30,_Duty
	LDS  R31,_Duty+1
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x4
; 0000 0066         lcd_gotoxy(0,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 0067         lcd_puts(Chuoi);
	RCALL SUBOPT_0x2
	RCALL _lcd_puts
; 0000 0068 }
	RET
;void Timer0_Init(){
; 0000 0069 void Timer0_Init(){
_Timer0_Init:
; 0000 006A     TIMSK&=~0x01;                         //Disable interrupt while initilization
	IN   R30,0x39
	ANDI R30,0xFE
	OUT  0x39,R30
; 0000 006B     TCCR0=(0<<CS02)|(1<<CS01)|(0<<CS00);  //Prescaler - 8
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 006C     TCNT0=156;                            //255-156+1=100 (100us)
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 006D }
	RET
;void Timer1_Init(){
; 0000 006E void Timer1_Init(){
_Timer1_Init:
; 0000 006F /* Timer 1 Initialization
; 0000 0070 // Timer 1 is used to create sine wave with changeable frequency
; 0000 0071 // ICR1 contains top value (control frequency)
; 0000 0072 // OCA1 create positive pole
; 0000 0073 // OCB1 create negative pole
; 0000 0074 // Clock source: System Clock
; 0000 0075 // Clock value: 8000.000 kHz
; 0000 0076 // Mode 14: Fast PWM go from 0 to value in ICR1
; 0000 0077 // Prescaler 1 */
; 0000 0078     //The Freq_load will control the frequency of sine wave
; 0000 0079     //1+Top=Fclk/Fpwm*100
; 0000 007A ////         Freq_load=761;
; 0000 007B //    Freq_load=8000000/(Freq*70)-1;
; 0000 007C //    TCCR1A =(1<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0);
; 0000 007D //    TCCR1A|=(1<<WGM11)|(0<<WGM10); TCCR1B|=(1<<WGM13) | (1<<WGM12); //Mode 14
; 0000 007E //    TCCR1B|=(0<<CS12) | (0<<CS11) | (1<<CS10);                      //Prescaler 1
; 0000 007F //    ICR1H=(Freq_load)>> 8;      ICR1L=(Freq_load)& 0xff;
; 0000 0080 //    TIMSK|=(0<<TICIE1)| (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1);
; 0000 0081 }
	RET
;void GPIO_Init(){
; 0000 0082 void GPIO_Init(){
_GPIO_Init:
; 0000 0083 /*GPIO Initialization
; 0000 0084  *PB7 Increse frequency
; 0000 0085  *PB6 Decrese frequency
; 0000 0086  *PB5 Increse Duty cycle
; 0000 0087  *PB4 Decrese Duty cycle
; 0000 0088 */
; 0000 0089     DDRB= (0<<DDB7) |(0<<DDB6) |(0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(31)
	OUT  0x17,R30
; 0000 008A     PORTB=(0<<PORTB7) | (0<<PORTB6)| (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 008B     DDRD= 0x00;
	OUT  0x11,R30
; 0000 008C     PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 008D     DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 008E }
	RET
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0090 {/*---------- Timer0 Overflow ISR------------------------------
; 0000 0091  // First Reinitialize timer0 value
; 0000 0092  // Increase count (T_delay) value every 100us */
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0093     TCNT0=156;    //Tinh toan = 0x9D(100), nhung bu sai so nen A0
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 0094     if(Freq_INC_flag==1) tick_freq_inc++;
	RCALL SUBOPT_0x0
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xC
	LDI  R26,LOW(_tick_freq_inc)
	LDI  R27,HIGH(_tick_freq_inc)
	RCALL SUBOPT_0x5
; 0000 0095     if(Freq_DEC_flag==1) tick_freq_dec++;
_0xC:
	RCALL SUBOPT_0x0
	CP   R30,R12
	CPC  R31,R13
	BRNE _0xD
	LDI  R26,LOW(_tick_freq_dec)
	LDI  R27,HIGH(_tick_freq_dec)
	RCALL SUBOPT_0x5
; 0000 0096     if(Duty_INC_flag==1) tick_duty_inc++;
_0xD:
	LDS  R26,_Duty_INC_flag
	LDS  R27,_Duty_INC_flag+1
	SBIW R26,1
	BRNE _0xE
	LDI  R26,LOW(_tick_duty_inc)
	LDI  R27,HIGH(_tick_duty_inc)
	RCALL SUBOPT_0x5
; 0000 0097     if(Duty_DEC_flag==1) tick_duty_dec++;
_0xE:
	LDS  R26,_Duty_DEC_flag
	LDS  R27,_Duty_DEC_flag+1
	SBIW R26,1
	BRNE _0xF
	LDI  R26,LOW(_tick_duty_dec)
	LDI  R27,HIGH(_tick_duty_dec)
	RCALL SUBOPT_0x5
; 0000 0098     T_delay++;
_0xF:
	LDI  R26,LOW(_T_delay)
	LDI  R27,HIGH(_T_delay)
	RCALL SUBOPT_0x5
; 0000 0099 //    TIMSK&=~0x01;        need for button
; 0000 009A };
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 009B interrupt [9] void timer1_ovf_isr(void){
_timer1_ovf_isr:
; 0000 009C     /*  Timer1 Overflow ISR
; 0000 009D      *  Each time execute, update new compare value to create sine wave
; 0000 009E      *  When reach all array values, new cycle of sine frequency start
; 0000 009F      *  The arrays contain duty cycles of small signal of big sine wave
; 0000 00A0     */
; 0000 00A1 //
; 0000 00A2 //    Low_line=(35/2)-(Duty/2*35/100);       //1st half wave ->35
; 0000 00A3 //    High_line=(35/2)+(Duty/2*35/100);      //1st half wave ->35
; 0000 00A4 //    //Else enable output
; 0000 00A5 //    if ((numb<Low_line)||(numb>High_line)||(Sine1[numb] == 0)) TCCR1A = TCCR1A&( ~0x80); //If the duty is 0, then disable output
; 0000 00A6 //    else                  TCCR1A = TCCR1A|0x80;     //Else enable output
; 0000 00A7 //    if (Sine2[numb] == 0) TCCR1A = TCCR1A&( ~0x20); //If the duty is 0, then disable output
; 0000 00A8 ////    if ((numb<Low_line)||(numb>High_line)||(Sine2[numb] == 0)) TCCR1A = TCCR1A&( ~0x20); //If the duty is 0, then disable output
; 0000 00A9 //    else                  TCCR1A = TCCR1A|0x20;     //Else enable output
; 0000 00AA //    //-----------------------Load new value of duty cycle-----------------------------//
; 0000 00AB //    LoadA=Freq_load/100*Sine1[numb];          //Calculate new compare value (Channel A)
; 0000 00AC //    LoadB=Freq_load/100*Sine2[numb];          //Calculate new compare value (Channel B)
; 0000 00AD //    OCR1AH=LoadA>> 8;   OCR1AL=LoadA& 0xff;   //Load new compare value (control Duty A)
; 0000 00AE //    OCR1BH=LoadB>> 8;   OCR1BL=LoadB& 0xff;   //Load new compare value (control Duty B)
; 0000 00AF //    //-----------------------Control H-Bridge-----------------------------------------//
; 0000 00B0 //    if  ((numb<35)&& (SW2==0))                             {SW4=1; SW3=0;}
; 0000 00B1 //    else SW4=0;
; 0000 00B2 //    if ((numb<=70)&&(numb>=35)&&(SW1==0))                  {SW4=0; SW3=1;}
; 0000 00B3 //    else SW3=0;
; 0000 00B4 //    //-----------------------Change to next array value-------------------------------//
; 0000 00B5 //    numb++;
; 0000 00B6 //    if(numb>=70)  numb=0;                    //Reload when count all array elements                                            //Start new cycle
; 0000 00B7 
; 0000 00B8 }
	RETI
;void ADC_Init(void){
; 0000 00B9 void ADC_Init(void){
_ADC_Init:
; 0000 00BA     ADMUX = (1<<REFS0); //V_ref is VCC, left adjust
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00BB     ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);    // prescaler = 128
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 00BC }
	RET
;/* Read value from ADC channel
; * Input: Input channel (0-7)
; * Output: 0-1024 corresponding to the value
;*/
;unsigned int ADC_Read(unsigned int channel)
; 0000 00C2 {
_ADC_Read:
; 0000 00C3   unsigned int ADCval;
; 0000 00C4   channel &= 0b00000111;  // AND operation with 7
	RCALL __SAVELOCR2
;	channel -> Y+2
;	ADCval -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ANDI R30,LOW(0x7)
	ANDI R31,HIGH(0x7)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00C5   ADMUX = (ADMUX & 0xF8)|channel; // clears the bottom 3 bits for choosing channel
	IN   R30,0x7
	ANDI R30,LOW(0xF8)
	LDD  R26,Y+2
	OR   R30,R26
	OUT  0x7,R30
; 0000 00C6   // start single convertion by writing ’1' to ADSC
; 0000 00C7   ADCSRA |= (1<<ADSC);
	SBI  0x6,6
; 0000 00C8   // wait for conversion to complete, ADSC becomes ’0' again
; 0000 00C9   while(ADCSRA & (1<<ADSC));
_0x10:
	SBIC 0x6,6
	RJMP _0x10
; 0000 00CA   ADCval = ADCL;
	IN   R16,4
	CLR  R17
; 0000 00CB   ADCval = (ADCH << 8) + ADCval;    // ADCH is read so ADC can be updated again
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	__ADDWRR 16,17,30,31
; 0000 00CC   if(ADCval>=1000) ADCval=1000;
	__CPWRN 16,17,1000
	BRLO _0x13
	__GETWRN 16,17,1000
; 0000 00CD   return (ADCval);
_0x13:
	MOVW R30,R16
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
; 0000 00CE }
;void Update_value(void){
; 0000 00CF void Update_value(void){
_Update_value:
; 0000 00D0   unsigned long temp_duty,temp_freq;
; 0000 00D1   temp_duty=ADC_Read(1)/10;
	SBIW R28,8
;	temp_duty -> Y+4
;	temp_freq -> Y+0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x6
	__PUTD1S 4
; 0000 00D2   if(temp_duty<5)         temp_duty=5;
	RCALL SUBOPT_0x7
	__CPD2N 0x5
	BRSH _0x14
	__GETD1N 0x5
	RJMP _0x31
; 0000 00D3   else if (temp_duty>95) temp_duty=95;
_0x14:
	RCALL SUBOPT_0x7
	__CPD2N 0x60
	BRLO _0x16
	__GETD1N 0x5F
_0x31:
	__PUTD1S 4
; 0000 00D4   Duty=temp_duty;
_0x16:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	STS  _Duty,R30
	STS  _Duty+1,R31
; 0000 00D5   temp_freq=ADC_Read(0)/10;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x6
	RCALL __PUTD1S0
; 0000 00D6   if(temp_freq<1)            temp_freq=1;
	RCALL SUBOPT_0x8
	__CPD2N 0x1
	BRSH _0x17
	__GETD1N 0x1
	RJMP _0x32
; 0000 00D7   else if (temp_freq>75)     temp_freq=75;
_0x17:
	RCALL SUBOPT_0x8
	__CPD2N 0x4C
	BRLO _0x19
	__GETD1N 0x4B
_0x32:
	RCALL __PUTD1S0
; 0000 00D8   Freq=temp_freq;
_0x19:
	RCALL __GETD1S0
	STS  _Freq,R30
	STS  _Freq+1,R31
	STS  _Freq+2,R22
	STS  _Freq+3,R23
; 0000 00D9   Freq_load=8000000/(Freq*70)-1;
	RCALL SUBOPT_0x3
	__GETD2N 0x46
	RCALL __MULD12U
	__GETD2N 0x7A1200
	RCALL __DIVD21U
	__SUBD1N 1
	MOVW R8,R30
; 0000 00DA   ICR1H=(Freq_load-1)>> 8; ICR1L=(Freq_load-1)& 0xff;
	MOVW R30,R8
	SBIW R30,1
	MOV  R30,R31
	LDI  R31,0
	OUT  0x27,R30
	MOVW R30,R8
	SBIW R30,1
	OUT  0x26,R30
; 0000 00DB 
; 0000 00DC }
	ADIW R28,8
	RET
;void Delay_100us(unsigned int Time)  //TEST DONE
; 0000 00DE {
_Delay_100us:
; 0000 00DF /* Create delay function with 100us corresponding to each value */
; 0000 00E0     TCNT0=0x9D;         //Tinh toan = 0x9D, nhung bu sai so nen A0
;	Time -> Y+0
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 00E1     TIMSK|=0x01;        //Cho phep ngat tran timer0
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0000 00E2     T_delay=0;          //Reset gia tri dem
	LDI  R30,LOW(0)
	STS  _T_delay,R30
	STS  _T_delay+1,R30
; 0000 00E3     while(T_delay<Time);//Chua du
_0x1A:
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_T_delay
	LDS  R27,_T_delay+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1A
; 0000 00E4     TIMSK&=~0x01;       //Du thoi gian, tat ngat tran timer0
	IN   R30,0x39
	ANDI R30,0xFE
	OUT  0x39,R30
; 0000 00E5 };
	RJMP _0x2080002
;void Update_Timer1(void){
; 0000 00E6 void Update_Timer1(void){
; 0000 00E7 /*  Update new value "TOP value" when frequency change */
; 0000 00E8 //    Freq_load=761;
; 0000 00E9     Freq_load=8000000/(Freq*70)-1;
; 0000 00EA     ICR1H=(Freq_load-1)>> 8; ICR1L=(Freq_load-1)& 0xff;
; 0000 00EB }
;void CheckSW(void)
; 0000 00ED {
; 0000 00EE     if(!Freq_INC){
; 0000 00EF         TIMSK|=0x01;
; 0000 00F0         Freq_INC_flag=1;
; 0000 00F1         if((tick_freq_inc/2000)!=0) //delay 200ms
; 0000 00F2         {
; 0000 00F3             if(Freq<150)    {Freq+=5;  Update_Timer1();}
; 0000 00F4             else             Freq=150;
; 0000 00F5             tick_freq_inc=0;
; 0000 00F6         }
; 0000 00F7     }
; 0000 00F8     else
; 0000 00F9     Freq_INC_flag=0;
; 0000 00FA     if(!Freq_DEC){
; 0000 00FB         TIMSK|=0x01;
; 0000 00FC         Freq_DEC_flag=1;
; 0000 00FD         if((tick_freq_dec/2000)!=0) //delay 200ms
; 0000 00FE         {
; 0000 00FF             if(Freq>20)      {Freq-=5;  Update_Timer1();}
; 0000 0100             else             Freq=20;
; 0000 0101             tick_freq_dec=0;
; 0000 0102         }
; 0000 0103 
; 0000 0104     }
; 0000 0105     else
; 0000 0106     Freq_DEC_flag=0;
; 0000 0107     if(!Duty_INC){
; 0000 0108         TIMSK|=0x01;
; 0000 0109         Duty_INC_flag=1;
; 0000 010A         if((tick_duty_inc/2000)!=0) //delay 200ms
; 0000 010B         {
; 0000 010C             if(Duty<100)     Duty+=2;
; 0000 010D             else             Duty=95;
; 0000 010E             tick_duty_inc=0;
; 0000 010F         }
; 0000 0110     }
; 0000 0111     else
; 0000 0112     Duty_INC_flag=0;
; 0000 0113     if(!Duty_DEC){
; 0000 0114         TIMSK|=0x01;
; 0000 0115         Duty_DEC_flag=1;
; 0000 0116         if((tick_duty_dec/2000)!=0) //delay 200ms
; 0000 0117         {
; 0000 0118             if(Duty>5)       Duty-=2;
; 0000 0119             else             Duty=5;
; 0000 011A             tick_duty_dec=0;
; 0000 011B         }
; 0000 011C     }
; 0000 011D     else
; 0000 011E     Duty_DEC_flag=0;
; 0000 011F 
; 0000 0120 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x9
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x9
	ADIW R26,2
	RCALL SUBOPT_0x5
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x5
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0xB
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0xB
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xE
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x12
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x12
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x13
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x13
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x13
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0xB
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x12
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x12
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x13
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0xE
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x14
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x1
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x1
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x1
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x12,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x12,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,7
_0x202000B:
	__DELAY_USB 5
	SBI  0x12,3
	__DELAY_USB 13
	CBI  0x12,3
	__DELAY_USB 13
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x15
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x15
	__DELAY_USB 133
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x16
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,1
	LD   R30,Y
	RCALL SUBOPT_0x16
	CBI  0x12,1
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,7
	SBI  0x11,3
	SBI  0x11,1
	SBI  0x11,2
	CBI  0x12,3
	CBI  0x12,1
	CBI  0x12,2
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x1
	RCALL _delay_ms
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x19
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x16
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_Freq:
	.BYTE 0x4
_Duty_INC_flag:
	.BYTE 0x2
_Duty_DEC_flag:
	.BYTE 0x2
_tick_duty_inc:
	.BYTE 0x2
_tick_duty_dec:
	.BYTE 0x2
_tick_freq_inc:
	.BYTE 0x2
_tick_freq_dec:
	.BYTE 0x2
_Duty:
	.BYTE 0x2
_T_delay:
	.BYTE 0x2
_Chuoi:
	.BYTE 0x10
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(_Chuoi)
	LDI  R31,HIGH(_Chuoi)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDS  R30,_Freq
	LDS  R31,_Freq+1
	LDS  R22,_Freq+2
	LDS  R23,_Freq+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x5:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x1
	RCALL _ADC_Read
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x1
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x1
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xC
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__DELAY_USW 200
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
