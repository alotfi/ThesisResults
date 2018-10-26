/**********************************************************************
Copyright ©2013 Advanced Micro Devices, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

•   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
•   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************/


#include "BlackScholes.hpp"

#include <math.h>
#include <malloc.h>

//const int degraded_CU_id = 0;
//const int degraded_lane_id = 2;


//  Constants
#define S_LOWER_LIMIT 10.0f
#define S_UPPER_LIMIT 100.0f
#define K_LOWER_LIMIT 10.0f
#define K_UPPER_LIMIT 100.0f
#define T_LOWER_LIMIT 1.0f
#define T_UPPER_LIMIT 10.0f
#define R_LOWER_LIMIT 0.01f
#define R_UPPER_LIMIT 0.05f
#define SIGMA_LOWER_LIMIT 0.01f
#define SIGMA_UPPER_LIMIT 0.10f

float
BlackScholes::phi(float X)
{
    float y, absX, t;

    // the coeffs
    const float c1 =  0.319381530f;
    const float c2 = -0.356563782f;
    const float c3 =  1.781477937f;
    const float c4 = -1.821255978f;
    const float c5 =  1.330274429f;

    const float oneBySqrt2pi = 0.398942280f;

    absX = fabs(X);
    t = 1.0f / (1.0f + 0.2316419f * absX);

    y = 1.0f - oneBySqrt2pi * exp(-X * X / 2.0f) *
        t * (c1 +
             t * (c2 +
                  t * (c3 +
                       t * (c4 + t * c5))));

    return (X < 0) ? (1.0f - y) : y;
}

void
BlackScholes::blackScholesCPU()
{
    int y;
    for (y = 0; y < width * height * 4; ++y)
    {
        float d1, d2;
        float sigmaSqrtT;
        float KexpMinusRT;
        float s = S_LOWER_LIMIT * randArray[y] + S_UPPER_LIMIT * (1.0f - randArray[y]);
        float k = K_LOWER_LIMIT * randArray[y] + K_UPPER_LIMIT * (1.0f - randArray[y]);
        float t = T_LOWER_LIMIT * randArray[y] + T_UPPER_LIMIT * (1.0f - randArray[y]);
        float r = R_LOWER_LIMIT * randArray[y] + R_UPPER_LIMIT * (1.0f - randArray[y]);
        float sigma = SIGMA_LOWER_LIMIT * randArray[y] + SIGMA_UPPER_LIMIT *
                      (1.0f - randArray[y]);

        sigmaSqrtT = sigma * sqrt(t);

        d1 = (log(s / k) + (r + sigma * sigma / 2.0f) * t) / sigmaSqrtT;
        d2 = d1 - sigmaSqrtT;

        KexpMinusRT = k * exp(-r * t);
        hostCallPrice[y] = s * phi(d1) - KexpMinusRT * phi(d2);
        hostPutPrice[y]  = KexpMinusRT * phi(-d2) - s * phi(-d1);
    }
}



