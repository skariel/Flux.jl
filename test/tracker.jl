using Flux.Tracker, Base.Test, NNlib
using Flux.Tracker: gradcheck

gradtest(f, xs::AbstractArray...) = gradcheck((xs...) -> sum(f(xs...)), xs...)
gradtest(f, dims...) = gradtest(f, rand.(dims)...)

@testset "Tracker" begin

@test gradtest((x, W, b) -> σ.(W*x .+ b), 5, (2,5), 2)
@test gradtest((x, W, b) -> σ.(W*x .+ b), (5,3), (2,5), 2)

@test gradtest(x -> sin.(sum(x, (2, 3))), (3,4,5))

@test gradtest(x -> softmax(x).*(1:3), 3)
@test gradtest(x -> softmax(x).*(1:3), (3,5))

@test gradtest(Flux.mse, rand(5,5), rand(5, 5))
@test gradtest(Flux.crossentropy, rand(5,5), rand(5, 5))

@test gradtest(x -> x', rand(5))

@test gradtest(vcat, rand(5), rand(3))
@test gradtest(vcat, rand(2,3), rand(3,3))

@test gradtest(rand(5)) do x
  y = x.^2
  2y + x
end

end
