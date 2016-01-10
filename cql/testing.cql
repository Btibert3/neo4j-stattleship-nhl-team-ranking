// bruins subgraph
MATCH (b:Team {nickname:'Bruins'})-[rb]->(g:Game)<-[ro]-(o)
WITH b, rb, g, ro, o
RETURN *

// bruins winning percentage by team
MATCH (b:Team {nickname:'Bruins'})-[rb]->(g:Game)<-[ro]-(o)
WITH b, rb, o, CASE WHEN rb.outcome = 'win' THEN 2
                    WHEN rb.outcome = 'overtime_loss' THEN 1
                    ELSE 0
                    END as points, g
RETURN b, o, sum(rb.goals) as gf, sum(ro.goals) as ga, sum(points) as points, count(g) as games



