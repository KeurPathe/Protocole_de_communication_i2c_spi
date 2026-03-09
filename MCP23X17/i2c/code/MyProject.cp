#line 1 "D:/Mes docs/SEECS 04/Protocole de communication/Projets/MCP23X17/i2c/code/MyProject.c"
int i;

void i2c_init()
{
 SSPCON = 0x28;
 SSPCON2 = 0x00;
 SSPSTAT = 0x80;
 SSPADD = 8000/(4*50) - 1 ;
}

void i2c_send(char donnee)
{
 SSPBUF = donnee;
 while(!PIR1.SSPIF);
 PIR1.SSPIF=0;
}

void i2cMCP_send(char address, char donnee)
{

 PIR1.SSPIF = 0;
 SSPCON2.SEN=1;
 while(SSPCON2.SEN);
 PIR1.SSPIF=0;


 i2c_send(0b01000110);
 if(SSPCON2.ACKSTAT==1){
 SSPCON2.PEN=1;
 while(SSPCON2.PEN);
 return ;
 }



 i2c_send(address);
 if(SSPCON2.ACKSTAT==1){
 SSPCON2.PEN=1;
 while(SSPCON2.PEN);
 return ;
 }


 i2c_send(donnee);
 if(SSPCON2.ACKSTAT==1){
 SSPCON2.PEN=1;
 while(SSPCON2.PEN);
 return ;
 }


 SSPCON2.PEN = 1;
 while(SSPCON2.PEN);

}

char i2cMCP_read(char address)
{
 char recu;

 PIR1.SSPIF = 0;
 SSPCON2.SEN=1;
 while(SSPCON2.SEN);
 PIR1.SSPIF=0;


 i2c_send(0b01000110);
 if(SSPCON2.ACKSTAT==1){
 SSPCON2.PEN=1;
 while(SSPCON2.PEN);
 return ;
 }
 i2c_send(address);

 SSPCON2.RSEN = 1;
 while(!PIR1.SSPIF);
 PIR1.SSPIF = 0;

 i2c_send(0b01000111);
 if(SSPCON2.ACKSTAT==1){
 SSPCON2.PEN=1;
 while(SSPCON2.PEN);
 return ;
 }



 SSPCON2.RCEN = 1;
 while(!SSPSTAT.BF);
 recu = SSPBUF;
 PIR1.SSPIF = 0;


 SSPCON2.ACKDT = 1;
 SSPCON2.ACKEN = 1;
 while(SSPCON2.ACKEN);


 SSPCON2.PEN = 1;
 while(SSPCON2.PEN);

 return recu;

}


void main() {
 TRISC.RC3 = 1;
 TRISC.RC4=1;
 TRISB=0x00;

 i2c_init();
 Delay_ms(500);

 PORTB=0;

 i2cMCP_send(0x01, 0x00);
 delay_ms(100);
 i=2;
 while(i)
 {
 i2cMCP_send(0x13, 0xAA);
 delay_ms(500);
 i2cMCP_send(0x13,0x55);
 delay_ms(500);
 delay_ms(100);
 i-- ;
 }

 PORTB=i2cMCP_read(0x13);
 delay_ms(100);
}
