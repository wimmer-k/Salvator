.EXPORT_ALL_VARIABLES:

.PHONY: clean all

BIN_DIR = $(HOME)/bin
LIB_DIR = $(HOME)/lib
COMMON_DIR = $(HOME)/common/
TARTSYS=/usr/local/anaroot5


ROOTCFLAGS   := $(shell root-config --cflags)
ROOTLIBS     := $(shell root-config --libs)
ROOTGLIBS    := $(shell root-config --glibs)
ROOTINC      := -I$(shell root-config --incdir)

CPP             = g++
CFLAGS		= -Wall -Wno-long-long -g -O3 $(ROOTCFLAGS) -fPIC

INCLUDES        = -I./inc -I$(COMMON_DIR) -I$(TARTSYS)/include
BASELIBS 	= -lm $(ROOTLIBS) $(ROOTGLIBS) -L$(LIB_DIR) -L$(TARTSYS)/lib -lSpectrum -lXMLParser
ALLIBS  	=  $(BASELIBS) -lCommandLineInterface -lanaroot -lananadeko -lanacore -lanabrips -lanaloop -lanadali -lSalvator
LIBS 		= $(ALLIBS)
LFLAGS		= -g -fPIC -shared
CFLAGS += -Wl,--no-as-needed
LFLAGS += -Wl,--no-as-needed
CFLAGS += -Wno-unused-variable -Wno-write-strings

LIB_O_FILES = build/FocalPlane.o build/FocalPlaneDictionary.o build/Beam.o build/BeamDictionary.o build/PPAC.o build/PPACDictionary.o build/DALI.o build/DALIDictionary.o 

O_FILES = build/Reconstruction.o build/Settings.o
EU_O_FILES = build/BuildEvents.o

all: Metamorphosis FriedBacon BurningGiraffe Disintegration Persistence MergeEURICA

Metamorphosis: Metamorphosis.cc $(LIB_DIR)/libSalvator.so build/Settings.o
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) build/Settings.o -o $(BIN_DIR)/$@ 

FriedBacon: FriedBacon.cc $(LIB_DIR)/libSalvator.so build/Settings.o
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) build/Settings.o -o $(BIN_DIR)/$@ 

BurningGiraffe: BurningGiraffe.cc $(LIB_DIR)/libSalvator.so
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) -o $(BIN_DIR)/$@ 

Disintegration: Disintegration.cc $(LIB_DIR)/libSalvator.so
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) -o $(BIN_DIR)/$@ 

Persistence: Persistence.cc $(LIB_DIR)/libSalvator.so $(O_FILES)
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) $(O_FILES) -o $(BIN_DIR)/$@ 

MergeEURICA: MergeEURICA.cc $(LIB_DIR)/libSalvator.so $(LIB_DIR)/libEURICA.so $(EU_O_FILES)
	@echo "Compiling $@"
	@$(CPP) $(CFLAGS) $(INCLUDES) $< $(LIBS) -lEURICA $(EU_O_FILES) -o $(BIN_DIR)/$@ 

$(LIB_DIR)/libSalvator.so: $(LIB_O_FILES) 
	@echo "Making $@"
	@$(CPP) $(LFLAGS) -o $@ $^ -lc

$(LIB_DIR)/libEURICA.so: build/EURICA.o build/EURICADictionary.o 
	@echo "Making $@"
	@$(CPP) $(LFLAGS) -o $@ $^ -lc

build/Reconstruction.o: src/Reconstruction.cc inc/Reconstruction.hh $(LIB_DIR)/libSalvator.so 
	@echo "Compiling $@"
	@mkdir -p $(dir $@)
	@$(CPP) $(CFLAGS) $(INCLUDES) -c $< -o $@ 

build/%.o: src/%.cc inc/%.hh
	@echo "Compiling $@"
	@mkdir -p $(dir $@)
	@$(CPP) $(CFLAGS) $(INCLUDES) -c $< -o $@ 

build/%Dictionary.o: build/%Dictionary.cc
	@echo "Compiling $@"
	@mkdir -p $(dir $@)
	@$(CPP) $(CFLAGS) $(INCLUDES) -fPIC -c $< -o $@

build/%Dictionary.cc: inc/%.hh inc/%LinkDef.h
	@echo "Building $@"
	@mkdir -p build
	@rootcint -f $@ -c $(INCLUDES) $(ROOTCFLAGS) $(notdir $^)

doc:	doxyconf
	doxygen doxyconf


clean:
	@echo "Cleaning up"
	@rm -rf build doc
	@rm -f inc/*~ src/*~ *~
