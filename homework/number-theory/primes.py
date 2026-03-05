



prime = 701

for i in range(1, prime):
    is_prime = True
    for j in range(1, i):
        if i % j == 0:
            is_prime = False

    if is_prime: 
        print(i)

