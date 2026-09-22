#!/usr/bin/env python3
"""任务一的校验与计时。勿改。

两个细节别动：

1. .so 路径用 __file__ 拼绝对路径，从任何 cwd 调用都能找到；
2. restype 必须设。不设的话 ctypes 认为返回值是 32 位 int，
   64 位的结果会被悄悄截断。
"""

import ctypes
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
SO = os.path.join(HERE, os.pardir, "build", "libfib.so")

CASE_MAX = 30  # 正确性检查的 n 上界
N_TIMED = 25  # 计时用的 n
C_REP = 30  # C 侧重复次数，避免单次噪声


def ref_iter(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a


def ref_rec(n):
    return n if n < 2 else ref_rec(n - 1) + ref_rec(n - 2)


def load_fib():
    if not os.path.exists(SO):
        sys.exit("[Error]: 找不到 %s，先跑 make test1" % SO)
    lib = ctypes.CDLL(SO)
    try:
        fn = lib.fib
    except AttributeError:
        sys.exit("[Error]: libfib.so 里没有 fib 符号——task1/fib.c 还没实现？")
    fn.argtypes = [ctypes.c_int]
    fn.restype = ctypes.c_longlong
    return fn


def main():
    fib = load_fib()

    for n in range(CASE_MAX + 1):
        got, want = fib(n), ref_iter(n)
        if got != want:
            sys.exit("[Error]: fib(%d) = %d，参考值 %d" % (n, got, want))

    t0 = time.perf_counter()
    for _ in range(C_REP):
        fib(N_TIMED)
    t_c = (time.perf_counter() - t0) / C_REP

    t0 = time.perf_counter()
    ref_rec(N_TIMED)
    t_rec = time.perf_counter() - t0

    t0 = time.perf_counter()
    ref_iter(N_TIMED)
    t_iter = time.perf_counter() - t0

    ratio = t_iter / t_c
    if ratio >= 1:
        rel = "C 快 %.1f 倍" % ratio
    else:
        rel = "C 慢 %.1f 倍" % (1 / ratio)

    print("[ok] 正确性：n = 0..%d 与 Python 参考实现一致" % CASE_MAX)
    print("[time] n = %d" % N_TIMED)
    print("  C              %10.1f us" % (t_c * 1e6))
    print("  Python 递归    %10.2f ms   → C 快 %.1f 倍" % (t_rec * 1e3, t_rec / t_c))
    print("  Python 迭代    %10.1f us   → %s" % (t_iter * 1e6, rel))
    print("  注：C 的耗时里含约 1 us 的 ctypes 调用开销")


if __name__ == "__main__":
    main()
