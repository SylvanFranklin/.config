#let neq = $eq.not$
#let geq = $>=$
#let def = $:=$
#let leq = $<=$
#let iff = $<==>$
#let ep = $epsilon$
#let qed = align(right, $square.filled$)
#let ff = $cal(F)$
#let pf = text(style: "italic", [proof:])
#let rn = $RR^n$
#let r2 = $RR^2$
#let sub = math.subset.eq
#let r3 = $RR^3$
#let cong = math.eq.triple
#let en = $V_ep$

#let styling = it => {
  show regex("(?i)Proof"): it => [_Proof:_]
  show regex("qed"): it => align(right, $square.filled$)
  show regex("Problem \d"): it => text(weight: "bold", [#it. ])
  // set text(white)
  // set page(fill: color.rgb("#323C4A"))
  it
}

