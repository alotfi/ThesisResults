/**********************************************************************
Copyright ©2013 Advanced Micro Devices, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************/

/*
 * For a description of the algorithm and the terms used, please see the
 * documentation for this sample.
 *
 * Each thread calculates a pixel component(rgba), by applying a filter 
 * on group of 8 neighbouring pixels in both x and y directions. 
 * Both filters are summed (vector sum) to form the final result.
 */
#define CU_COUNT 20
#define SC_COUNT 16


#pragma OPENCL EXTENSION cl_khr_global_int32_extended_atomics : enable
__kernel void sobel_filter(__global uchar4* inputImage, __global uchar4* outputImage, __global char* degradationStatus, __const uint width, __const uint height,  __const int work_item_count)
{
    size_t localId = get_local_id(0);
    size_t gid = get_global_id(0);
    size_t groupId = get_group_id(0);
    __local int queueRWIid[128]; 
    __local uint sharedIndex[1];
/////////////////////////
    bool is_run_kernel = 1;
    int index;
    if (localId == 0)
    	sharedIndex[0] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);
	if (degradationStatus[gid]){
		if (localId < work_item_count){
		index = atomic_inc(&sharedIndex[0]);
		queueRWIid[index] = localId;
		}
		is_run_kernel = 0;
        }
    
 
     barrier(CLK_LOCAL_MEM_FENCE);
     if (localId >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		localId =  (index > 0) ? queueRWIid[index-1] : localId;
   }



	if (is_run_kernel){
   		uint gid = groupId * work_item_count + localId; //= get_global_id(0);

     		uint x = gid % width; 
    		uint y = gid / width;

		float4 Gx = (float4)(0);
		float4 Gy = Gx;
	
		int c = x + y * width;


		/* Read each texel component and calculate the filtered value using neighbouring texel components */
		if( x >= 1 && x < (width-1) && y >= 1 && y < height - 1)
		{
			float4 i00 = convert_float4(inputImage[c - 1 - width]);
			float4 i10 = convert_float4(inputImage[c - width]);
			float4 i20 = convert_float4(inputImage[c + 1 - width]);
			float4 i01 = convert_float4(inputImage[c - 1]);
			float4 i11 = convert_float4(inputImage[c]);
			float4 i21 = convert_float4(inputImage[c + 1]);
			float4 i02 = convert_float4(inputImage[c - 1 + width]);
			float4 i12 = convert_float4(inputImage[c + width]);
			float4 i22 = convert_float4(inputImage[c + 1 + width]);

			Gx =   i00 + (float4)(2) * i10 + i20 - i02  - (float4)(2) * i12 - i22;

			Gy =   i00 - i20  + (float4)(2)*i01 - (float4)(2)*i21 + i02  -  i22;

			/* taking root of sums of squares of Gx and Gy */
			outputImage[c] = convert_uchar4(hypot(Gx, Gy)/(float4)(2));

		}
	}	
}

	

	 






	

	




	

	

	
	
