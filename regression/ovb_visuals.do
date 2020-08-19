*Omitted Variables Bias

*
clear
matrix C = (1, .8 \ .8, 1)
drawnorm x w, n(100) corr(C) m(2 2)
gen a=0 if w<=2
replace a=1 if w>2

drawnorm u, sd(2)

gen y = 2 + 2*x - 10*a + u

drop if x<0

reg y x

reg y x a
predict yhat

gen yadj = y+10*a if a==1
replace yadj=y if a==0


scatter y x, legend(off) xtitle(x) ytitle(y) yscale(range(-10(5)15)) ylabel(-10(5)15)

twoway (scatter y x) (lfit y x), legend(off) xtitle(x) ytitle(y) yscale(range(-10(5)15)) ylabel(-10(5)15)

twoway (scatter y x if a==0)  (lfit y x) (scatter y x if a==1), legend(off) xtitle(x) ytitle(y) yscale(range(-10(5)15)) ylabel(-10(5)15)

twoway (scatter y x if a==0) (lfit yhat x if a==0) (scatter y x if a==1)  (lfit yhat x if a==1), legend(off) xtitle(x) ytitle(y) yscale(range(-10(5)15)) ylabel(-10(5)15)

twoway (scatter yadj x if a==0) (lfit yadj x ) (scatter yadj x if a==1)  , legend(off) xtitle(x) ytitle(y) yscale(range(-10(5)15)) ylabel(-10(5)15)



