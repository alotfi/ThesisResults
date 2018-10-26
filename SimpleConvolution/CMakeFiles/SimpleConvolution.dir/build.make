# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /opt/AMDAPPSDK-2.9-1/samples/opencl

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /opt/AMDAPPSDK-2.9-1/samples/opencl

# Include any dependencies generated for this target.
include cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/depend.make

# Include the progress variables for this target.
include cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/progress.make

# Include the compile flags for this target's objects.
include cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/flags.make

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/flags.make
cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o: cl/SimpleConvolution/SimpleConvolution.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/opt/AMDAPPSDK-2.9-1/samples/opencl/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o"
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o -c /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/SimpleConvolution.cpp

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.i"
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/SimpleConvolution.cpp > CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.i

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.s"
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/SimpleConvolution.cpp -o CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.s

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.requires:

.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.requires

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.provides: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.requires
	$(MAKE) -f cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/build.make cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.provides.build
.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.provides

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.provides.build: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o


# Object files for target SimpleConvolution
SimpleConvolution_OBJECTS = \
"CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o"

# External object files for target SimpleConvolution
SimpleConvolution_EXTERNAL_OBJECTS =

cl/SimpleConvolution/bin/x86_64/Release/SimpleConvolution: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o
cl/SimpleConvolution/bin/x86_64/Release/SimpleConvolution: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/build.make
cl/SimpleConvolution/bin/x86_64/Release/SimpleConvolution: /opt/AMDAPPSDK-2.9-1/lib/x86_64/libOpenCL.so
cl/SimpleConvolution/bin/x86_64/Release/SimpleConvolution: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/opt/AMDAPPSDK-2.9-1/samples/opencl/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable bin/x86_64/Release/SimpleConvolution"
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/SimpleConvolution.dir/link.txt --verbose=$(VERBOSE)
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && /usr/bin/cmake -E copy_if_different /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/SimpleConvolution_Kernels.cl /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/bin/x86_64/Release/.
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && /usr/bin/cmake -E copy_if_different /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/SimpleConvolution_Kernels.cl ./

# Rule to build all files generated by this target.
cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/build: cl/SimpleConvolution/bin/x86_64/Release/SimpleConvolution

.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/build

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/requires: cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/SimpleConvolution.cpp.o.requires

.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/requires

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/clean:
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution && $(CMAKE_COMMAND) -P CMakeFiles/SimpleConvolution.dir/cmake_clean.cmake
.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/clean

cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/depend:
	cd /opt/AMDAPPSDK-2.9-1/samples/opencl && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /opt/AMDAPPSDK-2.9-1/samples/opencl /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution /opt/AMDAPPSDK-2.9-1/samples/opencl /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution /opt/AMDAPPSDK-2.9-1/samples/opencl/cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cl/SimpleConvolution/CMakeFiles/SimpleConvolution.dir/depend

