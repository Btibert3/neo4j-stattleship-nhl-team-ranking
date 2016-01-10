// winning percentage for the bruins
MATCH (b:Team {nickname:'Bruins'})-[rb]->(g:Game)<-[ro]-(o)
WITH b, rb, g, ro, o
RETURN o.nickname, count(g) as games, sum(rb.goals) as gf, sum(ro.goals) as ga, sum(rb.points) as points
ORDER BY games DESC

// for each team, return their stats against optonents, and the oppents against everyone else exxcept them
// runs but data dont seem correct, like multiple counting
MATCH (a:Team {nickname:'Bruins'})-[r1]->(g1:Game)<-[r2]-(b:Team)-[r3]->(g2:Game)<-[r4]-(c:Team)
WHERE a <> c
WITH a.nickname as bruins, 
     sum(r1.goals) as gf, 
     sum(r1.points) as pts_for, 
     sum(r2.goals) as ga, 
     sum(r2.points) as pts_a,
     sum(r3.goals) as opp_for,
     sum(r3.points) as opp_pts_for,
     sum(r4.goals) as opp_ga,
     sum(r4.points) as opp_pts_a
RETURN *
LIMIT 10

// explore
MATCH (a:Team {nickname:'Bruins'})-[r1]->(g1:Game)<-[r2]-(b:Team)-[r3]->(g2:Game)<-[r4]-(c:Team)
WHERE a <> c
RETURN a, r1, g1, r2, b, r3, g2, r4, c
LIMIT 10


// goals for and allowed
MATCH (b:Team)




games
https://docs.google.com/spreadsheets/d/1QwXJE2qWVsejWeJGOouYxblNTox_Z9Ly5TWggzQNQVY/pub?gid=33501648&single=true&output=csv
teams
https://docs.google.com/spreadsheets/d/1QwXJE2qWVsejWeJGOouYxblNTox_Z9Ly5TWggzQNQVY/pub?gid=0&single=true&output=csv
