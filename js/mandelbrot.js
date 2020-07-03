const i_n = 512;
const side = 1024;
const centerX = 0.4;
const centerY = 0.4;
const scale = 0.3;


const fs = require('fs');

const header = `P6 ${side} ${side} 255 `
const data = Buffer.allocUnsafe(side * side * 3 + header.length);

const solvePixel = i => {
    const x = i % side;
    const y = (i / side) |0;
    let zR = 0;
    let zC = 0;
    let cR = x / side * scale * 2 - scale + centerX;
    let cC = y / side * scale * 2 - scale + centerY;
    let k = 0;
    for (; k < i_n; ++k) {
        const tmp = zR
        zR = zR * zR - zC * zC + cR;
        zC = zC * tmp * 2 + cC;
        if (zR * zR + zC * zC > 4) {
            break;
        }
    }
    return k / i_n;
}

data.write(header);

for (let i = 0; i < side * side; ++i) {
    const x = Math.min((solvePixel(i) * 255) |0, 255);
    const idx = i * 3 + header.length
    data.writeUInt8(x, idx );
    data.writeUInt8(x, idx  + 1);
    data.writeUInt8(x, idx  + 2);
}
fs.writeFile("out.ppm", data, "binary", function(err) {
    //ignore errors
});
