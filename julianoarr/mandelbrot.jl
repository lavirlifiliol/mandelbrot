const i_n = 512
const side = 1024
const center = 0.4+0.4im
const scale = 0.3


function solvePixel(i)
    x = i % side
    y = i ÷ side
    c = (x / side * 2 * scale - scale) + (y / side * 2 * scale - scale) * 1im + center
    z = 0im
    k = 0
    while (k < i_n)
        z = z * z + c
        if (abs(z) > 2)
            break
        end
        k+=1
    end
    return 1 - k / i_n
end

open("out.ppm", "w") do io
    write(io, "P6 $side $side 255 ")
    for i in 0:side-1
        buffer = Vector{UInt8}(zeros(side * 3) )
        for j in 1:side
            idx = i * side + j
            res = UInt8(floor(solvePixel(idx) * 255))
            buffer[j * 3 - 2] = res
            buffer[j * 3 - 1] = res
            buffer[j * 3 - 0] = res
        end
        write(io, buffer)
    end
end
