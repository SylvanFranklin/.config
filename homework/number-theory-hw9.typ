Sylvan Franklin |
Number Theory |
#datetime.today().display()

#import "prelude.typ": *;
#show: styling

6.2

Problem 2

proof

If $Lambda(n) > 0$, then $n$ is a prime power.
This $n$ decomposes as a product of prime powers:
$p_1^e_1 ... p_k^e_k$, using log rules
$log n = e_1log(p_1) + ... + e_k log(p_k)$. Since only
prime powers will contribute to the sum, and
we have exactly $e_1$ contributions of $p_1$,
therefore we get: $ sum_(d|n) Lambda(n)
= e_1log(p_1) + ... + e_k log(p_k)
= log n $ Applying the Möbius inversion function
with $g=Lambda$ and $f=log(n)$ we get
$log n = sum_(d|n) mu (n /d) log d$. Indexing
backwards $log n = sum_(d|n) mu (d) log (n/d)$,
then splitting using log properties.
$(sum_(d|n) mu (d)) log n - sum_(d|n) mu(d) log d$
Then by Theorem 6.6 this will reduce to
$- sum_(d|n) mu(d) log d$

qed

Problem 4

(a)

proof

Since $tau(p) = 2$, when $p$ is prime and
$tau$ is multiplicative. Since every
$1-tau(p_n) = -1$,
$sum_(d|n) mu(d)tau(d) = (-1)^r$

qed

Problem 5

proof

$|mu(n)| = 0$ if $n$ is divisible by a
square, and $1$ otherwise. So $S(n) =
sum_(d|n)|mu(d)|$ is obvious. With the
set of prime factors of $n$, where
the exponents are either $1$ or $0$.
${p_1, ..., p_k}$. Any subset of this
set forms a divisor. There are a total
of $2^omega(n)$ such subsets.

qed


Problem 7 (a)

proof
#let la = $lambda$

$la(a times b) = la(a) times la(b)$,
where $gcd(a, b) = 1$. Trivially say
if $a = 1$, or $b = 1$, this is multiplicative.
So $a = p_1^e_1...p_k^e_k$,
and $b = q_1^f_1...q_n^f_n$,
where $p_i eq.not q_j$, for all
relevant $i, j$.

$la(p_1^e_1...p_k^e_k) = (-1)^(e_1 + ... + e_k)$
and,
$la(q_1^f_1...q_n^f_n) = (-1)^(f_1 + ... + f_n)$

Because $a$ and $b$ are coprime, this
is the unique way to represent it as
a product of prime powers.

$la(p_1^e_1...p_k^e_k times q_1^f_1...q_n^f_n)
= (-1)^(e_1 + dots + e_k + f_1 + dots + f_n)$

qed

(b)

proof

Suppose $f(n) = sum_(d|n) la(d)$. We know
by Theorem 6.4 that $f$ is multiplicative.
Evaluating $f$ at a prime and power $p^e$.
$f(p^e) = la(1) + la(p) + la(p^2) + ... + la(p^e)
= 1 + (-1)^1 + (-1)^2 + ... + (-1)^e$
If $e$ is odd then we'll cancel all terms and
end on a $0$. If it's even then $(-1)^2k$, will
be $1$, and all terms except the last $1$
will cancel. If we have a general $n$, we can
write it as a product of prime factors. Since
$f$ is multiplicative we can consider it as
a product $f$ at each of those prime factors.
If one of the prime's exponents is odd, $f$
will be $0$, so the entire product will be
$0$. If every exponent is even, every component
in that product will be $1$, so the entire
product will be $1$. A number is a square if
and only if all the primes in its factorization
have even powers.

qed

Section 6.3:

Problem 4,

proof

Case: $n/2 in ZZ$. Then $n/2 + n/2 = n$.

Case: $n/2 in.not ZZ$, then $n=2k+1$.
$floor((2k+1)/2) - floor(-(2k+1)/2)
= k - (-k - 1) = 2k+1 = n$

qed

Number 5

proof

(a) Want to show that for $2^e_1, 5^e_2$
we have $min(e_1, e_2) = 249$. For every
multiple of $5$ in the factorial, we will
encounter a multiple of $2$. Using
Legendre's formula

#range(1, 5).map(it => calc.floor(1000 / calc.pow(5, it))).sum()

#range(1, 15).map(it => calc.floor(1000 / calc.pow(2, it))).sum()

```typst
#range(1, 5).map(it => calc.floor(1000 / calc.pow(5, it))).sum()

#range(1, 15).map(it => calc.floor(1000 / calc.pow(2, it))).sum()
```

So the $min(249, 994) = 249$

qed

(b)

proof

$37 = sum_(k=1)^infinity floor(n / 5^k)$

#let c(n) = {
  let k = 1
  let sum = 0
  while calc.pow(5, k) <= n {
    sum += calc.floor(n / calc.pow(5, k))
    k += 1
  }
  return sum
}
$n!$ has $k$ 0's, $(n+1)!$ has at least that
many 0s. We have that $n = 149$, we get 36
and at $150$, at $155$ we get $37$ zeros,
and at $156$ we have $38$, zeros. There must
be at least as many $2$ as $5$ (in general), but
certainly within this range.

qed

// #range(150, 155).map(c)

// #range(1, 20).map(it => calc.floor(1000 / calc.pow(5, it)))

Problem 6

(a)

proof
$(2n)!/(n!)^2$ is an even integer.
Using $binom(n, r) = n!/((n-r)!r!)$

$binom(2n, n) = (2n)!/((2n-n)!n!) = (2n)!/(n!)^2 = 2 binom(2n -1, n-1)$
qed