int
BlackScholes::setupBlackScholes()
{
    int i = 0;

    // Calculate width and height from samples
    samples = samples / 4;
    samples = (samples / GROUP_SIZE)? (samples / GROUP_SIZE) * GROUP_SIZE:
              GROUP_SIZE;

    unsigned int tempVar1 = (unsigned int)sqrt((double)samples);
    tempVar1 = (tempVar1 / GROUP_SIZE)? (tempVar1 / GROUP_SIZE) * GROUP_SIZE:
               GROUP_SIZE;
    samples = tempVar1 * tempVar1;

    width = 512;//128;//256*2;//512;//512;//tempVar1; //128;//32;//64;//tempVar1;
    height = 512;//256;//256;//512;//width; //120;//64;// width;


   printf ("input   = %d x %d floats \n", height, width);

#if defined (_WIN32)
    randArray = (cl_float*)_aligned_malloc(width * height * sizeof(cl_float4), 16);
#else
    randArray = (cl_float*)memalign(16, width * height * sizeof(cl_float4));
#endif
    CHECK_ALLOCATION(randArray, "Failed to allocate host memory. (randArray)");

   printf ("input size = %d bytes \n", height*width*sizeof(cl_float4));
    for(i = 0; i < width * height * 4; i++)
    {
        randArray[i] = /*(float)rand()*/(float)(10.0 * i) / (float)RAND_MAX;
    }

    deviceCallPrice = (cl_float*)malloc(width * height * sizeof(cl_float4));
    CHECK_ALLOCATION(deviceCallPrice,
                     "Failed to allocate host memory. (deviceCallPrice)");
    memset(deviceCallPrice, 0, width * height * sizeof(cl_float4));

    devicePutPrice = (cl_float*)malloc(width * height * sizeof(cl_float4));
    CHECK_ALLOCATION(devicePutPrice,
                     "Failed to allocate host memory. (devicePutPrice)");
    memset(devicePutPrice, 0, width * height * sizeof(cl_float4));

    hostCallPrice = (cl_float*)malloc(width * height * sizeof(cl_float4));
    CHECK_ALLOCATION(hostCallPrice,
                     "Failed to allocate host memory. (hostCallPrice)");
    memset(hostCallPrice, 0, width * height * sizeof(cl_float4));

    hostPutPrice = (cl_float*)malloc(width * height * sizeof(cl_float4));
    CHECK_ALLOCATION(hostPutPrice,
                     "Failed to allocate host memory. (hostPutPrice)");
    memset(hostPutPrice, 0, width * height * sizeof(cl_float4));

/*    for (int i =0; i < NumDEGRADED; i++){
	degraded_CU_id[i] = (unsigned int) rand() % 20;
	degraded_lane_id[i] = (unsigned int) rand() % 16;
    }*/

	NumDouble = 1;
	i = 1;
	srand (time(NULL));
	degraded_CU_id[0] = (unsigned int) rand() % CU_Count;
	degraded_lane_id[0] = (unsigned int) rand() % SC_Count;
	while (i < NumDEGRADED){
		degraded_lane_id[i] = (degraded_lane_id[i-1] + rand() % 2 + 1) % SC_Count;
		degraded_CU_id[i] = degraded_CU_id[0];

/*    		if (i < 3){
			degraded_CU_id[i] = (degraded_CU_id[i-1] + rand()%2+1 )%20;
			degraded_lane_id[i] = (unsigned int) rand() % 16;
		}
		else if (i < 6){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 2;
		}
		else if (i < 9){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 3;
		}
		else if (i < 12){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 4;
		}
		else if (i < 15){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 5;
		}
		else if (i < 18){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 6;
		}
		else if (i < 21){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 7;
		}
		else if (i < 24){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%16;
			NumDouble = 8;
		}
		else{
			degraded_CU_id[i] = (degraded_CU_id[i-1] + rand()%2+1 )%20;
			degraded_lane_id[i] = (unsigned int) rand() % 16;
	
		} */
		i++;
	}

    for (int i =0; i < NumDEGRADED; i++)
	printf("faulty element = (%d %d)   ", degraded_CU_id[i], degraded_lane_id[i]) ;
	printf("\n");

    return SDK_SUCCESS;
}

int
BlackScholes::genBinaryImage()
{
    /*
     * Have a look at the available platforms and pick either
     * the AMD one if available or a reasonable default.
     */

    bifData binaryData;
    binaryData.kernelName = std::string("BlackScholes_Kernels.cl");
    binaryData.flagsStr = std::string("");
    if(sampleArgs->isComplierFlagsSpecified())
    {
        binaryData.flagsFileName = std::string(sampleArgs->flags.c_str());
    }

    binaryData.binaryName = std::string(sampleArgs->dumpBinary.c_str());
    int status = generateBinaryImage(binaryData);
    return status;
}


