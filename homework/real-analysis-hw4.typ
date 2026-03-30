#import "prelude.typ": *;
#show: styling
Sylvan Franklin | Real Analysis | Homework 4

#line(length: 100%, stroke: 0.5pt)


*Problem 1*

a) Possible with $f(x) = x$, since $lim_(x->1) f(x) = 1 in (0, 1]$

b) Not possible because we have a gap at $1$ that we have to jump over.

c) $f(x, y) = (tan (pi (x - 1/2)), tan(pi (y - 1/2))$

d) Not possible since $S$ is compact but $T$ is not.

*Problem 2*

proof

Let the domain = $A$. For all $x in A$, $forall ep>0 exists delta>0$ st. $|x-c|
< delta ==> f(x) - f(c) < ep$ By the definition of uniform continuity $exists
delta$, such that this holds.

qed

*Problem 3*
a) proof

Construct $g = f(x) - f(x + 1/2)$, which is continuous $g(0) = f(0) - f(1/2)$
and $g(1/2) = f(1/2) - f(1)$ If $g(0)=0$ we're done, otherwise $g(0) neq 0$,
then $g(0)$ and $-g(0)$ have opposite signs. By the MVT this $g$ has a $0$ for
$g$. And therefore $f(x) = f(y)$ and $|x-y| = 1/2$.

qed

b)
Construct $g = f(x) - f(x + 1/n)$, if $g = 0$ we're done.
Consider $g(0), g(1/n), ... g(1)$. If you have a change in
sign, there must must be a zero by IVT. WLOG if $g(0)$ is
positive, and if we have no zeros, then $g(1/n)$ should also be positive, up to
$g(1)$. So $f(0), f(1/n), f(2/n), ... f(1)$  must be strictly decreasing, but
$f(0) = f(1)$ which is a contradiction.

c) If $g(0)$ is positive and $g(2/5)$

$f(0) = f(1) = 0, f(1/5)=2, f(2/5)= -1, f(3/5) = 1, f(4/5)=-2$


*Problem 4*

Def $forall ep > 0 exists delta > 0$, st. $|x-c| < delta ==> |f(x) - f(c)| < ep$,
where $x, c in [0, 1]$.

proof

Let $ep$ be arbitrary. Let $delta = ep/2$
Assume $|x-c| < delta$.
$
  |x^2 - c^2| = |(x-c)(x+c)| = |x-c||x+c| < delta (x+c) < 2 delta < epsilon
$

qed
