#import "prelude.typ": *;
#show: styling
Sylvan Franklin | Real Analysis | Homework 5

#line(length: 100%, stroke: 0.5pt)

Problem

(a) $f(x) = sin(1/x)$

$
  lim_(x->c) (sin(1/x) - sin(1/c))/(x-c) = lim_(x->c) 2cos((1/x+1/c)/2)sin((1/x-1/c)/2)/(x-c)
  = lim_(x->c) -sin((x-c)/(2c x))/(x-c) 2 cos((1/x + 1/c)/2) \
  = -2cos(1/c) sin((x-c)/(2c x))/(x-c) ((x-c)/(2 c x))/((x-c)/(2 c x)) \
  = -2cos(1/c) 1/(2c x) = -1/c^2 cos(1/c)
$
qed

(b) $f(x) = x sin(1/x)$

$
  lim_(h->0) ((c + h)sin(1/(c+h)) - c sin(1/c))/h
  = lim_(h->0) (c(sin(1/(c+h)) - sin(1/c)))/h + sin(1/(c+h)) \
  = lim_(h->0) c(2 cos((1/(c+h) + 1/c)/2)sin((1/(c+h)-1/c)/2))/h + sin(1/(c+h)) \
  = lim_(h->0) 2 c cos((1/(c+h) + 1/c)/2) (sin((1/(c+h)-1/c)/2))/h ((1/(c+h)-1/c)/2)/((1/(c+h)-1/c)/2) + sin(1/(c+h)) \
  = -2 c cos(1/c) (1/2c^2) + sin(1/(c)) \
  = sin(1/(c))-1/c cos(1/c) \
$

qed

(c) $x^2 sin(1/x)$

$
  lim_(h->0) ((c+h)^2 sin(1/(c+h)) - c^2 sin(1/c))/h = \
  lim_(h->0) ((c^2+c h + h^2) sin(1/(c+h)) - c^2 sin(1/c))/h =
  lim_(h->0) (c^2 sin(1/(c+h)) + c h sin(1/(c+h)) + h^2 sin(1/(c+h)) - c^2 sin(1/c))/h = \
  lim_(h->0) (c^2( sin(1/(c+h)) - sin(1/c)))/h + c sin(1/(c+h)) + h sin(1/(c+h))= \
  lim_(h->0) (c^2( 2cos((1/(c+h) + 1/c)/2)sin((1/(c+h) - 1/(c))/2)))/h + c sin(1/(c+h)) + h sin(1/(c+h))= \
  lim_(h->0) c^2 2cos((1/(c+h) + 1/c)/2) (sin((1/(c+h) - 1/(c))/2))/h + c sin(1/(c+h)) + h sin(1/(c+h))= \
  -cos(1/c) + 2c sin(1/(c))
  \
$

qed

Problem

proof

$(f(x + h) - f(x))/h = (f(c) - f(x))/(c-x)$ (using $h = (c-x)$ )

Now $f'(c) = (f(c) - f(x))/(c-x) = f'(x + theta(h)) = f'(x - theta x + theta c)$, With $theta in (0, 1)$

Not sure exactly on the formatting of this one. This holds up perfectly when $theta=1$,
but I guess as we slide along we will get different results.


qed

Problem

proof

We will show that the sequence is Cauchy. Take $1/n < 1/m$ WLOG.
By the mean value theorem $f'(c) = (f(1/m) - f(1/n))/(1/m - 1/n)$.
Now since $f' < 1$, we have $f(1/m) - f(1/n) < (1/m - 1/n)$, now
$|a_m - a_n| < |1/m + 1/n|$. Let $e>0$. Choose $N$, st. $2/N > ep$.
Now we have for $m, n >= N$  $|a_m - a_n| < |1/N + 1/N| < ep$.

qed




Problem

proof

Since $f$ and $f'$ are continuous and differentiable on $[a, b]$. And since $f'(a) = f'(b)$, using
Roll's Theorem, we know that $f'''(c) = 0$ for some $c in (a, b)$.

qed

Problem

1. proof
$a>0$. Using the definition of continuity, Any positive power of $a$, will
easily give us a delta which is the reciprocal of the exponent ie.
$|x| < delta = ep^(1/a) ==> |x^a| < ep$. This of course fails when $a=0$,
and $a<0$, since the negative power will flip $x$ and not give us the desired result.
qed

2. proof

We will consider the left and right limits respectively. Approaching from the left
we get $f'_a(x) = 0$ no matter what the choice of $a$ is. Approaching from the right
$lim_(x->c) (x^a - c^a)/(x-c) = lim_(x->c) (x^(a-1) + x^(a-2)c + ... + x c^(n-2) + c^(n-1)) = a c^(a-1)$
Solving for when, where $c->0$ we get $a c^(a-1) = 0 ==> a > 1$.

3. proof

The second derivative given by $a(a-1)c^(a-2)$, can also be solved for $c->0$, when
$a>2$.

qed
