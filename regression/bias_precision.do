************VISUALIZING PRECISION & BIAS**************

*source of code for exercise: Cunningham's "Causal Inference Mix Tape"
*http://scunning.com/cunningham_mixtape.pdf

clear 
set seed 1 
set obs 10000
gen x = 9*rnormal() //x is a random variable drawn from a normal distribution in the population
gen u = 36*rnormal() //u is a random variable drawn from a normal distribution, 
					// but is not systematically correlated with x.
					// Note that it may end up being correlated just in our sample, but
					// is not in the population
corr x u 			
					// for example, I can run it again and get a different correlation:
clear 
set seed 2
set obs 10000
gen x = 9*rnormal() 
gen u = 36*rnormal() 
					
corr x u 			// note the different correlation with a different sample - just by chance


gen y = 3 + 2*x+u // y is a function of x, u, and a constant
reg y x // the true coefficient on x is 2, but it will not be exactly 2 here 
		// because of random correlation with u.
		// Look at 95% CI to see that 2 is very much in our range of likely values
reg y x u 	// we have perfectly identified all of the variation - the coefficients 
			// should exactly match what we created them to be in line 21,
			// with no error because every observation will match this definition perfectly

*Now try the same thing again with fewer observations (less precision, higher standard errors)

clear 
set seed 2
set obs 100
gen x = 9*rnormal() 
gen u = 36*rnormal() 
gen y = 3 + 2*x+u 
reg y x // still close to 2, but SE's are huge now


*Now we'll do this same exercise 1000 times and plot the coefficients from each sample in a histogram'
*Note the sample size in each draw = 10,000, but we'll repeat 1,000 times to have 1,000 estimates of beta

********VALID & PRECISE*********
clear all 
program define ols, rclass 
version 14.2 
syntax [, obs(integer 1) mu(real 0) sigma(real 1) ] 
clear 
drop _all 
set obs 10000
gen x = 9*rnormal() 
gen u = 36*rnormal() 
gen y = 3 + 2*x+u 
reg y x 
end 
simulate beta=_b[x], reps(1000): ols 
su 
hist beta, xline(2)

*Try it again with a smaller sample size (n=100), still over 1000 repetitions

********VALID & IMPRECISE*********
clear all 
program define ols, rclass 
version 14.2 
syntax [, obs(integer 1) mu(real 0) sigma(real 1) ] 
clear 
drop _all 
set obs 100
gen x = 9*rnormal() 
gen u = 36*rnormal() 
gen y = 3 + 2*x+u 
reg y x 
end 
simulate beta=_b[x], reps(1000): ols 
su 
hist beta, xline(2)

*Now we can play around with introducing bias into the model by making it so that 
*u is an omitted variable that is correlated with both x and y

********BIASED & PRECISE********
clear all
program define ols, rclass 
version 14.2 
syntax [, obs(integer 1) mu(real 0) sigma(real 1) ] 
clear 
drop _all 
set obs 10000
matrix C = (1, .2 \ .2, 1)
drawnorm x u, corr(C) //add a parameter to the population - x and u have a correlation = .2
gen y = 3 + 2*x+u 
reg y x 
end 
simulate beta=_b[x], reps(1000): ols 
su 
hist beta, xline(2) start(2)

********BIASED & IMPRECISE********
clear all
program define ols, rclass 
version 14.2 
syntax [, obs(integer 1) mu(real 0) sigma(real 1) ] 
clear 
drop _all 
set obs 100
matrix C = (1, .2 \ .2, 1)
drawnorm x u, corr(C) //add a parameter to the population - x and u have a correlation = .2
gen y = 3 + 2*x+u 
reg y x 
end 
simulate beta=_b[x], reps(1000): ols 
su 
hist beta, xline(2)
