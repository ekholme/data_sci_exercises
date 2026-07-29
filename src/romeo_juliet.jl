# Romeo and Juliet agree to meet between 8am and 9am. each arrives at a random time in the house and then waits 15 minutes. What is the probability that they meet?
using Random

Random.seed!(0408)

function sample_rj(reps::Int)
    v = Vector{Bool}(undef, reps)
    for i ∈ 1:reps
        x = rand(1:60, 2)
        abs(x[1] - x[2] <= 15)
    end
    return v
end

n = 10_000

p = sum(sample_rj(n)) / n