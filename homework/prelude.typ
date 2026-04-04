#let neq = $eq.not$
#let geq = $>=$
#let def = $:=$
#let times = $dot$
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
#let problem = counter("problem")


#let styling = it => {
  show regex("(?i)Proof"): it => [_Proof:_]
  show regex("qed"): it => align(right, $square.filled$)
  show regex("(?i)Problem"): it => {
    problem.step()
    context text(weight: "bold", [Problem #problem.display()])
  }
  it
}



