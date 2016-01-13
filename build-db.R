###############################################################################
## Use Stattleship and Neo4j to Rank NHL Teams for the 2015-16 Season
## @brocktibert
###############################################################################

## factors are the devil
options(stringsAsFactors = FALSE)

## un-comment below to install the packages if necessary
# install.packages("devtools")
# devtools::install_github("stattleship/stattleship-r")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("stringr")
# devtools::install_github("nicolewhite/RNeo4j")

## packages -- if errors, see above
library(stattleshipR)
library(dplyr)
library(lubridate)
library(stringr)
library(RNeo4j)

## set the token from an environment variable
set_token(Sys.getenv("STATTLE_TOKEN"))
# set_token("yourtokenhere")

###############################################################################
## A few helper functions 
###############################################################################

## parse out entries from ss_get_result when walk=T and length > 1
parse_stattle <- function(stattle_list, entry) {
  x <- do.call("rbind", lapply(stattle_list, function(x) x[[entry]]))
  stopifnot(is.data.frame(x))
  return(x)
}

## helper function to import cql files against neo4j import shell tool
## set NEO_SHELL to your locally running neo4j server shell
# build_import <- function(NEO_SHELL="~/neo4j-community-2.3.1/bin/neo4j-shell", 
#                          cypher_file) {
#   cmd = sprintf("%s -file %s", NEO_SHELL, cypher_file)
#   system(cmd)
# }

###############################################################################
## A few calls against the Stattleship API gives us everything we need
###############################################################################

## get all of the completed games for the 2015-16 season
games_ss <- ss_get_result(ep="games", query=list(status="ended"), walk = TRUE)


## parse out the games and keep the columns we want (regular season only)
games <- parse_stattle(games_ss, "games") %>% 
  filter(interval_type=='regularseason') %>% 
  select(id, 
         started_at,
         ended_at,
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

## parse out the teams from the games API -- need to do that just once
teams <- parse_stattle(games_ss, "home_teams") %>% 
  unique(.) %>% 
  select(id, 
         location, 
         name, 
         nickname, 
         slug)  

## write the datafiles as csvs for neo import and future use
# save.image(file="data/session.Rdata")
write.table(games, file="data/games.csv", sep=",", row.names=F, na="")
write.table(teams, file="data/teams.csv", sep=",", row.names=F, na="")

###############################################################################
## Setup
###############################################################################

## connect to a running neo4j server , most likely this is running locally
graph <- startGraph("http://localhost:7474/db/data/",
                    username = "neo4j",
                    password = "password")

## clear the ENTIRE graph database -- will make clean slate
clear(graph, input=FALSE)

## import the constraints
build_import(cypher_file="cql/constraints.cql")

## import the database 
build_import(cypher_file="cql/build-db.cql")
