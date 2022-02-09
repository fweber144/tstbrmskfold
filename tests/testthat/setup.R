run_snaps <- TRUE
if (run_snaps) {
  testthat_ed_max2 <- edition_get() <= 2
}

data("bball1970", package = "rstanarm")
set.seed(9294)
bball1970$noise <- rnorm(nrow(bball1970))
bball1970$Player <- gl(6, 3, nrow(bball1970))
bfit <- brms::brm(Hits | trials(AB) ~ s(noise, k = 5) + (1 | Player),
                  data = bball1970,
                  family = binomial(),
                  chains = 2,
                  iter = 500,
                  file = testthat::test_path("bfit"),
                  file_refit = "on_change",
                  seed = 1234,
                  refresh = 0)

folds_vec <- loo::kfold_split_random(K = 2, N = nrow(bball1970))
kobj <- loo::kfold(bfit,
                   folds = folds_vec,
                   save_fits = TRUE,
                   seed = 9876)
# To be able to compare manually after differing snapshots:
saveRDS(kobj, testthat::test_path("kobj.rds"))
