.globl my_strlen
my_strlen:
    xor %rcx,%rcx  #rcx作为计数器,先清零
    
loop:
    movb (%rdi,%rcx,1),%al  #对应字符串的地址
    cmp $0,%al   
    je done  #到'\0'就跳出循环
    inc %rcx  #没跳出循环计数器+1
    jmp loop  #跳回去循环


done:
    movq %rcx,%rax   #返回值统一放rax中
    ret    #返回