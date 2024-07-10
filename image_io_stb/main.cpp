#define STB_IMAGE_IMPLEMENTATION
#include <stb/stb_image.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb/stb_image_write.h>

#include<iostream>
 
int main() {
  int w, h, channels;
  uint8_t* img = stbi_load("lena.jpg", &w, &h, &channels, 3);

  float contrast = 0.5f;
  int index = 0;
  for (int j = 0; j < h; ++j) {
    for (int i = 0; i < w; ++i) {
      for (int c = 0; c < channels; ++c) {
        img[index++] = (uint8_t)(contrast * img[index]);
      }
    }
  }

  stbi_write_jpg("lena_low_contrast.jpg", w, h, channels, img, 100);
  stbi_image_free(img);
  return 0;
}
