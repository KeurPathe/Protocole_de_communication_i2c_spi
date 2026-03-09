int i;
void spi_init()
{
      SSPSTAT=0x40;
      SSPCON= 0x21;
}

void spi_send(char octet)
{
     char receive_data;
     SSPBUF= octet;
     while(!SSPSTAT.BF);
     receive_data= SSPBUF;
     PIR1.SSPIF=0;
     delay_ms(10);
}

char spi_read()
{
     SSPBUF= 0x00;
     while(!SSPSTAT.BF);
     PIR1.SSPIF=0;
     return SSPBUF;
}

void spiMCP_send(char address, char octet)
{
     PORTC.RC2=0;
     spi_send(0b01000100); //address du MCP configurer manuellement sur proteus (voir datasheet)
     spi_send(address);  //address du registres du MCP où on souhaite écrire
     spi_send(octet);
     PORTC.RC2=1;
}

char spiMCP_read(char address_register)
{
     char receive;
     PORTC.RC2=0;
     spi_send(0b01000101); // address du MCP + read bit=1
     spi_send(address_register);
     receive = spi_read();
     PORTC.RC2=1;
     return receive;
}



void main() {
     TRISB=0x00;
     TRISC.RC2=0;
     TRISC.RC3=0;
     TRISC.RC4 = 1;
     TRISC.RC5=0;
     
     PORTC.RC2=1;

     delay_ms(100);
     spi_init();
     spiMCP_send(0x00,0x00); //config port A as output

     i=3;
     while(i){
       spiMCP_send(0x12,0xAA); //Mettre le port A 10101010
       delay_ms(500);
       spiMCP_send(0x12,0x55);
       delay_ms(500);
       i-- ;
    }
    
    PORTB=spiMCP_read(0x12);
    delay_ms(100);

}