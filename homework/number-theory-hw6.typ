#align(right)[
  Sylvan Franklin |
  Number Theory |
  #datetime.today().display()
]


#import "prelude.typ": *;
#show: styling

// color scheme
// #set text(white)
// #set page(fill: color.rgb("#323C4A"))

Section 4.2:

Problem $a_1, a_2,...,a_n$ is a complete set of residues
modulo $n$, and $gcd(b, n) = 1$, prove that
$b(a_1, a_2,...,a_n)$ is also a complete set of
residues mod n

proof

Assume towards a contradiction that
$b(a_1, a_2,...,a_n)$ is not a
complete set of residues mod n. We
have some $b a_i = b a_j mod n$.
Since $gcd(b, n) = 1$. We have
$a_i = a_j$, $==><==$

qed

Problem Establish that if $a$ is an odd integer, then for an $n geq 1$
$a^(2^n) cong 1 mod 2^(n+2)$

proof

Proceed by induction on $n$. Base case $n=1$.
$a^2 cong 1 mod 8$. In other words
$8|(a^2 - 1)$ Since $a^2$ is odd.
$8|4k^2 + 4k$. Inductive step:
Assume $(2k+1)^2^n cong 1 mod 2^(n+2)$.
Want to show

$
  (2k+1)^2^(n) = 1 + k 2^(n+2) \
  ((2k+1)^2^(n))^2 = (1 + k 2^(n+2))^2 \
  (2k+1)^(2^(n+1)) = 1 + 2k 2^(n+2) + (k 2^(n+2))^2 \
  (2k+1)^(2^(n+1)) = 1 + k 2^(n+3) + k^2 2^(2n+4)\
  (2k+1)^(2^(n+1)) = 1 + 2^(n+3)(k + k 2^(n+1))
$

Which is congruent. By PMI we are done

Also


$(2k+1)^2^n cong 1 mod 2^(n+2)$

$
  (2k+1)^2^n & = binom(2^n, 0)(2k)^2^n + binom(2^n, 1)(2k)^(2^n-1) + ... + 1 \
             & =(2k)^2^n + (2^n)!/(2^n -1)!(2k)^(2^n-1) + ... +2k + 1 \
$

Since every term except the last is divisible by
$2^(n+2)$, and the last cancels using
$2^(n+2)|(2k+1)^2^n -1$.

qed

Problem Prove that whenever $a b cong c d (mod n)$ and
$b cong d (mod n)$, with $gcd(b, n) = 1$. then
$a cong c (mod n)$

proof

$a cong b mod m <==> a = b + k m$


Given
$a b = c d + k n$,
$b = d + j n$,

Since $a (d + j n) = c d + k n$,
Then $a d + a j n = c d + k n$,
Then $a d = c d + (k n - a j n)$,
Finally $a = c + n (k - a j)/d$
And $n (k - a j)/d$ is an integer
since $gcd(d, n) = 1$.

qed


Section 4.3:

Problem Use the binary exponentiation algorithm to compute
both $19^53 (mod 501)$

proof


$53 = 32 + 16 + 0 times 8 + 4 + 0 times 2 + 1
=(110101)_2$

#let value = 19
#let total = 1
#let powers = (1, 4, 16, 32)
#for i in (1, 2, 4, 8, 16, 32) {
  if i in powers { total *= value }
  value = calc.pow(value, 2)
  value = calc.rem(value, 501)
  $
    19^#i = value mod 501
  $
}

So we have #calc.rem(total, 501)

qed

Problem Find the last two digits $9^9^9$ [Hint
$9^9 cong 9 (mod 10);$ hence $9^9^9 = 9^(9+10k)$,
now use the fact that $9^9 cong 89 (mod 100)$]


proof


Well $9^9^9 = 9^(9 + 10k)
=9^9 9^(10)^k
cong 89 times 9^(10)^k (mod 100)
cong 89 times 801 (mod 100) cong 89$

Problem Prove that no integer whose digits add up to $15$ can be a square or a cube.

proof

$s_n$ is the sum of digits.

$s_n = 15$, $n cong 6 mod 9$,

so $3|n$, but $9 divides.not n$. Suppose towards a contradiction that
$n$ is a perfect square. If $n$ is a perfect
square $k^2 = n$. So $3|k^2 ==> 3|k ==>
9|k^2 ==> 9|n$ contradiction. If $n$ is
a perfect cube then $n = j^3 ==> 3|j^2
==> 9|j^3$. Which is a contradiction.

qed

