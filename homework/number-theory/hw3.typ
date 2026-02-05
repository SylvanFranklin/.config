#let neq = $eq.not$
#let geq = $>=$
#let leq = $<=$
#let iff = $<==>$
#let qed = align(right, $square.filled$)
#let pf = text(style: "italic", [proof:])

// #set page(fill: black)
// #set text(fill: white)

#align(center)[Math 3517 | Section A | HW 3 | Sylvan Franklin  |
  2026-02-04 ]

*7*:
Prove that if $a$ and $b$ are both odd integers, then $16|(a^4 + b^4 -2)$

Since $a, b$ are odd, then $a = 2k + 1, b = 2j+1$, Plugging in:

$
  (2k+1)^4 + (2j + 1)^4 -2 \
  16k^4 + (4)8k^3 + (6)4k^2 + (4)2k + 1 +
  16j^4 + (4)8j^3 + (6)4j^2 + (4)2j + 1 -2 \
  16k^4 + 32k^3 + 24k^2 + 8k +
  16j^4 + 32j^3 + 24j^2 + 8j \
  16(k^4 + j^4) + 32(k^3 + j^3) + 24(k^2 + j^2) + 8(k + j) \
  8(2(k^4 + j^4) + 4(k^3 + j^3) + 3(k^2 + j^2) + (k+ j))\
  8(2(k^4 + j^4) + 4(k^3 + j^3) + k(3k + 1) + j(3j + 1))\
$

Since $k(3k+1)$ and $j(3j+1)$ are both even, we fix $2m = j(j+3)$, $2n = k(k+3)$

$
  16((k^4 + j^4) + 2(k^3 + j^3) + m + n)\
$

#qed

*13*: Given integers $a$ and $b$, prove the following:


(a) There exist integers $x$ and $y$ for which $c = a x + b y$ if and only if $gcd(a, b)|c$.

#pf

$==>$ Using the fact that $gcd(a, b)|a$ and $gcd(a, b)|b$: $c=a x+ b y = n gcd(a, b) x + m gcd(a, b) y$
Factoring out $gcd(a, b)$ we get $c = gcd(a, b)(m x + n y) ==> gcd(a, b) | c.$

$<==$ Using Bezout's lemma we can express $gcd(a, b) = a x + b y$, then $k gcd(a, b) = k a x + k a y$, where $k gcd(a, b) = c$. Now $c = a x k + b y k$, where $x = k x$, $y = k y$, so $c = a x + b y$

#qed

(b) If there exist integers $x$, $y$, for which $a x + b y = gcd(a, b)$, then $gcd(x, y) = 1$    .

Since $gcd(a, b)|a$ and $gcd(a, b)|b$, we have $b = gcd(a, b)n$, $a = gcd(a, b)m$

$gcd(a, b)(m x + n y) = gcd(a, b) ==> m x + n y = 1 ==> gcd(x, y) = 1$

#qed

*18*: Prove the product of three consecutive integers is divisible by $6$; the product of any four consecutive integers is divisible by $24$; the product of any five consecutive integers is divisible by $120$. Hint theorem 2.4

Case: $2|n(n+1)(n+2)$, since every other number is
even, we know one of these factors is even.

Case: $3|n(n+1)(n+2)$. Since every third number is
divisible by three this is true.

#qed

Case: $2^3$ $n(n+1)(n+2)(n+3)$. Since every fourth integer is divisible by
four, and every other integer is divisible by two. Eliminating the two that we
count twice we have two and four as factors and therefore $8$ or $2^3$.

Case: $3$ $n(n+1)(n+2)(n+3)$, Every third is divisible
by $3$.

Split $120$ into prime factors $2 times 5 times 2 times 2 times 3$

From the previous case we have that $24$ divides $4$ consecutive integers, we only have to show
that $5$ divides $n(n+1)(n+2)(n+3)(n+4)$.

Case $5$. Since every 5th integer is divisible by five, this is true.

#qed

*20*: Confirm the following property of the gcd.

(d) if $gcd(a, b) = 1$ and $c|(a + b)$, then $gcd(a, c) = gcd(b, c) = 1$

$d = gcd(a, c)$, now $d|a, d|c$. Because $d|(a+b)$, we have that $d|b$. So $d | gcd(a, b)$. Since $gcd(a, c) = 1 = gcd(a, b)$. The whole
statement is symmetric in $a$ and kko$b$.

#qed

*21*:

(a) Prove that if $d | n$, then $(2^d -1)|(2^n -1)$



#let dk = $d k$


Using $d k = n$, $2^dk -1 = 2^n - 1 = (2^d)^k - 1$.


$
  (2^dk -1)/(2^d-1) =
  ((2^d)^k -1)/(2^d-1)
  \
$

Which is the formula for a sum of the geometric series:

$
  1 + 2^d + (2^d)^2 + ... + (2^d)^(n-1)
$

Which is a whole number $v$. Therefore

$
  ((2^d)^k -1)/(2^d-1) = v ==> v(2^d -1) = 2^n -1 ==> 2^d -1|2^n -1
$

#qed

(b) Verify that $2^35 -1$ is divisible by $31$ and $127$

// Using the expansion $2^x - 1 = (x-1)(1 + x + x^2 + ... + x^(n-1))$

We can write $31$ as $2^5 -1$, and using the previous result $2^5-1|2^35-1$, since $5|35$

We can write $127$ as $2^7 -1$, and using the previous result $2^7-1|2^35-1$, since $7|35$


*Bonus: 22* Let $t_n$ denote the nth triangular number. For what values of $n$, does $t_n$ divide the sum $t_1 + t_2 + ... + t_n$?


$
             t_n = (k(k+1))/2 \
  #let plug = $(k(k+1))/2$
  t_1 + t_2 + t_3 + ... + t_n & = sum t_n = sum (k(k+1))/2 \
                              & = 1/2sum k^2 + 1/2sum k \
                              & = 1/12 (n)(n+1)(2n+1) + 1/4 (n)(n+1) \
                              \
                              & = (n(n+1))/2 (1/6 (2n+1) + 1/2) \
                              & = (n(n+1)(n+2))/6 \
$

Dividing by $t_n = n(n+1)/2$ , we would get $((n+2)/3)$. When this is an integer $t_n | t_1+t_2+...+t_n$

#qed


How long did this take?

Like 6 hours.

