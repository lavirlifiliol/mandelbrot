use std::fs::File;
use std::io::Write;

const i_n:usize = 512;
const side:usize = 1024;
const scale:f32 = 0.3;
const center_x:f32 = 0.4;
const center_y:f32 = 0.4;


fn solve_pixel(i:usize) -> f32 {
    let x = (i % side) as f32;
    let y = (i / side) as f32;
    let c_r:f32 = x * 2.0 / side as f32 * scale - scale + center_x;
    let c_c:f32 = y * 2.0 / side as f32 * scale - scale + center_y;
    let mut z_r:f32 = 0.0;
    let mut z_c:f32 = 0.0;
    let mut k:usize = 0;
    while k < i_n {
        let tmp = z_r;
        z_r = z_r * z_r - z_c * z_c + c_r;
        z_c = 2.0  * tmp * z_c + c_c;
        if z_r * z_r + z_c * z_c > 4.0 {
            break;
        }
        k+=1;
    }
    return 1.0 - k as f32 / i_n as f32;

}
fn main() {
    let mut f = File::create("out.ppm").unwrap();
    write!(f, "P6 {} {} 255 ", side, side).expect("failed write");
    for i in 0..side {
        let mut buf: [u8; side * 3] = [0; side * 3];
        for j in 0..side {
            let idx = i * side + j;
            let res:u8 = (255.0 * solve_pixel(idx)) as u8;
            buf[j * 3] = res;
            buf[j * 3 + 1] = res;
            buf[j * 3 + 2] = res;
        }
        f.write_all(&buf).expect("failed Write");
    }
}
