using GLM
using Distributions
using Random

Random.seed!(0408)

# simulate data
n = 100_000
p = 3
X = hcat(ones(n), randn(n, p))

# define ground-truth coefficients
β = [1., 1.5, 2., 2.5]

# generate the linear predictor
z = X * β

# define a sigmoid function
function sigmoid(x::Float64)
    return 1 / (1 + exp(-x))
end

probs = sigmoid.(z)

# simulate y by drawing from a Bernoulli distribution for each probability
y = Int.(rand.(Bernoulli.(probs)))

# fit the logistic regression model
# this takes the predictor matric, the outcome vector, the distribution, and the canonical link function
mod = glm(X, y, Binomial(), LogitLink())

# extract the model coefficients
β̂ = coef(mod)

# test if beta hat and beta values are similar enough (within .05)
isapprox(β, β̂, atol=0.05)

# measuring model accuracy
ŷ = Int.(round.(predict(mod)))

accuracy = (sum(y .== ŷ)) / n