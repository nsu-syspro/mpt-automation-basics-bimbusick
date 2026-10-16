CC := gcc

FILE_NAME := wordcount
SOURCE_DIR := src
OUTPUT_DIR := build

TEST_FOLDER := test
TEST_INS := $(wildcard $(TEST_FOLDER)/*.txt)
TEST_EXPECTEDS := $(TEST_INS:%.txt=%.expected)
TESTS := $(TEST_INS:.txt=.test)

NAME := $(shell jq -r '.name' config.json)
VERSION := $(shell jq -r '.version' config.json)

.PHONY: all clean check

all: $(OUTPUT_DIR)/$(NAME)

$(OUTPUT_DIR)/$(NAME): $(SOURCE_DIR)/$(FILE_NAME).c config.json | $(OUTPUT_DIR)
	@$(CC) $< -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\" -o $@

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

clean:
	@rm -r $(OUTPUT_DIR)

check: $(OUTPUT_DIR)/$(NAME) $(TESTS)
	@

$(TESTS) : $(TEST_FOLDER)/%.test : $(TEST_FOLDER)/%.txt
	@./$(OUTPUT_DIR)/$(NAME) <$^ | diff -u --color=always $(TEST_FOLDER)/$*.expected -
