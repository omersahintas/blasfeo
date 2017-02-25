/**************************************************************************************************
*                                                                                                 *
* This file is part of BLASFEO.                                                                   *
*                                                                                                 *
* BLASFEO -- BLAS For Embedded Optimization.                                                      *
* Copyright (C) 2016-2017 by Gianluca Frison.                                                     *
* Developed at IMTEK (University of Freiburg) under the supervision of Moritz Diehl.              *
* All rights reserved.                                                                            *
*                                                                                                 *
* HPMPC is free software; you can redistribute it and/or                                          *
* modify it under the terms of the GNU Lesser General Public                                      *
* License as published by the Free Software Foundation; either                                    *
* version 2.1 of the License, or (at your option) any later version.                              *
*                                                                                                 *
* HPMPC is distributed in the hope that it will be useful,                                        *
* but WITHOUT ANY WARRANTY; without even the implied warranty of                                  *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                                            *
* See the GNU Lesser General Public License for more details.                                     *
*                                                                                                 *
* You should have received a copy of the GNU Lesser General Public                                *
* License along with HPMPC; if not, write to the Free Software                                    *
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA                  *
*                                                                                                 *
* Author: Gianluca Frison, giaf (at) dtu.dk                                                       *
*                          gianluca.frison (at) imtek.uni-freiburg.de                             *
*                                                                                                 *
**************************************************************************************************/

#include <stdlib.h>
#if defined(DIM_CHECK)
#include <stdio.h>
#endif

#include "../include/blasfeo_block_size.h"
#include "../include/blasfeo_common.h"
#include "../include/blasfeo_s_kernel.h"
#include "../include/blasfeo_s_aux.h"



void sgemm_nt_libstr(int m, int n, int k, float alpha, struct s_strmat *sA, int ai, int aj, struct s_strmat *sB, int bi, int bj, float beta, struct s_strmat *sC, int ci, int cj, struct s_strmat *sD, int di, int dj)
	{

	if(m<=0 || n<=0)
		return;
	
#if defined(DIM_CHECK)
	// A: m x k
	if(ai+m > sA->m) printf("\n***** sgemm_nt_libstr : ai+m > row(A) : %d+%d > %d *****\n\n", ai, m, sA->m);
	if(aj+k > sA->n) printf("\n***** sgemm_nt_libstr : aj+k > col(A) : %d+%d > %d *****\n\n", aj, k, sA->n);
	// B: n x k
	if(bi+n > sB->m) printf("\n***** sgemm_nt_libstr : bi+n > row(B) : %d+%d > %d *****\n\n", bi, n, sB->m);
	if(bj+k > sB->n) printf("\n***** sgemm_nt_libstr : bj+k > col(B) : %d+%d > %d *****\n\n", bj, k, sB->n);
	// C: m x n
	if(ci+m > sC->m) printf("\n***** sgemm_nt_libstr : ci+m > row(C) : %d+%d > %d *****\n\n", ci, n, sC->m);
	if(cj+n > sC->n) printf("\n***** sgemm_nt_libstr : cj+n > col(C) : %d+%d > %d *****\n\n", cj, k, sC->n);
	// D: m x n
	if(di+m > sD->m) printf("\n***** sgemm_nt_libstr : di+m > row(D) : %d+%d > %d *****\n\n", di, n, sD->m);
	if(dj+n > sD->n) printf("\n***** sgemm_nt_libstr : dj+n > col(D) : %d+%d > %d *****\n\n", dj, k, sD->n);
#endif

	const int bs = 8;

	int sda = sA->cn;
	int sdb = sB->cn;
	int sdc = sC->cn;
	int sdd = sD->cn;
	float *pA = sA->pA + aj*bs;
	float *pB = sB->pA + bj*bs;
	float *pC = sC->pA + cj*bs;
	float *pD = sD->pA + dj*bs;

	int i, j, l;

	i = 0;

#if defined(TARGET_X64_INTEL_HASWELL)
	for(; i<m-23; i+=24)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
			kernel_sgemm_nt_24x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
			kernel_sgemm_nt_24x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, &pC[(j+4)*bs+i*sdc], sdc, &pD[(j+4)*bs+i*sdd], sdd);
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nt_24x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
				if(j<n-4)
					{
					kernel_sgemm_nt_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 8, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nt_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 8, 0, n-j);
				}
			}
		}
	if(m-i>0)
		{
		if(m-i<=8)
			{
			goto left_8;
			}
		else if(m-i<=16)
			{
			goto left_16;
			}
		else
			{
			goto left_24;
			}
		}
