import sys.io.File;
import haxe.io.Bytes;

abstract Complex({r:Float, c:Float}) {
	public inline function new(a:{r:Float, c:Float}) {
		this = a;
	}

	public inline function r() {
		return this.r;
	}

	public inline function c() {
		return this.c;
	}

	@:op(A + B)
	public inline function add(other:Complex):Complex {
		return new Complex({r: this.r + other.r(), c: this.c + other.c()});
	}

	public inline function square():Complex {
		return new Complex({r: this.r * this.r - this.c * this.c, c: 2 * this.r * this.c});
	}

	public inline function sqrAbs() {
		return Math.sqrt(this.r * this.r + this.c * this.c);
	}
}

class Main {
	static final i_n = 512;
	static final side = 1024;
	static final center = new Complex({r: 0.4, c: 0.4});
	static final scale = 0.3;
	static final header = Bytes.ofString('P6 $side $side 255 ');
	static final contents = Bytes.alloc(side * side * 3);

	static function solvePixel(idx:Int):Float {
		var i = 0;
		var x = idx % side;
		var y = Std.int(idx / side);
		var c = new Complex({r: x / side * 2 * scale - scale , c: y / side * 2 * scale - scale})
			+ center;
		var z = new Complex({r: 0, c: 0});
		while (i < i_n) {
			if (z.sqrAbs() < 2) {
				z = z.square() + c;
				i++;
			} else {
				break;
			}
		}
		return 1 - i / i_n;
	}

	static function main() {
		for (pIdx in 0...(side * side)) {
			var part = solvePixel(pIdx);
			var color = Std.int(255 * part);
			contents.set(pIdx * 3, color);
			contents.set(pIdx * 3 + 1, color);
			contents.set(pIdx * 3 + 2, color);
		}
		var out = File.write("out.ppm", true);
		out.write(header);
		out.write(contents);
		out.close();
	}
}
