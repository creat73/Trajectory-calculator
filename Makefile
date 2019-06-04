# Nazwa pliku wyjsciowego
BIN := trajectory

# lista plikow zrodowych automatycznie z katalogu src
SRCS := $(wildcard src/*.cpp)

# lista katalogów nagłówkowych
INCLUDES := include


#Detekcja systemu Windows Linux dodawanie suffixu exe
ifdef OS
	BIN := $(BIN).exe
endif

# Lista plikow zawarta w archiwum programu
DISTFILES := $(BIN)

# Nazwa skompresowanego programu wynikowego
DISTOUTPUT := $(BIN).tar.gz

# Nazwa katalogu na pliki posrednie
OBJDIR := .o
# Nazwa katalogu dla plikow zaleznosci
DEPDIR := .d

# Pliki obiektowe obj automatycznie wygenerowane z plikow zrodlowych
OBJS := $(patsubst %,$(OBJDIR)/%.o,$(basename $(SRCS)))
# Pliki zaleznosci autoamtycznie wygenerwoane z plikow zrodlowych
DEPS := $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRCS)))

# Automatyczne tworzenie podkatalogow
$(shell mkdir -p $(dir $(OBJS)) >/dev/null)
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

# Kompilator C - nazwa programu
CC := gcc
# Kompilator C++ - nazwa programu
CXX := g++
# linker
LD := g++
# tar
TAR := tar

# flagi kompilatora C
CFLAGS := -std=c11 
# flagi kompilatora C++
CXXFLAGS := -std=c++17
# flagi wspolne C/C++
CPPFLAGS := -g -Wall -Wextra -pedantic
# flagi linekra
LDFLAGS :=
# flagi potrzebne dla kompilatora do wygenerowania zaleznosci
DEPFLAGS = -MT $@ -MD -MP -MF $(DEPDIR)/$*.Td

# kompilacja plikow C z plikow zrodlowych
COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) -c -o $@
# kompilacja plikow C++ z plikow zrodlowych
COMPILE.cc = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c -o $@
# linkowanie do pliku wynikowego
LINK.o = $(LD) $(LDFLAGS) $(LDLIBS) -o $@
# Prekompilacja
PRECOMPILE =
# Post kompilacja
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d
INCLUDE_FLAGS := $(foreach d, $(INCLUDES), -I$d)
CXXFLAGS += $(INCLUDE_FLAGS)
CFLAGS += $(INCLUDE_FLAGS)

all: $(BIN)

dist: $(DISTFILES)
	$(TAR) -cvzf $(DISTOUTPUT) $^

.PHONY: clean
clean:
	$(RM) -r $(OBJDIR) $(DEPDIR)

.PHONY: distclean
distclean: clean
	$(RM) $(BIN) $(DISTOUTPUT)

.PHONY: install
install:
	@echo no install tasks configured

.PHONY: uninstall
uninstall:
	@echo no uninstall tasks configured

.PHONY: check
check:
	@echo no tests configured

.PHONY: help
help:
	@echo available targets: all dist clean distclean install uninstall check

$(BIN): $(OBJS)
	$(LINK.o) $^

$(OBJDIR)/%.o: %.c
$(OBJDIR)/%.o: %.c $(DEPDIR)/%.d
	$(PRECOMPILE)
	$(COMPILE.c) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cpp
$(OBJDIR)/%.o: %.cpp $(DEPDIR)/%.d
	$(PRECOMPILE)
	$(COMPILE.cc) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cc
$(OBJDIR)/%.o: %.cc $(DEPDIR)/%.d
	$(PRECOMPILE)
	$(COMPILE.cc) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cxx
$(OBJDIR)/%.o: %.cxx $(DEPDIR)/%.d
	$(PRECOMPILE)
	$(COMPILE.cc) $<
	$(POSTCOMPILE)

.PRECIOUS = $(DEPDIR)/%.d
$(DEPDIR)/%.d: ;

-include $(DEPS)
