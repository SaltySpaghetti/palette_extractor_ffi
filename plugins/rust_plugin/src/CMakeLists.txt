cmake_minimum_required(VERSION 3.11)

project(ffi_rust_plugin_library VERSION 0.0.1 LANGUAGES C)

# Enable ExternalProject CMake module
include(FetchContent)

# Set default ExternalProject root directory
set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/palette_extractor)


# This will build Rust sources.
# The resulting lib will be src/palette_extractor/target/release/libpalette_extractor.so
execute_process (
    COMMAND cargo build --release
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/palette_extractor
    OUTPUT_VARIABLE outVar
)

set(SIM_LIB_NAME "libpalette_extractor.dylib")

if (WIN32)
  set(SIM_LIB_NAME "palette_extractor.dll")
endif()

install(
  FILES "palette_extractor/target/release/${SIM_LIB_NAME}" 
  DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
# configure_file(
#   "palette_extractor/target/release/${SIM_LIB_NAME}" 
#   "${CMAKE_INSTALL_PREFIX}/lib"
#   COPYONLY)
message("************************************************************** ${CMAKE_INSTALL_PREFIX}")




add_library(rust_plugin SHARED
  "rust_plugin.cpp"
)

set_target_properties(rust_plugin PROPERTIES
  PUBLIC_HEADER rust_plugin.h
  OUTPUT_NAME "rust_plugin"
)

target_compile_definitions(rust_plugin PUBLIC DART_SHARED_LIB)
