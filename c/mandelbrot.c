#include <stdio.h>
#include <stdlib.h>
const int side = 1024;
const int i_n = 512;
const float scale = 0.3;
const float center_x = 0.4;
const float center_y = 0.4;
char header[20];

float solve_index(int idx) {
    int x = idx % side;
    int y = idx / side;
    int i = 0;
    float zx = 0;
    float zy = 0;
    float cx = x * 2.0 / side * scale -  scale + center_x;
    float cy = y * 2.0 / side * scale -  scale + center_y;
    for (; i < i_n; i++) {
        if (zx * zx + zy * zy < 4) {
            float tmp = zx;
            zx = zx * zx - zy * zy + cx;
            zy = 2 * tmp * zy + cy;
        }
        else {
            break;
        }
    }
    return 1 - i * 1.0 / i_n;
}

int main() {
    sprintf(header, "P6 %d %d 255 ", side, side);
    unsigned char* contents = malloc(side * side * 3);
    for (int i = 0; i < side * side; ++i) {
        unsigned char res = (unsigned char) (solve_index(i) * 255);
        contents[i * 3] = res;
        contents[i * 3 + 1] = res;
        contents[i * 3 + 2] = res;
    }
    FILE* f = fopen("out.ppm", "wb");
    fputs(header, f);
    fwrite(contents, 1, side*side*3, f);
    fclose(f);
    return 0;
}
