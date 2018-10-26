/**********************************************************************
Copyright ©2013 Advanced Micro Devices, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************/


#include "SimpleConvolution.hpp"
//const int degraded_CU_id = 5;
//const int degraded_lane_id = 2;


int SimpleConvolution::setupSimpleConvolution()
{
    cl_uint inputSizeBytes;

    if(width * height < 256)
    {
        width = 64;
        height = 64;
    }

    // allocate and init memory used by host
   printf("input length = %d x %d int \n", width, height); 
   printf("input size = %d bytes \n", width*height*sizeof(cl_uint)); 
    inputSizeBytes = width * height * sizeof(cl_uint);
    input  = (cl_uint *) malloc(inputSizeBytes);
    CHECK_ALLOCATION(input, "Failed to allocate host memory. (input)");

    output = (cl_uint  *) malloc(inputSizeBytes);
    CHECK_ALLOCATION(output, "Failed to allocate host memory. (output)");


    cl_uint maskSizeBytes = maskWidth * maskHeight * sizeof(cl_float);
    mask = (cl_float  *) malloc(maskSizeBytes);
    CHECK_ALLOCATION(mask, "Failed to allocate host memory (mask)");

   printf("mask size = %d bytes \n", maskSizeBytes); 
    // random initialisation of input
    fillRandom<cl_uint >(input, width, height, 0, 255);

    // Fill a blurr filter or some other filter of your choice
    for(cl_uint i = 0; i < maskWidth*maskHeight; i++)
    {
        mask[i] = 0;
    }

    cl_float val = 1.0f / (maskWidth * 2.0f - 1.0f);

    for(cl_uint i = 0; i < maskWidth; i++)
    {
        cl_uint y = maskHeight / 2;
        mask[y * maskWidth + i] = val;
    }

    for(cl_uint i = 0; i < maskHeight; i++)
    {
        cl_uint x = maskWidth / 2;
        mask[i * maskWidth + x] = val;
    }

    // Unless quiet mode has been enabled, print the INPUT array.
/*    if(!sampleArgs->quiet)
    {
        printArray<cl_uint >(
            "Original Input",
            input,
            width,
            1);
        printArray<cl_float >(
            "mask",
            mask,
            maskWidth,
            maskHeight);
    }
*/

	NumDouble = 1;
	int i = 1;
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
	
		} 
	*/	i++;
	}
	printf("faulty element = ");
    for (int i =0; i < NumDEGRADED; i++)
	printf("  (%d %d) ", degraded_CU_id[i], degraded_lane_id[i]) ;
	printf ("\n");

    return SDK_SUCCESS;
}


