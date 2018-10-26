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


#include "FastWalshTransform.hpp"
//const int degraded_CU_id = 7;
//const int degraded_lane_id = 2;


int
FastWalshTransform::setupFastWalshTransform()
{
    cl_uint inputSizeBytes;

    if(length < 512)
    {
        length = 512;
    }

    printf("input length = %d float \n", length);
    // allocate and init memory used by host
    inputSizeBytes = length * sizeof(cl_float);
    printf("input size = %d Bytes \n", inputSizeBytes);
    input = (cl_float *) malloc(inputSizeBytes);
    CHECK_ALLOCATION(input, "Failed to allocate host memory. (input)");

    output = (cl_float *) malloc(inputSizeBytes);
    CHECK_ALLOCATION(output, "Failed to allocate host memory. (output)");

    // random initialisation of input
    fillRandom<cl_float>(input, length, 1, 0, 255);

//    if(sampleArgs->verify)
//    {
        verificationInput = (cl_float *) malloc(inputSizeBytes);
        CHECK_ALLOCATION(verificationInput,
                         "Failed to allocate host memory. (verificationInput)");
        memcpy(verificationInput, input, inputSizeBytes);
//    }

    // Unless sampleArgs->quiet mode has been enabled, print the INPUT array.
/*    if(!sampleArgs->quiet)
    {
        printArray<cl_float>(
            "Input",
            input,
            length,
            1);
    }*/

	NumDouble = 1;
	int i = 1;
	degraded_CU_id[0] = (unsigned int) rand() % CU_Count;
	degraded_lane_id[0] = (unsigned int) rand() % SC_Count;
	while (i < NumDEGRADED){
    	//	if (i < 3){
		degraded_lane_id[i] = (degraded_lane_id[i-1] + rand() % 2 + 1) % SC_Count;
		degraded_CU_id[i] = degraded_CU_id[0];
		//	degraded_CU_id[i] = (degraded_CU_id[i-1] + /*rand()%2+*/1 )%20;
		//	degraded_lane_id[i] = (unsigned int) rand() % 16;
	/*	}
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
	
		}*/ 
		i++;
	}

    for (int i =0; i < NumDEGRADED; i++)
	printf("faulty element = (%d %d)  ", degraded_CU_id[i], degraded_lane_id[i]) ;
    printf("\n");


    return SDK_SUCCESS;
}


