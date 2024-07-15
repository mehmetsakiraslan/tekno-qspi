	.file	"spi_demo.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.text.uart_txfull,"ax",@progbits
	.align	2
	.globl	uart_txfull
	.type	uart_txfull, @function
uart_txfull:
	li	a5,536870912
	lw	a0,4(a5)
	andi	a0,a0,1
	ret
	.size	uart_txfull, .-uart_txfull
	.section	.text.zputchar,"ax",@progbits
	.align	2
	.globl	zputchar
	.type	zputchar, @function
zputchar:
	li	a4,536870912
.L4:
	lw	a5,4(a4)
	andi	a5,a5,1
	bne	a5,zero,.L4
	sw	a0,12(a4)
	ret
	.size	zputchar, .-zputchar
	.section	.text.print,"ax",@progbits
	.align	2
	.globl	print
	.type	print, @function
print:
	lbu	a3,0(a0)
	beq	a3,zero,.L6
	li	a4,536870912
.L9:
	addi	a0,a0,1
.L8:
	lw	a5,4(a4)
	andi	a5,a5,1
	bne	a5,zero,.L8
	sw	a3,12(a4)
	lbu	a3,0(a0)
	bne	a3,zero,.L9
.L6:
	ret
	.size	print, .-print
	.section	.text.tekno_printf,"ax",@progbits
	.align	2
	.globl	tekno_printf
	.type	tekno_printf, @function
tekno_printf:
	addi	sp,sp,-64
	lbu	t1,0(a0)
	sw	a5,52(sp)
	addi	a5,sp,36
	sw	a1,36(sp)
	sw	a2,40(sp)
	sw	a3,44(sp)
	sw	a4,48(sp)
	sw	a6,56(sp)
	sw	a7,60(sp)
	sw	a5,8(sp)
	beq	t1,zero,.L15
	addi	a2,a0,1
	li	a3,0
	li	t3,0
	li	a5,0
	li	a1,37
	li	a4,536870912
	li	a7,10
	li	a6,72
	lla	a0,.L20
.L16:
	beq	a5,zero,.L17
	addi	t1,t1,-48
	andi	t1,t1,0xff
	bgtu	t1,a6,.L66
	slli	t1,t1,2
	add	t1,t1,a0
	lw	t1,0(t1)
	add	t1,t1,a0
	jr	t1
	.section	.rodata
	.align	2
	.align	2
.L20:
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L23-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L26-.L20
	.word	.L25-.L20
	.word	.L66-.L20
	.word	.L19-.L20
	.word	.L66-.L20
	.word	.L24-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L58-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L22-.L20
	.word	.L66-.L20
	.word	.L21-.L20
	.word	.L66-.L20
	.word	.L66-.L20
	.word	.L19-.L20
	.section	.text.tekno_printf
.L66:
	lw	a5,4(a4)
	andi	a5,a5,1
	bne	a5,zero,.L66
	sw	a1,12(a4)
	li	a3,0
	li	t3,0
.L23:
	lbu	t1,0(a2)
	addi	a2,a2,1
	bne	t1,zero,.L16
.L15:
	addi	sp,sp,64
	jr	ra
.L17:
	li	a5,1
	beq	t1,a1,.L23
.L54:
	lw	a5,4(a4)
	andi	a5,a5,1
	bne	a5,zero,.L54
	sw	t1,12(a4)
	bne	t1,a7,.L23
	li	t1,536870912
.L55:
	lw	a5,4(t1)
	andi	a5,a5,1
	bne	a5,zero,.L55
	li	t4,13
	sw	t4,12(t1)
	j	.L23
.L19:
	lw	a5,8(sp)
	addi	t4,a5,4
	beq	t3,zero,.L28
	lw	t0,0(a5)
	sw	t4,8(sp)
	li	t1,28
.L29:
	li	t6,9
	li	a3,536870912
	li	t5,-4
.L33:
	srl	a5,t0,t1
	andi	t4,a5,15
	addi	t3,t4,87
	bgtu	t4,t6,.L32
	addi	t3,t4,48
.L32:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L32
	sw	t3,12(a3)
	addi	t1,t1,-4
	bne	t1,t5,.L33
.L43:
	li	a3,0
	li	t3,0
	li	a5,0
	j	.L23
.L22:
	lw	a5,8(sp)
	lw	t1,0(a5)
	addi	a5,a5,4
	sw	a5,8(sp)
	lbu	t3,0(t1)
	beq	t3,zero,.L43
	li	a3,536870912
.L52:
	addi	t1,t1,1
.L51:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L51
	sw	t3,12(a3)
	lbu	t3,0(t1)
	bne	t3,zero,.L52
	li	a3,0
	li	t3,0
	li	a5,0
	j	.L23
