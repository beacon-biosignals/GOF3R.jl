using GOF3R
using Test

@testset "GOF3R.jl" begin
    GOF3R.s3gof3r_jll.gof3r() do exe
        @test success(`$exe --version`)
    end
end