#else
#if 1
	for(; i<m-15; i+=16)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
			kernel_sgemm_nt_16x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
			kernel_sgemm_nt_16x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, &pC[(j+4)*bs+i*sdc], sdc, &pD[(j+4)*bs+i*sdd], sdd);
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nt_16x4_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
				if(j<n-4)
					{
					kernel_sgemm_nt_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 8, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nt_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 8, 0, n-j);
				}
			}
		}
	if(m-i>0)
		{
		if(m-i<=8)
			{
			goto left_8;
			}
		else
			{
			goto left_16;
			}
		}
#else
	for(; i<m-7; i+=8)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
#if 1
			kernel_sgemm_nt_8x8_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
#else
			kernel_sgemm_nt_8x4_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
			kernel_sgemm_nt_8x4_lib8(k, &alpha, &pA[i*sda], &pB[4+j*sdb], &beta, &pC[(j+4)*bs+i*sdc], &pD[(j+4)*bs+i*sdd]);
#endif
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nt_8x4_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
				if(j<n-4)
					{
					kernel_sgemm_nt_8x4_gen_lib8(k, &alpha, &pA[i*sda], &pB[4+j*sdb], &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 8, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nt_8x4_gen_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 8, 0, n-j);
				}
			}
		}
	if(m>i)
		{
		goto left_8;
		}
#endif
#endif

	// common return if i==m
	return;

	// clean up loops definitions

	left_24:
	j = 0;
	for(; j<n-4; j+=8)
		{
		kernel_sgemm_nt_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, 4);
		kernel_sgemm_nt_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, m-i, 0, n-(j+4));
		}
	if(j<n)
		{
		kernel_sgemm_nt_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;

	left_16:
	j = 0;
	for(; j<n-4; j+=8)
		{
		kernel_sgemm_nt_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, 4);
		kernel_sgemm_nt_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[4+j*sdb], &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, m-i, 0, n-(j+4));
		}
	if(j<n)
		{
		kernel_sgemm_nt_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;

	left_8:
	j = 0;
	for(; j<n-4; j+=8)
		{
		kernel_sgemm_nt_8x8_gen_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	if(j<n)
		{
		kernel_sgemm_nt_8x4_gen_lib8(k, &alpha, &pA[i*sda], &pB[0+j*sdb], &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;

	}



void sgemm_nn_libstr(int m, int n, int k, float alpha, struct s_strmat *sA, int ai, int aj, struct s_strmat *sB, int bi, int bj, float beta, struct s_strmat *sC, int ci, int cj, struct s_strmat *sD, int di, int dj)
	{

	if(m<=0 || n<=0)
		return;
	
#if defined(DIM_CHECK)
	// A: m x k
	if(ai+m > sA->m) printf("\n***** sgemm_nn_libstr : ai+m > row(A) : %d+%d > %d *****\n\n", ai, m, sA->m);
	if(aj+k > sA->n) printf("\n***** sgemm_nn_libstr : aj+k > col(A) : %d+%d > %d *****\n\n", aj, k, sA->n);
	// B: k x n
	if(bi+k > sB->m) printf("\n***** sgemm_nn_libstr : bi+k > row(B) : %d+%d > %d *****\n\n", bi, k, sB->m);
	if(bj+n > sB->n) printf("\n***** sgemm_nn_libstr : bj+n > col(B) : %d+%d > %d *****\n\n", bj, n, sB->n);
	// C: m x n
	if(ci+m > sC->m) printf("\n***** sgemm_nn_libstr : ci+m > row(C) : %d+%d > %d *****\n\n", ci, n, sC->m);
	if(cj+n > sC->n) printf("\n***** sgemm_nn_libstr : cj+n > col(C) : %d+%d > %d *****\n\n", cj, k, sC->n);
	// D: m x n
	if(di+m > sD->m) printf("\n***** sgemm_nn_libstr : di+m > row(D) : %d+%d > %d *****\n\n", di, n, sD->m);
	if(dj+n > sD->n) printf("\n***** sgemm_nn_libstr : dj+n > col(D) : %d+%d > %d *****\n\n", dj, k, sD->n);
#endif

	const int bs = 8;

	int sda = sA->cn;
	int sdb = sB->cn;
	int sdc = sC->cn;
	int sdd = sD->cn;
	float *pA = sA->pA + aj*bs;
	float *pB = sB->pA + bj*bs + bi/bs*bs*sdb;
	float *pC = sC->pA + cj*bs;
	float *pD = sD->pA + dj*bs;

	int offsetB = bi%bs;

	int i, j, l;

	i = 0;

#if defined(TARGET_X64_INTEL_HASWELL)
	for(; i<m-23; i+=24)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
			kernel_sgemm_nn_24x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
			kernel_sgemm_nn_24x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, &pC[(j+4)*bs+i*sdc], sdc, &pD[(j+4)*bs+i*sdd], sdd);
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nn_24x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
				if(j<n-4)
					{
					kernel_sgemm_nn_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 16, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nn_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 16, 0, n-j);
				}
			}
		}
	if(m>i)
		{
		if(m-i<=8)
			{
			goto left_8;
			}
		else if(m-i<=16)
			{
			goto left_16;
			}
		else
			{
			goto left_24;
			}
		}