.L21:
	lw	a5,8(sp)
	addi	a3,a5,4
	lw	a5,0(a5)
	sw	a3,8(sp)
	li	a3,10
	mv	t4,a5
	div	a5,a5,a3
	beq	a5,zero,.L61
	li	a3,1
	li	t3,10
.L47:
	div	a5,a5,t3
	mv	t1,a3
	addi	a3,a3,1
	bne	a5,zero,.L47
.L46:
	li	t5,10
	li	a3,536870912
	li	t6,-1
.L49:
	remu	t3,t4,t5
	addi	t3,t3,48
.L48:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L48
	sw	t3,12(a3)
	addi	t1,t1,-1
	divu	t4,t4,t5
	bne	t1,t6,.L49
	li	a3,0
	li	t3,0
	li	a5,0
	j	.L23
.L25:
	lw	a5,8(sp)
	lw	t3,0(a5)
	addi	a3,a5,4
	sw	a3,8(sp)
	blt	t3,zero,.L86
.L36:
	li	a3,10
	div	a3,t3,a3
	beq	a3,zero,.L60
	li	t4,1
	li	t1,10
.L39:
	div	a3,a3,t1
	mv	a5,t4
	addi	t4,t4,1
	bne	a3,zero,.L39
.L38:
	addi	t5,sp,12
	add	a5,t5,a5
	mv	t1,t5
	li	t6,10
.L40:
	rem	a3,t3,t6
	mv	t0,a5
	addi	a5,a5,-1
	addi	a3,a3,48
	sb	a3,1(a5)
	div	t3,t3,t6
	bne	t5,t0,.L40
	add	t5,t5,t4
	li	a3,536870912
.L42:
	lbu	t3,0(t1)
.L41:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L41
	sw	t3,12(a3)
	addi	t1,t1,1
	bne	t5,t1,.L42
	li	a3,0
	li	t3,0
	li	a5,0
	j	.L23
.L26:
	lw	a5,8(sp)
	li	a3,536870912
	lw	t1,0(a5)
	addi	a5,a5,4
	sw	a5,8(sp)
.L53:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L53
	andi	t1,t1,255
	sw	t1,12(a3)
	li	t3,0
	li	a3,0
	j	.L23
.L28:
	snez	t1,a3
	neg	t1,t1
	andi	t1,t1,-24
	lw	t0,0(a5)
	sw	t4,8(sp)
	addi	t1,t1,28
	j	.L29
.L58:
	mv	t3,a5
	li	a3,0
	j	.L23
.L24:
	mv	a3,a5
	li	t3,0
	li	a5,0
	j	.L23
.L86:
	neg	t3,t3
	li	a3,536870912
.L37:
	lw	a5,4(a3)
	andi	a5,a5,1
	bne	a5,zero,.L37
	li	a5,45
	sw	a5,12(a3)
	j	.L36
.L61:
	li	t1,0
	j	.L46
.L60:
	li	a5,0
	li	t4,1
	j	.L38
	.size	tekno_printf, .-tekno_printf
	.section	.text.uart_rxempty,"ax",@progbits
	.align	2
	.globl	uart_rxempty
	.type	uart_rxempty, @function
uart_rxempty:
	li	a5,536870912
	lw	a0,4(a5)
	srli	a0,a0,3
	andi	a0,a0,1
	ret
	.size	uart_rxempty, .-uart_rxempty
	.section	.text.zgetchar,"ax",@progbits
	.align	2
	.globl	zgetchar
	.type	zgetchar, @function
zgetchar:
	li	a4,536870912
.L89:
	lw	a5,4(a4)
	srli	a5,a5,3
	andi	a5,a5,1
	bne	a5,zero,.L89
	lw	a0,8(a4)
	andi	a0,a0,0xff
	ret
	.size	zgetchar, .-zgetchar
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"\b \b"
	.section	.text.zscan,"ax",@progbits
	.align	2
	.globl	zscan
	.type	zscan, @function
zscan:
	mv	t1,a0
	li	a4,536870912
	li	a0,0
	li	a7,8
	li	t3,13
	li	t4,94
	addi	t5,a1,-1
.L93:
	lw	a5,4(a4)
	srli	a5,a5,3
	andi	a5,a5,1
	bne	a5,zero,.L93
	lw	a1,8(a4)
	andi	a3,a1,0xff
	beq	a3,a7,.L117
	beq	a3,t3,.L99
	addi	a5,a3,-32
	andi	a5,a5,0xff
	bgtu	a5,t4,.L93
	ble	t5,a0,.L93
	bne	a2,zero,.L118
.L100:
	sb	a3,0(t1)
	addi	a0,a0,1
	addi	t1,t1,1
	j	.L93
