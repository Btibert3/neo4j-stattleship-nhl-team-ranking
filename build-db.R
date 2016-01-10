options(stringsAsFactors = FALSE)

## packages
library(stattleshipR)
library(dplyr)
library(lubridate)
library(stringr)

## set the token
set_token(Sys.getenv("STATTLE_TOKEN"))

## helper function
parse_stattle <- function(stattle_list, entry) {
  x <- do.call("rbind", lapply(stattle_list, function(x) x[[entry]]))
  stopifnot(is.data.frame(x))
  return(x)
}

## get the API request for games 
games_ss <- ss_get_result(ep="games", query=list(status="ended"), walk = TRUE)

## parse out the games and keep the columns we want
games <- parse_stattle(games_ss, "games")
games <- select(games, 
                id, 
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

## parse out the teams from the games API
teams <- parse_stattle(games_ss, "home_teams")    ## just need to get once
teams <- unique(teams) %>% 
  select(id, 
         location, 
         name, 
         nickname, 
         slug)  

## write the datafiles for neo import
save.image(file="data/session.Rdata")
write.table(games, file="data/games.csv", sep=",", row.names=F, na="")
write.table(teams, file="data/teams.csv", sep=",", row.names=F, na="")

## connect to a running neo4j server -- for local development
# library(RNeo4j)
# graph <- startGraph("http://localhost:7474/db/data/",
#                     username = "neo4j",
#                     password = "password")
# 
# ## helper function to import cql files against neo4j import shell tool
# ## a function to import cypher statements into the shell
# build_import <- function(NEO_SHELL="~/neo4j-community-2.3.1/bin/neo4j-shell", 
#                         cypher_file) {
#   cmd = sprintf("%s -file %s", NEO_SHELL, cypher_file)
#   system(cmd)
# }
# 
# 
# ## clear the ENTIRE graph database
# clear(graph, input=FALSE)
# 
# ## import the constraints
# build_import(cypher_file="cql/constraints.cql")
# 
# ## import the database 
# build_import(cypher_file="cql/build-db.cql")
