/**********************************************************************
Copyright �2013 Advanced Micro Devices, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

�	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
�	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************/

/**
 * SimpleConvolution is where each pixel of the output image
 * is the weighted sum of the neighborhood pixels of the input image
 * The neighborhood is defined by the dimensions of the mask and 
 * weight of each neighbor is defined by the mask itself.
 * @param output Output matrix after performing convolution
 * @param input  Input  matrix on which convolution is to be performed
 * @param mask   mask matrix using which convolution was to be performed
 * @param inputDimensions dimensions of the input matrix
 * @param maskDimensions  dimensions of the mask matrix
 */

void kernelSimpleConvolution(   uint tid,
				__global  uint  * output,
                                __global  uint  * input,
                                __global  float  * mask,
                                const     uint2  inputDimensions,
                                const     uint2  maskDimensions)
{
//	for (int m = 0; m < 5000; m++){

   //for (int m = 0; m < 5000000; m++){
   for (int m = 0; m < 3500000; m++){
    uint width  = inputDimensions.x;
    uint height = inputDimensions.y;
    
    uint x      = tid%width;
    uint y      = tid/width;
    
    uint maskWidth  = maskDimensions.x;
    uint maskHeight = maskDimensions.y;
    
    uint vstep = (maskWidth  -1)/2;
    uint hstep = (maskHeight -1)/2;
    
    /*
     * find the left, right, top and bottom indices such that
     * the indices do not go beyond image boundaires
     */
    uint left    = (x           <  vstep) ? 0         : (x - vstep);
    uint right   = ((x + vstep) >= width) ? width - 1 : (x + vstep); 
    uint top     = (y           <  hstep) ? 0         : (y - hstep);
    uint bottom  = ((y + hstep) >= height)? height - 1: (y + hstep); 
    
    /*
     * initializing wighted sum value
     */
    float sumFX = 0;
  
    for(uint i = left; i <= right; ++i)
        for(uint j = top ; j <= bottom; ++j)    
        {
            /*
             * performing wighted sum within the mask boundaries
             */
            uint maskIndex = (j - (y - hstep)) * maskWidth  + (i - (x - vstep));
            uint index     = j                 * width      + i;
            
            sumFX += ((float)input[index] * mask[maskIndex]);
        }
    /* 
     *To round to the nearest integer
     */
    sumFX += 0.5f;
    output[tid] = (uint)sumFX;
    }
}


__kernel void simpleConvolution(__global  uint  * output,
                                __global  uint  * input,
                                __global  float  * mask,
                                const     uint2  inputDimensions,
                                const     uint2  maskDimensions,
    				__global char * degradationStatus,
				__const int work_item_count)
{

    int index;
    __local int queueRWIid[128]; 
    __local int sharedIndex[1];
   
    uint globalId   = get_global_id(0);
    
    uint localId = get_local_id(0);
    uint groupId = get_group_id(0);

    //bool isFaulty = (globalId % 20 == 5) ? ((localId % 16 == 1) ? 1 : 0) : 0;
/////////////////////////
    bool is_run_kernel = 1;
    if (localId == 0)
    	sharedIndex[0] = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

	if (degradationStatus[globalId]){
		if (localId < work_item_count){
			index = atomic_inc(&sharedIndex[0]);
			queueRWIid[index] = localId;
	//		printf("pushed %d %d index = %d\n", groupId, localId, index);
		}
		is_run_kernel = 0;
      }
    
 
     barrier(CLK_LOCAL_MEM_FENCE);
     if (localId >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		localId =  (index > 0) ? queueRWIid[index-1] : localId;
	//	if (is_run_kernel)	
	//		printf("poped %d %d index = %d\n", groupId, localId, index);
   }


   size_t tid = groupId * work_item_count + localId; //= get_global_id(0);

////////////////////////

   if (is_run_kernel == 1)
	kernelSimpleConvolution(tid,output,input, mask, inputDimensions, maskDimensions);

}
