// ratins and stregnth of schedule
// http://www.collegerpi.com/rpifaq.html

// import the teams
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/neo4j-graphgist-2016/data/teams.csv" AS row
MERGE (t:Team {id:row.id, nickname:row.nickname, slug:row.slug});


// import the games
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/neo4j-graphgist-2016/data/games.csv" AS row
WITH row
MERGE (g:Game {id:row.id, 
	           duration:toInt(row.duration), 
	           attendance:toInt(row.attendance), 
	           score_diff:toInt(row.score_differential), 
	           scoreline:row.scoreline,
	           year:toInt(row.year),
	           month:toInt(row.month),
	           day:toInt(row.day)} );


// connect the teams and games -- assumes everything is created already, otherwise use merge
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/neo4j-graphgist-2016/data/games.csv" AS row
WITH row
MATCH (g:Game {id:row.id})
MATCH (a:Team {id:row.away_team_id})
MATCH (h:Team {id:row.home_team_id})
WITH row, g, a, h
MERGE (a) -[:AWAY_TEAM {goals:toInt(row.away_team_score), 
	                    outcome:row.away_team_outcome,
	                    win: CASE WHEN row.away_team_outcome='win' THEN 1
	                              ELSE 0
	                              END,
	                    points: CASE WHEN row.away_team_outcome='win' THEN 2
	                                 WHEN row.away_team_outcome='overtime_loss' THEN 1
	                                 ELSE 0 
	                             END}]-> (g)
MERGE (h) -[:HOME_TEAM {goals:toInt(row.home_team_score), 
	                    outcome:row.home_team_outcome,
	                    win: CASE WHEN row.home_team_outcome='win' THEN 1
	                              ELSE 0
	                              END,
	                    points: CASE WHEN row.home_team_outcome='win' THEN 2
	                                 WHEN row.home_team_outcome='overtime_loss' THEN 1
	                                 ELSE 0 
	                             END}]-> (g);