int
BlackScholes::setupCL(bool isNaive)
{
    cl_int status = 0;

    cl_device_type dType;

    if(sampleArgs->deviceType.compare("cpu") == 0)
    {
        dType = CL_DEVICE_TYPE_CPU;
    }
    else //deviceType = "gpu"
    {
        dType = CL_DEVICE_TYPE_GPU;
        if(sampleArgs->isThereGPU() == false)
        {
            std::cout << "GPU not found. Falling back to CPU device" << std::endl;
            dType = CL_DEVICE_TYPE_CPU;
        }
    }

    /*
     * Have a look at the available platforms and pick either
     * the AMD one if available or a reasonable default.
     */

    cl_platform_id platform = NULL;
    int retValue = getPlatform(platform, sampleArgs->platformId,
                               sampleArgs->isPlatformEnabled());
    CHECK_ERROR(retValue, SDK_SUCCESS, "BlackScholes::getPlatform() failed");

    // Display available devices.
    retValue = displayDevices(platform, dType);
    CHECK_ERROR(retValue, SDK_SUCCESS, "BlackScholes::::displayDevices() failed");

    // If we could find our platform, use it. Otherwise use just available platform.
    cl_context_properties cps[3] =
    {
        CL_CONTEXT_PLATFORM,
        (cl_context_properties)platform,
        0
    };

    context = clCreateContextFromType(cps,
                                      dType,
                                      NULL,
                                      NULL,
                                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateContextFromType failed.");

    // getting device on which to run the sample
    status = getDevices(context, &devices,sampleArgs-> deviceId,
                        sampleArgs->isDeviceIdEnabled());
    CHECK_ERROR(status, SDK_SUCCESS, "getDevices() failed");

    {
        // The block is to move the declaration of prop closer to its use
        cl_command_queue_properties prop = 0;
        commandQueue = clCreateCommandQueue(context,
                                            devices[sampleArgs->deviceId],
                                            CL_QUEUE_PROFILING_ENABLE,
                                            &status);
        CHECK_OPENCL_ERROR(status, "clCreateCommandQueue failed.");
    }
    //Set device info of given cl_device_id
    retValue = deviceInfo.setDeviceInfo(devices[sampleArgs->deviceId]);
    CHECK_ERROR(retValue, SDK_SUCCESS, "SDKDeviceInfo::setDeviceInfo() failed");


    // Set Presistent memory only for AMD platform
    cl_mem_flags inMemFlags = CL_MEM_READ_ONLY;
    if(sampleArgs->isAmdPlatform())
    {
        inMemFlags |= CL_MEM_USE_PERSISTENT_MEM_AMD;
    }

    randBuf = clCreateBuffer(context,
                             inMemFlags,
                             sizeof(cl_float4) * width  * height,
                             NULL,
                             &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (randBuf)");

    callPriceBuf = clCreateBuffer(context,
                                  CL_MEM_WRITE_ONLY,
                                  sizeof(cl_float4) * width * height,
                                  NULL,
                                  &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (callPriceBuf)");

    putPriceBuf = clCreateBuffer(context,
                                 CL_MEM_WRITE_ONLY,
                                 sizeof(cl_float4) * width * height,
                                 NULL,
                                 &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (putPriceBuf)");

    // create a CL program using the kernel source
    buildProgramData buildData;
    if (isNaive)
    	buildData.kernelName = std::string("BlackScholes_Kernels.cl");
    else
    	buildData.kernelName = std::string("degraded_kernel.cl");

    buildData.devices = devices;
    buildData.deviceId = sampleArgs->deviceId;
    buildData.flagsStr = std::string("");
    if(sampleArgs->isLoadBinaryEnabled())
    {
        buildData.binaryName = std::string(sampleArgs->loadBinary.c_str());
    }

    if(sampleArgs->isComplierFlagsSpecified())
    {
        buildData.flagsFileName = std::string(sampleArgs->flags.c_str());
    }

    retValue = buildOpenCLProgram(program, context, buildData);
    CHECK_ERROR(retValue, SDK_SUCCESS, "buildOpenCLProgram() failed");



    // get a kernel object handle for a kernel with the given name
    if (useScalarKernel)
    {
        kernel = clCreateKernel(program, "blackScholes_scalar", &status);
    }
    else
    {
        kernel = clCreateKernel(program, "blackScholes", &status);
    }
    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.(kernel)");

    status = kernelInfo.setKernelWorkGroupInfo(kernel,
             devices[sampleArgs->deviceId]);
    CHECK_OPENCL_ERROR(status, "kernelInfo.setKernelWorkGroupInfo failed");

    // Calculte 2D block size according to required work-group size by kernel
    kernelInfo.kernelWorkGroupSize = kernelInfo.kernelWorkGroupSize > GROUP_SIZE ?
                                     GROUP_SIZE : kernelInfo.kernelWorkGroupSize;
//comment boud ati
    while((blockSizeX * blockSizeY) < kernelInfo.kernelWorkGroupSize)
    {
        bool next = false;
        if(2 * blockSizeX * blockSizeY <= kernelInfo.kernelWorkGroupSize)
        {
            blockSizeX <<= 1;
            next = true;
        }
        if(2 * blockSizeX * blockSizeY <= kernelInfo.kernelWorkGroupSize)
        {
            next = true;
            blockSizeY <<= 1;
        }

        // Break if no if statement is executed
        if(next == false)
        {
            break;
        }
    }

    return SDK_SUCCESS;
}


int
BlackScholes::runCLKernels(bool isNaiveVersion)
{
    cl_int   status;
    cl_event ndrEvt;

	std::ostringstream os;
	os << "timing_" << NumDEGRADED << "_" << GROUP_SIZE << ".csv";
	std::string fname = os.str(); 
	std::ofstream foutput_time;
	foutput_time.open(fname.c_str(), std::ios_base::out | std::ios_base::app);



  //  cl_int prv_wic = blockSizeY * blockSizeX;
    cl_int work_item_count = GROUP_SIZE;//blockSizeY * blockSizeX;

    size_t localThreads[1] = {blockSizeY * blockSizeX}; //{blockSizeX, blockSizeY};

   /* if (!isNaiveVersion && work_item_count == 256){
    	prv_wic = work_item_count/2;  //1
    	work_item_count = work_item_count/2;  //2
   	localThreads[0] = {work_item_count}; //3  Atieh
    }*/



  /*  int min_deg_lane = degraded_lane_id[0];
    for (int i = 0; i < NumDEGRADED; i++){
	if (degraded_lane_id[i] < min_deg_lane){
		min_deg_lane = degraded_lane_id[i];
	}
    }
*/

//printf("width height %d %d  blockSizeX blockSizeY %d %d \n", width, height, blockSizeX, blockSizeY);
    size_t globalThreads[1] ={width * height}; //{width, height};
    if (useScalarKernel)
    {
        globalThreads[0]*=4;
    }
if (isNaiveVersion){
	printf("Naive kernel: \n");
	printf("localThreads = %d , globalThreads = %d \n", localThreads[0],  globalThreads[0]);
}
else{

 		uint redundant_wi = ceil((float)((float)work_item_count/(float)SC_Count)) * NumDEGRADED;
		for (int i = work_item_count; i < work_item_count+redundant_wi; i++){
			for (int j = 0; j < NumDEGRADED; j++)
				if (i % SC_Count == degraded_lane_id[j])
					redundant_wi++;
		}


  /*  uint redundant_wi = ceil((float)((float)work_item_count/16.0)) ;
 	for (int i = work_item_count; i < work_item_count+redundant_wi; i++)
		if (i % 16 == min_deg_lane)
			redundant_wi++;
   redundant_wi = redundant_wi * NumDouble;  
    if (redundant_wi + work_item_count > 256)
	work_item_count = 128; //256 - redundant_wi;
 */  // if (work_item_count % 2 != 0)
//	work_item_count -= 1;
/*redundant_wi = ceil((float)((float)work_item_count/16.0)) ;
 	for (int i = work_item_count; i < work_item_count+redundant_wi; i++)
		if (i % 16 == min_deg_lane)
			redundant_wi++;
   redundant_wi = redundant_wi * NumDouble; 
*/
    printf("redundant wi = %d \n", redundant_wi);	
    localThreads[0] = work_item_count + redundant_wi;
  /*  if (localThreads[0] % 2 != 0){
//	work_item_count -= 1;
	localThreads[0] += 1;
    }*/
    globalThreads[0] = ceil((double)((double)globalThreads[0]/(double)work_item_count * (double)(work_item_count + redundant_wi)));
    //globalThreads[0] = (globalThreads[0]/work_item_count) * localThreads[0]; //(work_item_count + redundant_wi);
    printf("Aging enabled kernel: \n");
    printf("localThreads = %d, work_item_count = %d, globalThreads = %d \n",localThreads[0], work_item_count,  globalThreads[0] );
}

    degradationStatus = (cl_char *) malloc(globalThreads[0]*sizeof(cl_char));
    CHECK_ALLOCATION(degradationStatus, "Failed to allocate memory! (degradationStatus)");

    CUdegradationStatus = (cl_char *) malloc(globalThreads[0]*sizeof(cl_char));
    CHECK_ALLOCATION(CUdegradationStatus, "Failed to allocate memory! (CUdegradationStatus)");


     	int counter = 0;
    	for (int i=0; i<globalThreads[0]/localThreads[0]; i++){	
		for (int j = 0; j < localThreads[0]; j++){
			
			degradationStatus[i*localThreads[0]+j] = 0;
			CUdegradationStatus[i*localThreads[0]+j] = 0;
			for (int k = 0; k < NumDEGRADED; k++){
				if ((i % CU_Count) == degraded_CU_id[k] && ((j%SC_Count) == degraded_lane_id[k])){
					degradationStatus[i*localThreads[0]+j] = 1;
					counter++;
				}
				if (i%CU_Count == degraded_CU_id[k])
					CUdegradationStatus[i*localThreads[0]+j] = 1;
			}
		}
    	} 
		printf("# degraded WIs = %d \n", counter);

	  // Create memory object for degStat Image
	    degradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY,
				   globalThreads[0] * sizeof(cl_char), //to be parametric
				   0,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (degradationBufer)");

	    CUdegradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY,
				   globalThreads[0] * sizeof(cl_char), //to be parametric
				   0,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (CUdegradationBufer)");


/*    if(localThreads[0] > deviceInfo.maxWorkItemSizes[0] ||
            localThreads[1] > deviceInfo.maxWorkItemSizes[1] ||
            localThreads[0]*localThreads[1] >
            deviceInfo.maxWorkGroupSize) //(size_t)blockSizeX * blockSizeY
    {
        std::cout << "Unsupported: Device does not support"
                  "requested number of work items.";
        FREE(maxWorkItemSizes);
        return SDK_FAILURE;
    }
*/
    cl_event inMapEvt;
    void* mapPtr = clEnqueueMapBuffer(
                       commandQueue,
                       randBuf,
                       CL_FALSE,
                       CL_MAP_WRITE,
                       0,
                       sizeof(cl_float4) * width  * height,
                       0,
                       NULL,
                       &inMapEvt,
                       &status);
    CHECK_OPENCL_ERROR(status, "clEnqueueMapBuffer failed. (mapPtr)");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush(commandQueue) failed.");

    status = waitForEventAndRelease(&inMapEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(inMapEvt) Failed");

    memcpy(mapPtr, randArray, sizeof(cl_float4) * width  * height);

    cl_event unmapEvent;
    status = clEnqueueUnmapMemObject(
                 commandQueue,
                 randBuf,
                 mapPtr,
                 0,
                 NULL,
                 &unmapEvent);
    CHECK_OPENCL_ERROR(status, "clEnqueueUnmapMemObject failed. (randBuf)");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed. (randBuf)");

    status = waitForEventAndRelease(&unmapEvent);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(unmapEvent) Failed");

	    cl_event degEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 degradationStatusBuffer,
			 CL_FALSE,
			 0,
			 globalThreads[0] * sizeof(cl_char),
			 degradationStatus,
			 0,
			 NULL,
			 &degEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (degStatBuffer)");

	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&degEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(degEvt) Failed");


	    cl_event cudegEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 CUdegradationStatusBuffer,
			 CL_FALSE,
			 0,
			 globalThreads[0] * sizeof(cl_char),
			 CUdegradationStatus,
			 0,
			 NULL,
			 &cudegEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (cudegStatBuffer)");

	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&cudegEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(cudegEvt) Failed");


	
    // whether sort is to be in increasing order. CL_TRUE implies increasing
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&randBuf);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (randBuf)");

    int rowStride = useScalarKernel?width*4:width;
    status = clSetKernelArg(kernel, 1, sizeof(rowStride), (const void *)&rowStride);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (width)");


    status = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&callPriceBuf);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (callPriceBuf)");

    status = clSetKernelArg(kernel, 3, sizeof(cl_mem), (void *)&putPriceBuf);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (putPriceBuf)");
	/////
// degradationStatBuffer
    status = clSetKernelArg(
		 kernel,
		 4,
		 sizeof(cl_mem),
		 &degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (degradationStatBuffer)");

    status = clSetKernelArg(
		 kernel,
		 5,
		 sizeof(cl_mem),
		 &CUdegradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (CUdegradationStatBuffer)");


	   if (!isNaiveVersion){
	    status = clSetKernelArg(kernel,
				    6,
				    sizeof(int),
				    (void*)&work_item_count);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg(numSteps) failed.");

	   }

//for (int m = 0; m < 100; m++){
//printf("localThreads = %d %d globalThreads = %d %d \n", localThreads[0], globalThreads[0]);
    // Enqueue a kernel run call.
    status = clEnqueueNDRangeKernel(commandQueue,
                                    kernel,
                                    1,//2,
                                    NULL,
                                    globalThreads,
                                    localThreads,
                                    0,
                                    NULL,
                                    &ndrEvt);

    CHECK_OPENCL_ERROR(status, "clEnqueueNDRangeKernel failed.");

    // wait for the kernel call to finish execution
    status = clFinish(commandQueue);
    CHECK_OPENCL_ERROR(status, "clEnqueueNDRangeKernel failed.");

    status = clWaitForEvents(1, &ndrEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(ndrEvt) Failed");
	////////////////////////////////timing
	    cl_ulong time_start, time_end;
	    double total_time;
	    clGetEventProfilingInfo(ndrEvt, CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL);
	    if (status != CL_SUCCESS) {
		printf("clGetEventProfilingInfo(COMMAND_START) failed: 1\n");
		time_start = 0;
	    }
	    clGetEventProfilingInfo(ndrEvt, CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL);
	    if (status != CL_SUCCESS) {
	       printf("clGetEventProfilingInfo(COMMAND_END) failed: 2\n");
	       time_end = 0;
	    }	 
	    total_time = (double) (time_end - time_start);
	    printf("\nTotal kernel execution time = %0.3f ms\n", (total_time / 1000000.0) );
	   foutput_time << (double)(total_time/1000000.0) << "\n"; 
//}
	foutput_time.close();
	  //  avgTime += total_time;
	     clReleaseEvent(ndrEvt);

	//////////////////////////////// end timing

    cl_event callEvent;
    cl_event putEvent;

    // Enqueue the results to application pointer
    status = clEnqueueReadBuffer(commandQueue,
                                 callPriceBuf,
                                 CL_FALSE,
                                 0,
                                 width * height * sizeof(cl_float4),
                                 deviceCallPrice,
                                 0,
                                 NULL,
                                 &callEvent);
    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");

    // Enqueue the results to application pointer
    status = clEnqueueReadBuffer(commandQueue,
                                 putPriceBuf,
                                 CL_FALSE,
                                 0,
                                 width * height * sizeof(cl_float4),
                                 devicePutPrice,
                                 0,
                                 NULL,
                                 &putEvent);
    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush(commanQueue) failed.");

    status = waitForEventAndRelease(&callEvent);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(callEvent) Failed");

    status = waitForEventAndRelease(&putEvent);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(putEvent) Failed");

    return SDK_SUCCESS;
}

int
BlackScholes::initialize()
{
    // Call base class Initialize to get default configuration
    CHECK_ERROR((sampleArgs->initialize()), SDK_SUCCESS,
                "OpenCL resource initialization  failed");
    Option* num_samples = new Option;
    CHECK_ALLOCATION(num_samples,
                     "Failed to intialization of class. (num_samples)");
    num_samples->_sVersion = "x";
    num_samples->_lVersion = "samples";
    num_samples->_description = "Number of samples to be calculated";
    num_samples->_type = CA_ARG_INT;
    num_samples->_value = &samples;

    sampleArgs->AddOption(num_samples);

    num_samples->_sVersion = "i";
    num_samples->_lVersion = "iterations";
    num_samples->_description = "Number of iterations";
    num_samples->_type = CA_ARG_INT;
    num_samples->_value = &iterations;

    sampleArgs->AddOption(num_samples);

    num_samples->_sVersion = "s";
    num_samples->_lVersion = "scalar";
    num_samples->_description =
        "Run the scalar kernel instead of the vectoroized kernel";
    num_samples->_type = CA_NO_ARGUMENT;
    num_samples->_value = &useScalarKernel;

    sampleArgs->AddOption(num_samples);

    delete num_samples;

    return SDK_SUCCESS;
}

int
BlackScholes::setup(bool isNaive)
{
/*    if(setupBlackScholes() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
*/
    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    if(setupCL(isNaive) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
    sampleTimer->stopTimer(timer);

    // Compute setup time
    setupTime = (double)(sampleTimer->readTimer(timer));

    return SDK_SUCCESS;
}


int
BlackScholes::run(bool isNaive)
{
    avgTime = 0.0;
    // Warm up
    for(int i = 0; i < 2 && iterations != 1; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if(runCLKernels(isNaive) != SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
    }

    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    std::cout << "Executing kernel for " << iterations
              << " iterations" << std::endl;
    std::cout <<"-------------------------------------------" << std::endl;

    for(int i = 0; i < iterations; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if(runCLKernels(isNaive) != SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
    }
    printf("average time = %lf\n", (double)(avgTime/(1000000.0*100.0)));
    sampleTimer->stopTimer(timer);
    // Compute kernel time
    kernelTime = (double)(sampleTimer->readTimer(timer)) / iterations;

/*    if(!sampleArgs->quiet)
    {
        printArray<cl_float>("deviceCallPrice",
                             deviceCallPrice,
                             width,
                             1);

        printArray<cl_float>("devicePutPrice",
                             devicePutPrice,
                             width,
                             1);
    }*/
    return SDK_SUCCESS;
}

int
BlackScholes::verifyResults()
{
 //   if(sampleArgs->verify)
 //   {
        /* reference implementation
         * it overwrites the input array with the output
         */
        blackScholesCPU();

/*       if(!sampleArgs->quiet)
        {
            printArray<cl_float>("hostCallPrice",
                                 hostCallPrice,
                                 width,
                                 1);

            printArray<cl_float>("hostPutPrice",
                                 hostPutPrice,
                                 width,
                                 1);
        }
*/

        // compare the call/put price results and see if they match
        bool callPriceResult = compare(hostCallPrice, deviceCallPrice,
                                       width * height * 4);
        bool putPriceResult = compare(hostPutPrice, devicePutPrice, width * height * 4,
                                      1e-4f);
 /*       printf("CallPrice: host vs device  = %f    %f \n", *hostCallPrice, *deviceCallPrice);
	printf("put price: host vs device = %f     %f \n", *hostPutPrice, *devicePutPrice);
        
        for (int i =0; i < width * height; i++){
		printf("%f vs  %f  \n", hostPutPrice[i], devicePutPrice[i]);
		printf("%f vs  %f  \n", hostCallPrice[i], devicePutPrice[i]);

	}*/
	if(!(callPriceResult ? (putPriceResult ? true : false) : false))
        {
            std::cout << "Failed\n" << std::endl;
            return SDK_FAILURE;
        }
        else
        {
            std::cout << "Passed!\n" << std::endl;
            return SDK_SUCCESS;
        }
  //  }

    return SDK_SUCCESS;
}

void
BlackScholes::printStats()
{

    if(sampleArgs->timing)
    {
        int actualSamples = width * height * 4;
        sampleTimer->totalTime = setupTime + kernelTime;

        std::string strArray[4] =
        {
            "Option Samples",
            "Time(sec)",
            "[Transfer+kernel]Time(sec)",
            "Options/sec"
        };

        std::string stats[4];
        stats[0] = toString(actualSamples, std::dec);
        stats[1] = toString(sampleTimer->totalTime, std::dec);
        stats[2] = toString(kernelTime, std::dec);
        stats[3] = toString(actualSamples / sampleTimer->totalTime, std::dec);

        printStatistics(strArray, stats, 4);

    }
}

int BlackScholes::cleanup()
{
    // Releases OpenCL resources (Context, Memory etc.)
    cl_int status;
    status = clReleaseMemObject(randBuf);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject(randBuf) failed.");

    status = clReleaseMemObject(callPriceBuf);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject(callPriceBuf) failed.");

    status = clReleaseMemObject(putPriceBuf);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject(callPriceBuf) failed.");

    status = clReleaseKernel(kernel);
    CHECK_OPENCL_ERROR(status, "clReleaseKernel(kernel) failed.");

    status = clReleaseProgram(program);
    CHECK_OPENCL_ERROR(status, "clReleaseProgram(program) failed.");

    status = clReleaseCommandQueue(commandQueue);
    CHECK_OPENCL_ERROR(status, "clReleaseCommandQueue(commandQueue) failed.");

    status = clReleaseContext(context);
    CHECK_OPENCL_ERROR(status, "clReleaseContext(context) failed.");

    status = clReleaseMemObject(degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");

    status = clReleaseMemObject(CUdegradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");
 
 
    // Release program resources (input memory etc.)

#ifdef _WIN32
    ALIGNED_FREE(randArray);
#else
    FREE(randArray);
#endif

    FREE(deviceCallPrice);
    FREE(devicePutPrice);
    FREE(hostCallPrice);
    FREE(hostPutPrice);
    FREE(devices);

    FREE(degradationStatus);
    FREE(CUdegradationStatus);
    FREE(degraded_CU_id);
    FREE(degraded_lane_id);
    return SDK_SUCCESS;
}

int
main(int argc, char * argv[])
{
    // Create MonteCalroAsian object
    BlackScholes clBlackScholes;

    // Initialization
    if(clBlackScholes.initialize() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    // Parse command line options
    if(clBlackScholes.sampleArgs->parseCommandLine(argc, argv))
    {
        return SDK_FAILURE;
    }
    clBlackScholes.blockSizeY = clBlackScholes.sampleArgs->WIcount/16;///16;
    clBlackScholes.blockSizeX = 16;//16;
//    clBlackScholes.width = clBlackScholes.blockSizeY*10;
//    clBlackScholes.height =clBlackScholes.blockSizeX*10;
    clBlackScholes.NumDEGRADED = clBlackScholes.sampleArgs->numDegraded;
    clBlackScholes.GROUP_SIZE = clBlackScholes.sampleArgs->WIcount;
    clBlackScholes.degraded_CU_id = (int *) malloc(clBlackScholes.NumDEGRADED * sizeof(int));
    clBlackScholes.degraded_lane_id = (int *) malloc(clBlackScholes.NumDEGRADED * sizeof(int));
 

//    clBlackScholes.width = clBlackScholes.blockSizeY*5;
//    clBlackScholes.height =clBlackScholes.blockSizeX;//*4;
    if(clBlackScholes.sampleArgs->isDumpBinaryEnabled())
    {
        return clBlackScholes.genBinaryImage();
    }
    else
    {
    if(clBlackScholes.setupBlackScholes() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
	if (clBlackScholes.sampleArgs->kernelType){
        	// Setup
        	if(clBlackScholes.setup(false) !=SDK_SUCCESS)
        	{
            	return SDK_FAILURE;
        	}

       		 // Run
        	if(clBlackScholes.run(false) !=SDK_SUCCESS)
        	{
            	return SDK_FAILURE;
        	}
	}
	else{
        	// Setup
        	if(clBlackScholes.setup(true) !=SDK_SUCCESS)
        	{
            	return SDK_FAILURE;
        	}

        	// Run
        	if(clBlackScholes.run(true) !=SDK_SUCCESS)
        	{
            	return SDK_FAILURE;
        	}
	}
        // Verifty
        if(clBlackScholes.verifyResults() !=SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
        // Print performance statistics
        clBlackScholes.printStats();

        if(clBlackScholes.cleanup() !=SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }



    }



    return SDK_SUCCESS;
}