#else
#if 1
	for(; i<m-15; i+=16)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
			kernel_sgemm_nn_16x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
			kernel_sgemm_nn_16x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, &pC[(j+4)*bs+i*sdc], sdc, &pD[(j+4)*bs+i*sdd], sdd);
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nn_16x4_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], sdc, &pD[(j+0)*bs+i*sdd], sdd);
				if(j<n-4)
					{
					kernel_sgemm_nn_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 16, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nn_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 16, 0, n-j);
				}
			}
		}
	if(m>i)
		{
		if(m-i<=8)
			{
			goto left_8;
			}
		else
			{
			goto left_16;
			}
		}
#else
	for(; i<m-7; i+=8)
		{
		j = 0;
		for(; j<n-7; j+=8)
			{
#if 1
			kernel_sgemm_nn_8x8_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
#else
			kernel_sgemm_nn_8x4_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
			kernel_sgemm_nn_8x4_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+4)*bs], sdb, &beta, &pC[(j+4)*bs+i*sdc], &pD[(j+4)*bs+i*sdd]);
#endif
			}
		if(j<n)
			{
			if(j<n-3)
				{
				kernel_sgemm_nn_8x4_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, &pC[(j+0)*bs+i*sdc], &pD[(j+0)*bs+i*sdd]);
				if(j<n-4)
					{
					kernel_sgemm_nn_8x4_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, 8, 0, n-(j+4));
					}
				}
			else
				{
				kernel_sgemm_nn_8x4_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, 8, 0, n-j);
				}
			}
		}
	if(m>i)
		{
		goto left_8;
		}
#endif
#endif

	// common return if i==m
	return;

#if defined(TARGET_X64_INTEL_HASWELL)
	left_24:
	j = 0;
	for(; j<n-4; j+=8)
		{
		kernel_sgemm_nn_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		kernel_sgemm_nn_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, m-i, 0, n-(j+4));
		}
	if(j<n)
		{
		kernel_sgemm_nn_24x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;
#endif

	left_16:
	j = 0;
	for(; j<n-4; j+=8)
		{
		kernel_sgemm_nn_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		kernel_sgemm_nn_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, m-i, 0, n-(j+4));
		}
	if(j<n)
		{
		kernel_sgemm_nn_16x4_gen_lib8(k, &alpha, &pA[i*sda], sda, offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;

	left_8:
	j = 0;
	for(; j<n-4; j+=8)
		{
#if 1
		kernel_sgemm_nn_8x8_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
#else
		kernel_sgemm_nn_8x4_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		kernel_sgemm_nn_8x4_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+4)*bs], sdb, &beta, 0, &pC[(j+4)*bs+i*sdc], sdc, 0, &pD[(j+4)*bs+i*sdd], sdd, 0, m-i, 0, n-(j+4));
#endif
		}
	if(j<n)
		{
		kernel_sgemm_nn_8x4_gen_lib8(k, &alpha, &pA[i*sda], offsetB, &pB[(j+0)*bs], sdb, &beta, 0, &pC[(j+0)*bs+i*sdc], sdc, 0, &pD[(j+0)*bs+i*sdd], sdd, 0, m-i, 0, n-j);
		}
	return;

	}



