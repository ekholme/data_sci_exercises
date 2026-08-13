using StructuralEquationModels
using Random
using Distributions
using DataFrames

# see https://structuralequationmodels.github.io/StructuralEquationModels.jl/dev/tutorials/first_model/
# for guidance

# simulate some data ------------
Random.seed!(0408)
n = 1_000
m = 4

η = randn(n)
β = [1.0, 0.8, 0.7, 0.6]

d = Normal(0, 0.1)
ϵ = rand(d, n, m)

X = η * β' + ϵ

df = DataFrame(hcat(η, X), [:y, :x1, :x2, :x3, :x4])

latent_vars = [:y]
obs_vars = [:x1, :x2, :x3, :x4]

# define the model -----------
graph = @StenoGraph begin
    # loadings
    y → x1 + x2 + x3 + x4

    #variances
    y ↔ fixed(1.)*y
    x1 ↔ x1
    x2 ↔ x2
    x3 ↔ x3
    x4 ↔ x4

end

partable = ParameterTable(
    graph,
    latent_vars=latent_vars,
    observed_vars=obs_vars
)

model = Sem(
    specification=partable,
    data=df
)

model_fit = fit(model)

# explore model fit measures
fit_measures(model_fit)

# update the parameter table object to contain the estimates from the model
update_estimate!(partable, model_fit)

details(partable)

# trying with a matrix as the data -----------

partable2 = ParameterTable(
    graph,
    latent_vars=latent_vars,
    observed_vars=obs_vars
)

model2 = Sem(
    specification=partable2,
    data=X
)

model_fit2 = fit(model2)

update_estimate!(partable2, model_fit2)