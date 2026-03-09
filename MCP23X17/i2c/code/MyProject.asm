
_i2c_init:

;MyProject.c,3 :: 		void i2c_init()
;MyProject.c,5 :: 		SSPCON = 0x28;   // I2C Master mode
	MOVLW      40
	MOVWF      SSPCON+0
;MyProject.c,6 :: 		SSPCON2 = 0x00;
	CLRF       SSPCON2+0
;MyProject.c,7 :: 		SSPSTAT = 0x80;
	MOVLW      128
	MOVWF      SSPSTAT+0
;MyProject.c,8 :: 		SSPADD = 8000/(4*50) - 1  ;
	MOVLW      39
	MOVWF      SSPADD+0
;MyProject.c,9 :: 		}
L_end_i2c_init:
	RETURN
; end of _i2c_init

_i2c_send:

;MyProject.c,11 :: 		void i2c_send(char donnee)
;MyProject.c,13 :: 		SSPBUF = donnee;
	MOVF       FARG_i2c_send_donnee+0, 0
	MOVWF      SSPBUF+0
;MyProject.c,14 :: 		while(!PIR1.SSPIF);
L_i2c_send0:
	BTFSC      PIR1+0, 3
	GOTO       L_i2c_send1
	GOTO       L_i2c_send0
L_i2c_send1:
;MyProject.c,15 :: 		PIR1.SSPIF=0;
	BCF        PIR1+0, 3
;MyProject.c,16 :: 		}
L_end_i2c_send:
	RETURN
; end of _i2c_send

_i2cMCP_send:

;MyProject.c,18 :: 		void i2cMCP_send(char address, char donnee)
;MyProject.c,21 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;MyProject.c,22 :: 		SSPCON2.SEN=1;
	BSF        SSPCON2+0, 0
;MyProject.c,23 :: 		while(SSPCON2.SEN);
L_i2cMCP_send2:
	BTFSS      SSPCON2+0, 0
	GOTO       L_i2cMCP_send3
	GOTO       L_i2cMCP_send2
L_i2cMCP_send3:
;MyProject.c,24 :: 		PIR1.SSPIF=0;
	BCF        PIR1+0, 3
;MyProject.c,27 :: 		i2c_send(0b01000110);
	MOVLW      70
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,28 :: 		if(SSPCON2.ACKSTAT==1){
	BTFSS      SSPCON2+0, 6
	GOTO       L_i2cMCP_send4
;MyProject.c,29 :: 		SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
	BSF        SSPCON2+0, 2
;MyProject.c,30 :: 		while(SSPCON2.PEN);
L_i2cMCP_send5:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_send6
	GOTO       L_i2cMCP_send5
L_i2cMCP_send6:
;MyProject.c,31 :: 		return ;
	GOTO       L_end_i2cMCP_send
;MyProject.c,32 :: 		}
L_i2cMCP_send4:
;MyProject.c,36 :: 		i2c_send(address);
	MOVF       FARG_i2cMCP_send_address+0, 0
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,37 :: 		if(SSPCON2.ACKSTAT==1){
	BTFSS      SSPCON2+0, 6
	GOTO       L_i2cMCP_send7
;MyProject.c,38 :: 		SSPCON2.PEN=1; // arreter la trasmission esclave ne re oit pas
	BSF        SSPCON2+0, 2
;MyProject.c,39 :: 		while(SSPCON2.PEN);
L_i2cMCP_send8:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_send9
	GOTO       L_i2cMCP_send8
L_i2cMCP_send9:
;MyProject.c,40 :: 		return ;
	GOTO       L_end_i2cMCP_send
;MyProject.c,41 :: 		}
L_i2cMCP_send7:
;MyProject.c,44 :: 		i2c_send(donnee);
	MOVF       FARG_i2cMCP_send_donnee+0, 0
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,45 :: 		if(SSPCON2.ACKSTAT==1){
	BTFSS      SSPCON2+0, 6
	GOTO       L_i2cMCP_send10
;MyProject.c,46 :: 		SSPCON2.PEN=1; // arr ter la trasmission esclave ne re oit pas
	BSF        SSPCON2+0, 2
;MyProject.c,47 :: 		while(SSPCON2.PEN);
L_i2cMCP_send11:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_send12
	GOTO       L_i2cMCP_send11
L_i2cMCP_send12:
;MyProject.c,48 :: 		return ;
	GOTO       L_end_i2cMCP_send
;MyProject.c,49 :: 		}
L_i2cMCP_send10:
;MyProject.c,52 :: 		SSPCON2.PEN = 1;  // Initiate STOP condition
	BSF        SSPCON2+0, 2
