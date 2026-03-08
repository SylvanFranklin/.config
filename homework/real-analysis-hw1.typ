Sylvan Franklin | 2026-02-05


#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let ep = $epsilon$
#let qed = align(right, $square.filled$)
#let pf = text(style: "italic", [proof:])
#show regex("Proof"): it => [_Proof:_]


*Problem 1.*

Prove that the sequence $a_n = x^n$
converges to $0$ if $abs(x) < 1$, and
diverges if $abs(x) > 1$.

Proof

Case $|x| < 1$. Fix an arbitrary $ep > 0$. [Scratch work] $|x|$ as $1/(1+h)$, since $x < 1$. $|x^n|
= |x|^n = (1/(1+h))^n leq 1/(1+n h)$  By Bernouli's
inequality. Solving for $n$:  $(1/(1+n h)) < epsilon
==> 1 < (1+ n h) ep ==> 1 <ep + ep n h
==> (1-ep)/(ep h) < n.$ So pick $N = (1-ep)/(ep h)$. Now
$n geq N ==> n geq((1-ep)/(ep h)) ==> n ep h geq 1-ep
==> n ep h + ep >=1 ==>ep(n h + 1) geq 1 ==>ep geq
1/(1 + n h) geq |x|^n.$ By the definition of convergence 
this holds.

Case $|x| > 1$. Consider $ep = 1$. Now for any $N in NN$,
choose $n = N$. $|x^n| = |x|^n >= x^1 >= 1 = ep$   


#qed

*Problem 2.*
If $a_(n+2) = (a_(n+1) + a_n)/2$ for all $n geq 1$, show that $a_n -> (a_1 + 2a_2)/3$


*Problem 3.* A real sequence $x_n$ satisfies
$7x_(n+1) = x^3_n + 6$ for $n geq 1$ if $x_1 = 1/2$.
Prove that the sequences increases and find it's
limit.

*Problem 4.* In Problem 3 what happens if
$x_1 = 3/2$ or if $x_1 = 5/2$.

*Problem 5.* If $abs(a_n) < 2$ and $abs(a_(n+2) - a_(n+1))
leq 1/8 abs(a^2_(n+1) - a^2_n)$ for all $n geq 1$,
prove that $(a_n)$ converges.
