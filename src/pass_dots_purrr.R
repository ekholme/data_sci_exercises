# a worked example of how to pass dots to a function being iterated over in a {purrr} iteration function (e.g. purrr::map())
library(purrr)
library(rlang)

x <- 1:10
y <- c(11:19, NA_real_)
z <- list(x, y)

iter_mean <- function(l, ...) {
    dots <- list(...)

    ret <- purrr::map(
        l,
        ~ rlang::exec(mean, .x, !!!dots)
    )

    ret
}

res1 <- iter_mean(z, na.rm = TRUE, trim = .4)
res2 <- iter_mean(z)
