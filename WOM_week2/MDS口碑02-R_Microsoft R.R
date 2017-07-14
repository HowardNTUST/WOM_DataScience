A <- matrix(round(rnorm(500*500)*100), 500,500)
system.time(solve(A))

A <- matrix(round(rnorm(1000*1000)*100), 1000, 1000)
system.time(solve(A))

A <- matrix(round(rnorm(2000*2000)*100), 2000,2000)
system.time(solve(A))

A <- matrix(round(rnorm(4000*4000)*100), 4000,4000)
system.time(solve(A))