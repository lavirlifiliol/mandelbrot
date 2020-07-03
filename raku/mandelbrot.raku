#!/usr/bin/rakudo

my $i_n := 16;
my $side := 512;
my Num $scale := 0.3.Num;
my $center := 0.4+0.4i;


sub solve_pixel($i) {
    my Num $k = 0.Num;
    my Complex $z = 0i;
    my $x := $i % $side;
    my $y := $i div $side;
    my Complex $c := ($x / $side * 2 * $scale - $scale ) + ( $y / $side * 2 * $scale - $scale)i + $center;
    loop (; $k < $i_n; $k++) {
        $z = $z * $z + $c;
        if ($z.abs > 2) {
            last;
        }
    }
    return $k / $i_n;
}

my $blob = ("P6 {$side} {$side} 255 ".encode('ascii')) ~
    blob8.new: (map( -> $k {
       # say $k / $side if $k % $side == 0;
        (255 * solve_pixel($k)).round xx 3
    }, 0..^($side * $side))).flat;

spurt 'out.ppm', $blob;
