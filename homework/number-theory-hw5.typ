
// #set page(fill: black)
// #set text(white)

#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let sr = math.sqrt
#let cong = math.eq.triple
#let pf = text(style: "italic", [proof:])
#let current = it => text(red)[CURRENT: #it]

#let is-prime(prime) = {
  for j in range(2, calc.floor(calc.sqrt(prime) + 1)) {
    if calc.rem(prime, j) == 0 { return false }
  }
  return true
}

#show regex("(?i)^Proof"): it => [_Proof:_]
#show regex("qed"): it => align(right, $square.filled$)

#align(center)[Math 3517 | Section A | HW 5 | Sylvan Franklin | 2026/02/24]


Section 3.2: 1, 4 (b), 8

1. Determine whether the integer $701$ is prime by testing all primes
  $p leq sqrt(701)$ as positive divisors. Do the same for the integer $1009$.


#{
  let prime = 701
  for i in range(1, calc.ceil(calc.sqrt(prime))) {
    let is_prime = true
    for j in range(2, i) {
      if calc.rem(i, j) == 0 {
        is_prime = false
      }
    }
    if is_prime {
      if calc.rem(prime, i) == 0 [#i|701 ] else [#i $divides.not$ #prime ]
    }
  }
  [So #prime is prime. ]
}

#{
  let prime = 1009
  for i in range(1, calc.ceil(calc.sqrt(prime))) {
    let is_prime = true
    for j in range(2, i) {
      if calc.rem(i, j) == 0 {
        is_prime = false
      }
    }
    if is_prime {
      if calc.rem(prime, i) == 0 [#i|prime ] else [#i $divides.not$ #prime ]
    }
  }
  [So #prime is prime. ]
}

4. (b) Establish $sr(p)$ is irrational for any prime $p$.

proof

Assume towards a contradiction $sr(p) = a/b$, where
$a/b$ is reduced. Now
$p = a^2/b^2 ==> p b^2 = a^2$.
Now $p|a^2 ==> p|a ==> p k = a$ for some $k in ZZ$.
$p b^2 = (p k)^2$, $b^2 = p k^2 ==> p|b^2 ==> p|b$
So there exists some $l in ZZ$ st. $b = l p$.
$(p l)^2 = p k^2$. Since we have a common factor
of $p$ this is a contradiction.

qed


8. Give another proof of the infinitude of primes by assuming that there are only finitely many primes, say $p_1, p_2, ... p_n$, and using the following integer to arrive at a contradiction.

$ N = p_2p_3...p_n + p_1p_3...p_n + ... + p_1p_2...p_(n-1) $

proof

This proof will require the fact that if $p|(a+b)$
and $p|a$, then $p|b$. First since $p|(a+b)$, we have
$a+b = p n$, for some $n in NN$. Then since $p|b$, for
some $m in NN$, $p m = b$. Now $a + p m = p n ==> a = p (m - n)$
where $m - n$ is an integer.

Now since $N$ is an integer some prime $p_i$ divides it,
where $p in {p_1, ..., p_n}$. This $p_i$ divides all but
one of the terms in $N$ by the definition of $N$. If we
call that term $a$, and call the sum of the terms that $p_i$
does divide $b$, we have $p_i|(a+b)$ and $p_b$. Therefore
$p_i|a$ which is a contradiction.

qed

*Section 3.3: 3, 9, 12, 28*

3. Find all pairs of primes $p$ and $q$  satisfying $p-q=3$.

proof

#for i in range(1, 3) {
  if is-prime(i) and is-prime(i + 3) {
    [(#i, #(i + 3)) ]
  }
}

All primes greater than $2$ are odd. Two primes
$p = 2k + 1, q = 2j + 1$. $p-q = 2k - 2j - 0$. Which
is even. A difference of $3$ is impossible.


qed

9.
(a) For $n > 3$ , show that the integers $n, n+2, n+4$, cannot all be prime.

proof

Assume towards a contradiction $n, n+2, n+4$ are all
primes. They all have to be congruent to either $1$
or $2$ mod $3$. If $n cong 1 mod 3$,
then $n+2 cong 0 mod 3$ which is a contradiction.
If $n cong 2 mod 3$, $n+4 cong 0 mod 3$ which is
also a contradiction.

qed




(b) Three integers $p, p+2, p+6$, which are all prime, are called a _prime-triplet_. Find five sets of prime triplets.

#for i in range(1, 100) {
  if is-prime(i) and is-prime(i + 2) and is-prime(i + 6) {
    $(#i, #(i + 2), #(i + 6))$
  }
}

12. Let $p_n$ denote the nth prime number. For $n geq 3$, prove that $p_(n+3)^2 <p_n p_(n+1)p_(n+2)$

proof

$p_n < 2p_(n-1)$


$p_(n+3)^2 < 4 p_(n+2)^2 < 8 p_(n+1)p_(n+2)$,
multiply through by $p_n$. Since $n geq 3$.

$
  "since 8 " < p_(<4)-> p_(n+3)^2 & < p_n p_(n+1) p_(n+2) \
$

We have to verify $n=3, n=4$.

$13^2 < 5 times 7 times 11 ==> 169 < 55 times 7$

$17^2 < 7 times 11 times 13 ==> 289 < 770 < 7 times 11 * 13$

qed


28.

(a) If $n>1$, show that $n!$ is never a perfect square.

proof

By Bertrand's Postulate there exists
$p$ st. $n/2 < p < n$. Since $p < n$
$p | n!$. But $2p > n$, so $p^2 divides.not n!$
(As long as $n geq 4$). In the case that
$n$ is odd, we can use $(n+1)$, which
will be even.

qed

(b) Find the values of $n geq 1$ for which

$ n! + (n+1)! + (n+2)! $

is a perfect square.

proof
$
  n! + (n+1)! + (n+2)! & = n! + n!((n+1) + (n+1)(n+2)) \
                       & = n!((n+2) + (n+1)(n+2)) \
                       & = n!((n+2)(n+2)) \
                       & = n!(n+2)^2 \
$

This is true when $n!$ is a perfect square, which
from part (a) is only true, $n > 1$. So $1$ is the only
value of $n geq 1$.

qed


