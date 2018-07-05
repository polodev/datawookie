Here's an example. Make something simpler for illustration.
draft: true

movement_models <- function(method = c("ets", "arima")) {
  # Build a closure which has all of the data.
  #
  models <- subscribers_long %>%
    group_by(offering, feature) %>%
    nest() %>%
    mutate(
      mod = map(data, function(df) {
        count_series = zoo(df$count, df$date)
        count_series = ts(
          coredata(count_series),
          start = c(lubridate::year(start(count_series)), lubridate::month(start(count_series))),
          end = c(lubridate::year(end(count_series)), lubridate::month(end(count_series))),
          frequency = 12
        )
        forecast::stlm(count_series, s.window = "periodic", robust = FALSE, method = method)
      })
    )

  predict <- function(offering, feature) {
    models %>%
      .[.$offering == offering,] %>%
      .[.$feature == feature,] %>%
      pull(mod) %>%
      .[[1]]
  }
}
