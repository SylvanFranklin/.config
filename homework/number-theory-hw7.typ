// #set text(white)
// #set page(fill: color.rgb("#323C4A"))
//
Sylvan Franklin |
Number Theory |
#datetime.today().display()

#import "prelude.typ": *;
#show: styling

Section 4.4

1. Solve the following linear congruences

(a) $25x cong 15 (mod 29)$.

// $k 25 - 1 = 29 l$.
Since $25 cong -4 (mod 29)$, and
$(-4)^2 cong 16 cong 24 (mod 29)$,
$(-4)^28 cong cong (-4)(-4)^27 1 (mod 29)$
Then $(-4)^27 cong 7 (mod 29)$.
Now $15(7) cong 18 (mod 29)$

(b) $5x cong 2 (mod 26)$.

Since $gcd(5, 26) = 1$, $x cong 2 (5)^(-1) (mod 26)$.
Since $5^2 cong 25 cong -1 (mod 26)$. And $5^4 cong (-1)^2
cong 1 (mod(26)).$ Since $5^3 times 5 = 5^4$, which is
congruent to $-5 times 5^2 cong -5 cong 21 mod 26$.
So $x cong 2(-5) cong 16 (mod 26)$.

3. Find all solutions of the linear congruence $3x - 7y cong 11 (mod 13)$.

proof  Want $3^(-1) (mod 13)$, or $(3)^k cong 1 (mod 13)$

So $3^2 cong -4 (mod 13)$
So $3^3 cong 3 (-4) cong - 12 cong 1 (mod 13)$

$3x cong 11 + 7y (mod 13)$ and
$x cong 9(11 + 7y) cong 99 + 63y cong 8 + 11y (mod 13)$

So for every $y$, we get a unique $x$ as a solution.

#for i in range(1, 14) { [(y : #i, x: #(calc.rem(i * 11 + 8, 13))) ] }

4. Solve each of the following sets of simultaneous congruences:

(a) $x cong 1 (mod 3), x cong 2 (mod 5), x cong 3 (mod 7)$

proof $3,5,7$ are coprime pairwise.
Using CRT we need a
solution $mod 3 times 5 times 7 = 105$

We try $3$ more than multiples of $7$. Then check
which satisfy the two other conditions. Until we
find the residue class of $52 (mod 105)$

```typst
#for i in range(1, 10) {
  let three = (i * 7 + 3)
  let one = calc.rem(three, 3)
  let two = calc.rem(three, 5)
  if one == 1 and two == 2 {
    [ #three ]
    break
  } else { strike[ #three, ] }
}
```
qed

#for i in range(1, 10) {
  let three = (i * 7 + 3)
  let one = calc.rem(three, 3)
  let two = calc.rem(three, 5)
  if one == 1 and two == 2 {
    [ #three ]
    break
  } else { strike[ #three, ] }
}

(b) $x cong 5 (mod 11), x cong 14 (mod 29), x cong 15 (mod 31)$

proof

First $11,29,31$ are coprime pairwise, so we can use
CRT.

Doing the same thing as $(a)$

#for i in range(1, 1000) {
  let three = (i * 31 + 15)
  let one = calc.rem(three, 11)
  let two = calc.rem(three, 29)
  if one == 5 and two == 14 {
    [ #three ]
    break
  } else { strike[ #three, ] }
}

So $4944 (mod (31 * 11 * 29) = #(31 * 11 * 29))$

qed

11. Prove that the congruences
$ x cong a (mod n) quad "and" quad x cong b (mod m) $
admit a simultaneous solution if and only if
$gcd(n, m)|(a-b)$; if a solution exists, confirm that
it is unique modulo $lcm(n, m)$.

proof

$x cong a mod(n) ==>
x - a = k n ==>
x = k n + a$. Plugging into the other equation we obtain
$k n + a cong b (mod m)
==> k n cong (a - b)$ By the CRT this has a solution if $gcd(n, m)|(a - b)$.
Which we have. If we have two different solutions
$x_1$ and $x_2$, then $x_1 cong x_2 (mod n)$,
and $x_1 cong x_2 (mod m)$. Therefore
$m|(x_1 - x_2)$, and $n|(x_1 - x_2)$. Since
$n$ and $m$ divide $(x_1 - x_2)$, $lcm(n, m)$,
divides it as well. Then $x_1 cong x_2 (mod lcm(m, n))$








qed

Section 5.2

2. (a) If $gcd(a, 35) = 1$, show that $a^12 cong 1 (mod 35)$.

Since $a^6 cong 1 (mod 7)$, and
$a^4 cong 1 (mod 5)$. We can square
$a^6$ and cube $a^4$, and we simply get
that $a^12 cong 1 mod 35$.

(c) If $gcd(a, 133) = gcd(b, 133) = 1$, show that $133|(a^18 - b^18)$

$133 = 7 times 19$.
Using Fermat's little theorem:
$a^18 cong b^18 cong 1 (mod 19)$. And
$a^6 cong b^6 cong 1 (mod 7)$, Cubing
all terms we get that $a^18 cong b^18 cong 1 mod 7$.
Therefore we have $133|(a^18 - b^18)$.




4. Derive each of the following congruences:

(a) $a^21 cong a (mod 15)$ for all $a$.

Since $(a^2 cong 1) mod 3$, we have
that $a^20 cong 1^20 cong 1$. Multiply
by $a$ and we have $a^21 cong a (mod 3)$.
For $5$, by Fermat's theorem (again), we
have $a^4 cong 1 (mod 5)$. Then raising
to five and multiplying both sides by $a$
we get $a^21 cong a (mod 5)$. And can
conclude that $a^21 cong a (mod 35)$

(d) $a^9 cong a (mod 30)$ for all $a$.

Prime factors of $30$ are $5,3,2$. By Fermat
we have $a cong 1 (mod 2)$, $a^2 cong 1 (mod 3)$
and $a^4 cong 1 (mod 5)$. For the first raise
to $8$, multiply through by $a$. For the second
raise to $4$ multiply through by $a$. For the
third raise to the $2$, then multiply through
by $a$. With this triple congruence we conclude
that $a^9 cong a (mod 30)$.

9. Assuming that $a$ and $b$ are integers not divisible by the prime $p$, establish.

(b) if $a^p cong b^p (mod p)$, then $a^p cong b^p (mod p^2)$.




