library(DiagrammeR)

## the data model
grViz("
      digraph neo4j {
      
      # a 'graph' statement
      graph [overlap = false, fontsize = 10]
      
      # several 'node' statements
      node [shape = circle, fontname = Helvetica]
      a [label = '@@1-1'];
      b [label = '@@1-2'];
      c [label = '@@1-3'];
      y [label = 'Game'];
      e [label = '@@2-1'];
      f [label = '@@2-2'];
      g [label = '@@2-3'];
      h [label = '@@2-4'];
      
      # several 'edge' statements
      a -> b [label = '' fontsize = 9.5];
      b -> c [label = 'NEXT'];
      c -> d [label = 'NEXT'];
      d -> e [label = 'NEXT'];
      e -> f [label = 'NEXT'];
      a -> g [label = 'FROM_PERSONA'];
      a -> h [label = 'HAS_GENDER'];
      a -> i [label = 'LIVES_IN'];
      i -> j [label = 'IS_IN'];
      a -> k [label = 'HAS_INTERACTION' fontsize = 9.5];
      }
      
      [1]: rep('Team', 4)
      [2]: rep('Game', 4)
      ",
      engine = "circo")
