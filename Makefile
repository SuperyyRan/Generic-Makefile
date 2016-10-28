###########################################
#
#   a generic makefile
#
########################################### 
# name of exec
EXECUTABLE := amis_argus
# lib dir
LIBDIR:= /usr/local/lib
# lib file
LIBS := rabbitmq
# include dir
INCLUDES:= ./include /usr/local/include
# other src dir
SRCDIR:= ./src

#
# # Now alter any implicit rules' variables if you like, e.g.:

CC:=g++
#CFLAGS := -g -Wall -O3
CFLAGS :=
CPPFLAGS := $(CFLAGS)
CPPFLAGS += $(addprefix -I,$(INCLUDES))
CPPFLAGS += -MMD
#
# # The next bit checks to see whether rm is in your djgpp bin
# # directory; if not it uses del instead, but this can cause (harmless)
# # `File not found' error messages. If you are not using DOS at all,
# # set the variable to something which will unquestioningly remove
# # files.
#

RM-F := rm -f


# # You shouldn't need to change anything below this point.
#
SRCS := $(wildcard *.c) $(wildcard $(addsuffix /*.c, $(SRCDIR)))
OBJS := $(patsubst %.c,%.o,$(SRCS))
DEPS := $(patsubst %.o,%.d,$(OBJS))
MISSING_DEPS := $(filter-out $(wildcard $(DEPS)),$(DEPS))
MISSING_DEPS_SOURCES := $(wildcard $(patsubst %.d,%.c,$(MISSING_DEPS)))


.PHONY : all deps objs clean veryclean rebuild info

all: $(EXECUTABLE)

deps : $(DEPS)

objs : $(OBJS)

clean :
	@$(RM-F) *.o
	@$(RM-F) *.d
clean-all: clean
	@$(RM-F) $(EXECUTABLE)
	@$(RM-F) *~
rebuild: veryclean all
ifneq ($(MISSING_DEPS),)
$(MISSING_DEPS)	:
	@$(RM-F) $(patsubst %.d,%.o,$@)
endif
-include $(DEPS)
$(EXECUTABLE)	:$(OBJS)
	$(CC) -o $(EXECUTABLE) $(OBJS) $(CPPFLAGS) $(addprefix -l,$(LIBS))
	@$(RM-F) *.o 
	@$(RM-F) *.d

info:
	@echo $(SRCS)
	@echo $(OBJS)
	@echo $(DEPS)
	@echo $(MISSING_DEPS)
	@echo $(MISSING_DEPS_SOURCES)
