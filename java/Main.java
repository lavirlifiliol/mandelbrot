import java.io.IOException;
import java.io.FileOutputStream;
class Main {
    private static final int i_n = 512;
    private static final int side = 1024;
    private static final float centerX = 0.4f;
    private static final float centerY = 0.4f;
    private static final float scale = 0.3f;
    private static float solveIndex(int i) {
        int x = i % side;
        int y = i / side;
        float zR = 0, zC = 0;
        float cR = x * 2.0f / side * scale - scale + centerX;
        float cC = y * 2.0f / side * scale - scale + centerY;
        float k = 0;
        for(; k < i_n; ++k) {
            float tmp = zR;
            zR = zR * zR - zC * zC + cR;
            zC = 2 * zC * tmp + cC;
            if (zR * zR + zC * zC > 4) {
                break;
            }
        }
        return 1f - k / i_n;
    }
    public static void main(String [] args) throws IOException{
        byte[] res = new byte[side*side*3];
        for (int i = 0; i < side * side; i++) {
            byte x = (byte) (solveIndex(i) * 255);
            res[i * 3] = x;
            res[i * 3 + 1] = x;
            res[i * 3 + 2] = x;
        }
        FileOutputStream writer = new FileOutputStream("out.ppm");
        writer.write(String.format("P6 %d %d 255 ", side, side).getBytes("ascii"));
        writer.write(res);
    }
}