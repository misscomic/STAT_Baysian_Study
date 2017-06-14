
DATA Mercury;
	INPUT y;
	DATALINES;
29
27
34
40
22
28
14
35
26
35
12
30
23
17
11 
22 
23
33
;
PROC PRINT data=Mercury;
RUN;

ods graphics on;
PROC MCMC data=Mercury seed=17 nmc=10000 outpost=out1 diagnostics=ALL plots=ALL DIC;
	ods output PostSumInt=SummaryStats MCSE=MC_Errors DIC=DIC2;

	PARM mu 40;
	PARM sigma2;
	PRIOR mu ~ normal(0, var=1e6);
	PRIOR sigma2 ~ igamma(shape=.00001, scale=.00001);

	MODEL y ~ normal(mu, var=sigma2);
run;
ods graphics off;

PROC PRINT data=SummaryStats;
RUN;
PROC PRINT data=MC_Errors;
RUN;
PROC PRINT data=DIC2;
RUN;