;MyProject.c,53 :: 		while(SSPCON2.PEN);  // Wait for STOP to complete
L_i2cMCP_send13:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_send14
	GOTO       L_i2cMCP_send13
L_i2cMCP_send14:
;MyProject.c,55 :: 		}
L_end_i2cMCP_send:
	RETURN
; end of _i2cMCP_send

_i2cMCP_read:

;MyProject.c,57 :: 		char i2cMCP_read(char address)
;MyProject.c,61 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;MyProject.c,62 :: 		SSPCON2.SEN=1;
	BSF        SSPCON2+0, 0
;MyProject.c,63 :: 		while(SSPCON2.SEN);
L_i2cMCP_read15:
	BTFSS      SSPCON2+0, 0
	GOTO       L_i2cMCP_read16
	GOTO       L_i2cMCP_read15
L_i2cMCP_read16:
;MyProject.c,64 :: 		PIR1.SSPIF=0;
	BCF        PIR1+0, 3
;MyProject.c,67 :: 		i2c_send(0b01000110);
	MOVLW      70
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,68 :: 		if(SSPCON2.ACKSTAT==1){
	BTFSS      SSPCON2+0, 6
	GOTO       L_i2cMCP_read17
;MyProject.c,69 :: 		SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
	BSF        SSPCON2+0, 2
;MyProject.c,70 :: 		while(SSPCON2.PEN);
L_i2cMCP_read18:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_read19
	GOTO       L_i2cMCP_read18
L_i2cMCP_read19:
;MyProject.c,71 :: 		return ;
	GOTO       L_end_i2cMCP_read
;MyProject.c,72 :: 		}
L_i2cMCP_read17:
;MyProject.c,73 :: 		i2c_send(address);
	MOVF       FARG_i2cMCP_read_address+0, 0
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,75 :: 		SSPCON2.RSEN = 1;     // Repeated Start
	BSF        SSPCON2+0, 1
;MyProject.c,76 :: 		while(!PIR1.SSPIF);
L_i2cMCP_read20:
	BTFSC      PIR1+0, 3
	GOTO       L_i2cMCP_read21
	GOTO       L_i2cMCP_read20
L_i2cMCP_read21:
;MyProject.c,77 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;MyProject.c,79 :: 		i2c_send(0b01000111);
	MOVLW      71
	MOVWF      FARG_i2c_send_donnee+0
	CALL       _i2c_send+0
;MyProject.c,80 :: 		if(SSPCON2.ACKSTAT==1){
	BTFSS      SSPCON2+0, 6
	GOTO       L_i2cMCP_read22
;MyProject.c,81 :: 		SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
	BSF        SSPCON2+0, 2
;MyProject.c,82 :: 		while(SSPCON2.PEN);
L_i2cMCP_read23:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_read24
	GOTO       L_i2cMCP_read23
L_i2cMCP_read24:
;MyProject.c,83 :: 		return ;
	GOTO       L_end_i2cMCP_read
;MyProject.c,84 :: 		}
L_i2cMCP_read22:
;MyProject.c,88 :: 		SSPCON2.RCEN = 1;
	BSF        SSPCON2+0, 3
;MyProject.c,89 :: 		while(!SSPSTAT.BF);
L_i2cMCP_read25:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_i2cMCP_read26
	GOTO       L_i2cMCP_read25
