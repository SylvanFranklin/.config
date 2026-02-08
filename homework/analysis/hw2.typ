Sylvan Franklin | 2026-02-05

#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let qed = align(right, $square.filled$)
#let pf = text(style: "italic", [proof:])
#show regex("proof"): it => [_Proof:_]


*Problem 1.*

Prove that the sequence $a_n = x^n$
converges to $0$ if $abs(x) < 1$, and
diverges if $abs(x) > 1$.

Case $|x| < 1$

Let $epsilon > 0$.

WTS. $|x^n - A| < epsilon$  $forall n > N$
$
  <==> |x^n| < epsilon \
  <==> |x|^n < epsilon \
  <==> n ln |x| < ln epsilon \
  <==> n > log_(|x|) epsilon
$

Choose $N$ to be $>= log_|x| epsilon$

Case $|x| > 1$

For all $ forall A exists epsilon > 0
forall N exists n >= N
"such that"
|x^n - A| >= epsilon $

For all $A$, choose $epsilon = 1$
For all $N$, choose $n =$

$
  |x^n - A| >= 1 \
  |x^n - A| >= |x^n| - |A| \
  |x|^n >= 1 + |A| \
  n >= log_|x|(1 + |A|) \
$


*Problem 2.*
If $a_(n+2) = (a_(n+1) + a_n)/2$ for all $n geq 1$,
show that $a_n -> (a_1 + 2a_2)/3$

*Problem 3.* A real sequence $x_n$ satisfies
$7x_(n+1) = x^3_n + 6$ for $n geq 1$ if $x_1 = 1/2$.
Prove that the sequences increases and find it's
limit.

*Problem 4.* In Problem 3 what happens if
$x_1 = 3/2$ or if $x_1 = 5/2$.

*Problem 5.* If $abs(a_n) < 2$ and $abs(a_(n+2) - a_(n+1))
leq 1/8 abs(a^2_(n+1) - a^2_n)$ for all $n geq 1$,
prove that $(a_n)$ converges.




