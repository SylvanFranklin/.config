Sylvan Franklin |
Number Theory |
#datetime.today().display()

#import "prelude.typ": *;
#show: styling

Problems:

*Section 5.2*:
15.

(a) If the number $M_p = 2^p - 1$  is composite, where
$p$ is a prime, then $M_p$ is a psuedo-prime.

proof

$2^(2^p-1) cong 2 (mod M_p) <==>
2^(2^p-2) cong 1 (mod M_p) <==>
(2^p-1)|(2^(2^p-2)) - 1) <==
p|2(2^(p-1) - 1)$

#qed

In the case $p=2$, it's prime. If $p>2$, then
we need to show that $p|(2^(p-1)-1)$. By
Fermat's little theorem this is true.



16. Confirm that the following integers are absolute pseudo primes.

(a) $1105 = 5 times 13 times 17$

Starting with $a$ as a residue class 
mod $1105$.  

$2^(5 times 13 times 17) cong 1$

(b) $2821 = 7 times 13 times 31$

(c) $2465 = 5 times 17 times 29$

*Section 5.3:*
5.
(a) Prove that an integer $n > 1$ is prime if and only if $(n-2)! cong 0 (mod n)$.

(b) If $n$ is a composite integer, show that $(n-1)! cong 0 (mod n)$, except when $n=4$

6. Given a prime number $p$, establish the congruence.
$ (p-1)! cong p - 1 mod(1 + 2 + 3 + ... + (p-1)) $

*Section 5.4*:
1. Use Fermat's method to factor each of the following numbers:
(a) $2279$

*Section 6.1*:
6. For any integer $n geq 1$, establish the inequality
$tau(n) leq 2 sqrt(n)$.

[Hint: if $d|n$, then one of $d$ or $n/d$ is less than or equal
to $sqrt(n)$]

7. (a) Prove that $tau(n)$ is an odd integer if and only
if $n$ is a perfect square.

9. If $n$ is a square-free integer, prove that
$tau(n) = 2^r$, where $r$ is the number of prime
divisors of $n$.
