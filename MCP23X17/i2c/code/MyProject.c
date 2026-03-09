int i;

void i2c_init()
{
      SSPCON = 0x28;   // I2C Master mode
      SSPCON2 = 0x00;
      SSPSTAT = 0x80;
      SSPADD = 8000/(4*50) - 1  ;
}

void i2c_send(char donnee)
{
     SSPBUF = donnee;
     while(!PIR1.SSPIF);
     PIR1.SSPIF=0;
}

void i2cMCP_send(char address, char donnee)
{
      // initiate communication with start bit
       PIR1.SSPIF = 0;
       SSPCON2.SEN=1;
       while(SSPCON2.SEN);
       PIR1.SSPIF=0;

       //sending esclave's address and R/W bit
       i2c_send(0b01000110);
       if(SSPCON2.ACKSTAT==1){
            SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
            while(SSPCON2.PEN);
            return ;
       }


       //sending address register
       i2c_send(address);
       if(SSPCON2.ACKSTAT==1){
            SSPCON2.PEN=1; // arreter la trasmission esclave ne re oit pas
            while(SSPCON2.PEN);
            return ;
       }

       //sending  data
       i2c_send(donnee);
       if(SSPCON2.ACKSTAT==1){
            SSPCON2.PEN=1; // arr ter la trasmission esclave ne re oit pas
            while(SSPCON2.PEN);
            return ;
       }

       //send the stop condition
       SSPCON2.PEN = 1;  // Initiate STOP condition
       while(SSPCON2.PEN);  // Wait for STOP to complete

}

char i2cMCP_read(char address)
{
       char recu;
      // initiate communication with start bit
       PIR1.SSPIF = 0;
       SSPCON2.SEN=1;
       while(SSPCON2.SEN);
       PIR1.SSPIF=0;

       //sending esclave's address and R/W bit read=0
       i2c_send(0b01000110);
       if(SSPCON2.ACKSTAT==1){
            SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
            while(SSPCON2.PEN);
            return ;
       }
       i2c_send(address);
       
       SSPCON2.RSEN = 1;     // Repeated Start
       while(!PIR1.SSPIF);
       PIR1.SSPIF = 0;
       
       i2c_send(0b01000111);
       if(SSPCON2.ACKSTAT==1){
            SSPCON2.PEN=1; // stop la trasmission esclave does'nt receive
            while(SSPCON2.PEN);
            return ;
       }


      // Lecture des registres
      SSPCON2.RCEN = 1;
      while(!SSPSTAT.BF);
      recu = SSPBUF;
      PIR1.SSPIF = 0;

      // NACK pour arreter
      SSPCON2.ACKDT = 1;
      SSPCON2.ACKEN = 1;
      while(SSPCON2.ACKEN);

      //send the stop condition
      SSPCON2.PEN = 1;  // Initiate STOP condition
      while(SSPCON2.PEN);  // Wait for STOP to complete
       
      return recu;

}


void main() {
    TRISC.RC3 = 1;
    TRISC.RC4=1;
    TRISB=0x00;
    
    i2c_init();
    Delay_ms(500);

    PORTB=0;

    i2cMCP_send(0x01, 0x00); //Mettre le port B du MCP en sortie
    delay_ms(100);
    i=2;
    while(i)
    {
       i2cMCP_send(0x13, 0xAA); //Mettre le port B MCP 10101010
       delay_ms(500);
       i2cMCP_send(0x13,0x55);
       delay_ms(500);
       delay_ms(100);
       i-- ;
    }
    
    PORTB=i2cMCP_read(0x13);
    delay_ms(100);
}