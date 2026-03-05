//
// // If we could have a mode that would display
// // all of these definitions as cheat sheets,
// // and then another mode that would export this
// // as a set of flashcards that would be very interesting
// // After that's established making automatic connections
// // would be very interesting.
//
//
// #let neq = $eq.not$
// #let ep = $epsilon$
// #let geq = $>=$
// #let Union = $union.big$
// #let leq = $<=$
// #let iff = $<==>$
// #let qed = align(right, $square.filled$)
// #let pf = text(style: "italic", [proof:])
// #show regex("Proof"): it => [_Proof:_]
//
// https://rethinks.org/blog/wn7L93tV8V
//
// Definition: Open Set
// A set $O subset RR$ is open if for all points
// $a in O$, there exists an epsilon neighborhood
// $V_ep(a) subset O$.
//
// Definition: Closed Set
// A set is closed if it contains all it's limit
// points.
//
// Definition: Limit point (Cluster point, Accumulation Point)
// A point $x$ is a limit point of a set $A$
// if every epsilon neighborhood $V_ep(x)$
// intersects the set $A$ at some point
// other than $x$.
//
// A point $x$ is a limit point of $A$ if every neighborhood
// of $x$ contains infinitely many points of $A$
//
// A point $x$ is a limit point if and only if $x = lim_a_n$ for
// some sequence $(a_n)$ contained in $A$ satisfying $a_n neq x$
// for all $n in N$.
//
// Definition: Isolated Point
// A point $x in A$ is an isolated point of $A$ if
// it's not a limit point of $A$.
//
// Definition: Compact set
// A set $K subset RR$ is compact if every sequence
// in $K$ has a subsequence that converges to a limit
// that is also in $K$
//
// Definition: Open cover
// Let $A subset RR$. An open cover for $A$ is a (possibly infinite)
// collection of open sets ${O_lambda : lambda in Lambda$ whose union
// contains the set $A$; that is,
// $A subset Union_(lambda in Lambda) O_lambda$ Given an open cover
// for $A$, a finite subcover is a finite
// sub-collection of open sets from the original
// open cover who's union still manages to contain $A$.
//
// Definition: Connected Set.
// A set $E subset RR$ is connected if and only if,
// for all nonempty disjoint sets $A$ and $B$
// satisfying $E = A union B$, there always exists a
// convergent sequence $(x_n) -> x$ with $(x_n)$
// contained in one of $A$ or $B$, and $x$ an element
// of the other.
//
// Definition: Perfect Set
// A set $P subset RR$ is perfect if it is closed and contains
// no isolated points.
//
// Interior Point
//
//
// When trying to prove that a set is closed
// it's often easier to prove that the
// complement is open.
//
// vEnhance on youtube
//
//
// Just think of a finite set as a union of
// singleton sets, then you can prove it’s
// closed
//
// I guess there are two ways of
// doing this: take the def of "upper bound"
// and either (1) show that there is no element
// that satisfies it, or (2) shows that
// assuming that there is such implies
// contradict
//
//
// that's why pictures help a lot in analysis. We
// would usually just sketch something on the
// board and then guess epsilon from the picture
// and then an algebraic proof would become a
// technicality
//
//
// each but coming up with the tactic is one of the hardest
// parts of writing a proof, because you might try 5 different
// strategies before landing on one that works
