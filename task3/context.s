.global set_ctx
.global jmp_to

set_ctx:
     mov %rbx,(%rdi)
     mov %rbp,8(%rdi)
     mov %r12,16(%rdi)
     mov %r13,24(%rdi)
     mov %r14,32(%rdi)
     mov %r15,40(%rdi)  #这些都在保存寄存器的状态，这些寄存器都是被调用者保存寄存器，可以理解保存上下文
     leaq 8(%rsp),%rdx   #调用函数会先把下一条指令的返回地址压栈，rsp会-8，因此加8得到旧的rsp
     mov %rdx,48(%rdi)  #保存上一个函数的rbp的指针（所处在的内存位置）
     mov (%rsp),%rdx   #rsp指向返回地址
     mov %rdx,56(%rdi) #返回地址保存
     xor %rax,%rax    #setjmp的第一次返回值是0
     ret

jmp_to:
    mov %rsi,%rax #把返回值写入rax
    test %rax,%rax
    jnz 1f  #检查rax是不是1，longjmp过去返回值不能是1,1f表示跳到第一个标签时1的地方（f是forward的缩写）
    inc %rax #若返回值是0自动加1
     
1:
    mov (%rdi),%rbx
    mov 8(%rdi),%rbp
    mov 16(%rdi),%r12
    mov 24(%rdi),%r13
    mov 32(%rdi),%r14
    mov 40(%rdi),%r15 #恢复上下文，即setjmp时的状态
    mov 48(%rdi),%rsp #把栈顶移到旧的函数
    mov 56(%rdi),%rdx 
    jmp *%rdx #函数跳到setjmp下一条指令，并且从rax中读取返回值，因此longjmp就成功设置的返回值