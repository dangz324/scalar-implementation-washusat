cmake_minimum_required(VERSION 3.13)
project(SCALAR)

# Path to the F´ framework (submodule)
set(FPRIME_FRAMEWORK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external/fprime")

# Include the F´ build system
include("${FPRIME_FRAMEWORK_PATH}/cmake/FPrime.cmake")

# Add your components directory
add_fprime_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/components" SCALAR_COMPONENTS)

# Add PROVES components
add_fprime_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/external/proves" PROVES)

# Add fprime-zephyr (optional but recommended)
add_fprime_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/external/fprime-zephyr" FPRIME_ZEPHYR)