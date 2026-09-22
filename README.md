# lr-core-abi

三个小练习，走一遍"C 和汇编之间那条边界"：函数怎么被调用、值放在哪、状态怎么被保存。

你只需要改 **4 个文件**：

| 文件 | 任务 |
|---|---|
| `task1/fib.c` | 任务一：用 C 写 `fib`，再看它和 Python 的差距 |
| `task2/strlen.s` | 任务二：用 x86-64 汇编写 `my_strlen` |
| `task3/context.h` | 任务三：定义 `context_t` |
| `task3/context.s` | 任务三：用汇编写 `set_ctx` / `jmp_to` |

其余文件（`Makefile`、各个 `main.c`、`bench.py`）**勿改**，也不要新建文件。

---

## 五分钟跑起来

```bash
sudo apt install build-essential python3   # 只需要一次
make env                                   # 看一眼工具链版本
make help                                  # 看一眼有哪些 target

make test1
make test2
make test3
```

三个 target 一开始**全都会失败**，因为要你实现的文件是空的，任务还没做完。

`make testN` 的退出码就是判定结果：通过是 0，失败非 0。