int
FastWalshTransform::genBinaryImage()
{
    bifData binaryData;
    binaryData.kernelName = std::string("FastWalshTransform_Kernels.cl");
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
FastWalshTransform::setupCL(bool isNaive)
{
    cl_int status = 0;
    cl_device_type dType;

    if(sampleArgs->deviceType.compare("cpu") == 0)
    {
        dType = CL_DEVICE_TYPE_CPU;
    }
    else //sampleArgs->deviceType = "gpu"
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
    CHECK_ERROR(retValue, SDK_SUCCESS, "getPlatform() failed");

    // Display available devices.
    retValue = displayDevices(platform, dType);
    CHECK_ERROR(retValue, SDK_SUCCESS, "displayDevices() failed");


    /*
     * If we could find our platform, use it. Otherwise use just available platform.
     */
    cl_context_properties cps[3] =
    {
        CL_CONTEXT_PLATFORM,
        (cl_context_properties)platform,
        0
    };

    context = clCreateContextFromType(
                  cps,
                  dType,
                  NULL,
                  NULL,
                  &status);
    CHECK_OPENCL_ERROR( status, "clCreateContextFromType failed.");

    // getting device on which to run the sample
    status = getDevices(context, &devices, sampleArgs->deviceId,
                        sampleArgs->isDeviceIdEnabled());
    CHECK_ERROR(status, SDK_SUCCESS, "getDevices() failed");

    {
        // The block is to move the declaration of prop closer to its use
        cl_command_queue_properties prop = 0;
        commandQueue = clCreateCommandQueue(
                           context,
                           devices[sampleArgs->deviceId],
                           CL_QUEUE_PROFILING_ENABLE,
                           &status);
        CHECK_OPENCL_ERROR( status, "clCreateCommandQueue failed.");
    }

    //Set device info of given cl_device_id
    retValue = deviceInfo.setDeviceInfo(devices[sampleArgs->deviceId]);
    CHECK_ERROR(retValue, SDK_SUCCESS, "SDKDeviceInfo::setDeviceInfo() failed");

    inputBuffer = clCreateBuffer(
                      context,
                      CL_MEM_READ_WRITE,
                      sizeof(cl_float) * length,
                      0,
                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (inputBuffer)");

    // create a CL program using the kernel source
    buildProgramData buildData;
    if (isNaive)
    	buildData.kernelName = std::string("FastWalshTransform_Kernels.cl");
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
    kernel = clCreateKernel(program, "fastWalshTransform", &status);
    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.");

    return SDK_SUCCESS;
}


int
FastWalshTransform::runCLKernels(bool isNaiveVersion)
{
    cl_int   status;
    size_t globalThreads[1];
    size_t localThreads[1];
    double total_kernel_exeTime = 0; 

    /*
     * The kernel performs a butterfly operation and it runs for half the
     * total number of input elements in the array.
     * In each pass of the kernel two corresponding elements are found using
     * the butterfly operation on an array of numbers and their sum and difference
     * is stored in the same locations as the numbers
     */

    globalThreads[0] = length / 2;
    localThreads[0]  = 128;//length/32; //length/(2*32);    //128) ; ///length/(2*16);

/*   if (!isNaiveVersion && localThreads[0] == 256){
	localThreads[0] = localThreads[0]/2;
   }*/
   cl_int work_item_count = 128;

	std::ostringstream os;
	os << "timing_" << NumDEGRADED << "_256.csv";
	std::string fname = os.str(); 
	std::ofstream foutput_time;
	foutput_time.open(fname.c_str(), std::ios_base::out | std::ios_base::app);



    printf("work_item_count = %d \n", work_item_count);
if (isNaiveVersion){	
    printf("Naive kernel: \n");
    printf("globalThreads = %d, localThreads = %d , maxWorkItemSize = %d, maxWorkGroupSize = %d \n", globalThreads[0], localThreads[0], *(deviceInfo.maxWorkItemSizes), deviceInfo.maxWorkGroupSize);
}
else{
	uint redundant_wi = ceil((float)((float)work_item_count/(float)SC_Count)) * NumDEGRADED;
	for (int i = work_item_count; i < work_item_count+redundant_wi; i++){
		for (int j = 0; j < NumDEGRADED; j++)
			if (i % SC_Count == degraded_lane_id[j])
				redundant_wi++;
	}

        //        redundant_wi = redundant_wi * NumDouble;  
 		printf("redundant wi = %d \n", redundant_wi);	
   		localThreads[0] = work_item_count + redundant_wi;
    	//	globalThreads[0] = (globalThreads[0]/work_item_count) * (work_item_count + redundant_wi);
    		globalThreads[0] = ceil((double)((double)globalThreads[0]/(double)work_item_count * (double)(work_item_count + redundant_wi)));

/*    uint redundant_wi = ceil((float)((float)work_item_count/16.0)) ;
  for (int i = work_item_count; i < work_item_count+redundant_wi; i++)
		if (i % 16 == 0)
			redundant_wi++;

    redundant_wi = redundant_wi * NumDouble;  
  printf("redundant wi = %d \n", redundant_wi);	
    localThreads[0] = work_item_count + redundant_wi;
    globalThreads[0] = (globalThreads[0]/work_item_count) * (work_item_count + redundant_wi);*/
    printf("Aging enabled kernel: \n");
    printf("globalThreads = %d, localThreads = %d \n", globalThreads[0], localThreads[0]);
}

    // Check group size against kernelWorkGroupSize
    status = kernelInfo.setKernelWorkGroupInfo(kernel,
             devices[sampleArgs->deviceId]);
    CHECK_OPENCL_ERROR(status, "kernelInfo.setKernelWorkGroupInfo failed.");

    if((cl_uint)(localThreads[0]) > kernelInfo.kernelWorkGroupSize)
    {
        if(!sampleArgs->quiet)
        {
            std::cout << "Out of Resources!" << std::endl;
            std::cout << "Group Size specified : " << localThreads[0] << std::endl;
            std::cout << "Max Group Size supported on the kernel : "
                      << kernelInfo.kernelWorkGroupSize << std::endl;
            std::cout<<"Changing the group size to " << kernelInfo.kernelWorkGroupSize
                     << std::endl;
        }
        localThreads[0] = kernelInfo.kernelWorkGroupSize;
    }



    degradationStatus = (cl_uint *) malloc(globalThreads[0]*sizeof(cl_uint));
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
		printf("# degraded WIs = %d  out of %d WIs\n", counter, globalThreads[0]);

	  // Create memory object for degStat Image
	    degradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY,
				   globalThreads[0] * sizeof(cl_uint), //to be parametric
				   0,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (degradationBufer)");
	  // Create memory object for degStat Image
	    CUdegradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY,
				   globalThreads[0] * sizeof(cl_char), //to be parametric
				   0,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (CUdegradationBufer)");


    // Enqueue write input to inputBuffer
    cl_event writeEvt;
    status = clEnqueueWriteBuffer(
                 commandQueue,
                 inputBuffer,
                 CL_FALSE,
                 0,
                 length * sizeof(cl_float),
                 input,
                 0,
                 NULL,
                 &writeEvt);
    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.(commandQueue)");

    status = waitForEventAndRelease(&writeEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(writeEvt) Failed");


	    cl_event degEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 degradationStatusBuffer,
			 CL_FALSE,
			 0,
			 globalThreads[0] * sizeof(cl_uint),
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
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (CUdegStatBuffer)");

	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&cudegEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(cudegEvt) Failed");


    // Set appropriate arguments to the kernel

    // the input array - also acts as output
    status = clSetKernelArg(
                 kernel,
                 0,
                 sizeof(cl_mem),
                 (void *)&inputBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (inputBuffer)");
   
   // degradationStatBuffer
    status = clSetKernelArg(
		 kernel,
		 2,
		 sizeof(cl_mem),
		 &degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (degradationStatBuffer)");


/////
   if (!isNaiveVersion){
   // degradationStatBuffer
    status = clSetKernelArg(
		 kernel,
		 3,
		 sizeof(cl_mem),
		 &CUdegradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (CUdegradationStatBuffer)");


    status = clSetKernelArg(kernel,
                            4,
                            sizeof(int),
                            (void*)&work_item_count);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg(work_item_count) failed.");

  }



    for(cl_int step = 1; step < length; step <<= 1)
    {
        // stage of the algorithm
        status = clSetKernelArg(
                     kernel,
                     1,
                     sizeof(cl_int),
                     (void *)&step);
        CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (step)");

        // Enqueue a kernel run call
        cl_event ndrEvt;
       // printf("globalThreads = %d, localThreads = %d\n", globalThreads[0], localThreads[0]);
        status = clEnqueueNDRangeKernel(
                     commandQueue,
                     kernel,
                     1,
                     NULL,
                     globalThreads,
                     localThreads,
                     0,
                     NULL,
                     &ndrEvt);
        CHECK_OPENCL_ERROR(status, "clEnqueueNDRangeKernel failed.");

        status = clFinish(commandQueue);
        CHECK_OPENCL_ERROR(status, "clFinish failed.(commandQueue)");

        status = clWaitForEvents(1, &ndrEvt);
        CHECK_ERROR(status, SDK_SUCCESS, "WaitForEvents(ndrEvt) Failed");

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
    total_kernel_exeTime += total_time;
     clReleaseEvent(ndrEvt);
//////////////////////////////// end timing
 
    }


    // Enqueue readBuffer
    cl_event readEvt;
    status = clEnqueueReadBuffer(
                 commandQueue,
                 inputBuffer,
                 CL_FALSE,
                 0,
                 length *  sizeof(cl_float),
                 output,
                 0,
                 NULL,
                 &readEvt);
    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.(commandQueue)");

    status = waitForEventAndRelease(&readEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(readEvt) Failed");

    printf("\nTotal kernel execution time = %0.3f ms\n", (total_kernel_exeTime / 1000000.0) );	
   foutput_time << (double)(total_kernel_exeTime/1000000.0) << "\n"; 
	foutput_time.close();


    return SDK_SUCCESS;
}

/*
 * This is the reference implementation of the FastWalsh transform
 * Here we perform the buttery operation on an array on numbers
 * to get and pair and a match indices. Their sum and differences are
 * stored in the corresponding locations and is used in the future
 * iterations to get a transformed array
 */
void
FastWalshTransform::fastWalshTransformCPUReference(
    cl_float * vinput,
    const cl_uint length)
{
    // for each pass of the algorithm
    for(cl_uint step = 1; step < length; step <<= 1)
    {
        // length of each block
        cl_uint jump = step << 1;
        // for each blocks
        for(cl_uint group = 0; group < step; ++group)
        {
            // for each pair of elements with in the block
            for(cl_uint pair = group; pair < length; pair += jump)
            {
                // find its partner
                cl_uint match = pair + step;

                cl_float T1 = vinput[pair];
                cl_float T2 = vinput[match];

                // store the sum and difference of the numbers in the same locations
                vinput[pair] = T1 + T2;
                vinput[match] = T1 - T2;
            }
        }
    }
}

int
FastWalshTransform::initialize()
{
    // Call base class Initialize to get default configuration
    if(sampleArgs->initialize() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    // Now add customized options
    Option* signal_length = new Option;
    CHECK_ALLOCATION(signal_length, "Memory allocation error.\n");

    signal_length->_sVersion = "x";
    signal_length->_lVersion = "length";
    signal_length->_description = "Length of input array";
    signal_length->_type = CA_ARG_INT;
    signal_length->_value = &length;
    sampleArgs->AddOption(signal_length);
    delete signal_length;

    Option* num_iterations = new Option;
    CHECK_ALLOCATION(num_iterations, "Memory allocation error.\n");

    num_iterations->_sVersion = "i";
    num_iterations->_lVersion = "iterations";
    num_iterations->_description = "Number of iterations for kernel execution";
    num_iterations->_type = CA_ARG_INT;
    num_iterations->_value = &iterations;

    sampleArgs->AddOption(num_iterations);
    delete num_iterations;

    return SDK_SUCCESS;
}

int
FastWalshTransform::setup(bool isNaive)
{
    // make sure the length is the power of 2
    if(isPowerOf2(length))
    {
        length = roundToPowerOf2(length);
    }

    if(setupFastWalshTransform() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    if(setupCL(isNaive) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    sampleTimer->stopTimer(timer);
    setupTime = (cl_double)sampleTimer->readTimer(timer);

    return SDK_SUCCESS;
}


int
FastWalshTransform::run(bool isNaive)
{
    // Warm up
    for(int i = 0; i < 2 && iterations != 1; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if(runCLKernels(isNaive) != SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
    }

    std::cout << "Executing kernel for " << iterations
              << " iterations" << std::endl;
    std::cout << "-------------------------------------------" << std::endl;

    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    for(int i = 0; i < iterations; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if(runCLKernels(isNaive) != SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
    }

    sampleTimer->stopTimer(timer);
    totalKernelTime = (double)(sampleTimer->readTimer(timer)) / iterations;

 /*   if(!sampleArgs->quiet)
    {
        printArray<cl_float>("Output", input, length, 1);
    }
*/
    return SDK_SUCCESS;
}

int
FastWalshTransform::verifyResults()
{
//    if(sampleArgs->verify)
//    {
        /*
         * reference implementation
         * it overwrites the input array with the output
         */
        int refTimer = sampleTimer->createTimer();
        sampleTimer->resetTimer(refTimer);
        sampleTimer->startTimer(refTimer);

        fastWalshTransformCPUReference(verificationInput, length);

        sampleTimer->stopTimer(refTimer);
        referenceKernelTime = sampleTimer->readTimer(refTimer);

        // compare the results and see if they match
        if(compare(output, verificationInput, length))
        {
            std::cout << "Passed!\n" << std::endl;
            return SDK_SUCCESS;
        }
        else
        {
            std::cout << "Failed\n" << std::endl;
            return SDK_FAILURE;
        }
//    }

    return SDK_SUCCESS;
}

void
FastWalshTransform::printStats()
{
    if(sampleArgs->timing)
    {
        std::string strArray[3] = {"Length", "Time(sec)", "[Transfer+Kernel]Time(sec)"};
        std::string stats[3];

        sampleTimer->totalTime = setupTime + totalKernelTime ;

        stats[0] = toString(length, std::dec);
        stats[1] = toString(sampleTimer->totalTime, std::dec);
        stats[2] = toString(totalKernelTime, std::dec);

        printStatistics(strArray, stats, 3);
    }
}
int
FastWalshTransform::cleanup()
{
    // Releases OpenCL resources (Context, Memory etc.)
    cl_int status;

    status = clReleaseKernel(kernel);
    CHECK_OPENCL_ERROR(status, "clReleaseKernel failed.(kernel)");

    status = clReleaseProgram(program);
    CHECK_OPENCL_ERROR(status, "clReleaseProgram failed.(program)");

    status = clReleaseMemObject(inputBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(inputBuffer)");

    status = clReleaseCommandQueue(commandQueue);
    CHECK_OPENCL_ERROR(status, "clReleaseCommandQueue failed.(commandQueue)");

    status = clReleaseContext(context);
    CHECK_OPENCL_ERROR(status, "clReleaseContext failed. (context)");

status = clReleaseMemObject(degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");
 
status = clReleaseMemObject(CUdegradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");

    // release program resources (input memory etc.)

    FREE(input);
    FREE(output);
    FREE(verificationInput);
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
    FastWalshTransform clFastWalshTransform;

    // Initialize
    if( clFastWalshTransform.initialize() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    if(clFastWalshTransform.sampleArgs->parseCommandLine(argc, argv))
    {
        return SDK_FAILURE;
    }
    
    clFastWalshTransform.length = clFastWalshTransform.sampleArgs->WIcount * 2 * 16;
    clFastWalshTransform.NumDEGRADED = clFastWalshTransform.sampleArgs->numDegraded;

    clFastWalshTransform.degraded_CU_id = (int *) malloc(clFastWalshTransform.NumDEGRADED * sizeof(int));
    clFastWalshTransform.degraded_lane_id = (int *) malloc(clFastWalshTransform.NumDEGRADED * sizeof(int));



//    int localTh  = clFastWalshTransform.length/(2*128) ; ///length/(2*16);
 
    if(clFastWalshTransform.sampleArgs->isDumpBinaryEnabled())
    {
        return clFastWalshTransform.genBinaryImage();
    }

   if (clFastWalshTransform.sampleArgs->kernelType){
	/// Degraded
//////////////////// Atieh
/*    uint redundant_wi = ceil((float)((float)localTh/16.0)) ;

    redundant_wi++;

    redundant_wi = redundant_wi * (1 + clFastWalshTransform.NumDEGRADED/3);
    if (redundant_wi + localTh > 256)
	localTh = 256;
    clFastWalshTransform.length = localTh * 256;*/
   	// Setup
    	if(clFastWalshTransform.setup(false) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
    	}

   	 // Run
   	 if(clFastWalshTransform.run(false) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
    	}
} 
else{
/// Naive
   // Setup
    if(clFastWalshTransform.setup(true) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
    if(clFastWalshTransform.setupFastWalshTransform() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }


    // Run
    if(clFastWalshTransform.run(true) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
}
    // VerifyResults
    if(clFastWalshTransform.verifyResults() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    // Cleanup
    if(clFastWalshTransform.cleanup() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
    clFastWalshTransform.printStats();

    return SDK_SUCCESS;
}
