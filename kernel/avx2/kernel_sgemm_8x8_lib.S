/**************************************************************************************************
*                                                                                                 *
* This file is part of BLASFEO.                                                                   *
*                                                                                                 *
* BLASFEO -- BLAS For Embedded Optimization.                                                      *
* Copyright (C) 2019 by Gianluca Frison.                                                          *
* Developed at IMTEK (University of Freiburg) under the supervision of Moritz Diehl.              *
* All rights reserved.                                                                            *
*                                                                                                 *
* The 2-Clause BSD License                                                                        *
*                                                                                                 *
* Redistribution and use in source and binary forms, with or without                              *
* modification, are permitted provided that the following conditions are met:                     *
*                                                                                                 *
* 1. Redistributions of source code must retain the above copyright notice, this                  *
*    list of conditions and the following disclaimer.                                             *
* 2. Redistributions in binary form must reproduce the above copyright notice,                    *
*    this list of conditions and the following disclaimer in the documentation                    *
*    and/or other materials provided with the distribution.                                       *
*                                                                                                 *
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND                 *
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED                   *
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE                          *
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR                 *
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES                  *
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;                    *
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                     *
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT                      *
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS                   *
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                    *
*                                                                                                 *
* Author: Gianluca Frison, gianluca.frison (at) imtek.uni-freiburg.de                             *
*                                                                                                 *
**************************************************************************************************/





// common inner routine with file scope
//
// strsm
// right
// lower
// transposed
// not-unit
//
// input arguments:
// r10  <- D
// r11  <- ldd
// r12  <- inv_diag_D
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm12 <- dirty
// ymm13 <- dirty
// ymm14 <- dirty
// ymm15 <- dirty
//
// output arguments:
// r10  <- D
// r11  <- ldd
// r12  <- inv_diag_D
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm12 <- dirty
// ymm13 <- dirty
// ymm14 <- dirty
// ymm15 <- dirty

#if MACRO_LEVEL>=1
	.macro INNER_EDGE_TRSM_RLT_INV_8X8_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_edge_trsm_rlt_inv_8x8_libc)
