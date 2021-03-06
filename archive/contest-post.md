# NHL Team Rankings with Stattleship and Neo4j
:neo4j-version: 2.3.0
:author: Brock
:twitter: @brocktibert

## About this entry

This entry is intended to demonsrate how easy it is, using Stattleship's API, and R package, along with Neo4j as a database, to 
create your own team rankings/strength of schedule ranking/adjustment.

*** Include links ***


== Assumptions

1.  R installed  
2.  

== Data Model



// Provide an introduction to your data modeling domain and what you are trying to accomplish

// Provide a domain model image (using something like http://www.apcjones.com/arrows/# or https://www.gliffy.com/)

// You can run this query to get an overview of entities and how they are related:
// MATCH (a)-[r]->(b) WHERE labels(a) <> [] AND labels(b) <> []
// RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That LIMIT 10

image::http://i.imgur.com/5giAsjq.png[]

// REMOVEME: A Cypher query to setup the database
//setup
//hide
[source,cypher]
----
CREATE
  (a:Person {name: 'Alice'}),
  (b:Person {name: 'Bob'}),
  (c:Person {name: 'Carrie'}),
  (d:Person {name: 'David'}),
  (e:Person {name: 'Emily'}),
  (a)-[:FRIENDS_WITH]->(b),
  (a)-[:FRIENDS_WITH]->(e),
  (b)-[:FRIENDS_WITH]->(c),
  (b)-[:FRIENDS_WITH]->(d)
----

// REMOVEME: Display the whole graph:

//graph

// REMOVEME: Describe what this query is designed to do

// REMOVEME: A Cypher query to give table output
[source,cypher]
----
MATCH (a:Person {name: 'Alice'})-[:FRIENDS_WITH]-(:Person)-[:FRIENDS_WITH]-(fof:Person)
RETURN fof.name
----

//table

// REMOVEME: Describe what this query is designed to do

// REMOVEME: A Cypher query to give graph visualization output
[source,cypher]
----
MATCH path=(a:Person {name: 'Alice'})-[:FRIENDS_WITH]-(:Person)-[:FRIENDS_WITH]-(fof:Person)
RETURN path
----

//graph_result

// REMOVEME: Offer a conclusion