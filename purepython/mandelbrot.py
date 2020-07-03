#!/usr/bin/env python3
from pathlib import Path

i_n = 16
side = 512
scale = 0.3
center = .4 + .4j


def solve_pixel(i):
    z = 0
    x = i % side
    y = i // side
    c = (x / side * 2 * scale - scale) + (1j * (y / side * scale * 2 - scale)) + center
    for k in range(i_n):
        z = z ** 2 + c
        if abs(z) > 2:
            break
    return k / i_n


res = b''.join(bytes([int(255 * c)]) * 3 for i in range(side * side) for c in [solve_pixel(i)])
Path('out.ppm').write_bytes(f'P6 {side} {side} 255 '.encode() + res)
