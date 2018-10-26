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


#include "SobelFilter.hpp"
#include <cmath>

//const int degraded_CU_id = 0;
//const int degraded_lane_id = 2;

// There is no -wic option for this kernel
int
SobelFilter::readInputImage(std::string inputImageName)
{

    // load input bitmap image
    inputBitmap.load(inputImageName.c_str());

    // error if image did not load
    if(!inputBitmap.isLoaded())
    {
        std::cout << "Failed to load input image!";
        return SDK_FAILURE;
    }


    // get width and height of input image
    height = inputBitmap.getHeight();
    width = inputBitmap.getWidth();
   printf ("input image  = %d x %d chars \n", height, width);
   printf ("input image size = %d bytes \n", height*width*sizeof(cl_uchar));

    // allocate memory for input & output image data
    inputImageData  = (cl_uchar4*)malloc(width * height * sizeof(cl_uchar4));
    CHECK_ALLOCATION(inputImageData, "Failed to allocate memory! (inputImageData)");

   // allocate memory for output image data
    outputImageData = (cl_uchar4*)malloc(width * height * sizeof(cl_uchar4));
    CHECK_ALLOCATION(outputImageData,
                     "Failed to allocate memory! (outputImageData)");

    // initializa the Image data to NULL
    memset(outputImageData, 0, width * height * pixelSize);



	    // get the pointer to pixel data
	    pixelData = inputBitmap.getPixels();
	    if(pixelData == NULL)
	    {
		std::cout << "Failed to read pixel Data!";
		return SDK_FAILURE;
	    }

	    // Copy pixel data into inputImageData
	    memcpy(inputImageData, pixelData, width * height * pixelSize);

	    // allocate memory for verification output
	    verificationOutput = (cl_uchar*)malloc(width * height * pixelSize);
	    CHECK_ALLOCATION(verificationOutput,
			     "verificationOutput heap allocation failed!");

	    // initialize the data to NULL
	    memset(verificationOutput, 0, width * height * pixelSize);

	NumDouble = 1;
	int i = 1;
	degraded_CU_id[0] = (unsigned int) rand() % CU_Count;
	degraded_lane_id[0] = (unsigned int) rand() % SC_Count;
	while (i < NumDEGRADED){
		degraded_lane_id[i] = (degraded_lane_id[i-1] + rand() % 4 + 2) % SC_Count;
		degraded_CU_id[i] = degraded_CU_id[0];
/*    		if (i < 3){
			degraded_CU_id[i] = (degraded_CU_id[i-1] + rand()%2+1 )%CU_Count;
			degraded_lane_id[i] = (unsigned int) rand() % SC_Count;
		}
		else if (i < 6){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 2;
		}
		else if (i < 9){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 3;
		}
		else if (i < 12){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 4;
		}
		else if (i < 15){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 5;
		}
		else if (i < 18){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 6;
		}
		else if (i < 21){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 7;
		}
		else if (i < 24){
			degraded_CU_id[i] = degraded_CU_id[i-3];
			degraded_lane_id[i] = (degraded_lane_id[i-3] + rand()%2+1)%SC_Count;
			NumDouble = 8;
		}
		else{
			degraded_CU_id[i] = (degraded_CU_id[i-1] + rand()%2+1 )%CU_Count;
			degraded_lane_id[i] = (unsigned int) rand() % SC_Count;
	
		} */
		i++;
	}

    for (int i =0; i < NumDEGRADED; i++)
	printf("faulty element = (%d %d)   ", degraded_CU_id[i], degraded_lane_id[i]) ;
    printf("\n");


	    return SDK_SUCCESS;

	}


	int
	SobelFilter::writeOutputImage(std::string outputImageName)
	{
	    // copy output image data back to original pixel data
	    memcpy(pixelData, outputImageData, width * height * pixelSize);

	    // write the output bmp file
	    if(!inputBitmap.write(outputImageName.c_str()))
	    {
		std::cout << "Failed to write output image!";
		return SDK_FAILURE;
	    }

	    return SDK_SUCCESS;
	}

	int
	SobelFilter::genBinaryImage()
	{
	    bifData binaryData;
	    binaryData.kernelName = std::string("SobelFilter_Kernels.cl");
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
	SobelFilter::setupCL(bool isNaive)
	{
	    cl_int status = CL_SUCCESS;
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
	    status = getDevices(context,&devices,sampleArgs->deviceId,
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

	    cl_uint buf_uint;
	    clGetDeviceInfo(devices[sampleArgs->deviceId], CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(buf_uint), &buf_uint, NULL);
	    printf ("MAX_COMPUTE_UNIT =  %u\n",(unsigned int)buf_uint);
	char buf[128];	
		clGetDeviceInfo(devices[sampleArgs->deviceId], CL_DEVICE_VERSION, 128, buf, NULL);
        	fprintf(stdout, "%s\n", buf);
	    //Set device info of given cl_device_id
	    retValue = deviceInfo.setDeviceInfo(devices[sampleArgs->deviceId]);
	    CHECK_ERROR(retValue, 0, "SDKDeviceInfo::setDeviceInfo() failed");


	    // Create and initialize memory objects

	    // Set Presistent memory only for AMD platform
	    cl_mem_flags inMemFlags = CL_MEM_READ_ONLY;
	    if(sampleArgs->isAmdPlatform())
	    {
		inMemFlags |= CL_MEM_USE_PERSISTENT_MEM_AMD;
	    }

	    // Create memory object for input Image
	    inputImageBuffer = clCreateBuffer(
				   context,
				   inMemFlags,
				   width * height * pixelSize,
				   0,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (inputImageBuffer)");


	  // Create memory object for degStat Image
	    
	    // Create memory objects for output Image
	    outputImageBuffer = clCreateBuffer(context,
					       CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR,
					       width * height * pixelSize,
					       outputImageData,
					       &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (outputImageBuffer)");
		
	    // create a CL program using the kernel source
	    buildProgramData buildData;
	    if (isNaive)
		buildData.kernelName = std::string(/*"IntrospectiveKernel.cl"*/"SobelFilter_Kernels.cl");
	    else{
	//	buildData.kernelName = std::string("Introspective_kernel.cl");
		buildData.kernelName = std::string("degraded_kernel.cl");
		}
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
	    CHECK_ERROR(retValue, 0, "buildOpenCLProgram() failed");
	
/*	    introspectiveKernel = clCreateKernel(
			 program,
			 "introspectiveKernel",
			 &status);
	    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.");
*/
	    // get a kernel object handle for a kernel with the given name
	    kernel = clCreateKernel(
			 program,
			 "sobel_filter",
			 &status);
	    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.");

	    status = kernelInfo.setKernelWorkGroupInfo(kernel,
		     devices[sampleArgs->deviceId]);
	    CHECK_ERROR(status, SDK_SUCCESS,"kernelInfo.setKernelWorkGroupInfo() failed");

/*	    status = kernelInfo.setKernelWorkGroupInfo(introspectiveKernel,
		     devices[sampleArgs->deviceId]);
	    CHECK_ERROR(status, SDK_SUCCESS,"kernelInfo.setKernelWorkGroupInfo() failed");
*/


	    if((blockSizeX * blockSizeY) > kernelInfo.kernelWorkGroupSize)
	    {
		if(!sampleArgs->quiet)
		{
		    std::cout << "Out of Resources!" << std::endl;
		    std::cout << "Group Size specified : "
			      << blockSizeX * blockSizeY << std::endl;
		    std::cout << "Max Group Size supported on the kernel : "
			      << kernelWorkGroupSize << std::endl;
		    std::cout << "Falling back to " << kernelInfo.kernelWorkGroupSize << std::endl;
		}

		// Three possible cases
		if(blockSizeX > kernelInfo.kernelWorkGroupSize)
		{
		    blockSizeX = kernelInfo.kernelWorkGroupSize;
		    blockSizeY = 1;
		}
	    }
	    return SDK_SUCCESS;
	}

	int
	SobelFilter::runCLKernels(bool isNaiveVersion)
	{
	    cl_int status;
	    cl_int work_item_count = blockSizeX * blockSizeY; 
	    cl_int isNaiveKernel;

	    size_t globalThreads[] = {width * height}; //{width, height};
	    size_t localThreads[] = {blockSizeY * blockSizeX}; //{blockSizeX, blockSizeY};


	std::ostringstream os;
	os << "timing_" << NumDEGRADED << "_" << work_item_count << ".csv";
	std::string fname = os.str(); 
	std::ofstream foutput_time;
	foutput_time.open(fname.c_str(), std::ios_base::out | std::ios_base::app);



 
/*	  RWIs = (cl_uint*)malloc((width * height)/(blockSizeY*blockSizeX) * sizeof(cl_uint));
	  CHECK_ALLOCATION(RWIs,
                     "Failed to allocate memory! (RWIs)");

    // initializa the RWIs to 0
    memset(RWIs, 0, width * height * sizeof(cl_uint)/(width * height));

   // Create memory objects for RIW
	    RWIsBuffer = clCreateBuffer(context,
					       CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
					       width * height * sizeof(cl_uint)/(blockSizeX*blockSizeY),
					       RWIs,
					       &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (RWIsBuffer)");
*/
/*    int min_deg_lane = degraded_lane_id[0];
    for (int i = 0; i < NumDEGRADED; i++){
	if (degraded_lane_id[i] < min_deg_lane){
		min_deg_lane = degraded_lane_id[i];
	}
    }
*/

	    // Enqueue a kernel run call.
	    if (isNaiveVersion){
		printf("Naive kernel: \n");
		printf("localThreads = %d , globalThreads = %d \n", localThreads[0],  globalThreads[0]);
	   }
	   else{
/*		if (localThreads[0] == 256){
			localThreads[0] = 240;//128;
			work_item_count = 240;//128;
		}*/
    		uint redundant_wi = ceil((float)((float)work_item_count/(float)SC_Count)) * NumDEGRADED;
		//printf("beforeeeeeeeeeeeeeeeee red = %d \n", redundant_wi);
		for (int i = work_item_count; i < work_item_count+redundant_wi; i++){
			for (int j = 0; j < NumDEGRADED; j++)
				if (i % SC_Count == degraded_lane_id[j])
				{
					//printf("because of you (%d, %d)   , ", i, degraded_lane_id[j]);
					redundant_wi++;
				}
		}

        //        redundant_wi = redundant_wi * NumDouble;  
    		printf("redundant wi = %d \n", redundant_wi);	
    		localThreads[0] = work_item_count + redundant_wi;
    		printf("globalThreads %d / wic = %d \n", globalThreads[0], work_item_count);	
    		//globalThreads[0] = ceil((double)((double)globalThreads[0]/(double)work_item_count * (double)(work_item_count + redundant_wi)));
    		globalThreads[0] = (globalThreads[0]/work_item_count * (work_item_count + redundant_wi));
    		printf("Aging enabled kernel: \n");
    		printf("globalThreads = %d, localThreads = %d  \n", globalThreads[0], localThreads[0]);
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
				//	printf("in id %d (%d, %d) \n", i*localThreads[0]+j, i, j);
					counter++;
				}
				if (i%CU_Count == degraded_CU_id[k])
					CUdegradationStatus[i*localThreads[0]+j] = 1;
			}
		}
    	} 
		printf("# degraded WIs = %d  out of %d WIs\n", counter, globalThreads[0]);



    	 degradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
				   globalThreads[0] * sizeof(cl_char), //to be parametric
				   degradationStatus,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (degradationBufer)");

    	 CUdegradationStatusBuffer = clCreateBuffer(
				   context,
				   CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
				   globalThreads[0] * sizeof(cl_char), //to be parametric
				   CUdegradationStatus,
				   &status);
	    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (CUdegradationBufer)");



	    // Set input data
	    cl_event writeEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 inputImageBuffer,
			 CL_FALSE,
			 0,
			 width * height * pixelSize,
			 inputImageData,
			 0,
			 NULL,
			 &writeEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (inputImageBuffer)");
	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&writeEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(writeEvt) Failed");



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
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (CUdegStatBuffer)");
		status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&cudegEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(cudegEvt) Failed");



/*	    if (isNaiveVersion){
	    cl_event rwisEvt;
	    status = clEnqueueWriteBuffer(
			 commandQueue,
			 RWIsBuffer,
			 CL_FALSE,
			 0,
			 (globalThreads[0]/localThreads[0]) * sizeof(cl_uint),
			 RWIs,
			 0,
			 NULL,
			 &rwisEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (rwisBuffer)");
		status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&rwisEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(rwiEvt) Failed");
	   }
*/
	   
	    // Set appropriate arguments to the kernel
	    // input buffer image
	    status = clSetKernelArg(
			 kernel,
			 0,
			 sizeof(cl_mem),
			 &inputImageBuffer);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (inputImageBuffer)")

	    // outBuffer imager
	    status = clSetKernelArg(
			 kernel,
			 1,
			 sizeof(cl_mem),
			 &outputImageBuffer);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (outputImageBuffer)");

	    // degradationStatBuffer imager
	    status = clSetKernelArg(
			 kernel,
			 2,
			 sizeof(cl_mem),
			 &degradationStatusBuffer);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (degradationStatBuffer)");


	    status = clSetKernelArg(
			 kernel,
			 3,
			 sizeof(int),
			 &width);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (width)")
	
	    status = clSetKernelArg(
			 kernel,
			 4,
			 sizeof(int),
			 &height);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (height)");




	   if (!isNaiveVersion){
		    status = clSetKernelArg(
			 kernel,
			 5,
			 sizeof(cl_mem),
			 &CUdegradationStatusBuffer);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (CUdegradationStatBuffer)");

	/////
	   status = clSetKernelArg(kernel,
				    6,
				    sizeof(int),
				    (void*)&work_item_count);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg(numSteps) failed.");
	   }

/*	   if (isNaiveVersion){
	    status = clSetKernelArg(
			 kernel,
			 5,
			 sizeof(cl_mem),
			 &RWIsBuffer);
	    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (rwiBuffer)");
	}
*/

//printf("number of red wis  = %d \n", counter);
	    //size_t globalThreads[] = {width, height};
	    //size_t localThreads[] = {blockSizeX, blockSizeY};
	    cl_event ndrEvt;
//for (int m = 0; m < 10000; m++){
//for (int m = 0; m < 10; m++){
	    status = clEnqueueNDRangeKernel(
			 commandQueue,
			 kernel,
			 1, //2,
			 NULL,
			 globalThreads,
			 localThreads,
			 0,
			 NULL,
			 &ndrEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueNDRangeKernel failed.");

	    status = clFinish(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFinish failed.");

	    status = clWaitForEvents(1, &ndrEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEvent(ndrEvt) Failed");

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
	    printf("\nTotal kernel execution time = %0.5f ms\n", (total_time / 1000000.0) );
	   foutput_time << (double)(total_time/1000000.0) << "\n"; 
//	    avgTime += total_time;
//}
	foutput_time.close();
	     clReleaseEvent(ndrEvt);

	//////////////////////////////// end timing


	    // Enqueue readBuffer
	    cl_event readEvt;
//	    cl_event rwiEvt;
	    status = clEnqueueReadBuffer(
			 commandQueue,
			 outputImageBuffer,
			 CL_FALSE,
			 0,
			 width * height * pixelSize,
			 outputImageData,
			 0,
			 NULL,
			 &readEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");

/*	    status = clEnqueueReadBuffer(
			 commandQueue,
			 RWIsBuffer,
			 CL_FALSE,
			 0,
			 width * height * sizeof(cl_uint)/(blockSizeY*blockSizeX),
			 RWIs,
			 0,
			 NULL,
			 &rwiEvt);
	    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");
*/

	    status = clFlush(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clFlush failed.");

	    status = waitForEventAndRelease(&readEvt);
	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(readEvt) Failed");

//	    status = waitForEventAndRelease(&rwiEvt);
//	    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(rwiEvt) Failed");

/*          int numWGs = (width*height) / (blockSizeX * blockSizeY);
	   int max = RWIs[0];
	  for (int i= 1; i < numWGs; i++){
		if (RWIs[i] > max)
			max = RWIs[i];
	}

	printf("number of red WIs in the healthy execution is = %d \n", max );
*/
	    return SDK_SUCCESS;
	}



	int
	SobelFilter::initialize()
	{
	    cl_int status = 0;
	    // Call base class Initialize to get default configuration
	    status = sampleArgs->initialize();
	    CHECK_ERROR(status, SDK_SUCCESS, "OpenCL Initialization failed");

	    Option* iteration_option = new Option;
	    CHECK_ALLOCATION(iteration_option, "Memory Allocation error.\n");

	    iteration_option->_sVersion = "i";
	    iteration_option->_lVersion = "iterations";
	    iteration_option->_description = "Number of iterations to execute kernel";
	    iteration_option->_type = CA_ARG_INT;
	    iteration_option->_value = &iterations;

	    sampleArgs->AddOption(iteration_option);

	    delete iteration_option;

	    return SDK_SUCCESS;
	}

	int
	SobelFilter::setup(bool isNaive)
	{
	    cl_int status = 0;
	    // Allocate host memory and read input image
	    std::string filePath = getPath() + std::string(INPUT_IMAGE);
	    status = readInputImage(filePath);
	    CHECK_ERROR(status, SDK_SUCCESS, "Read InputImage failed");

	    // create and initialize timers
	    int timer = sampleTimer->createTimer();
	    sampleTimer->resetTimer(timer);
	    sampleTimer->startTimer(timer);

	    status = setupCL(isNaive);
	    if(status != SDK_SUCCESS)
	    {
		return status;
	    }

	    sampleTimer->stopTimer(timer);
	    // Compute setup time
	    setupTime = (double)(sampleTimer->readTimer(timer));

	    return SDK_SUCCESS;
	}


	int
	SobelFilter::run(bool isNaive)
	{
		avgTime = 0;
	    cl_int status = 0;
	    if(!byteRWSupport)
	    {
		return SDK_SUCCESS;
	    }
//		iterations = 50;
	    for(int i = 0; i < 2 && iterations != 1; i++)
	    {
		// Set kernel arguments and run kernel
		if(runCLKernels(isNaive) != SDK_SUCCESS)
		{
		    return SDK_FAILURE;
		}
	    }

	    std::cout << "Executing kernel for " << iterations
		      << " iterations" <<std::endl;
	    std::cout << "-------------------------------------------" << std::endl;

	    // create and initialize timers
	    int timer = sampleTimer->createTimer();
	    sampleTimer->resetTimer(timer);
	    sampleTimer->startTimer(timer);
	    
	    for(int i = 0; i < iterations; i++)
	    {
		// Set kernel arguments and run kernel
		if(runCLKernels(isNaive) != SDK_SUCCESS)
		{
		    return SDK_FAILURE;
		}
	    }
	 //   printf("average time = %lf\n", (double)(avgTime/(1000000.0*100.0)));
	//    printf("average time is = %lf\n", (double)(avgTime/(1000000.0)));
	    sampleTimer->stopTimer(timer);
	    // Compute kernel time
	    kernelTime = (double)(sampleTimer->readTimer(timer)) / iterations;

	    // write the output image to bitmap file
	    status = writeOutputImage(OUTPUT_IMAGE);
	    CHECK_ERROR(status, SDK_SUCCESS, "write Output Image Failed");

	    return SDK_SUCCESS;
	}

	int
	SobelFilter::cleanup()
	{
	    if(!byteRWSupport)
	    {
		return SDK_SUCCESS;
	    }

	    // Releases OpenCL resources (Context, Memory etc.)
	    cl_int status;

	    status = clReleaseKernel(kernel);
	    CHECK_OPENCL_ERROR(status, "clReleaseKernel failed.");

	    status = clReleaseProgram(program);
	    CHECK_OPENCL_ERROR(status, "clReleaseProgram failed.");

	    status = clReleaseMemObject(inputImageBuffer);
	    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");

	    status = clReleaseMemObject(degradationStatusBuffer);
	    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");


	    status = clReleaseMemObject(CUdegradationStatusBuffer);
	    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");



	    status = clReleaseMemObject(outputImageBuffer);
	    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");


	    status = clReleaseCommandQueue(commandQueue);
	    CHECK_OPENCL_ERROR(status, "clReleaseCommandQueue failed.");

	    status = clReleaseContext(context);
	    CHECK_OPENCL_ERROR(status, "clReleaseContext failed.");

	    // release program resources (input memory etc.)
	    FREE(inputImageData);
	    FREE(degradationStatus);
	    FREE(CUdegradationStatus);
	    FREE(outputImageData);
	    FREE(verificationOutput);
	    FREE(degraded_CU_id);
    	    FREE(degraded_lane_id);
 

	    FREE(devices);

	    return SDK_SUCCESS;
	}


	void
	SobelFilter::sobelFilterCPUReference()
	{
	    // x-axis gradient mask
	    const int kx[][3] =
	    {
		{ 1, 2, 1},
		{ 0, 0, 0},
		{ -1,-2,-1}
	    };

	    // y-axis gradient mask
	    const int ky[][3] =
	    {
		{ 1, 0, -1},
		{ 2, 0, -2},
		{ 1, 0, -1}
	    };

	    int gx = 0;
	    int gy = 0;

	    // pointer to input image data
	    cl_uchar *ptr = (cl_uchar*)malloc(width * height * pixelSize);
	    memcpy(ptr, inputImageData, width * height * pixelSize);

	    // each pixel has 4 uchar components
	    int w = width * 4;

	    int k = 1;

	    // apply filter on each pixel (except boundary pixels)
	    for(int i = 0; i < (int)(w * (height - 1)) ; i++)
	    {
		if(i < (k+1)*w - 4 && i >= 4 + k*w)
		{
		    gx =  kx[0][0] **(ptr + i - 4 - w)
			  + kx[0][1] **(ptr + i - w)
			  + kx[0][2] **(ptr + i + 4 - w)
			  + kx[1][0] **(ptr + i - 4)
			  + kx[1][1] **(ptr + i)
			  + kx[1][2] **(ptr + i + 4)
			  + kx[2][0] **(ptr + i - 4 + w)
			  + kx[2][1] **(ptr + i + w)
			  + kx[2][2] **(ptr + i + 4 + w);


		    gy =  ky[0][0] **(ptr + i - 4 - w)
			  + ky[0][1] **(ptr + i - w)
			  + ky[0][2] **(ptr + i + 4 - w)
			  + ky[1][0] **(ptr + i - 4)
			  + ky[1][1] **(ptr + i)
			  + ky[1][2] **(ptr + i + 4)
			  + ky[2][0] **(ptr + i - 4 + w)
			  + ky[2][1] **(ptr + i + w)
			  + ky[2][2] **(ptr + i + 4 + w);

		    float gx2 = pow((float)gx, 2);
		    float gy2 = pow((float)gy, 2);


		    *(verificationOutput + i) = (cl_uchar)(sqrt(gx2 + gy2) / 2.0);
		}

		// if reached at the end of its row then incr k
		if(i == (k + 1) * w - 5)
		{
		    k++;
		}
	    }

	    free(ptr);
	}


	int
	SobelFilter::verifyResults()
	{
	    if(!byteRWSupport)
	    {
		return SDK_SUCCESS;
	    }

	//    if(sampleArgs->verify)
	//    {
		// reference implementation
		sobelFilterCPUReference();

		float *outputDevice = new float[width * height * pixelSize];
		CHECK_ALLOCATION(outputDevice,
				 "Failed to allocate host memory! (outputDevice)");

		float *outputReference = new float[width * height * pixelSize];
		CHECK_ALLOCATION(outputReference, "Failed to allocate host memory!"
				 "(outputReference)");

		// copy uchar data to float array
		for(int i = 0; i < (int)(width * height); i++)
		{
		    outputDevice[i * 4 + 0] = outputImageData[i].s[0];
		    outputDevice[i * 4 + 1] = outputImageData[i].s[1];
		    outputDevice[i * 4 + 2] = outputImageData[i].s[2];
		    outputDevice[i * 4 + 3] = outputImageData[i].s[3];

		    outputReference[i * 4 + 0] = verificationOutput[i * 4 + 0];
		    outputReference[i * 4 + 1] = verificationOutput[i * 4 + 1];
		    outputReference[i * 4 + 2] = verificationOutput[i * 4 + 2];
		    outputReference[i * 4 + 3] = verificationOutput[i * 4 + 3];
		}


		// compare the results and see if they match
		if(compare(outputReference,
			   outputDevice,
			   width * height * 4))
		{
		    std::cout << "Passed!\n" << std::endl;
		    delete[] outputDevice;
		    delete[] outputReference;
		}
		else
		{
		    std::cout << "Failed\n" << std::endl;
		    delete[] outputDevice;
		    delete[] outputReference;
		    return SDK_FAILURE;
		}
		
	   return SDK_SUCCESS;
	}

	void
	SobelFilter::printStats()
	{
	    if(sampleArgs->timing)
	    {
		std::string strArray[4] =
		{
		    "Width",
		    "Height",
		    "Time(sec)",
		    "[Transfer+Kernel]Time(sec)"
		};
		std::string stats[4];

		sampleTimer->totalTime = setupTime + kernelTime;

		stats[0] = toString(width, std::dec);
		stats[1] = toString(height, std::dec);
		stats[2] = toString(sampleTimer->totalTime, std::dec);
		stats[3] = toString(kernelTime, std::dec);

		printStatistics(strArray, stats, 4);
	    }
	}


	int
	main(int argc, char * argv[])
	{
	    cl_int status = 0;
	    SobelFilter clSobelFilter;

	    if(clSobelFilter.initialize() != SDK_SUCCESS)
	    {
		return SDK_FAILURE;
	    }

	    if(clSobelFilter.sampleArgs->parseCommandLine(argc, argv) != SDK_SUCCESS)
	    {
		return SDK_FAILURE;
	    }
	   
    	    clSobelFilter.GROUP_SIZE = clSobelFilter.sampleArgs->WIcount;
	    clSobelFilter.blockSizeX = clSobelFilter.GROUP_SIZE;
	    clSobelFilter.NumDEGRADED = clSobelFilter.sampleArgs->numDegraded;

    	    clSobelFilter.degraded_CU_id = (int *) malloc(clSobelFilter.NumDEGRADED * sizeof(int));
   	    clSobelFilter.degraded_lane_id = (int *) malloc(clSobelFilter.NumDEGRADED * sizeof(int));
	    //std::cout << "Atieh : " << clSobelFilter.sampleArgs->kernelType << std::endl; 


	    if(clSobelFilter.sampleArgs->isDumpBinaryEnabled())
	    {
		return clSobelFilter.genBinaryImage();
	    }

	    if (clSobelFilter.sampleArgs->kernelType){
		///degraded
	    	status = clSobelFilter.setup(false);
	    	if(status != SDK_SUCCESS)
	    	{
			return status;
	    	}

	    	if(clSobelFilter.run(false) != SDK_SUCCESS)
    		{
        		return SDK_FAILURE;
    		}
	    }
	    else{
		///naive
	    	status = clSobelFilter.setup(true);
	    	if(status != SDK_SUCCESS)
	    	{
			return status;
	    	}

	    	if(clSobelFilter.run(true) != SDK_SUCCESS)
	    	{
			return SDK_FAILURE;
	    	}
	    }
	    if(clSobelFilter.verifyResults() != SDK_SUCCESS)
	    {
		return SDK_FAILURE;
	    }

	    if(clSobelFilter.cleanup() != SDK_SUCCESS)
	    {
		return SDK_FAILURE;
	    }

	    clSobelFilter.printStats();

    return SDK_SUCCESS;



}
