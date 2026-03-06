
#let neq = $eq.not$
#let geq = $>=$

#let closure = overline
#let interior(it) = $it^circle.small$
#let comp(it) = overline(it)
#let def = $:=$
#let leq = $<=$
#let iff = $<==>$
#let ep = $epsilon$
#let qed = align(right, $square.filled$)
#let ff = $cal(F)$
#let pf = text(style: "italic", [proof:])
#show regex("(?i)Proof"): it => [_Proof:_]
#show regex("qed"): it => align(right, $square.filled$)
#show regex("Problem \d*"): it => text(weight: "bold", [#it. ])
#let rn = $RR^n$
#let r2 = $RR^2$
#let sub = math.subset.eq
#let r3 = $RR^3$
#let en = $V_ep$
#let dn = $V_delta$
#let xn = $x_n$


//
// $x_n = (-1)^(n) (1-(1)/(n+1))$
//
// // $exists ep > 0 forall N |x_n - L|<ep => n>N$
//
// $(1-1/3), (1-1/5), (1-1/7), ..., (1-1/(2n + 1) -> 1$
//
// $-(1-1/2), -(1-1/4), -(1-1/6), ..., -(1-1/(2n)) -> -1$
//
// Since we have two convergent subsequence converging to
// different limits we have that this is divergent.


Proving that $sum r^n$ converges iff $r<1$

If it's a series of partial sums.

//
// $
// s_n &= 1 + r^1 + r^2 + ... + r^n \
// s_n (1-r) &= (1 + r^1 + r^2 + ... + r^n)(1-r) \
// s_n (1-r) &= (1^n-r^(n+1)) \
// s_n &= (1-r^(n+1))/(1-r)
// $


Let $|r| < 1$. Let $ep > 0$. Let $s_n$ be
the partial series of sums of $r^n$. Defined
as $s_n = (1-r^n)/(1-r)$. We will show that
$s_n$ converges. Choose $N = log(|r|) ep |1-r|$
Now $                           n & > log_(|r|) ep |1-r| \
                      |r|^n & > ep |(1-r)| \
              |(r^n)/(1-r)| & > ep \
|(1 - r^n)/(1-r) - 1/(1-r)| & > ep \ $

By the definition of convergence $s_n$ converges.


$
  |(1-r^n)/(1-r) - 1/(1-r)| < ep \
  |(r^n)/(1-r)| < ep \
  |(r^n)| < ep (1-r) \
  |r|^n < ep (1-r) \
  n < log_(|r|) ep |(1-r)| \
$

// $
// |(-1)^n (1-1/(n+1)) - 1| &< ep \
// |(-1)^n (1-1/(n+1)) - 1| &< ep \
// $




Prove that in $RR$
any finite set is compact.

proof

Method One: Compact $iff$ Bounded and Closed

Boundedness, by the well ordering principle we can
take the first and last elements of the
union of singletons as bounds.


If $a_n$ converges in a finite set $S$. It must
eventually be constant and in $S$. So
$S$ contains all it's limit points and is closed.

Method Two: Compact $iff$ Every Cover has a finite subcover


If $S$ has an open cover, then for every
$s in S$, $s$ is contained in some open set
in the cover $O(s)$. The union of these $O(s)$
form a finite subcover.

2026-03-04 06:18:30 Open closed Problems

Problem 11

a)
Take $1$ is a lower bound since $1$ is
less than all elements in the set.

Assume $m$ is an upper bound.
Consider $m+1$. Since $m+1 > 1$, it's
in the set and $m+1 > m$. Therefore
there is no upper bound.

If $n > inf S_2 = 1$, then $n in S_2$,
and is not a lower bound.

b) Not closed since $1$ is a limit point
not contained in $S_2$. Open since for
an arbitrary $x in S_2$. We have
an $en x sub S_2$, by choosing
$ep = {1-x}/2$.

Problem 12

The open unit disk.

a) Prove directly $A$ is open in $RR^2$

For an arbitrary $(x, y) in A$. Now
$x^2 + y^2 < 1$. Using $ep = 1-(d((x, y), (0, 0)))$.
For an arbitrary
$ d((a, b), (0, 0)) leq d((0, 0), (x, y)) + d((x, y), (a, b)) \
d((a, b), (0, 0)) < d((0, 0), (x, y)) + (1-d((x, y) + (0, 0))) \
d((a, b), (0, 0)) < 1 \ $.

b) Find $delta A$ (boundry) and $overline(A)$ the closure of $A$

$delta A = {(x, y) in RR^2 : x^2 + y^2 = 1}$

$closure(A) = {(x, y) in RR^2 : x^2 + y^2 leq 1}$

