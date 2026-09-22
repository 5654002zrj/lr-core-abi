# lr-core-abi —— 勿改。编译、链接、跑测试都由这里负责。

CC     := gcc
CFLAGS := -Wall -Wextra -O0 -g -std=c11 -no-pie
PY     := python3
BUILD  := build

.PHONY: help env all test1 test2 test3 clean

help:
	@echo "make test1  任务一：C 实现 fib（正确性校验 + ctypes 计时）"
	@echo "make test2  任务二：汇编实现 my_strlen（与库函数逐个样例对比）"
	@echo "make test3  任务三：自己实现 set_ctx / jmp_to"
	@echo "make env    打印工具链版本"
	@echo "make clean  删除 build/"

env:
	@echo "gcc:    $$($(CC) --version | head -1)"
	@echo "arch:   $$($(CC) -dumpmachine)"
	@echo "python: $$($(PY) --version)"

all: test1 test2 test3

$(BUILD):
	@mkdir -p $@

test1: | $(BUILD)
	$(CC) $(CFLAGS) -shared -fPIC task1/fib.c -o $(BUILD)/libfib.so
	$(PY) task1/bench.py

test2: | $(BUILD)
	$(CC) $(CFLAGS) -Wa,--noexecstack task2/main.c task2/strlen.s -o $(BUILD)/test2
	@./$(BUILD)/test2

test3: | $(BUILD)
	$(CC) $(CFLAGS) -Wa,--noexecstack task3/main.c task3/context.s -o $(BUILD)/test3
	@out=$$(timeout 10 ./$(BUILD)/test3) || { \
		echo "task3 挂了：超时或崩溃（上限 10 秒）"; exit 1; }; \
	 [ "$$out" = "023" ] || { echo "期望输出 023，实际：$$out"; exit 1; }; \
	 echo "task3 通过：输出 $$out"

clean:
	rm -rf $(BUILD)
