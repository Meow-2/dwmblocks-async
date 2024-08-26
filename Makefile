.POSIX:

BIN := dwmblocks
BUILD_DIR := build
SRC_DIR := src
INC_DIR := include

DEBUG := 0
VERBOSE := 0
LIBS := xcb-atom

PREFIX := /usr/local
CFLAGS := -Ofast -I. -I$(INC_DIR) -std=c99
CFLAGS += -DBINARY=\"$(BIN)\" -D_POSIX_C_SOURCE=200809L
CFLAGS += -Wall -Wpedantic -Wextra -Wswitch-enum
CFLAGS += $(shell pkg-config --cflags $(LIBS))
LDLIBS := $(shell pkg-config --libs $(LIBS))

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(subst $(SRC_DIR)/,$(BUILD_DIR)/,$(SRCS:.c=.o))

INSTALL_DIR := $(DESTDIR)$(PREFIX)/bin

# Prettify output
PRINTF := @printf "%-8s %s\n"
ifeq ($(VERBOSE), 0)
	Q := @
endif

ifeq ($(DEBUG), 1)
	CFLAGS += -g
endif

all: options $(BUILD_DIR)/$(BIN)

options:
	@printf "\033[32m==================== Build dwmblocks ====================\033[0m\n"
	@echo dwmblocks build options:
	@echo "PREFIX   = ${PREFIX}"
	@echo "CFLAGS   = ${CFLAGS}"


$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c config.h 
	$Qmkdir -p $(@D)
	$(PRINTF) "CC" $@
	$Q$(COMPILE.c) -o $@ $<

$(BUILD_DIR)/$(BIN): $(OBJS)
	$(PRINTF) "LD" $@
	$Q$(LINK.o) $^ $(LDLIBS) -o $@

clean:
	@printf "\033[32m==================== Clean dwmblocks ====================\033[0m\n"
	$(PRINTF) "CLEAN" $(BUILD_DIR)
	$Q$(RM) $(BUILD_DIR)/*

install: $(BUILD_DIR)/$(BIN)
	@printf "\033[32m=================== Install dwmblocks ===================\033[0m\n"
	$(PRINTF) "INSTALL" $(INSTALL_DIR)/$(BIN)
	install -D -m 755 $(BUILD_DIR)/$(BIN) $(INSTALL_DIR)/$(BIN)

uninstall:
	@printf "\033[32m================== Uninstall dwmblocks ==================\033[0m\n"
	$(PRINTF) "RM" $(INSTALL_DIR)/$(BIN)
	$Q$(RM) $(INSTALL_DIR)/$(BIN)

.PHONY: all clean install uninstall
