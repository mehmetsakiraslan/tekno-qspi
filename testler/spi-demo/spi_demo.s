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
	li	a4,33685504
	li	a5,536936448
	addi	a4,a4,415
	sw	a4,0(a5)
	li	a3,536936448
	li	a5,999
.L2:
	sw	a4,0(a3)
	addi	a5,a5,-1
	bne	a5,zero,.L2
.L3:
	j	.L3
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
