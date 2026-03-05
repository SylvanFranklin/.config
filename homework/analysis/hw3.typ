Sylvan Franklin | Real Analysis | 2026/02/18

#line(length: 100%, stroke: 0.5pt)

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
#let en = $V_ep$
#show regex("(?i)Proof"): it => [_Proof:_]
#show regex("qed"): it => align(right, $square.filled$)
#show regex("Problem \d"): it => text(weight: "bold", [#it. ])

Problem 1
If $S subset.eq RR^n$ prove that $"int"(S)$ is the
union of all open subsets of $RR^n$ which are
contained in $S$.

#let is = $"int"(S)$

proof

$U def union.big {s sub rn : s sub S "and" s "is open"}$,
$is def {x in S: exists en (x) sub S}$.

*$U subset.eq is$:* Let $x$ in $U$. So $x in M$, for some $M sub S$, where
$M$ is open. Want to show that $exists en(x) sub S$.
Take $M$ to be the epsilon neighborhood.

*$is subset.eq U$*: Let $x in is$. Since $is$ is an open
subset of $S$. It's in $U$.

qed


Problem 2
Let $ff$ be a collection of sets in $rn$, and let $T
:= inter_(A in ff)A$. Prove that if $x$ is a limit
point of $T$ then $x$ is a limit point of each set $A$
in $cal(F)$.

proof

Since $x$ is a limit point of $T$. There exists a
sequence $a_n$ contained in $T$. Which implies $a_n in
A$ for each $A in ff$.

qed


Problem 3
Prove that the collection $ff def {(1/n, 2/n)|n = 2, 3, 4, ...}$
is an open covering of $(0, 1)$. Moreover, show that no
finite subcollection of $ff$ covers $(0, 1)$

proof

Want to show every element of $ff$ is open. Given an arbitrary $(1/n, 2/n)$
for some $n in NN^(geq 2)$. Let $ep > 0$.
For an arbitrary $x in (1/n, 2/n)$, choose
$ep = min({|x-1/n|, |2/n-x|})$. Since an arbitrary union
of open sets is open, $ff$ is open. Now want to
show that $(0, 1) sub ff$. For an arbitrary $x in (0, 1)$.
We want $n in NN$ such that $x in (1/n, 2/n)$, in other words
$2/n > x > 1/n$. Multiply through by $n/x$. Now
$2/x > n > 1/x$. Choose $n$ to be the largest integer
less than $2/x$. $n$ is at least $2/x -1 - (2 -x)/x$.
But $x < 1$ so $n > (2 -1) / x > 1/x$

If $S$ is a finite subcollection of $ff$. Take $n$ to
be the largest index in the sub collection.
$x = 1/(n+1)$ won't be in the union.

qed

Problem 4
Prove that the only connected subsets of $RR$ are

1. The Empty Set:
Vacuously true, by definition.

2. The sets consisting of a single point.
If the set contains a single point, by
the definition it can't be the union of
two disjoint nonempty sets. So it is vacuously
connected.

3. Intervals (open, closed, infinite)

If $S$ is a connected subset of $RR$.
Want to show that if $a, c in S$, then
$a < b < c ==> b in S$. If $b in.not S$,
then we can construct a disjoint union
$S = {s in S | s < b} union {s in S | b < s}$.
Then $S$ is disconnected. If $b in S$. Then
by definition $S$ is an interval.

qed

Problem 5

Show that the following function are continuous
in their domain:

a) $f : (0, 1] -> RR$ where $f(x) = 1/x$

proof

Let $c in (0, 1]$. Let $ep > 0$
be arbitrary. Let $delta = min {c/2, (epsilon c^2) / 2}$.
Let $0 < |x-c| < delta$ and $x in (0, 1]$.
Now $|x-c| < delta ==> |x-c| < ep c^2/2 ==>
|x-c| < x c ep ("since" c/2 < x) ==> |(x c)/(x-c)| < ep
==> |1/x = 1/c| < ep.$

qed

