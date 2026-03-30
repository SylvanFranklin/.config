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

Square Free, Yes.

$4 | (1105 - 1)$
$12 | (1105 - 1)$
$16| (1105 - 1)$

Absolute Pseudoprime by Korselt's Criterion.


(b) $2821 = 7 times 13 times 31$

Square Free, Yes.

$6 | (2821 - 1)$
$12 | (2821 - 1)$
$30| (2821 - 1)$

Absolute Pseudoprime by Korselt's Criterion.

(c) $2465 = 5 times 17 times 29$

Square Free, Yes.

$4 | (2465 - 1)$
$16 | (2465 - 1)$
$28| (2465 - 1)$

Absolute Pseudoprime by Korselt's Criterion.

*Section 5.3:*
5.
(a) Prove that an integer $n > 1$ is prime if and only if $(n-2)! cong 0 (mod n)$.

proof

Since $(n-2)! cong 1 (mod n) <==> n|(n-2)! -1$
by Wilson's Theorem:
$(n-1)! cong (n-1)(n-2)! cong -1 (mod n)
<==> n|(n-1)(n-2)! + 1
<==> n|n(n-2)! -(n-2)! + 1
<==> n|-(n-2)! + 1
<==> n|-1((n-2)! - 1)
<==> n|(n-2)! - 1$

qed

(b) If $n$ is a composite integer, show that $(n-1)! cong 0 (mod n)$, except when $n=4$

proof

It suffices to show that $n|(n-1)!$. Since $n$ is composite $exists a b in ZZ$ st. $a b = n |
1 geq a geq b < n$. By definition $(n-1)!$ contains $a b$, so $n|(n-1)!$

qed

6. Given a prime number $p$, establish the congruence.


$ (p-1)! cong p - 1 mod(1 + 2 + 3 + ... + (p-1)) $

proof

We want to show that $p(p-1)/2 | (p-1)! - (p-1)$. By Wilson's theorem $(p-1)! cong 1 (mod p)$ and
$(p-2)! cong 1 (mod p)$, So surely $p|$

qed

*Section 5.4*:
1. Use Fermat's method to factor each of the following numbers:
(a) $2279$

proof

Using a rough estimation $sqrt(2297) approx 48$. Now
$48^2−2279=2304−2279=25=5^2$. So $2279=(48−5)(48+5)=43 times 53$

qed

*Section 6.1*:
6. For any integer $n geq 1$, establish the inequality
$tau(n) leq 2 sqrt(n)$.

[Hint: if $d|n$, then one of $d$ or $n/d$ is less than or equal
to $sqrt(n)$]

proof

Call the number of divisors less than $sqrt(n)$, $k$. Each of those
divisors will have a corresponding divisor $geq sqrt(n)$. Since there
are maximum $floor(sqrt(n))$ integers $leq sqrt(n)$, we have $k leq sqrt(n)$
and therefore $tau(n) leq 2sqrt(n)$.


7. (a) Prove that $tau(n)$ is an odd integer if and only
if $n$ is a perfect square.

proof

For any integer $tau(n)$ is at least $2$. For perfect squares 
we have $a^2 = n$, where $a$ is in the set of divisors, this 
gives us $2+1 = 3$ divisors. It remains to show that an additional 
number of divisors will be even. This is evident when $n$ is a perfect
square since $d<sqrt(n) => exists q>sqrt(n)$ as a divisor pair. 
We now have $2 + 1 + 2k$ which is odd.  

qed

9. If $n$ is a square-free integer, prove that
$tau(n) = 2^r$, where $r$ is the number of prime
divisors of $n$.