int
SimpleConvolution::genBinaryImage()
{
    bifData binaryData;
    binaryData.kernelName = std::string("SimpleConvolution_Kernels.cl");
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
SimpleConvolution::setupCL(bool isNaive)
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
    CHECK_ERROR(retValue, SDK_SUCCESS, "getPlatform() failed");

    // Display available devices.
    retValue = displayDevices(platform, dType);
    CHECK_ERROR(retValue, SDK_SUCCESS, "displayDevices() failed");


    // If we could find our platform, use it. Otherwise use just available platform.
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

    inputBuffer = clCreateBuffer(
                      context,
                      CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR,
                      sizeof(cl_uint ) * width * height,
                      input,
                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (inputBuffer)");

    outputBuffer = clCreateBuffer(
                       context,
                       CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR,
                       sizeof(cl_uint ) * width * height,
                       output,
                       &status);
    CHECK_OPENCL_ERROR( status,  "clCreateBuffer failed. (outputBuffer)");

    maskBuffer = clCreateBuffer(
                     context,
                     CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR,
                     sizeof(cl_float ) * maskWidth * maskHeight,
                     mask,
                     &status);
    CHECK_OPENCL_ERROR( status, "clCreateBuffer failed. (maskBuffer)");

    // create a CL program using the kernel source
    buildProgramData buildData;
    if (isNaive)
    	buildData.kernelName = std::string("SimpleConvolution_Kernels.cl");
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
    kernel = clCreateKernel(program, "simpleConvolution", &status);
    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.");

    return SDK_SUCCESS;
}

int SimpleConvolution::setWorkGroupSize(bool isNaiveVersion)
{
    cl_int status = 0;
    status = kernelInfo.setKernelWorkGroupInfo(kernel,
             devices[sampleArgs->deviceId]);
    CHECK_ERROR(status, SDK_SUCCESS, " setKernelWorkGroupInfo() failed");
/*    int min_deg_lane = degraded_lane_id[0];
    for (int i = 0; i < NumDEGRADED; i++){
	if (degraded_lane_id[i] < min_deg_lane){
		min_deg_lane = degraded_lane_id[i];
	}
    }*/

    globalThreads[0] = width*height;
    
/*    if (!isNaiveVersion && localTh == 256){
	localThreads[0] = 128;
    }*/
    work_item_count =localTh; //localThreads[0];
    cl_int prv_wic = localTh;//localThreads[0];

if (isNaiveVersion){	
    localThreads[0]  = localTh;//256;
    printf("Naive kernel: \n");
    printf("globalThreads = %d, localThreads = %d  \n", globalThreads[0], localThreads[0]);
}
else{
		uint redundant_wi = ceil((float)((float)work_item_count/(float)SC_Count)) * NumDEGRADED;
		for (int i = work_item_count; i < work_item_count+redundant_wi; i++){
			for (int j = 0; j < NumDEGRADED; j++)
				if (i % SC_Count == degraded_lane_id[j])
					redundant_wi++;
		}
		printf("redundant wi = %d \n", redundant_wi);	
    		localThreads[0] = work_item_count + redundant_wi;
    		//globalThreads[0] = (globalThreads[0]/work_item_count) * (work_item_count + redundant_wi);
    		globalThreads[0] = ceil((double)((double)globalThreads[0]/(double)work_item_count * (double)(work_item_count + redundant_wi)));

/*
    uint redundant_wi = ceil((float)((float)work_item_count/SC_Count)) ;

 for (int i = work_item_count; i < work_item_count+redundant_wi; i++)
		if (i % SC_Count == min_deg_lane)
			redundant_wi++;
    redundant_wi = redundant_wi * NumDouble;
    printf("redundant wi = %d \n", redundant_wi);	
    if (redundant_wi + work_item_count > 256)
	work_item_count = 256 - redundant_wi;
 
    localThreads[0] = work_item_count + redundant_wi;
    globalThreads[0] = (globalThreads[0]/prv_wic) * localThreads[0];
*/    printf("Aging enabled kernel: \n");
    printf("globalThreads = %d, localThreads = %d work_item_count = %d redundant_wi = %d \n", globalThreads[0], localThreads[0], work_item_count, redundant_wi);
}

    if((cl_uint)(localThreads[0]) > kernelInfo.kernelWorkGroupSize)
    {
        if(!sampleArgs->quiet)
        {
            std::cout << "Out of Resources!" << std::endl;
            std::cout << "Group Size specified : "<< localThreads[0]
                      << std::endl;
            std::cout << "Max Group Size supported on the kernel : "
                      << kernelInfo.kernelWorkGroupSize <<std::endl;
            std::cout <<"Changing the group size to " << kernelInfo.kernelWorkGroupSize
                      << std::endl;
        }

//        localThreads[0] = kernelInfo.kernelWorkGroupSize;   //Atieh
    }

    degradationStatus = (cl_char *) malloc(globalThreads[0]*sizeof(cl_char));
    CHECK_ALLOCATION(degradationStatus, "Failed to allocate memory! (degradationStatus)");


//    degradationStatus = (cl_char *) malloc(globalThreads[0]*sizeof(cl_char));
//    CHECK_ALLOCATION(degradationStatus, "Failed to allocate memory! (degradationStatus)");

     	int counter = 0;
    	for (int i=0; i<globalThreads[0]/localThreads[0]; i++){	
		for (int j = 0; j < localThreads[0]; j++){
			
			degradationStatus[i*localThreads[0]+j] = 0;
			for (int k = 0; k < NumDEGRADED; k++){
				if ((i % CU_Count) == degraded_CU_id[k] && ((j%SC_Count) == degraded_lane_id[k])){
					degradationStatus[i*localThreads[0]+j] = 1;
					counter++;
				}
			}
		}
    	} 
		printf("# degraded WIs = %d \n", counter);

	  // Create memory object for degStat Image
	    degradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
				   globalThreads[0] * sizeof(cl_char), //  * sizeof(cl_uint),
				   degradationStatus, //0,
				   &status);
            
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (degradationBufer)");
	    printf("degradationStatusBuffer size = %d %d %d \n", globalThreads[0] * sizeof(cl_char), sizeof(cl_bool), sizeof(cl_char));



    return SDK_SUCCESS;
}

