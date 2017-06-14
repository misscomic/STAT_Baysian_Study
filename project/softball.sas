
DATA CollegeSoftball;
	INPUT hits atBats;
	DATALINES;
	5 30
	;
RUN;

DATA CollegeSoftball;
	SET CollegeSoftball;
	
	prior = "Realistic";
	alpha = 11;
	beta = 21;
	OUTPUT;

	prior = "Jeffreys";
	alpha = .5;
	beta = .5;
	OUTPUT;

	prior = "Mothers";
	alpha = 51;
	beta = 71;
	OUTPUT;
RUN;
PROC SORT data=CollegeSoftball;
	BY prior alpha beta;
RUN;

PROC PRINT data=CollegeSoftball;
RUN;



ods graphics on;
PROC MCMC data=CollegeSoftball seed=17 nmc=10000 outpost=out1 diagnostics=ALL plots=ALL DIC;
 	BY prior;
ods output PostSumInt=SummaryStats MCSE=MC_Errors DIC=DIC2;

	PARM p 0.2;
	PRIOR p ~ beta(alpha,beta);

	MODEL hits ~ binomial(atBats, p);
run;
ods graphics off;

PROC PRINT data=SummaryStats;
RUN;
PROC PRINT data=MC_Errors;
RUN;
PROC PRINT data=DIC2;
RUN;