L_i2cMCP_read26:
;MyProject.c,90 :: 		recu = SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      i2cMCP_read_recu_L0+0
;MyProject.c,91 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;MyProject.c,94 :: 		SSPCON2.ACKDT = 1;
	BSF        SSPCON2+0, 5
;MyProject.c,95 :: 		SSPCON2.ACKEN = 1;
	BSF        SSPCON2+0, 4
;MyProject.c,96 :: 		while(SSPCON2.ACKEN);
L_i2cMCP_read27:
	BTFSS      SSPCON2+0, 4
	GOTO       L_i2cMCP_read28
	GOTO       L_i2cMCP_read27
L_i2cMCP_read28:
;MyProject.c,99 :: 		SSPCON2.PEN = 1;  // Initiate STOP condition
	BSF        SSPCON2+0, 2
;MyProject.c,100 :: 		while(SSPCON2.PEN);  // Wait for STOP to complete
L_i2cMCP_read29:
	BTFSS      SSPCON2+0, 2
	GOTO       L_i2cMCP_read30
	GOTO       L_i2cMCP_read29
L_i2cMCP_read30:
;MyProject.c,102 :: 		return recu;
	MOVF       i2cMCP_read_recu_L0+0, 0
	MOVWF      R0+0
;MyProject.c,104 :: 		}
L_end_i2cMCP_read:
	RETURN
; end of _i2cMCP_read

_main:

;MyProject.c,107 :: 		void main() {
;MyProject.c,108 :: 		TRISC.RC3 = 1;
	BSF        TRISC+0, 3
;MyProject.c,109 :: 		TRISC.RC4=1;
	BSF        TRISC+0, 4
;MyProject.c,110 :: 		TRISB=0x00;
	CLRF       TRISB+0
;MyProject.c,112 :: 		i2c_init();
	CALL       _i2c_init+0
;MyProject.c,113 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main31:
	DECFSZ     R13+0, 1
	GOTO       L_main31
	DECFSZ     R12+0, 1
	GOTO       L_main31
	DECFSZ     R11+0, 1
	GOTO       L_main31
	NOP
	NOP
;MyProject.c,115 :: 		PORTB=0;
	CLRF       PORTB+0
;MyProject.c,117 :: 		i2cMCP_send(0x01, 0x00); //Mettre le port B du MCP en sortie
	MOVLW      1
	MOVWF      FARG_i2cMCP_send_address+0
	CLRF       FARG_i2cMCP_send_donnee+0
	CALL       _i2cMCP_send+0
;MyProject.c,118 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
	NOP
;MyProject.c,119 :: 		i=2;
	MOVLW      2
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
;MyProject.c,120 :: 		while(i)
L_main33:
	MOVF       _i+0, 0
	IORWF      _i+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
;MyProject.c,122 :: 		i2cMCP_send(0x13, 0xAA); //Mettre le port B MCP 10101010
	MOVLW      19
	MOVWF      FARG_i2cMCP_send_address+0
	MOVLW      170
	MOVWF      FARG_i2cMCP_send_donnee+0
	CALL       _i2cMCP_send+0
;MyProject.c,123 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main35:
	DECFSZ     R13+0, 1
	GOTO       L_main35
	DECFSZ     R12+0, 1
	GOTO       L_main35
	DECFSZ     R11+0, 1
	GOTO       L_main35
	NOP
	NOP
;MyProject.c,124 :: 		i2cMCP_send(0x13,0x55);
	MOVLW      19
	MOVWF      FARG_i2cMCP_send_address+0
	MOVLW      85
	MOVWF      FARG_i2cMCP_send_donnee+0
	CALL       _i2cMCP_send+0
;MyProject.c,125 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;MyProject.c,126 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
;MyProject.c,127 :: 		i-- ;
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MyProject.c,128 :: 		}
	GOTO       L_main33
L_main34:
;MyProject.c,130 :: 		PORTB=i2cMCP_read(0x13);
	MOVLW      19
	MOVWF      FARG_i2cMCP_read_address+0
	CALL       _i2cMCP_read+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;MyProject.c,131 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
;MyProject.c,132 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