int
SimpleConvolution::runCLKernels(bool isNaiveVersion)
{
    cl_int   status;
    cl_event events[2];

	std::ostringstream os;
	os << "timing_" << NumDEGRADED << "_" << localTh << ".csv";
	std::string fname = os.str(); 
	std::ofstream foutput_time;
	foutput_time.open(fname.c_str(), std::ios_base::out | std::ios_base::app);


    status = this->setWorkGroupSize(isNaiveVersion);
    CHECK_ERROR(status, SDK_SUCCESS, "setWorkGroupSize() failed");

	    cl_event degEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 degradationStatusBuffer,
			 CL_FALSE,
			 0,
			 globalThreads[0] * sizeof(cl_char), //cl_uint
			 degradationStatus,
			 0,
			 NULL,
			 &degEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (degStatBuffer)");

	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&degEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(degEvt) Failed");
	


    // Set appropriate arguments to the kernel
    status = clSetKernelArg(
                 kernel,
                 0,
                 sizeof(cl_mem),
                 (void *)&outputBuffer);
    CHECK_OPENCL_ERROR( status, "clSetKernelArg failed. (outputBuffer)");

    status = clSetKernelArg(
                 kernel,
                 1,
                 sizeof(cl_mem),
                 (void *)&inputBuffer);
    CHECK_OPENCL_ERROR( status, "clSetKernelArg failed. (inputBuffer)");

    status = clSetKernelArg(
                 kernel,
                 2,
                 sizeof(cl_mem),
                 (void *)&maskBuffer);
    CHECK_OPENCL_ERROR( status, "clSetKernelArg failed. (maskBuffer)");

    cl_uint2 inputDimensions = {width, height};
    cl_uint2 maskDimensions  = {maskWidth, maskHeight};

    status = clSetKernelArg(
                 kernel,
                 3,
                 sizeof(cl_uint2),
                 (void *)&inputDimensions);
    CHECK_OPENCL_ERROR( status, "clSetKernelArg failed. (inputDimensions)");

    status = clSetKernelArg(
                 kernel,
                 4,
                 sizeof(cl_uint2),
                 (void *)&maskDimensions);
    CHECK_OPENCL_ERROR( status, "clSetKernelArg failed. (maskDimensions)");

// degradationStatBuffer
    status = clSetKernelArg(
		 kernel,
		 5,
		 sizeof(cl_mem),
		 &degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (degradationStatBuffer)");




/////
   if (!isNaiveVersion){
    status = clSetKernelArg(kernel,
                            6,
                            sizeof(int),
                            (void*)&work_item_count);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg(work_item_count) failed.");

  }


//    printf("localThread = %d,  globalThreads = %d \n", localThreads[0], globalThreads[0]);

    // Enqueue a kernel run call.
    status = clEnqueueNDRangeKernel(
                 commandQueue,
                 kernel,
                 1,
                 NULL,
                 globalThreads,
                 localThreads,
                 0,
                 NULL,
                 &events[0]);
    CHECK_OPENCL_ERROR( status, "clEnqueueNDRangeKernel failed.");

    status = clFinish(commandQueue);
    CHECK_OPENCL_ERROR(status,"clFinish() failed");

    status = clWaitForEvents(1, &events[0]);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(events[0]) Failed");
////////////////////////////////timing

    cl_ulong time_start, time_end;
    double total_time;
    clGetEventProfilingInfo(events[0], CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL);
    if (status != CL_SUCCESS) {
        printf("clGetEventProfilingInfo(COMMAND_START) failed: 1\n");
	time_start = 0;
    }
    clGetEventProfilingInfo(events[0], CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL);
    if (status != CL_SUCCESS) {
       printf("clGetEventProfilingInfo(COMMAND_END) failed: 2\n");
       time_end = 0;
    }	 
    total_time = (double) (time_end - time_start);
//    total_kernel_exeTime += total_time;
    printf("\nTotal kernel execution time = %0.3f ms\n", (total_time / 1000000.0) );
	foutput_time << (double)(total_time/1000000.0) << "\n"; 
	foutput_time.close();

     clReleaseEvent(events[0]);
//////////////////////////////// end timing
 
    // Enqueue readBuffer
    status = clEnqueueReadBuffer(
                 commandQueue,
                 outputBuffer,
                 CL_TRUE,
                 0,
                 width * height * sizeof(cl_uint),
                 output,
                 0,
                 NULL,
                 &events[1]);
    CHECK_OPENCL_ERROR( status, "clEnqueueReadBuffer failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status,"clFlush() failed");

    status = waitForEventAndRelease(&events[1]);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(events[1]) Failed");


    return SDK_SUCCESS;
}

/**
 * Reference CPU implementation of Simple Convolution
 * for performance comparison
 */
void
SimpleConvolution::simpleConvolutionCPUReference(cl_uint  *output,
        const cl_uint  *input,
        const cl_float *mask,
        const cl_uint  width,
        const cl_uint height,
        const cl_uint maskWidth,
        const cl_uint maskHeight)
{
    cl_uint vstep = (maskWidth  - 1) / 2;
    cl_uint hstep = (maskHeight - 1) / 2;

    // for each pixel in the input
    for(cl_uint x = 0; x < width; x++)
        for(cl_uint y = 0; y < height; y++)
        {
            /*
             * find the left, right, top and bottom indices such that
             * the indices do not go beyond image boundaires
             */
            cl_uint left    = (x           <  vstep) ? 0         : (x - vstep);
            cl_uint right   = ((x + vstep) >= width) ? width - 1 : (x + vstep);
            cl_uint top     = (y           <  hstep) ? 0         : (y - hstep);
            cl_uint bottom  = ((y + hstep) >= height)? height - 1: (y + hstep);

            /*
             * initializing wighted sum value
             */
            cl_float sumFX = 0;

            for(cl_uint i = left; i <= right; ++i)
                for(cl_uint j = top ; j <= bottom; ++j)
                {
                    /*
                     * performing wighted sum within the mask boundaries
                     */
                    cl_uint maskIndex = (j - (y - hstep)) * maskWidth  + (i - (x - vstep));
                    cl_uint index     = j                 * width      + i;

                    /*
                     * to round to the nearest integer
                     */
                    sumFX += ((float)input[index] * mask[maskIndex]);
                }
            sumFX += 0.5f;
            output[y*width + x] = cl_uint(sumFX);
        }
}

int SimpleConvolution::initialize()
{
    // Call base class Initialize to get default configuration
    if  (sampleArgs->initialize() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    // Now add customized options
    Option* width_option = new Option;
    CHECK_ALLOCATION(width_option, "Memory allocation error.\n");

    width_option->_sVersion = "x";
    width_option->_lVersion = "width";
    width_option->_description = "Width of the input matrix";
    width_option->_type = CA_ARG_INT;
    width_option->_value = &width;

    sampleArgs->AddOption(width_option);
    delete width_option;

    Option* height_option = new Option;
    CHECK_ALLOCATION(height_option, "Memory allocation error.\n");

    height_option->_sVersion = "y";
    height_option->_lVersion = "height";
    height_option->_description = "Height of the input matrix";
    height_option->_type = CA_ARG_INT;
    height_option->_value = &height;

    sampleArgs->AddOption(height_option);
    delete height_option;

    Option* mask_width = new Option;
    CHECK_ALLOCATION(mask_width, "Memory allocation error.\n");

    maskWidth = 3;
    mask_width->_sVersion = "m";
    mask_width->_lVersion = "masksize";
    mask_width->_description = "Width of the mask matrix";
    mask_width->_type = CA_ARG_INT;
    mask_width->_value = &maskWidth;
    sampleArgs->AddOption(mask_width);
    delete mask_width;

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

int SimpleConvolution::setup(bool isNaive)
{
    if(!isPowerOf2(width))
    {
        width = roundToPowerOf2(width);
    }
    if(!isPowerOf2(height))
    {
        height = roundToPowerOf2(height);
    }

   printf("input length = %d x %d int \n", width, height); 
    maskHeight = maskWidth;

    if(!(maskWidth%2))
    {
        maskWidth++;
    }
    if(!(maskHeight%2))
    {
        maskHeight++;
    }

    if (setupSimpleConvolution() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    if (setupCL(isNaive) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    sampleTimer->stopTimer(timer);

    setupTime = (cl_double)sampleTimer->readTimer(timer);

    return SDK_SUCCESS;
}


int SimpleConvolution::run(bool isNaive)
{
    int timer = sampleTimer->createTimer();
    sampleTimer->resetTimer(timer);
    sampleTimer->startTimer(timer);

    std::cout << "Executing kernel for " << iterations <<
              " iterations" << std::endl;
    std::cout << "-------------------------------------------" << std::endl;

    for(int i = 0; i < iterations; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if (runCLKernels(isNaive) != SDK_SUCCESS)
        {
            return SDK_FAILURE;
        }
    }

    sampleTimer->stopTimer(timer);
    totalKernelTime = (double)(sampleTimer->readTimer(timer)) / iterations;

/*    if(!sampleArgs->quiet)
    {
        printArray<cl_uint >("Output", output, width, 1);
    }
*/
    return SDK_SUCCESS;
}

int SimpleConvolution::verifyResults()
{
//    if(sampleArgs->verify)
//    {
        verificationOutput = (cl_uint *) malloc(width * height * sizeof(cl_uint ));
        CHECK_ALLOCATION(verificationOutput,
                         "Failed to allocate host memory. (verificationOutput)");

        /*
         * reference implementation
         */
        cl_uint2 inputDimensions = {width    , height};
        cl_uint2 maskDimensions  = {maskWidth, maskHeight};

        simpleConvolutionCPUReference(verificationOutput, input, mask, width, height,
                                      maskWidth, maskHeight);

        // compare the results and see if they match
        if(memcmp(output, verificationOutput, height*width*sizeof(cl_uint )) == 0)
        {
            std::cout<<"Passed!\n" << std::endl;
            return SDK_SUCCESS;
        }
        else
        {
            std::cout<<"Failed\n" << std::endl;
            return SDK_FAILURE;
        }
//    }

    return SDK_SUCCESS;
}

void SimpleConvolution::printStats()
{
    if(sampleArgs->timing)
    {
        std::string strArray[5] = {"Width", "Height", "mask Size", "Time(sec)", "KernelTime(sec)"};
        std::string stats[5];

        sampleTimer->totalTime = setupTime + totalKernelTime;

        stats[0]  = toString(width    , std::dec);
        stats[1]  = toString(height   , std::dec);
        stats[2]  = toString(maskWidth, std::dec);
        stats[3]  = toString(sampleTimer->totalTime, std::dec);
        stats[4]  = toString(totalKernelTime, std::dec);

        printStatistics(strArray, stats, 5);
    }
}

int SimpleConvolution::cleanup()
{
    // Releases OpenCL resources (Context, Memory etc.)
    cl_int status;

    status = clReleaseKernel(kernel);
    CHECK_OPENCL_ERROR(status, "clReleaseKernel failed.(kernel)");

    status = clReleaseProgram(program);
    CHECK_OPENCL_ERROR(status, "clReleaseProgram failed.(program)");

    status = clReleaseMemObject(inputBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(inputBuffer)");

    status = clReleaseMemObject(outputBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(outputBuffer)");

    status = clReleaseMemObject(maskBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(maskBuffer)");

    status = clReleaseCommandQueue(commandQueue);
    CHECK_OPENCL_ERROR(status, "clReleaseCommandQueue failed.(commandQueue)");

    status = clReleaseContext(context);
    CHECK_OPENCL_ERROR(status, "clReleaseContext failed.(context)");

    status = clReleaseMemObject(degradationStatusBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");
 
    // release program resources (input memory etc.)
    FREE(input);
    FREE(output);
    FREE(mask);
    FREE(verificationOutput);
    FREE(devices);
    FREE(degradationStatus);
    FREE(degraded_CU_id);
    FREE(degraded_lane_id);

    return SDK_SUCCESS;
}

int
main(int argc, char * argv[])
{
    SimpleConvolution clSimpleConvolution;

    if (clSimpleConvolution.initialize() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    if (clSimpleConvolution.sampleArgs->parseCommandLine(argc, argv) != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }
    clSimpleConvolution.localTh = clSimpleConvolution.sampleArgs->WIcount;
    clSimpleConvolution.NumDEGRADED = clSimpleConvolution.sampleArgs->numDegraded;

    clSimpleConvolution.degraded_CU_id = (int *) malloc(clSimpleConvolution.NumDEGRADED * sizeof(int));
    clSimpleConvolution.degraded_lane_id = (int *) malloc(clSimpleConvolution.NumDEGRADED * sizeof(int));
 

///////////////////

    if(clSimpleConvolution.sampleArgs->isDumpBinaryEnabled())
    {
        return clSimpleConvolution.genBinaryImage();
    }

    clSimpleConvolution.width = 512;//1024; //clSimpleConvolution.localTh;// --* 10;
    clSimpleConvolution.height = 512;//512;//1024; //40;// 10;
    if (clSimpleConvolution.sampleArgs->kernelType){
	//degraded
////////////////////  Atieh

  /*  uint redundant_wi = ceil((float)((float)clSimpleConvolution.localTh/16.0)) ;

    redundant_wi++;

    redundant_wi = redundant_wi * (1 + clSimpleConvolution.NumDEGRADED/3);
    if (redundant_wi + clSimpleConvolution.localTh > 256)
	clSimpleConvolution.localTh = 256;// - redundant_wi;
 
///////////////////

    clSimpleConvolution.width = 64; //clSimpleConvolution.localTh; // * 10;
    clSimpleConvolution.height = 64; //40; //10;
*/ //Atieh

	if (clSimpleConvolution.setup(false) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
   	 }
       	if (clSimpleConvolution.run(false) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
    	}
    }
    else{
	//naive
/*    clSimpleConvolution.width = 64; //clSimpleConvolution.localTh;// --* 10;
    clSimpleConvolution.height = 64; //40;// 10;
*/ //Atieh

    	if (clSimpleConvolution.setup(true) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
    	}


   	 if (clSimpleConvolution.run(true) != SDK_SUCCESS)
    	{
        	return SDK_FAILURE;
    	}
    }
    if (clSimpleConvolution.verifyResults() != SDK_SUCCESS)
    {
        return SDK_FAILURE;
    }

    clSimpleConvolution.printStats();
    return SDK_SUCCESS;
}
