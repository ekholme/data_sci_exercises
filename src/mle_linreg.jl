using Distributions
using Optim
using Random

# simulate data ------------
n = 1_000
m = 3

β = [0., 1., 2., 3.]

X = hcat(ones(n), randn(n, m))
ϵ = rand(Normal(0, 0.1), n)
y = X * β .+ ϵ

# estimate with maximum likelihood
function estimate_mle(X::Matrix, y::Vector{<:Real})
    p = size(X)[2]

    start_params = zeros(p + 1)

    function neg_ll(params)
        b = params[begin:p]
        σ = exp(params[end])

        ŷ = X*b

        residuals = y .- ŷ

        ll = -loglikelihood(Normal(0, σ), residuals)

        return ll
    end

    res = optimize(neg_ll, start_params, LBFGS())

    params = Optim.minimizer(res)
    β̂ = params[1:p]
    σ̂ = exp(params[end])

    return (β=β̂, σ=σ̂, result=res)

end

out_params = estimate_mle(X, y)

isapprox(out_params.β, β, atol=0.01)