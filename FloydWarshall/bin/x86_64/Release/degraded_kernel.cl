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

/*!
 * returns the lesser of the two integers a and b
 */
inline 
unsigned int uintMin(unsigned int a, unsigned int b)
{
    return (b < a) ? b : a;
}

/*!
 * The floyd Warshall algorithm is a multipass algorithm
 * that calculates the shortest path between each pair of
 * nodes represented by pathDistanceBuffer. 
 *
 * In each pass a node k is introduced and the pathDistanceBuffer
 * which has the shortest distance between each pair of nodes
 * considering the (k-1) nodes (that are introduced in the previous
 * passes) is updated such that
 *
 * ShortestPath(x,y,k) = min(ShortestPath(x,y,k-1), ShortestPath(x,k,k-1) + ShortestPath(k,y,k-1))
 * where x and y are the pair of nodes between which the shortest distance 
 * is being calculated.
 * 
 * pathBuffer stores the intermediate nodes through which the shortest
 * path goes for each pair of nodes.
 *
 * numNodes is the number of nodes in the graph.
 *
 * for more detailed explaination of the algorithm kindly refer to the document
 * provided with the sample
 */

__kernel 
void floydWarshallPass(__global uint * pathDistanceBuffer, 
                       __global uint * pathBuffer        , 
                       const unsigned int numNodes                  , 
                       const unsigned int pass, __global char* degradationStatus,  __global char* CUdegradationStatus,  __const int work_item_count)

{
//    size_t localId = get_local_id(0);
//    size_t groupId = get_group_id(0);
/////////////////////////
    size_t localId = get_local_id(0);
    size_t gid = get_global_id(0);
    size_t groupId = get_group_id(0);
    __local int queueRWlid[128]; 
    __local uint sharedIndex[1];

/*
    bool is_run_kernel = 1;
    int index;
    if (CUdegradationStatus[gid]){
    	if (localId == 0)
    		sharedIndex[0] = 0;
    	barrier(CLK_LOCAL_MEM_FENCE);
	if (localId < work_item_count && degradationStatus[gid]){
//		if (degradationStatus[gid]){
			index = atomic_inc(&sharedIndex[0]);
			queueRWlid[index] = localId;
			is_run_kernel = 0;
//		}
        }
    
 
 	barrier(CLK_LOCAL_MEM_FENCE);
     	if (localId >= work_item_count){
//		if (degradationStatus[gid]) is_run_kernel = 0;
//		else{
		index =  atomic_dec(&sharedIndex[0]);
//		is_run_kernel =  1; 
		localId =  queueRWlid[index-1];

//		}
   	}
   }
   else {
	is_run_kernel = (localId >=work_item_count) ? 0 : 1;
	}
*/

    bool is_run_kernel = 1;
    int index;
    if (localId == 0)
    	sharedIndex[0] = 0;
//		printf(" pushing  %d \n", localId);
//    barrier(CLK_LOCAL_MEM_FENCE);
	if (degradationStatus[gid]){
		if (localId < work_item_count){
		index = atomic_inc(&sharedIndex[0]);
		queueRWlid[index] = localId;
//		printf(" pushing  %d \n", localId);
		}
		is_run_kernel = 0;
        }
    
 
 //    barrier(CLK_LOCAL_MEM_FENCE);
     if (localId >= work_item_count){
		index =  atomic_dec(&sharedIndex[0]);
		is_run_kernel =  (index > 0) ? 1 : 0;
		localId =  (index > 0) ? queueRWlid[index-1] : localId;
   }





if (is_run_kernel){
   uint gid = groupId * work_item_count + localId; //= get_global_id(0);
//for (int m = 0; m <1000; m++){
//for (int m = 0; m < 1000000; m++){
for (int m = 0; m < 770000; m++){


//    int gid =  get_global_id(0);

    int xValue = gid % numNodes; //get_global_id(0);
    int yValue = gid / numNodes; //get_global_id(1);

    int k = pass;
    int oldWeight = pathDistanceBuffer[yValue * numNodes + xValue];
    int tempWeight = (pathDistanceBuffer[yValue * numNodes + k] + pathDistanceBuffer[k * numNodes + xValue]);
    
    if (tempWeight < oldWeight)
    {
        pathDistanceBuffer[yValue * numNodes + xValue] = tempWeight;
        pathBuffer[yValue * numNodes + xValue] = k;
    }
}
}
}

