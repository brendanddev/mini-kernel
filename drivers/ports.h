// Declares function for reading and writing to hardware I/O ports.

unsigned char port_byte_in(unsigned short port);
void port_byte_out(unsigned short port, unsigned char data);
unsigned short port_word_in(unsigned short port);
void port_word_at(unsigned short port, unsigned short data);
