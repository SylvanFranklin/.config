#import "prelude.typ": *;
#show: styling
Sylvan Franklin | Real Analysis | Homework 5

#line(length: 100%, stroke: 0.5pt)

Problem 4

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


Problem 7

Problem