.L117:
	beq	a0,zero,.L93
	bne	a2,zero,.L119
.L96:
	addi	t1,t1,-1
	addi	a0,a0,-1
	j	.L93
.L99:
	sb	zero,0(t1)
	li	a4,536870912
.L102:
	lw	a5,4(a4)
	andi	a5,a5,1
	bne	a5,zero,.L102
	li	a5,10
	sw	a5,12(a4)
	ret
.L119:
	lla	a6,.LC0
	li	a1,536870912
.L98:
	addi	a6,a6,1
.L97:
	lw	a5,4(a1)
	andi	a5,a5,1
	bne	a5,zero,.L97
	sw	a3,12(a1)
	lbu	a3,0(a6)
	bne	a3,zero,.L98
	j	.L96
.L118:
	li	a6,536870912
.L101:
	lw	a5,4(a6)
	andi	a5,a5,1
	bne	a5,zero,.L101
	andi	a1,a1,255
	sw	a1,12(a6)
	j	.L100
	.size	zscan, .-zscan
	.section	.text.strcmp,"ax",@progbits
	.align	2
	.globl	strcmp
	.type	strcmp, @function
strcmp:
.L123:
	lbu	a5,0(a0)
	addi	a1,a1,1
	addi	a0,a0,1
	lbu	a4,-1(a1)
	beq	a5,zero,.L125
	beq	a5,a4,.L123
	sub	a0,a5,a4
	ret
.L125:
	neg	a0,a4
	ret
	.size	strcmp, .-strcmp
	.section	.text.strlen,"ax",@progbits
	.align	2
	.globl	strlen
	.type	strlen, @function
strlen:
	lbu	a5,0(a0)
	beq	a5,zero,.L129
	mv	a5,a0
.L128:
	lbu	a4,1(a5)
	addi	a5,a5,1
	bne	a4,zero,.L128
	sub	a0,a5,a0
	ret
.L129:
	li	a0,0
	ret
	.size	strlen, .-strlen
	.section	.text.startup.main,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	li	a3,536936448
	li	a4,33816576
	li	a1,-1431654400
	addi	a4,a4,259
	li	a5,0
	li	a7,160
	addi	a6,a3,28
	addi	a1,a1,-1366
	li	a0,1000
	j	.L134
.L148:
	sw	a7,4(a3)
	sw	a1,0(a6)
	sw	a4,0(a3)
	lw	a2,8(a3)
	addi	a5,a5,1
	beq	a5,a0,.L147
.L134:
	andi	a2,a5,1
	beq	a2,zero,.L148
	sw	zero,4(a3)
	sw	a1,0(a6)
	sw	a4,0(a3)
	lw	a2,8(a3)
	addi	a5,a5,1
	bne	a5,a0,.L134
.L147:
	li	a5,33554432
	addi	a5,a5,262
	li	a4,33619968
	sw	a5,0(a3)
	addi	a4,a4,261
	sw	a4,0(a3)
	li	a5,99
	li	a3,536936448
.L135:
	sw	a4,0(a3)
	addi	a5,a5,-1
	bne	a5,zero,.L135
	li	a5,447393792
	addi	a5,a5,-1373
	sw	a5,8(a3)
	li	a5,-1140850688
	addi	a5,a5,-1
	sw	a5,12(a3)
	li	a5,-559038464
	addi	a5,a5,-273
	sw	a5,16(a3)
	li	a5,-57344
	addi	a5,a5,-1
	sw	a5,20(a3)
	li	a5,984264704
	addi	a5,a5,-1366
	sw	a5,24(a3)
	li	a5,1610612736
	addi	a5,a5,-9
	sw	a5,28(a3)
	li	a5,1252700160
	addi	a5,a5,-1370
	sw	a5,32(a3)
	li	a5,618831872
	addi	a5,a5,1621
	sw	a5,36(a3)
	li	a5,176
	sw	a5,4(a3)
	li	a5,33816576
	addi	a5,a5,1282
	li	a4,33619968
	sw	a5,0(a3)
	addi	a4,a4,261
	sw	a4,0(a3)
	lw	a5,8(a3)
	beq	a5,zero,.L136
	li	a5,536936448
.L137:
	sw	a4,0(a5)
	lw	a3,8(a5)
	bne	a3,zero,.L137
.L136:
	li	a4,33619968
	li	a5,536936448
	addi	a4,a4,261
	sw	a4,0(a5)
	li	a3,536936448
	li	a5,99
.L138:
	sw	a4,0(a3)
	addi	a5,a5,-1
	bne	a5,zero,.L138
	li	a4,33816576
	li	a5,208
	addi	a4,a4,259
	sw	a5,4(a3)
	sw	a4,0(a3)
.L139:
	j	.L139
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
