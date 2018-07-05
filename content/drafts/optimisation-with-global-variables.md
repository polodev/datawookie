THIS ILLUSTRATES HOW TO HANDLE GLOBAL VARIABLES BY MAKING A CLOSURE.
draft: true



make_fitness <- function(target, reaction_rates, dist_time) {
  force(target)
  force(reaction_rates)
  force(dist_time)
  
  dist_time_stats <- function(cust_zone) {
    dist_time %>%
      inner_join(cust_zone, by = c("orig_id" = "custid")) %>%
      inner_join(cust_zone, by = c("dest_id" = "custid"), suffix = c("_orig", "_dest")) %>%
      #
      # Select only orig/dest customers in same zone.
      #
      filter(zone_orig == zone_dest) %>%
      select(
        -zone_dest
      ) %>%
      rename(
        zone = zone_orig
      ) %>% filter(
        orig_id != dest_id
      ) %>%
      group_by(dest_id, zone) %>%
      summarise(avg_time = mean(time)) %>%
      left_join(reaction_rates, by = "dest_id") %>%
      mutate(
        # Subscribers without signals -> set rate to zero.
        signals_per_day = ifelse(is.na(signals_per_day), 0, signals_per_day),
        # Utilisation.
        utilisation = avg_time * signals_per_day
      ) %>%
      group_by(zone) %>%
      summarise(
        total_utilisation = sum(utilisation)
      )
  }
  
  # The fitness function will largely be responsible for the outcome. The implementation below aims to minimise the maximum
  # total utilisation across each of the zones. This will ultimately produce zones with similar total utilisations.
  #
  function(zone) {
    target$zone = zone
    
    stats = dist_time_stats(target)
    
    max(stats$total_utilisation)
  }
}

# fitness(target$zone)

# Range of permissible values.
#
domain <- matrix(c(1, NZONE), nrow = nrow(target), ncol = 2, byrow = TRUE)

if (file.exists(NEWZONERDS)) {
  SEED = readRDS(NEWZONERDS)$par
} else {
  SEED = as.integer(target$seed_zone)
}

# Things to try:
#
# - temp: larger values increase degree of random variation
# - tmax: number of evaluations at each temperature
#
new_zones <- genoud(make_fitness(target, reaction_rates, dist_time),
                    nvars = nrow(target),
                    data.type.int =  TRUE,
                    optim.method = "SANN",
                    boundary.enforcement = 2,
                    solution.tolerance = 0.0000001,
                    #
                    # Memory footprint tends to grow with the number of generations.
                    #
                    max.generations = 500,
                    wait.generations = 100,
                    print.level = 1,
                    control = list(
                      temp = 2000,
                      tmax = 30
                    ),
                    max = FALSE,
                    starting.values = SEED,
                    Domains = domain,
                    cluster = cluster
)
