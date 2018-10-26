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
#define CU_COUNT 20
#define SC_COUNT 16


__kernel 
void floydWarshallPass(__global uint * pathDistanceBuffer, 
                       __global uint * pathBuffer        , 
                       const unsigned int numNodes                  , 
                       const unsigned int pass,  __const int work_item_count,
    		  __const int degraded_CU_id,
    		  __const int degraded_lane_id )
{
    size_t localId = get_local_id(0);
    size_t groupId = get_group_id(0);
/////////////////////////
    bool is_run_kernel = 1;

    bool condition1 = localId >= work_item_count && localId < work_item_count + ceil((float)((float)work_item_count/16.0));
    bool condition2 = localId >= work_item_count + ceil((float)((float)work_item_count/16.0)); 
    if (groupId % CU_COUNT ==  degraded_CU_id){
	if (localId % SC_COUNT == degraded_lane_id){
		//do nothing
		is_run_kernel = 0;
        }
    
    	else {
		if ( condition1 ){
                        localId = degraded_lane_id + SC_COUNT * (localId - work_item_count); 
		}
		else if ( condition2 ){
                        localId = degraded_lane_id + SC_COUNT * (localId - work_item_count); 
                        localId = degraded_lane_id + SC_COUNT * (localId - work_item_count); 
                        //localId = degraded_lane_id + SC_COUNT * ((localId - work_item_count - (work_item_count/16))%SC_COUNT); 
		}
	}	  
    }	
   else{
	if (localId >= work_item_count) 
	 	is_run_kernel = 0;
  }
if (is_run_kernel){
   uint gid = groupId * work_item_count + localId; //= get_global_id(0);


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

