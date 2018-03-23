https://www.quora.com/Could-someone-give-an-explanation-of-how-eval-quote-and-substitute-work-in-R

http://adv-r.had.co.nz/Computing-on-the-language.html

https://stat.ethz.ch/R-manual/R-devel/library/base/html/substitute.html

http://dplyr.tidyverse.org/articles/programming.html

http://maraaverick.rbind.io/2017/08/tidyeval-resource-roundup/

https://cran.r-project.org/web/packages/rlang/vignettes/tidy-evaluation.html

Giving an unquoted argument and having it quoted inside function.

#' Filter data according to service offering.
#'
#' @param .data
#' @param offering Unquoted name of service offering.
#'
#' @return
#' @export
#'
#' @examples
#' data %>% select_offering(premium) %>% tail()
#' data %>% select_offering(analogue) %>% tail()
filter_offering <- function(.data, offering) {
	  # Turn expression into a character vector.
	  offering <- deparse(substitute(offering))
  #
  .data %>% filter(Service_Offering == offering)
}
