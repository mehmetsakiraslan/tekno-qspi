	.file	"spi_demo.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.text.startup.main,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	li	a5,-1431654400
	li	a4,536936448
	addi	a5,a5,-1366
	sw	a5,8(a4)
	li	a5,33685504
	addi	a5,a5,415
	sw	a5,0(a4)
.L2:
	j	.L2
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