b) $f : [-m, m] -> RR$ where $f(x) = x^n$, for $n = 2, 3, 4, 5, ...$

proof

Let $ep > 0$. Let $c in [-m, m]$.
Let $delta = epsilon/(n m^(n-1))$.
Now let $0 < |x-c| < delta$. And $x in [-m, m]$ Now
$|x-c| < epsilon/(n m^(n-1))
==> |x-c||n m^(n-1)| < ep
("since" |x|,|c| < m)
==> |(x-c)||x^(n-1) + c x^(n-2) + ... + c^(n-1)|
leq |x-c||n m^(n-1)| < ep
==> |x - c| < ep$

qed


#line(length: 100%, stroke: 0.5pt)

= Extra

For each of the following distance functions determine
whether the sets are closed, open, or compact or some combination.
In each case using a metric space $M def (rn, d)$.

$ d_2(x, y) = ||x-y||_2 = sqrt(sum_(i=1)^n (x_i - y_i)^2) $
*1 -- The integer lattice* $ZZ^n = {x in rn : x_i in ZZ "for all" i}$

Not open since ${x_1 + epsilon / 2, x_2,...x_n}$,
intersects $ZZ^n$ at $x_2$, but
${x_1 + epsilon / 2, x_2,...x_n} subset.eq.not ZZ^n$
for $epsilon < 1$.

It is Closed since all points are
isolated points, and points, cannot
be both limit and isolated points.
Vacuously this is closed.

It's unbounded so cannot be compact.

*2 -- The cone* $C = { x in rn : x_n geq ||(x_1,...,x_(n-1))||_2 }$

The cone is not open because the epsilon
neighborhood around ${0,..,0}$ contains
${0,..,-epsilon/2} in.not C$.

Closed: Given an arbitrary convergent
sequence $x_a (in C) = {x_1,...x_n}$.
We have two component sequences
$B_a = (x_(a))_n$ and $A_a = ||(x_a)_1,...(x_a)_(n-1)||$
Now since $x_a in C$, $B_a geq A_a$.
Since $lim B_a geq lim A_a$, we have our
arbitrary limit point in $C$. So $C$
is closed.

Since $C$ is unbounded it's not compact.

*3 -- The open unit ball* $B(0, 1) = {x in rn : ||x||_2 < 1}$

Open: for an arbitrary $x_1 in B(0, 1)$,

Instance from edge $1 - |x_1|$,
say $epsilon = (1 - |x_1|)/2$. $V_epsilon(x_1) subset.eq B$

Not Closed: The sequence $(1-1/n, 0,...,0)$ is
contained within $B(0, 1)$. But it's limit
$1$ is not.

Since this isn't closed it's not compact.

*4 -- A hyperplane* $H = {x in rn : a dot x = c }$ for fixed $a in rn - {0}, c in RR$

Not open:
Let $a = (a_1, ..., a_n) in rn - {0}$,
And $a_k neq 0$ for some $k$.
Then $Q = {x_1,...x_k + ep / 2, ..., x_n}$.
Then $Q dot A = P dot a + a_k ep / 2$. Which
isn't in the hyperplane.
Since $||Q-P|| = ep / 2$, $P in en(Q)$. So
this epsilon ball is not in the hyperplane.

Closed: By showing the complement is open. If $v in H^C$,
then $a dot v neq c ==> |c - a dot v| > 0$. Now we want
to show that $B_(|c-a dot v|/||a||)(v) subset H^C$. For
an arbitrary $p in B_(|c-a dot v|/||a||)(v)$, $||p-v|| < (|c - a dot v|)/||a||$
$
  |c = a dot v| & = |(c - a dot p) + (a dot p - a dot v)| \
                & leq |c - a dot p| + |a dot p - a dot v| & <
$


Since the $H$ is unbounded it's not compact.

*5 -- The Trefoil Knot* $K = {sin t + 2 sin 2t, cos t - 2 cos 2t, -sin 3t} : t in [0, 2pi]$


