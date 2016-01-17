###############################################################################
## Use Stattleship and Neo4j to Rank NHL Teams for the 2015-16 Season
## @brocktibert
###############################################################################

## factors are the devil
options(stringsAsFactors = FALSE)

## packages -- if errors, install with ?install.packages
library(stattleshipR)
library(dplyr)
library(lubridate)
library(stringr)

## set the token from an environment variable
set_token(Sys.getenv("STATTLE_TOKEN"))

## parse out entries from ss_get_result when walk=T and length > 1
parse_stattle <- function(stattle_list, entry) {
  x <- do.call("rbind", lapply(stattle_list, function(x) x[[entry]]))
  stopifnot(is.data.frame(x))
  return(x)
}

## The Atlantic Division id
atlantic_div <- "15ca4e46-2b49-4f37-84ea-befb62de28c5"

## get the NHL teams in the atlantic division and keep just the key fields
teams <- hockey_teams() %>%
  filter(division_id == atlantic_div) %>%
  select(id, nickname, slug)

## get the finished games, keep only those between atlantic division teams
all_games <- hockey_games(team_id="")
games <- filter(all_games,
                !is.na(ended_at) &
                  home_team_id %in% teams$id &
                  away_team_id %in% teams$id)
games <- select(games,
                id,
                started_at,
                scoreline,
                home_team_id,
                away_team_id,
                winning_team_id,
                attendance,
                duration,
                home_team_score,
                away_team_score,
                score_differential,
                home_team_outcome,
                away_team_outcome)

## extract dateparts from started date
games <- transform(games,
                   start_date = strptime(started_at, "%Y-%m-%dT%H:%M:%S"))
games <- transform(games,
                   year = year(start_date),
                   month = month(start_date),
                   day = day(start_date))
games$start_date <- NULL
games$started_at <- NULL

## save the csvs for import -- put on google drive for public access
write.table(teams, file="data/teams.csv", sep=",", row.names=F)
write.table(games, file="data/games.csv", sep=",", row.names=F)
