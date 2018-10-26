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
 * Quasi Random Sequence
 * Output size : n_dimensions * n_vectors
 * Input size: n_dimensions * n_directions 
 * shared buffer size : n_directions
 * Number of blocks : n_dimensions
 * First, all the direction numbers for a dimension are cached into
 * shared memory. Then each thread writes a single vector value by
 * using all the direction numbers from the shared memory.
 *
 */


#define N_DIRECTIONS_IN (32/4)

#define CU_COUNT 20
#define SC_COUNT 16

__kernel void QuasiRandomSequence_Vector(__global  float4* output,
                                  __global  uint4* input,
				 __local uint4* shared,
				 __global uint * degradationStatus,
	   	  	 	 __const int work_item_count
   				 )
{

    int index;
    __local int queueRWIid[128]; 
    __local int sharedIndex[1];
	uint global_id = get_global_id(0);
	uint local_id = get_local_id(0);
	uint group_id = get_group_id(0);

/////////////////////////
    bool is_run_kernel = 1;
    if (local_id == 0)
    	sharedIndex[0] = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

	if (degradationStatus[global_id]){
		if (local_id < work_item_count){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = local_id;
		}
		is_run_kernel = 0;
      }
    
 
     barrier(CLK_LOCAL_MEM_FENCE);
     if (local_id >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		local_id =  (index > 0) ? queueRWIid[index-1] : local_id;
   }


   global_id = group_id * work_item_count + local_id; //= get_global_id(0);


////////////////////////


   if (is_run_kernel == 1){
	for(int i=local_id; i<N_DIRECTIONS_IN; i+= work_item_count/*get_local_size(0)*/)
	{
		shared[i] = input[group_id * N_DIRECTIONS_IN + i];
	}
   }
	barrier(CLK_LOCAL_MEM_FENCE);
	
   if (is_run_kernel == 1){
	uint factor = local_id*4;
	uint4 vlid = (uint4)(factor, factor + 1, factor + 2, factor + 3);
	float divisor = (float)pow((float)2, (float)32);
	__local uint *shared_scalar = (__local uint*)shared;

	/*
	 * Assuming vlid(lastBit) can go max upto (1024*4)
	 * After 12th iteration lastBit will be zero
	 * So looping upto 12 iterations is enough, instead of 32
	 */
	uint4 temp = 0, lastBit = vlid;
	for(int k=0; k < 12; k++)
	{
		/*
         * (lastBit & 1) gives the LSB in lastBit
         * The loop iterates over all the bits and extracts each bit at a time
         */
        temp ^= (lastBit & 1) * shared_scalar[k];
		lastBit >>= 1;
	}

	output[global_id] = convert_float4(temp) / divisor;
    }
}



#define N_DIRECTIONS_IN_SCALAR 32

__kernel void QuasiRandomSequence_Scalar(__global  float* output,
                                  __global  uint* input, __local uint* shared, __global uint * degradationStatus, __global char * CUdegradationStatus, __const int work_item_count)
{
/*	uint global_id = get_global_id(0);
	uint local_id = get_local_id(0);
	uint group_id = get_group_id(0);*/

    int index;
    __local int queueRWIid[128]; 
    __local int sharedIndex[1];
	uint global_id = get_global_id(0);
	uint local_id = get_local_id(0);
	uint group_id = get_group_id(0);
/*
    bool is_run_kernel = 1;
    if (CUdegradationStatus[global_id]){
    	if (local_id == 0)
    		sharedIndex[0] = 0;
    	barrier(CLK_LOCAL_MEM_FENCE);
	if (local_id < work_item_count && degradationStatus[global_id]){
	//	if (degradationStatus[global_id]){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = local_id;
			is_run_kernel = 0;
	//	}
        }
    
 
 	barrier(CLK_LOCAL_MEM_FENCE);
     	if (local_id >= work_item_count){
		if (degradationStatus[global_id]) is_run_kernel = 0;
		else{
		index =  atomic_dec(&sharedIndex[0]);
		//is_run_kernel =  1; 
		local_id =  queueRWIid[index-1];

		}
   	}
   }
   else {
	is_run_kernel = (local_id >=work_item_count) ? 0 : 1;
	}
*/

/////////////////////////
    bool is_run_kernel = 1;
    if (local_id == 0)
    	sharedIndex[0] = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

	if (degradationStatus[global_id]){
		if (local_id < work_item_count){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = local_id;
		}
		is_run_kernel = 0;
      }
    
 
     barrier(CLK_LOCAL_MEM_FENCE);
     if (local_id >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		local_id =  (index > 0) ? queueRWIid[index-1] : local_id;
   }


////////////////////////

   if (is_run_kernel == 1){


   global_id = group_id * work_item_count + local_id; //= get_global_id(0);

//for (int m = 0; m < 10000; m ++){
//for (int m = 0; m < 100000000; m ++){
for (int m = 0; m < 30000000; m ++){
	float divisor = (float)pow((float)2, (float)32);
	for(int i=local_id; i<N_DIRECTIONS_IN_SCALAR; i+=get_local_size(0))
	{
		shared[i] = input[group_id * N_DIRECTIONS_IN_SCALAR + i];
	}
	barrier(CLK_LOCAL_MEM_FENCE);
	
	/*
	 * Assuming local_id(lastBit) can go max upto 1024
	 * After 10th iteration lastBit will be zero
	 * So looping upto 10 iterations is enough, instead of 32
	 */
    uint temp = 0, lastBit = local_id;
	for(int k=0; k < 10; k++)
	{
		/*
         * (lastBit & 1) gives the LSB in lastBit
         * The loop iterates over all the bits and extracts each bit at a time
         */
        temp ^= (lastBit & 1) * shared[k];
		lastBit >>= 1;
	}

	output[global_id] = convert_float(temp) / divisor;
}
}
}