Closed since it's the continuous (sin / cos) image of a closed set $[0, 2pi]$

Not open: Since the only open and closed sets are
$emptyset "and" RR$

Compact since the continuous (sin / cos) image
of a compact set is compact.

$ d_1(x, y) = ||x-y||_1 = sum_(i=1)^n abs(x_i - y_i) $

*1 -- The integer lattice* $ZZ^n = {x in rn : x_i in ZZ "for all" i}$

Same properties hold as $d_2$.

*2 -- The cone* $C = { x in rn : x_n geq ||(x_1,...x_(n-1))|| }$

Same properties hold as $d_2$.

*3 -- The open unit ball* $B(0, 1) = {x in rn : ||x||_2 < 1}$

Same properties hold as $d_2$.

*4 -- A hyperplane* $H = {x in rn : a dot x = c }$ for fixed $a in rn - {0}, c in RR$

Same properties hold as $d_2$.

*5 -- The Trefoil Knot* $K = {sin t + 2 sin 2t, cos t - 2 cos 2t, -sin 3t} : t in [0, 2pi]$

$ d_infinity(x, y) = ||x-y||_infinity = attach("max", b: 0 < i < n) |x_i - y_i| $

*1 -- The integer lattice* $ZZ^n = {x in rn : x_i in ZZ "for all" i}$

Not open. Since $exists r in en(x) | r in rn$. Since $x$ is a point in the
integer lattice and $ep > 0$. Also $r$ is not in the lattice.

It is Closed since all points are
isolated points, and points, cannot
be both limit and isolated points.
Vacuously this is closed.

Not compact since $1, 2, 3, ...$ does not converge.
Let $ep$

*2 -- The cone* $C = { x in rn : x_n geq ||(x_1,...x_(n-1))||}$

Same arguments as standard Euclidean distance.

*3 -- The open unit ball* $B(0, 1) = {x in rn : ||x||_2 < 1}$

Same arguments as standard Euclidean distance.

*4 -- A hyperplane* $H = {x in rn : a dot x = c }$ for fixed $a in rn - {0}, c in RR$

Same arguments as standard Euclidean distance.

*5 -- The Trefoil Knot* $K = {sin t + 2 sin 2t, cos t - 2 cos 2t, -sin 3t} : t in [0, 2pi]$

Same arguments as standard Euclidean distance.

$ d_"disc"(x,y) = cases(0 "if" x = y, 1 "if" x neq y) $

In general for a set $S$ if $a_n$ is a convergent sequence in $S$.
We want to show that $a_n --> a$, where $a in S$. Let $ep = 1$. Now
$|a_n - a| < ep$, for some $n > N in NN$. By definition of discrete
distance $a_n = a$. Therefore any set $S$ is closed. So $S^C$ is also
closed. And since the complement of any set is closed, the set must be
open. So the next five problems are all both closed and open.

Showing that infinite sets aren't compact in the metric
will make this easier. Suppose a set $S$ is infinite.
There exists an infinite sequence $a_n in S$, which
contains distinct elements. It's non constant and every
sequence is non constant. Since being eventually
constant and converging are the same thing in the metric
space the set is not compact. All of the following sets
are infinite and therefore not compact.

*1 -- The integer lattice* $ZZ^n = {x in rn : x_i in ZZ "for all" i}$

*2 -- The cone* $C = { x in rn : x_n geq ||(x_1,...x_(n-1))||_"disc" }$

*3 -- The open unit ball* $B(0, 1) = {x in rn : ||x||_"disc" < 1}$

The ball is just a point for any $n$ and is finite so not compact.

*4 -- A hyperplane* $H = {x in rn : a dot x = c }$ for fixed $a in rn - {0}, c in RR$

In the case that $n=1$. The hyperplane is just a point so it's finite and therefore compact.

*5 -- The Trefoil Knot* $K = {sin t + 2 sin 2t, cos t - 2 cos 2t, -sin 3t} : t in [0, 2pi]$

