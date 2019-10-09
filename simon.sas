%let p0 = 0.1 ;
%let p1 = 0.3 ;
%let nmax = 50 ;
%let alpha = 0.05 ;
%let beta = 0.1 ;

data simon_dat ;
  do n = 2  to &nmax. ;
    do n1 = 1 to (n-1) ;
	  n2=n-n1 ;
      do r1 = 0 to n1 ;
	    do r = r1 to n ;
	        alpha = 0 ;
			power = 0 ;
			do i = r1+1 to n1 ;
	          alpha + pdf('binomial', i, &p0., n1)*(1-cdf('binomial', max(r-i, -1), &p0., n2) ) ;
	          power  + pdf('binomial', i, &p1., n1)*(1-cdf('binomial', max(r-i, -1), &p1., n2) ) ;
			end ;
			PET = cdf('binomial', r1, &p0., n1) ;
			EN= n1 + n2*(1-PET) ;
              if (alpha <= &alpha.) and (power >= 1- &beta.) then output ;
        end ;
	  end ;
	end ;
  end ;
  drop i ;
run ;

proc sort data=simon_dat out=simon_dat_minimax_sort ;
  by n EN ;
run ;

proc sort data=simon_dat out=simon_dat_optimal_sort ;
  by EN ;
run ;


proc print data=simon_dat_minimax_sort(obs=1) ;
run ;  
proc print data=simon_dat_optimal_sort(obs=1) ;
run ;  
