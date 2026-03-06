// #set text(white)
// #set page(fill: black)
Sylvan Franklin | 2026-02-05 | Real Analysis

#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let ep = $epsilon$
#let qed = align(right, $square.filled$)
#let pf = text(style: "italic", [proof:])
#show regex("(?i)Proof"): it => [_Proof:_]
#show regex("qed"): it => align(right, $square.filled$)

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
1/(1 + n h) geq |x|^n.$ By the definition of convergence this holds.

Case $|x| > 1$. Consider $ep = 1$. Now for any $N in NN$,
choose $n = N$. $|x^n| = |x|^n >= x^1 >= 1 = ep$



qed

*Problem 2.*
If $a_(n+2) = (a_(n+1) + a_n)/2$ for all $n geq 1$, show that $a_n -> (a_1 + 2a_2)/3$

Proof

qed

*Problem 3.* A real sequence $x_n$ satisfies
$7x_(n+1) = x^3_n + 6$ for $n geq 1$ if $x_1 = 1/2$.
Prove that the sequences increases and find it's
limit.

Proof

Proceed by induction on $n$.
Base case: $1/2 < (6 + 1/8)/7$.
Assume $x_n < x_(n+1)$.
$
            x_n & < x_(n+1) \
          x_n^3 & < x_(n+1)^3 \
      x_n^3 + 6 & < x_(n+1)^3 +6 \
  (x_n^3 + 6)/7 & < (x_(n+1)^3 +6)/7 \
$
By induction $x_n$ is increasing for all $n in NN$.


$
          (L^3 + 6)/7 & = L \
        (L^3 -7L + 6) & = 0 \
  (L+1)(L - 1)(L - 6) & = 0 \
$

Because the sequence is positive and increasing,
the limit must be either $6$ or $1$. I strongly suspect
that it's 1, but to prove it we can show that it's bounded
by $1$ using induction. Base case $1/2 < 1$.
Inductive step: Assume $x_n leq 1$ wts $x_(n+1) < 1$.
Since $1/7(1^3 + 6) = 1$ we know that $x_n$ is bounded by $1$.

qed


*Problem 4.* In Problem 3 what happens if
$x_1 = 3/2$ or if $x_1 = 5/2$.

In both cases the sequence will diverge, consider $epsilon = 2$.  

*Problem 5.* If $abs(a_n) < 2$ and $abs(a_(n+2) - a_(n+1))
leq 1/8 abs(a^2_(n+1) - a^2_n)$ for all $n geq 1$,
prove that $(a_n)$ converges.

proof

Since the sequence has an upper bound $2$, it remains
to show that $a_n$ is monotonic increasing.


qed


