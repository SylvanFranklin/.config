#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let qed = align(right, $square.filled$)
#let pf = text(style: "italic", [proof:])
#show regex("Proof"): it => [_Proof:_]


$(1+h)^n geq 1 + h n$


Binomial theorem trick
Triangle inequality 

Convergence:
For every $epsilon > 0$, there
is an integer $N$, such that
$d(x_n, p) < epsilon$
whenever $n geq N$


--- PROOF TEMPLATES

Convergence.

proof

Let $epsilon > 0$ be arbitrary. Now
find an $N in NN$ (using scratch work, this
is usually in terms of $epsilon$ ).
Show that $n geq N ==> |a_n -A| < epsilon$


Convergence 

$exists A$ for the sequence $a_n$ $(forall epsilon >
0)(exists N)(forall n in NN)(n >=N ==>|a_n - A| <
epsilon)$

Divergence 
$forall A$ for the sequence $a_n$ $(exists
  epsilon > 0)(forall N)(exists n in NN)(n >=N and |a_n - A| >= epsilon)$










