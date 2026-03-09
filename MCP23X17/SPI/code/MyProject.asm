
_spi_init:

;MyProject.c,2 :: 		void spi_init()
;MyProject.c,4 :: 		SSPSTAT=0x40;
	MOVLW      64
	MOVWF      SSPSTAT+0
;MyProject.c,5 :: 		SSPCON= 0x21;
	MOVLW      33
	MOVWF      SSPCON+0
;MyProject.c,6 :: 		}
L_end_spi_init:
	RETURN
; end of _spi_init

_spi_send:

;MyProject.c,8 :: 		void spi_send(char octet)
;MyProject.c,11 :: 		SSPBUF= octet;
	MOVF       FARG_spi_send_octet+0, 0
	MOVWF      SSPBUF+0
;MyProject.c,12 :: 		while(!SSPSTAT.BF);
L_spi_send0:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_spi_send1
	GOTO       L_spi_send0
L_spi_send1:
;MyProject.c,14 :: 		PIR1.SSPIF=0;
	BCF        PIR1+0, 3
;MyProject.c,15 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_spi_send2:
	DECFSZ     R13+0, 1
	GOTO       L_spi_send2
	DECFSZ     R12+0, 1
	GOTO       L_spi_send2
	NOP
;MyProject.c,16 :: 		}
L_end_spi_send:
	RETURN
; end of _spi_send

_spi_read:

;MyProject.c,18 :: 		char spi_read()
;MyProject.c,20 :: 		SSPBUF= 0x00;
	CLRF       SSPBUF+0
;MyProject.c,21 :: 		while(!SSPSTAT.BF);
L_spi_read3:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_spi_read4
	GOTO       L_spi_read3
L_spi_read4:
;MyProject.c,22 :: 		PIR1.SSPIF=0;
	BCF        PIR1+0, 3
;MyProject.c,23 :: 		return SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      R0+0
;MyProject.c,24 :: 		}
L_end_spi_read:
	RETURN
; end of _spi_read

_spiMCP_send:

;MyProject.c,26 :: 		void spiMCP_send(char address, char octet)
;MyProject.c,28 :: 		PORTC.RC2=0;
	BCF        PORTC+0, 2
;MyProject.c,29 :: 		spi_send(0b01000100); //address du MCP configurer manuellement sur proteus (voir datasheet)
	MOVLW      68
	MOVWF      FARG_spi_send_octet+0
	CALL       _spi_send+0
;MyProject.c,30 :: 		spi_send(address);  //address du registres du MCP où on souhaite écrire
	MOVF       FARG_spiMCP_send_address+0, 0
	MOVWF      FARG_spi_send_octet+0
	CALL       _spi_send+0
;MyProject.c,31 :: 		spi_send(octet);
	MOVF       FARG_spiMCP_send_octet+0, 0
	MOVWF      FARG_spi_send_octet+0
	CALL       _spi_send+0
;MyProject.c,32 :: 		PORTC.RC2=1;
	BSF        PORTC+0, 2
;MyProject.c,33 :: 		}
L_end_spiMCP_send:
	RETURN
; end of _spiMCP_send

_spiMCP_read:

;MyProject.c,35 :: 		char spiMCP_read(char address_register)
;MyProject.c,38 :: 		PORTC.RC2=0;
	BCF        PORTC+0, 2
;MyProject.c,39 :: 		spi_send(0b01000101); // address du MCP + read bit=1
	MOVLW      69
	MOVWF      FARG_spi_send_octet+0
	CALL       _spi_send+0
;MyProject.c,40 :: 		spi_send(address_register);
	MOVF       FARG_spiMCP_read_address_register+0, 0
	MOVWF      FARG_spi_send_octet+0
	CALL       _spi_send+0
;MyProject.c,41 :: 		receive = spi_read();
	CALL       _spi_read+0
;MyProject.c,42 :: 		PORTC.RC2=1;
	BSF        PORTC+0, 2
;MyProject.c,43 :: 		return receive;
;MyProject.c,44 :: 		}
L_end_spiMCP_read:
	RETURN
; end of _spiMCP_read

_main:

;MyProject.c,48 :: 		void main() {
;MyProject.c,49 :: 		TRISB=0x00;
	CLRF       TRISB+0
;MyProject.c,50 :: 		TRISC.RC2=0;
	BCF        TRISC+0, 2
;MyProject.c,51 :: 		TRISC.RC3=0;
	BCF        TRISC+0, 3
;MyProject.c,52 :: 		TRISC.RC4 = 1;
	BSF        TRISC+0, 4
;MyProject.c,53 :: 		TRISC.RC5=0;
	BCF        TRISC+0, 5
;MyProject.c,55 :: 		PORTC.RC2=1;
	BSF        PORTC+0, 2
;MyProject.c,57 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
;MyProject.c,58 :: 		spi_init();
	CALL       _spi_init+0
;MyProject.c,59 :: 		spiMCP_send(0x00,0x00); //config port A as output
	CLRF       FARG_spiMCP_send_address+0
	CLRF       FARG_spiMCP_send_octet+0
	CALL       _spiMCP_send+0
;MyProject.c,61 :: 		i=3;
	MOVLW      3
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
;MyProject.c,62 :: 		while(i){
L_main6:
	MOVF       _i+0, 0
	IORWF      _i+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
;MyProject.c,63 :: 		spiMCP_send(0x12,0xAA); //Mettre le port A 10101010
	MOVLW      18
	MOVWF      FARG_spiMCP_send_address+0
	MOVLW      170
	MOVWF      FARG_spiMCP_send_octet+0
	CALL       _spiMCP_send+0
;MyProject.c,64 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;MyProject.c,65 :: 		spiMCP_send(0x12,0x55);
	MOVLW      18
	MOVWF      FARG_spiMCP_send_address+0
	MOVLW      85
	MOVWF      FARG_spiMCP_send_octet+0
	CALL       _spiMCP_send+0
;MyProject.c,66 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;MyProject.c,67 :: 		i-- ;
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MyProject.c,68 :: 		}
	GOTO       L_main6
L_main7:
;MyProject.c,70 :: 		PORTB=spiMCP_read(0x12);
	MOVLW      18
	MOVWF      FARG_spiMCP_read_address_register+0
	CALL       _spiMCP_read+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;MyProject.c,71 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
;MyProject.c,73 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
