# Default assembler and linker
AS = nasm
LD = ld

# Default flags (adjust as needed)
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 

# Get the .asm file name from the command line
ASM_FILE ?= $(error ASM_FILE is not set. Usage: make ASM_FILE=your_file.asm)

# Extract the base name without extension
BASE_NAME = $(basename $(ASM_FILE))

# Default target
all: $(BASE_NAME)

# Rule to assemble .asm to .o
%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

# Rule to link .o to executable
$(BASE_NAME): $(BASE_NAME).o
	$(LD) $(LDFLAGS) $< -o $@

# Clean rule
clean:
	rm -f $(BASE_NAME) *.o

.PHONY: all clean
