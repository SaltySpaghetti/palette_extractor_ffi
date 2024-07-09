#include "palette_extractor.h"

FFI_PLUGIN_EXPORT unsigned char *extract_palette(const char *img_path_ptr,
                                                 unsigned int img_path_len,
                                                 unsigned int k,
                                                 unsigned int max_iterations)
{
  unsigned char colors[k * 4];
  for (unsigned int i = 0; i < k * 4; i++)
  {
    colors[i] = 117;
  }

  return &colors[0];
}