Problem 13.

$F = {(x,y) in r2 : x y geq 1, x > 0}$
#let fc = $F^c$
$fc = {(x,y) in r2 : x y < 1 "or" x < 0}$

A) Prove that $F$ is closed in $r2$. By
showing the complement is open.


proof


Splitting the complement into two sets
${(x, y): x leq 0} union {(x,y) : x y < 1}$.
In the first case.

Case one: ${(x, y): x leq 0}$.

Define a (continuous) function $g(x, y) = x$.
The preimage of this function is the real
line which is open.


Case two: ${(x,y) : x y < 1}$. Define a
(continuous) function $f(x) = 1/x$ provided $x neq 0$ .
The preimage of this function is $RR - {0}$,
which is open.



B) Is $F$ bounded.

Say the upper bound is $m = x y$. We have
$m' = (x+1)(y+1) > m$. Since $m' > m$ and
$m' in F$. There is no upper bound.


Problem 14


Let $U_1$ and $U_2$ by open sets in $rn$.

a) Prove that $U_1 inter U_2$ is open.

Consider $u in U_1 inter U_2$. We have
$en_1 u in U_1$ and $en_2 u in U_2$. Choose
the smaller $en_1$ and $en_2$. This new
epsilon ball will be contained in both by
definition of intersection.

b) Prove that $U_1 union U_2$ is open.

Consider $u in U_1 union U_2$. Case
$u in U_1$, Since $U_1$ is open $en u sub U_1$.
Which is in $U_1 union U_2$. Similarly
$u in U_2 ==> en_2 u in U_2 in U_2 union U_1$.

b) Give an example showing that an infinite
intersection of open sets need not be open.


$inter.big_(n geq 2) (1-1/n, 1+1/n)$ will
be eventually be ${1}$, which is not open.





\ \
Problem 15

Consider the set $E = QQ inter [0, 1]$

a) Show that $E$ is neither open nor closed in $RR$

Not open: If $x in E$, an $en x$ will intersect real
numbers which aren't rational.

Not Closed: Showing the complement is not open.
Choose $x in [0, 1]$ such that $x in II$. Since
the rationals are dense in side the reals. Any
$en x$ will intersect a rational number.

Find a limit point $in.not E$. We want to
find a series of rational numbers converging
to an irrational number in $[0, 1]$. We can
pick rational numbers approximating the decimal
expansion of $x$ to increasing accuracy.

Since this is finite, so bounded. We want to show that
it's not compact. Want an open cover with
no finite subcover.


b) Find $overline(E)$ and $interior(E)$

$overline(E) = [0, 1]$

$interior(E) = emptyset$

Problem 17

Prove that any closed subset of a compact set in
$rn$ is compact.

Our subset is closed by assumption and bounded
since it's the subset of a bounded set. Therefore
it's compact by Heine-Bore.

Problem 18.

We have a collection of compact sets, they are
by hb all closed and bounded.

a) Intersection. For boundedness take any of the
compact sets. The intersection is a subset and
will be bounded by this contact set.

Want to show of closed sets is closed. If
$a_n$ converges to $n$. Since each of the
sets in the intersection is closed. $n$ must
be in all of the sets, and therefore $n$ is in
the intersection.


Problem 22

Continuity of $f(x) = 3x^2 -5x + 2$

For all Epsilon we have Delta such that

$|x - c| < delta ==> |f(x) - f(c)| < epsilon$

Let $ep > 0$ as arbitrary.
Let $m=(3(1+|2c| + |5|))$
Choose $delta = min(ep/m, 1)$
Let $x$, be in the domain $0 < |x-c| < delta$
Note that $|(x+c)|$ is bounded by $1+|2c|$.
Since $|x+2c-c| leq |x-c|+|2c| = 1 + |2c|$
Using $|x-c| < 1$.
Now $|3(x+c)-5| leq 3(1+|2c|+|5|) < m$

Now,
$
  |3x^2 - 5x +2 - (3c^2 - 5c +2)| = \
  |3(x^2 - c^2) - 5(x+c)| = \
  |3(x-c)(x+c) - 5(x-c)| = \
  |(x-c)||(3(x+c) - 5)| leq \
  |(x-c)|m < \
  delta m leq epsilon
$

By the definition of continuity this is
continuous.


// - Consistently finding the value
// of Epsilon and verifying algebraically
//
//
// How do you consistenly determine
// the value of epsilon for openness
// proofs. What's the "algorithm".
//

// $forall en f(c)$ and $exists dn c$,
// then $x in dn c ==> f(x) in en f(c)$
//
// Let $e > 0$.
//
// Find a delta, dependent
// on epsilon, such that
// $x$.




