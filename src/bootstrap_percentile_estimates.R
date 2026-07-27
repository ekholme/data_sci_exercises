# bootstrapping percentile estimates for a given dataset
library(purrr)

set.seed(0408)

# generate sample data
n <- 1000
x <- runif(n)

# function to resample from x and estimate percentiles
sample_percentiles <- function(x, p) {
    l <- length(x)

    y <- sample(x, l, replace = TRUE)

    quantile(y, probs = p)
}

# function to bootstrap the previous function
bootstrap_percentiles <- function(x, reps = 100, p = seq(0, 1, .25)) {
    out <- vector(mode = "list", length = reps)

    for (i in seq_len(reps)) {
        out[[i]] <- sample_percentiles(x, p)
    }

    list_transpose(out)
}

z <- bootstrap_percentiles(x)

# and to get the means
mu_z <- purrr::map_dbl(z, mean)
