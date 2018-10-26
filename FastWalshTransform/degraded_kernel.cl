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
 */
#define CU_COUNT 20
#define SC_COUNT 16

void kernel_fastWalshTransform(unsigned int tid,
			__global float * tArray,
                        __const  int   step 
                       )
{
        const unsigned int group = tid%step;
        const unsigned int pair  = 2*step*(tid/step) + group;

        const unsigned int match = pair + step;
        
        float T1          = tArray[pair];
        float T2          = tArray[match];
       
for (int m = 0; m < 2000000; m++){
        tArray[pair]             = T1 + T2; 
        tArray[match]            = T1 - T2;
}
}


__kernel 
void fastWalshTransform(__global float * tArray,
                        __const  int   step,
     		__global uint * degradationStatus,
     		__global char * CUdegradationStatus,
			__const int work_item_count)
{
    int index;
    __local int queueRWIid[128]; 
    __local int sharedIndex[1];
 
    unsigned int gid = get_global_id(0);
    unsigned int tid = get_local_id(0);
    unsigned int bid = get_group_id(0);
 
	
    bool is_run_kernel = 1;

if (CUdegradationStatus[gid]){
    	if (tid == 0)
    		sharedIndex[0] = 0;
    	barrier(CLK_LOCAL_MEM_FENCE);
	if (tid < work_item_count && degradationStatus[gid]){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = tid;
			is_run_kernel = 0;
        }
    
 
 	barrier(CLK_LOCAL_MEM_FENCE);
     	if (tid >= work_item_count){
		if (degradationStatus[gid]) is_run_kernel = 0;
		else{
	//	is_run_kernel = degradationStatus[gid] ? 0:is_run_kernel;
		index =  atomic_dec(&sharedIndex[0]);
	//	is_run_kernel =  1; 
		tid =  queueRWIid[index-1];

		}
   	}
   }
   else {
	is_run_kernel = (tid >=work_item_count) ? 0 : 1;
	}


/*    if (tid == 0)
    	sharedIndex[0] = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

	if (degradationStatus[gid]){
		if (tid < work_item_count){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = tid;
			//printf ("faulty = %d %d \n", bid, tid);
		}
		is_run_kernel = 0;
      }
    
 
     barrier(CLK_LOCAL_MEM_FENCE);
     if (tid >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		tid =  (index > 0) ? queueRWIid[index-1] : tid;
		//if (index > 0) printf ("degraded = %d %d \n", bid, tid);
   }
*/

   uint threadId = bid * work_item_count + tid; //= get_global_id(0);
   if (is_run_kernel == 1)
	kernel_fastWalshTransform(threadId, tArray, step);
	
}
