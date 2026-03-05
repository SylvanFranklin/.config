#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let pf = text(style: "italic", [proof:])
#let current = it => text(red)[CURRENT: #it]

#show regex("(?i)Proof"): it => [_Proof:_]
#show regex("qed"): it => align(right, $square.filled$)

#align(center)[Math 3517 | Section A | HW 4 | Sylvan Franklin  |
  2026-02-04 ]


*Section 2.4*

*2.*
Use the Euclidean Algorithm to obtain integers $x$ and $y$ satisfying
the following:

*(a)* $gcd(56, 72) = 56x + 72y$.

$
  72 = 56 (1) + 16 \
  56 = 16 (3) + 8 \
  16 = 8 (2) + 0 \
$

$8 = gcd(a, b) = 56 - 16(3) = (4)56 + -72(3)$

*(b)* $gcd(24, 138) = 24x + 138y$

$
  138 = 24 (5) + 18 \
  24 = 18 (1) + 6 \
  18 = 6 (3) + 0 \
$

$gcd(24, 138) = 6 = 24 - 18 = -138 + 24(6)$


*5.* For $n geq 1$, and positive integers
$a, b$. Show the following:

(a) If $gcd(a, b) = 1$, then $gcd(a^n, b^n) = 1$

$\#20$ $gcd(a, b) = 1 and gcd(a, c) = 1 ==> gcd(a, b c) = 1$

Proof:
Proceed by induction on $n$.
Assume $gcd(a, b) = 1$.
Base case: $n=1$ is true by assumption.
Inductive step, assume: $gcd(a, b^n) = 1$.
Since $gcd(a, b) = 1$ and $gcd(a, b^n) = 1$
Using $\#20$ We can conclude
$gcd(a, b^(n+1)) = 1$. By induction
$gcd(a, b) = 1 ==> gcd(a, b^n) =1$.
Since $gcd$ is symmetric we can apply
this argument twice, therefore
$gcd(a^n, b^n) = 1$

qed


(b) If $a^n | b^n ==> a | b$

// $gcd(a^n, b^n) = a^n$

$gcd(a, b) = d$ wts $d = a$

Now $k d = a$, and $l d = b$. We argue
$gcd(k, l) = 1$, since $gcd(k, l) d | a$
and $gcd(k, l) d | b$. It must be less
than $d$. $gcd(k^n, l^n) = 1$, since
$a^n | b^n ==> a^n r = b^n
==> (k d)^n r = (l d)^n
==> k^n r = l^n$, since $gcd(k^n, l^n) = 1$, Using previous
example $k^n = 1 ==> k = plus.minus 1 ==>
k = 1$ (since $a$, $b$ is positive),
we have $d = a ==> gcd(a, b) = a
==> a|b$

qed

*Section 2.5* (Diophantine Equations):

*1.* Which of the following Diophantine Equations cannot be solved.

(a) $6x + 51y = 22$. No since $gcd(6, 51) = 3 divides.not 22$

(b) $33x + 14y = 115$. Yes since $gcd(33, 14) = 1 divides 115$

(c) $14x + 35y = 11$ No since $gcd(14, 35) = 7 divides.not 11$

*2.* Determine all solutions in the integers of the following.

(a) $56 x + 72 y = 40$

Since $gcd(56, 72) = 8$, we know that solutions exist.
$
  72 & =(56) 1 + 16 \
  56 & =(16) 3 + 8 \
  16 & =(8) 2 + 0
$
General solution is given


$8 = 56 - 16 (3)
-> 8 = 56 - (3)(72 - 56)
-> 8 = 4(56) -3(72)$

$x = 4 + 7t, y = -3 - 9t$

*4.* If $a$ and $b$ are relatively prime positive
integers, prove that the Diophantine equation $a x -
b y = c$ has infinitely many solutions in the
positive integers.

$gcd(a, b) = 1$,
$==> a x_0 + b y_0 = 1$
$==> a (c x_0) + b (c y_0) = c$

So in general the solution is

$x = c (x_0) + b t$

$y = c (y_0) - a t$

qed

*Section 3.1* (Fundamental Theorem of Arithmetic):

*15.* Prove that a positive integer $a > 1$ is a square
if and only if in the canonical form of $a$,
all the exponents of the primes are even integers.

Proof

$==>$

Since $a$ is a square $a = b^2$, where $b in ZZ$.
By FToA $b = (p_1^(e_1) p_2^(e_2) ... p_n^(e_i))
==> b^2 = (p_1^(e_1) p_2^(e_2) ... p_n^(e_i))^2
==> b^2 = (p_1^(2e_1) p_2^(2e_2) ... p_n^(2e_i)) = a$.

$<==$

Since $(p_1^(2e_1) p_2^(2e_2) ... p_n^(2e_i)) = a$,
We have that $a = (p_1^(e_1) p_2^(e_2) ... p_n^(e_i))^2$

qed

*16.* An integer is said to be _square-free_ if it
is not divisible by the square of any integer greater
than $1$. Prove the following:

(a) An integer $n > 1$ is square-free if and only if $n$ can be factored into a product of distinct primes.

proof

$==>$

$n=p_1^e_1...p_n^e_n$ by the FToA.
Since $n$ is square free:
$a|n ==> a neq b^2$, for some $b>1 in ZZ$.
Since, $p_i^e_i|n$, $p_i^e_i neq b^2$.
No prime in the sequence $p_1...p_n$, may appear
more than once because then we would have
a square factor. Because for $e_i > 2$, we
have $p_i^2 | n$,
which contradicts $n$ being square free.

$<==$

We have $n = p_1...p_n$, which is unique by FToA.
Assume towards a contradiction $n = b^2$ for some $b in ZZ$.
By FToA $b = p_1^e_1...p_k^e_k ==> b^2 = (p_1^e_1...)^2 = n$.
Since we assumed the prime factorization of $n$
was distinct and unique, this is a contradiction.

qed

(b) Every integer $n > 1$ is the product of a square free integer and a perfect square.

Proof

Because of the FToA, we can write $n$ as
$p_1^e_1 ... p_k^e_k$. By the division
algorithm $e_i = 2k$ or $2k + 1$. Grouping
like terms after factoring $2$ out gives
$(p_i...)^2 p_j...$ Resulting in a square free
and square term.

qed
