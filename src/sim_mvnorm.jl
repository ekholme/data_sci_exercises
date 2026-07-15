using Distributions
using Random

Random.seed!(0408)

μ = [0., 0.]
Σ = [1. 0.8; 0.8 1.]
n = 1_000

d = MvNormal(μ, Σ)

X = rand(d, n)'

r = cor(X)