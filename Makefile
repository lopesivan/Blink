OBJS = led.o
BIN  = led
HEX  = led.hex
##############################################################################
# ubuntu install: sudo apt install gcc-avr avr-libc binutils-avr avrdude make
##############################################################################
PORT        = /dev/ttyACM0

# The path of Arduino IDE
ARDUINO_DIR = /opt/arduino-0022
# Boardy type: use "arduino" for Uno or "stk500v1" for Duemilanove
BOARD_TYPE  = arduino
# Baud-rate: use "115200" for Uno or "19200" for Duemilanove
BAUD_RATE   = 115200

#Compiler and uploader configuration
MCU         = atmega328p
DF_CPU      = 16000000UL
CC          = /usr/bin/avr-gcc
LD          = /usr/bin/avr-gcc
CFLAGS      = -Os -DF_CPU=$(DF_CPU) -mmcu=$(MCU) -c
LDFLAGS     = -mmcu=$(MCU) -o $@
LIBS        =
CPP         = /usr/bin/avr-g++
AVR_OBJCOPY = /usr/bin/avr-objcopy
AVR_OBJDUMP = /usr/bin/avr-objdump
AVRDUDE     = /usr/bin/avrdude
##############################################################################

include gmsl
##############################################################################

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

all: $(HEX)

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $+ $(LIBS)

$(HEX): $(BIN)
	$(AVR_OBJCOPY) -O ihex -R .eeprom $+ $@

$(BIN).lst: $(BIN)
	$(AVR_OBJDUMP) -d $+ >$@

up:
	echo avrdude -F -V -c arduino -p $(call uc,$(MCU)) -P $(PORT) -b $(BAUD_RATE) -U flash:w:$(HEX)
backup:
	echo avrdude -F -V -c arduino -p $(call uc,$(MCU)) -P $(PORT) -b $(BAUD_RATE) -U flash:r:flash_backup.hex:i

clean:
	rm -f $(OBJS) $(BIN) $(HEX) $(BIN).lst core

###
