test_that("kfold() is reproducible", {
  if (run_snaps) {
    if (testthat_ed_max2) local_edition(3)
    width_orig <- options(width = 145)
    dummy_out <- lapply(seq_len(2), function(k_idx) {
      m <- as.matrix(kobj$fits[, "fit"][[k_idx]])
      expect_snapshot({
        print(paste("k:", k_idx))
        print(rlang::hash(m))
      })
      return(invisible(TRUE))
    })
    options(width = width_orig$width)
    if (testthat_ed_max2) local_edition(2)
  }
})
