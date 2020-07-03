import numpy as np
from pathlib import Path
side = 1024
center = .4+.4j
scale = 0.3
i_n = 512
x = np.linspace(-scale,scale,side)
y = np.linspace(-scale,scale,side, dtype=complex) * 1j
c = np.tile(x, (side,1))+np.tile(y, (side, 1)).T + center
z = np.zeros((side,side))
r = np.zeros((side,side),dtype='uint16')
for k in range(i_n):
    z = z ** 2 + c
    r[np.abs(z) < 2] = k


image = np.tile((1 - r.flatten()  / i_n) * 255, (3, 1)).astype('uint8').tobytes('F')
Path('out.ppm').write_bytes(f'P6 {side} {side} 255 '.encode() + image)
