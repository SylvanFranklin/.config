#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node


#set page(width: 5in, height: 3in, fill: black)
#set text(fill: white, font: "0xProto Nerd Font Mono", size: 38pt)

On a break eating food

#place(bottom + left)[
  #set text(size: 10pt)
  $e^(i pi) = -1$
]

#place(bottom + center, box(width: 10pt, diagram(
  edge-stroke: (white),
  cell-size: 15mm,
  $
                  G edge(f, ->) edge("d", pi, ->>) & im(f) \
    G slash ker(f) edge("ur", tilde(f), "hook-->")
  $,
)))
