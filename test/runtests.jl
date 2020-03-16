using GOF3R
using Test

@testset "GOF3R.jl" begin
    @test success(`$(GOF3R.gof3r) --version`)
end
