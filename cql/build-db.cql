// the publicly available datasets
// teams csv: https://docs.google.com/spreadsheets/d/1N1ojcEY9syOvUI2EQ8ked54NGJB8Xmo9V-Rb5j0b7ZM/pub?gid=1724989853&single=true&output=csv
// games csv: https://docs.google.com/spreadsheets/d/1ZYBARl3UL6DL5OIQX43hcize7xyMf2HuzmskU10Hy2U/pub?gid=211648136&single=true&output=csv


// Load in the teams
//USING PERIODIC COMMIT
//LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/1N1ojcEY9syOvUI2EQ8ked54NGJB8Xmo9V-Rb5j0b7ZM/pub?gid=1724989853&single=true&output=csv" AS row
//RETURN row
//LIMIT 1

// Load in the games
//USING PERIODIC COMMIT
//LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/1ZYBARl3UL6DL5OIQX43hcize7xyMf2HuzmskU10Hy2U/pub?gid=211648136&single=true&output=csv" AS row
//RETURN row
//LIMIT 1

// import the teams
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/1N1ojcEY9syOvUI2EQ8ked54NGJB8Xmo9V-Rb5j0b7ZM/pub?gid=1724989853&single=true&output=csv" AS row
MERGE (t:Team {id:row.id, nickname:row.nickname, slug:row.slug});

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/Btibert3/neo4j-graphgist-2016/master/data/teams.csv" AS row
MERGE (t:Team {id:row.id, nickname:row.nickname, slug:row.slug});


//////////////////////////////// games

// import the games
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/1ZYBARl3UL6DL5OIQX43hcize7xyMf2HuzmskU10Hy2U/pub?gid=211648136&single=true&output=csv" AS row
WITH row
MERGE (g:Game {id:row.id, 
	           duration:toInt(row.duration), 
	           attendance:toInt(row.attendance), 
	           score_diff:toInt(row.score_differential), 
	           scoreline:row.scoreline} );


USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/Btibert3/neo4j-graphgist-2016/master/data/games.csv" AS row
WITH row
MERGE (g:Game {id:row.id, 
	           duration:toInt(row.duration), 
	           attendance:toInt(row.attendance), 
	           score_diff:toInt(row.score_differential), 
	           scoreline:row.scoreline} );


// connect the teams and games -- assumes everything is created already, otherwise use merge
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/1ZYBARl3UL6DL5OIQX43hcize7xyMf2HuzmskU10Hy2U/pub?gid=211648136&single=true&output=csv" AS row
WITH row
MATCH (g:Game {id:row.id})
MATCH (a:Team {id:row.away_team_id})
MATCH (h:Team {id:row.home_team_id})
WITH row, g, a, h
MERGE (a) -[:AWAY_TEAM {goals:toInt(row.away_team_score), 
	                    outcome:row.away_team_outcome,
	                    points: CASE WHEN row.away_team_outcome='win' THEN 2
	                                 WHEN row.away_team_outcome='overtime_loss' THEN 1
	                                 ELSE 0 
	                             END}]-> (g)
MERGE (h) -[:HOME_TEAM {goals:toInt(row.home_team_score), 
	                    outcome:row.home_team_outcome,
	                    points: CASE WHEN row.home_team_outcome='win' THEN 2
	                                 WHEN row.home_team_outcome='overtime_loss' THEN 1
	                                 ELSE 0 
	                             END}]-> (g);







