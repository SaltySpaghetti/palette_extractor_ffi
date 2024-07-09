#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT unsigned char *extract_palette(const char *img_path_ptr,
                                                 unsigned int img_path_len,
                                                 unsigned int k,
                                                 unsigned int max_iterations);