#endif

	leaq	(%r11, %r11, 2), %r14
	leaq	(%r11, %r11, 4), %r15

	vbroadcastss	0(%r12), %ymm13
	vmulps			%ymm0, %ymm13, %ymm0
	vbroadcastss	4(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm1
	vbroadcastss	8(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm2
	vbroadcastss	12(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm3
	vbroadcastss	16(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm4
	vbroadcastss	20(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm5
	vbroadcastss	24(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm6
	vbroadcastss	28(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm7

	vbroadcastss	4(%r12), %ymm13
	vmulps			%ymm1, %ymm13, %ymm1
	vbroadcastss	8(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm2
	vbroadcastss	12(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm3
	vbroadcastss	16(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm4
	vbroadcastss	20(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm5
	vbroadcastss	24(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm7

	vbroadcastss	8(%r12), %ymm13
	vmulps			%ymm2, %ymm13, %ymm2
	vbroadcastss	12(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm3
	vbroadcastss	16(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm4
	vbroadcastss	20(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm5
	vbroadcastss	24(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm7

	vbroadcastss	12(%r12), %ymm13
	vmulps			%ymm3, %ymm13, %ymm3
	vbroadcastss	16(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm4
	vbroadcastss	20(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm5
	vbroadcastss	24(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm7

	vbroadcastss	16(%r12), %ymm13
	vmulps			%ymm4, %ymm13, %ymm4
	vbroadcastss	20(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm5
	vbroadcastss	24(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm7

	vbroadcastss	20(%r12), %ymm13
	vmulps			%ymm5, %ymm13, %ymm5
	vbroadcastss	24(%r10, %r15), %ymm13
	vfnmadd231ps	%ymm5, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r15), %ymm13
	vfnmadd231ps	%ymm5, %ymm13, %ymm7

	vbroadcastss	24(%r12), %ymm13
	vmulps			%ymm6, %ymm13, %ymm6
	vbroadcastss	28(%r10, %r14, 2), %ymm13
	vfnmadd231ps	%ymm6, %ymm13, %ymm7

	vbroadcastss	28(%r12), %ymm13
	vmulps			%ymm7, %ymm13, %ymm7

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_edge_trsm_rlt_inv_8x8_libc)
#endif





// common inner routine with file scope
//
// strsm
// right
// lower
// transposed
// not-unit
//
// input arguments:
// r10  <- D
// r11  <- ldd
// r12  <- inv_diag_D
// r13  <- n1
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm12 <- dirty
// ymm13 <- dirty
// ymm14 <- dirty
// ymm15 <- dirty
//
// output arguments:
// r10  <- D
// r11  <- ldd
// r12  <- inv_diag_D
// r13  <- n1
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm12 <- dirty
// ymm13 <- dirty
// ymm14 <- dirty
// ymm15 <- dirty

#if MACRO_LEVEL>=1
	.macro INNER_EDGE_TRSM_RLT_INV_8X8_VS_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_edge_trsm_rlt_inv_8x8_vs_libc)
#endif

	leaq	(%r11, %r11, 2), %r14
	leaq	(%r11, %r11, 4), %r15

	vbroadcastss	0(%r12), %ymm13
	vmulps			%ymm0, %ymm13, %ymm0

	cmpl			$2, %r13d
	jl				0f // ret

	vbroadcastss	4(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm1
	vbroadcastss	4(%r12), %ymm13
	vmulps			%ymm1, %ymm13, %ymm1

	cmpl			$3, %r13d
	jl				0f // ret

	vbroadcastss	8(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm2
	vbroadcastss	8(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm2
	vbroadcastss	8(%r12), %ymm13
	vmulps			%ymm2, %ymm13, %ymm2

	cmpl			$4, %r13d
	jl				0f // ret

	vbroadcastss	12(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm3
	vbroadcastss	12(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm3
	vbroadcastss	12(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm3
	vbroadcastss	12(%r12), %ymm13
	vmulps			%ymm3, %ymm13, %ymm3

	cmpl			$5, %r13d
	jl				0f // ret

	vbroadcastss	16(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm4
	vbroadcastss	16(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm4
	vbroadcastss	16(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm4
	vbroadcastss	16(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm4
	vbroadcastss	16(%r12), %ymm13
	vmulps			%ymm4, %ymm13, %ymm4

	cmpl			$6, %r13d
	jl				0f // ret

	vbroadcastss	20(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm5
	vbroadcastss	20(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm5
	vbroadcastss	20(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm5
	vbroadcastss	20(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm5
	vbroadcastss	20(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm5
	vbroadcastss	20(%r12), %ymm13
	vmulps			%ymm5, %ymm13, %ymm5

	cmpl			$7, %r13d
	jl				0f // ret

	vbroadcastss	24(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm6
	vbroadcastss	24(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm6
	vbroadcastss	24(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm6
	vbroadcastss	24(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm6
	vbroadcastss	24(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm6
	vbroadcastss	24(%r10, %r15), %ymm13
	vfnmadd231ps	%ymm5, %ymm13, %ymm6
	vbroadcastss	24(%r12), %ymm13
	vmulps			%ymm6, %ymm13, %ymm6

	cmpl			$8, %r13d
	jl				0f // ret

	vbroadcastss	28(%r10), %ymm13
	vfnmadd231ps	%ymm0, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r11), %ymm13
	vfnmadd231ps	%ymm1, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r11, 2), %ymm13
	vfnmadd231ps	%ymm2, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r14), %ymm13
	vfnmadd231ps	%ymm3, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r11, 4), %ymm13
	vfnmadd231ps	%ymm4, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r15), %ymm13
	vfnmadd231ps	%ymm5, %ymm13, %ymm7
	vbroadcastss	28(%r10, %r14, 2), %ymm13
	vfnmadd231ps	%ymm6, %ymm13, %ymm7
	vbroadcastss	28(%r12), %ymm13
	vmulps			%ymm7, %ymm13, %ymm7

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_edge_trsm_rlt_inv_8x8_vs_libc)
#endif





// common inner routine with file scope
//
// scale for generic alpha and beta
//
// input arguments:
// r10   <- alpha
// r11   <- beta
// r12   <- C
// r13   <- ldc
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm8  <- dirty
// ymm9  <- dirty
// ymm10 <- dirty
// ymm11 <- dirty
// ymm15 <- dirty
//
// output arguments:
// r10   <- alpha
// r11   <- beta
// r12   <- C
// r13   <- ldc
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm8  <- dirty
// ymm9  <- dirty
// ymm10 <- dirty
// ymm11 <- dirty
// ymm15 <- dirty

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_AB_8X8_LIBC
#else
	FUN_START(inner_scale_ab_8x8_libc)
#endif
	
	// alpha
	vbroadcastss	0(%r10), %ymm15

	vmulps		%ymm0, %ymm15, %ymm0
	vmulps		%ymm1, %ymm15, %ymm1
	vmulps		%ymm2, %ymm15, %ymm2
	vmulps		%ymm3, %ymm15, %ymm3
	vmulps		%ymm4, %ymm15, %ymm4
	vmulps		%ymm5, %ymm15, %ymm5
	vmulps		%ymm6, %ymm15, %ymm6
	vmulps		%ymm7, %ymm15, %ymm7

	// beta
	vbroadcastss	0(%r11), %ymm14

	vxorps		%ymm15, %ymm15, %ymm15 // 0.0

	vucomiss	%xmm15, %xmm14 // beta==0.0 ?
	je			0f // end

	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm0
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm1
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm2
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm3
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm4
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm5
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm6
	addq		%r13, %r12
	vmovups		0(%r12), %ymm15
	vfmadd231ps	%ymm15, %ymm14, %ymm7
//	addq		%r13, %r12

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_ab_8x8_libc)
#endif





// common inner routine with file scope
//
// blend for generic alpha=1.0 and beta=1.0
//
// input arguments:
// r10   <- C
// r11   <- ldc
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm8  <- dirty
// ymm15 <- dirty
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_11_8X8_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_scale_11_8x8_libc)
#endif
	
	vmovups		0(%r10), %ymm15
	vaddps		%ymm0, %ymm15, %ymm0
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm1, %ymm15, %ymm1
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm2, %ymm15, %ymm2
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm3, %ymm15, %ymm3
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm4, %ymm15, %ymm4
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm5, %ymm15, %ymm5
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm6, %ymm15, %ymm6
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vaddps		%ymm7, %ymm15, %ymm7
//	addq		%r11, %r10

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_11_8x8_libc)
#endif





// common inner routine with file scope
//
// blend for generic alpha=1.0 and beta=1.0
//
// input arguments:
// r10   <- C
// r11   <- ldc
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm8  <- dirty
// ymm15 <- dirty
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_M11_8X8_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_scale_m11_8x8_libc)
#endif
	
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovaps		.LC03(%rip), %ymm14 // beta=1.0
#else
	vmovaps		LC03(%rip), %ymm14 // beta=1.0
#endif

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm0
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm1
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm2
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm3
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm4
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm5
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm6
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm7
//	addq		%r11, %r10

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_m11_8x8_libc)
#endif





// common inner routine with file scope
//
// scale for generic alpha and beta
//
// input arguments:
// r10   <- alpha
// r11   <- beta
// r12   <- C
// r13   <- ldc
// r14d   <- km
// r15d   <- kn
// ymm0 <- [d00 d11 d22 d33]
// ymm1 <- [d01 d10 d23 d32]
// ymm2 <- [d03 d12 d21 d30]
// ymm3 <- [d02 d13 d20 d31]
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_AB_8X8_VS_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_scale_ab_8x8_vs_libc)
#endif

	// alpha
	vbroadcastss	0(%r10), %ymm15

	vmulps		%ymm0, %ymm15, %ymm0
	vmulps		%ymm1, %ymm15, %ymm1
	vmulps		%ymm2, %ymm15, %ymm2
	vmulps		%ymm3, %ymm15, %ymm3
	vmulps		%ymm4, %ymm15, %ymm4
	vmulps		%ymm5, %ymm15, %ymm5
	vmulps		%ymm6, %ymm15, %ymm6
	vmulps		%ymm7, %ymm15, %ymm7

	// beta
	vbroadcastss	0(%r11), %ymm14

	vxorps		%ymm15, %ymm15, %ymm15 // 0.0
	vucomiss	%xmm15, %xmm14 // beta==0.0 ?
	je			0f // end


	vcvtsi2ss	%r14d, %xmm15, %xmm15
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovups		.LC00(%rip), %ymm13
#elif defined(OS_MAC)
	vmovups		LC00(%rip), %ymm13
#endif
	vshufps		$0x00, %xmm15, %xmm15, %xmm15
	vinsertf128	$0x1, %xmm15, %ymm15, %ymm15
	vsubps		%ymm15, %ymm13, %ymm13


	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm0
	addq		%r13, %r12
	cmpl		$2, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm1
	addq		%r13, %r12
	cmpl		$3, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm2
	addq		%r13, %r12
	cmpl		$4, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm3
	addq		%r13, %r12
	cmpl		$5, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm4
	addq		%r13, %r12
	cmpl		$6, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm5
	addq		%r13, %r12
	cmpl		$7, %r15d
	jl			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm6
	addq		%r13, %r12
	cmpl		$7, %r15d
	je			0f // end
	vmaskmovps	0(%r12), %ymm13, %ymm15
	vfmadd231ps	%ymm14, %ymm15, %ymm7
//	addq		%r13, %r12

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_ab_8x8_vs_libc)
#endif





// common inner routine with file scope
//
// blend for generic alpha=1.0 and beta=1.0
//
// input arguments:
// r10   <- C
// r11   <- ldc
// r12   <- m1
// r13   <- n1
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm8  <- dirty
// ymm15 <- dirty
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_11_8X8_VS_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_scale_11_8x8_vs_libc)
#endif
	
	vcvtsi2ss	%r12d, %xmm15, %xmm15
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovups		.LC00(%rip), %ymm13
#elif defined(OS_MAC)
	vmovups		LC00(%rip), %ymm13
#endif
	vshufps		$0x00, %xmm15, %xmm15, %xmm15
	vinsertf128	$0x1, %xmm15, %ymm15, %ymm15
	vsubps		%ymm15, %ymm13, %ymm13


	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm0, %ymm15, %ymm0
	addq		%r11, %r10

	cmpl		$2, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm1, %ymm15, %ymm1
	addq		%r11, %r10

	cmpl		$3, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm2, %ymm15, %ymm2
	addq		%r11, %r10

	cmpl		$4, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm3, %ymm15, %ymm3
	addq		%r11, %r10

	cmpl		$5, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm4, %ymm15, %ymm4
	addq		%r11, %r10

	cmpl		$6, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm5, %ymm15, %ymm5
	addq		%r11, %r10

	cmpl		$7, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm6, %ymm15, %ymm6
	addq		%r11, %r10

	cmpl		$7, %r15d
	je			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vaddps		%ymm7, %ymm15, %ymm7
//	addq		%r11, %r10

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_11_8x8_vs_libc)
#endif





// common inner routine with file scope
//
// blend for generic alpha=1.0 and beta=1.0
//
// input arguments:
// r10   <- C
// r11   <- ldc
// r12   <- m1
// r13   <- n1
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
// ymm4 <- []
// ymm5 <- []
// ymm6 <- []
// ymm7 <- []
// ymm8  <- dirty
// ymm15 <- dirty
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_SCALE_M11_8X8_VS_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_scale_m11_8x8_vs_libc)
#endif
	
	vcvtsi2ss	%r12d, %xmm15, %xmm15
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovups		.LC00(%rip), %ymm13
#elif defined(OS_MAC)
	vmovups		LC00(%rip), %ymm13
#endif
	vshufps		$0x00, %xmm15, %xmm15, %xmm15
	vinsertf128	$0x1, %xmm15, %ymm15, %ymm15
	vsubps		%ymm15, %ymm13, %ymm13


#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovaps		.LC03(%rip), %ymm14 // beta=1.0
#else
	vmovaps		LC03(%rip), %ymm14 // beta=1.0
#endif


	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm0
	addq		%r11, %r10

	cmpl		$2, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm1
	addq		%r11, %r10

	cmpl		$3, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm2
	addq		%r11, %r10

	cmpl		$4, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm3
	addq		%r11, %r10

	cmpl		$5, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm4
	addq		%r11, %r10

	cmpl		$6, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm5
	addq		%r11, %r10

	cmpl		$7, %r15d
	jl			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm6
	addq		%r11, %r10

	cmpl		$7, %r15d
	je			0f // end
	vmaskmovps	0(%r10), %ymm13, %ymm15
	vfmsub231ps	%ymm14, %ymm15, %ymm7
//	addq		%r11, %r10

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_scale_m11_8x8_vs_libc)
#endif





// common inner routine with file scope
//
// store n
//
// input arguments:
// r10  <- D
// r11  <- ldd
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_STORE_8X8_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_store_8x8_libc)
#endif

	vmovups		%ymm0, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm1, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm2, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm3, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm4, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm5, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm6, 0(%r10)
	addq		%r11, %r10
	vmovups		%ymm7, 0(%r10)
//	addq	%r11, %r10

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_store_8x8_libc)
#endif





// common inner routine with file scope
//
// store n
//
// input arguments:
// r10  <- D
// r11  <- ldd
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_STORE_L_8X8_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_store_l_8x8_libc)
#endif

	vmovups		%ymm0, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x01, %ymm15, %ymm1, %ymm1
	vmovups		%ymm1, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x03, %ymm15, %ymm2, %ymm2
	vmovups		%ymm2, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x07, %ymm15, %ymm3, %ymm3
	vmovups		%ymm3, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x0f, %ymm15, %ymm4, %ymm4
	vmovups		%ymm4, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x1f, %ymm15, %ymm5, %ymm5
	vmovups		%ymm5, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x3f, %ymm15, %ymm6, %ymm6
	vmovups		%ymm6, 0(%r10)
	addq		%r11, %r10

	vmovups		0(%r10), %ymm15
	vblendps	$0x7f, %ymm15, %ymm7, %ymm7
	vmovups		%ymm7, 0(%r10)
//	addq	%r11, %r10

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_store_l_8x8_libc)
#endif





// common inner routine with file scope
//
// store n vs
//
// input arguments:
// r10  <- D
// r11  <- ldd
// r12  <- km
// r13  <- kn
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
//
// output arguments:
// r10  <- D
// r11  <- ldd
// r12  <- km
// r13  <- kn
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []

#if MACRO_LEVEL>=1
	.macro INNER_STORE_8X8_VS_LIBC
#else
	FUN_START(inner_store_8x8_vs_libc)
#endif
	
	// compute mask for rows
	vcvtsi2ss	%r12d, %xmm14, %xmm14
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovups		.LC00(%rip), %ymm12
#elif defined(OS_MAC)
	vmovups		LC00(%rip), %ymm12
#endif
	vshufps		$0x00, %xmm14, %xmm14, %xmm14
	vinsertf128	$0x1, %xmm14, %ymm14, %ymm14
	vsubps		%ymm14, %ymm12, %ymm14

	// offset==0
	vmaskmovps	%ymm0, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$2, %r13d
	jl			0f // end
	vmaskmovps	%ymm1, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$3, %r13d
	jl			0f // end
	vmaskmovps	%ymm2, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$4, %r13d
	jl			0f // end
	vmaskmovps	%ymm3, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$5, %r13d
	jl			0f // end
	vmaskmovps	%ymm4, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$6, %r13d
	jl			0f // end
	vmaskmovps	%ymm5, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$7, %r13d
	jl			0f // end
	vmaskmovps	%ymm6, %ymm14, 0(%r10)
	addq		%r11, %r10
	cmpl		$7, %r13d
	je			0f // end
	vmaskmovps	%ymm7, %ymm14, 0(%r10)
//	addq		%r11, %r10

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_store_8x8_vs_libc)
#endif





// common inner routine with file scope
//
// store n
//
// input arguments:
// r10  <- D
// r11  <- ldd
// r12  <- km
// r13  <- kn
// ymm0 <- []
// ymm1 <- []
// ymm2 <- []
// ymm3 <- []
//
// output arguments:

#if MACRO_LEVEL>=1
	.macro INNER_STORE_L_8X8_VS_LIBC
#else
	.p2align 4,,15
	FUN_START(inner_store_l_8x8_vs_libc)
#endif

	// compute mask for rows
	vcvtsi2ss	%r12d, %xmm14, %xmm14
#if defined(OS_LINUX) | defined(OS_WINDOWS)
	vmovups		.LC00(%rip), %ymm12
#elif defined(OS_MAC)
	vmovups		LC00(%rip), %ymm12
#endif
	vshufps		$0x00, %xmm14, %xmm14, %xmm14
	vinsertf128	$0x1, %xmm14, %ymm14, %ymm14
	vsubps		%ymm14, %ymm12, %ymm14

	// offset==0
	vmaskmovps	%ymm0, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$2, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x01, %ymm15, %ymm1, %ymm1
	vmaskmovps	%ymm1, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$3, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x03, %ymm15, %ymm2, %ymm2
	vmaskmovps	%ymm2, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$4, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x07, %ymm15, %ymm3, %ymm3
	vmaskmovps	%ymm3, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$5, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x0f, %ymm15, %ymm4, %ymm4
	vmaskmovps	%ymm4, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$6, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x1f, %ymm15, %ymm5, %ymm5
	vmaskmovps	%ymm5, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$7, %r13d
	jl			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x3f, %ymm15, %ymm6, %ymm6
	vmaskmovps	%ymm6, %ymm14, 0(%r10)
	addq		%r11, %r10

	cmpl		$7, %r13d
	je			0f // end
	vmovups		0(%r10), %ymm15
	vblendps	$0x7f, %ymm15, %ymm7, %ymm7
	vmaskmovps	%ymm7, %ymm14, 0(%r10)
//	addq		%r11, %r10

0:

#if MACRO_LEVEL>=1
	.endm
#else
	ret

	FUN_END(inner_store_l_8x8_vs_libc)
#endif





//                                  1      2             3         4         5            6         7        8         9
// void kernel_sgemm_nt_8x8_lib88cc(int k, float *alpha, float *A, float *B, float *beta, float *C, int ldc, float *D, int ldd);

	GLOB_FUN_START(kernel_sgemm_nt_8x8_lib88cc)
	
	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner dgemm kernel nt

	movq	ARG1, %r10 // k
	movq	ARG3, %r11  // A
	movq	ARG4, %r12  // B

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner scale

	movq	ARG2, %r10 // alpha
	movq	ARG5, %r11 // beta
	movq	ARG6, %r12   // C
	movq	ARG7, %r13   // ldc
	sall	$2, %r13d

#if MACRO_LEVEL>=1
	INNER_SCALE_AB_8X8_LIBC
#else
	CALL(inner_scale_ab_8x8_libc)
#endif


	// store n

	movq	ARG8, %r10 // D
	movq	ARG9, %r11 // ldd
	sall	$2, %r11d

#if MACRO_LEVEL>=1
	INNER_STORE_8X8_LIBC
#else
	CALL(inner_store_8x8_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_sgemm_nt_8x8_lib88cc)





//                                    1      2              3          4          5             6          7        8          9        10      11
// void kernel_sgemm_nt_8x8_vs_lib88cc(int k, float *alpha, float *A, float *B, float *beta, float *C, int ldc, float *D, int ldd, int m1, int n1);

	.p2align 4,,15
	GLOB_FUN_START(kernel_sgemm_nt_8x8_vs_lib88cc)

	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner sgemm kernel nn

	movq	ARG1, %r10 // k
	movq	ARG3, %r11  // A
	movq	ARG4, %r12  // B

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner blend

	movq	ARG2, %r10 // alpha
	movq	ARG5, %r11 // beta
	movq	ARG6, %r12   // C
	movq	ARG7, %r13   // ldc
	sall	$2, %r13d
	movq	ARG10, %r14 // m1
	movq	ARG11, %r15 // n1

#if MACRO_LEVEL>=1
	INNER_SCALE_AB_8X8_VS_LIBC
#else
	CALL(inner_scale_ab_8x8_vs_libc)
#endif


	// store n

	movq	ARG8, %r10 // D
	movq	ARG9, %r11 // ldd
	sall	$2, %r11d
	movq	ARG10, %r12 // m1
	movq	ARG11, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_STORE_8X8_VS_LIBC
#else
	CALL(inner_store_8x8_vs_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_sgemm_nt_8x8_vs_lib88cc)





//                                     1      2         3         4         5        6         7        8
// void kernel_spotrf_nt_l_8x8_lib88cc(int k, float *A, float *B, float *C, int ldc, float *D, int ldd, float *inv_diag_D);

	.p2align 4,,15
	GLOB_FUN_START(kernel_spotrf_nt_l_8x8_lib88cc)
	
	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner dgemm kernel nt

	movq	ARG1, %r10
	movq	ARG2, %r11
	movq	ARG3, %r12

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner blender_loader nn

	movq	ARG4, %r10 // C
	movq	ARG5, %r11 // ldc
	sall	$2, %r11d // ldc*sizeof(float)

#if MACRO_LEVEL>=1
	INNER_SCALE_M11_8X8_LIBC
#else
	CALL(inner_scale_m11_8x8_libc)
#endif


	// factorization

	movq	ARG8, %r10  // inv_diag_D 
	movl	$8, %r11d // n1

#if MACRO_LEVEL>=1
	INNER_EDGE_POTRF_8X8_VS_LIB8
#else
	CALL(inner_edge_potrf_8x8_vs_lib8)
#endif


	// store

	movq	ARG6, %r10 // D
	movq	ARG7, %r11 // ldd
	sall	$2, %r11d // ldd*sizeof(float)

#if MACRO_LEVEL>=1
	INNER_STORE_L_8X8_LIBC
#else
	CALL(inner_store_l_8x8_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_spotrf_nt_l_8x8_lib88cc)





//                                        1      2         3         4         5        6         7        8                  9       10
// void kernel_spotrf_nt_l_8x8_vs_lib88cc(int k, float *A, float *B, float *C, int ldc, float *D, int ldd, float *inv_diag_D, int m1, int n1);

	.p2align 4,,15
	GLOB_FUN_START(kernel_spotrf_nt_l_8x8_vs_lib88cc)
	
	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner dgemm kernel nt

	movq	ARG1, %r10
	movq	ARG2, %r11
	movq	ARG3, %r12

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner blender_loader nn

	movq	ARG4, %r10 // C
	movq	ARG5, %r11 // ldc
	sall	$2, %r11d // ldc*sizeof(float)
	movq	ARG9, %r12 // m1
	movq	ARG10, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_SCALE_M11_8X8_VS_LIBC
#else
	CALL(inner_scale_m11_8x8_vs_libc)
#endif


	// factorization

	movq	ARG8, %r10  // inv_diag_D 
	movq	ARG10, %r11 // n1

#if MACRO_LEVEL>=1
	INNER_EDGE_POTRF_8X8_VS_LIB8
#else
	CALL(inner_edge_potrf_8x8_vs_lib8)
#endif


	// store

	movq	ARG6, %r10 // D
	movq	ARG7, %r11 // ldd
	sall	$2, %r11d // ldd*sizeof(float)
	movq	ARG9, %r12 // m1
	movq	ARG10, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_STORE_L_8X8_VS_LIBC
#else
	CALL(inner_store_l_8x8_vs_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_spotrf_nt_l_8x8_vs_lib88cc)





//                                          1      2         3         4         5        6         7        8         9        10
// void kernel_strsm_nt_rl_inv_8x8_lib88ccc(int k, float *A, float *B, float *C, int ldc, float *D, int ldd, float *E, int lde, float *inv_diag_E);

	.p2align 4,,15
	GLOB_FUN_START(kernel_strsm_nt_rl_inv_8x8_lib88ccc)
	
	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner dgemm kernel nt 

	movq	ARG1, %r10
	movq	ARG2, %r11
	movq	ARG3, %r12

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner blender_loader nn

	movq	ARG4, %r10
	movq	ARG5, %r11 // ldc
	sall	$2, %r11d // ldc*sizeof(float)

#if MACRO_LEVEL>=1
	INNER_SCALE_M11_8X8_LIBC
#else
	CALL(inner_scale_m11_8x8_libc)
#endif


	// solve

	movq	ARG8, %r10  // E 
	movq	ARG9, %r11 // lde
	sall	$2, %r11d // lde*sizeof(float)
	movq	ARG10, %r12  // inv_diag_E 
//	movq	$8, %r13 // n1

#if MACRO_LEVEL>=1
//	INNER_EDGE_TRSM_RLT_INV_8X8_VS_LIBC
	INNER_EDGE_TRSM_RLT_INV_8X8_LIBC
#else
//	CALL(inner_edge_trsm_rlt_inv_8x8_vs_libc)
	CALL(inner_edge_trsm_rlt_inv_8x8_libc)
#endif


	// store

	movq	ARG6, %r10 // D
	movq	ARG7, %r11 // ldd
	sall	$2, %r11d // ldd*sizeof(float)

#if MACRO_LEVEL>=1
	INNER_STORE_8X8_LIBC
#else
	CALL(inner_store_8x8_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_strsm_nt_rl_inv_8x8_lib88ccc)





//                                             1      2         3         4         5        6         7        8         9        10                 11      12
// void kernel_strsm_nt_rl_inv_8x8_vs_lib88ccc(int k, float *A, float *B, float *C, int ldc, float *D, int ldd, float *E, int lde, float *inv_diag_E, int m1, int n1);

	.p2align 4,,15
	GLOB_FUN_START(kernel_strsm_nt_rl_inv_8x8_vs_lib88ccc)
	
	PROLOGUE

	// zero accumulation registers

	ZERO_ACC


	// call inner dgemm kernel nt 

	movq	ARG1, %r10
	movq	ARG2, %r11
	movq	ARG3, %r12

#if MACRO_LEVEL>=2
	INNER_KERNEL_GEMM_ADD_NT_8X8_LIB8
#else
	CALL(inner_kernel_gemm_add_nt_8x8_lib8)
#endif


	// call inner blender_loader nn

	movq	ARG4, %r10
	movq	ARG5, %r11 // ldc
	sall	$2, %r11d // ldc*sizeof(float)
	movq	ARG11, %r12 // m1
	movq	ARG12, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_SCALE_M11_8X8_VS_LIBC
#else
	CALL(inner_scale_m11_8x8_vs_libc)
#endif


	// solve

	movq	ARG8, %r10  // E 
	movq	ARG9, %r11 // lde
	sall	$2, %r11d // lde*sizeof(float)
	movq	ARG10, %r12  // inv_diag_E 
	movq	ARG12, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_EDGE_TRSM_RLT_INV_8X8_VS_LIBC
#else
	CALL(inner_edge_trsm_rlt_inv_8x8_vs_libc)
#endif


	// store

	movq	ARG6, %r10 // D
	movq	ARG7, %r11 // ldd
	sall	$2, %r11d // ldd*sizeof(float)
	movq	ARG11, %r12 // m1
	movq	ARG12, %r13 // n1

#if MACRO_LEVEL>=1
	INNER_STORE_8X8_VS_LIBC
#else
	CALL(inner_store_8x8_vs_libc)
#endif


	EPILOGUE

	ret

	FUN_END(kernel_strsm_nt_rl_inv_8x8_vs_lib88ccc)






