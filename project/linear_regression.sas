DATA TempPressure;
INPUT temperature pressure logPressure;

response = "pressure";
y = pressure;
OUTPUT;

response = "logPressure";
y = logPressure;
OUTPUT;
DROP pressure logPressure;

DATALINES;
210.8 29.211 146.555
210.2 28.559 145.574
208.4 27.972 144.672
202.5 24.697 139.264
200.6 23.726 137.522
200.1 23.369 136.864
199.5 23.03 136.229
197 21.892 134.029
196.4 21.928 134.1
196.3 21.654 133.554
195.6 21.605 133.455
193.4 20.48 131.133
193.6 20.212 130.561
191.4 19.758 129.574
191.1 19.49 128.981
190.6 19.386 128.749
189.5 18.869 127.575
188.8 18.356 126.378
188.5 18.507 126.734
185.7 17.267 123.722
186 17.221 123.606
185.6 17.062 123.203
184.1 16.959 122.94
184.6 16.881 122.74
184.1 16.817 122.575
183.2 16.385 121.445
182.4 16.235 121.045
181.9 16.106 120.699
181.9 15.928 120.216
181 15.919 120.192
180.6 15.376 118.684
	;
RUN;

PROC SORT data=TempPressure;
BY response;
RUN;

DATA TempBar (KEEP= avgTemp);
SET TempPressure END=endOfFile;
total + temperature;

IF (endOfFile) THEN DO;
	avgTemp = total / _N_;
	OUTPUT;
END;
RUN;
DATA TempPressure;
SET TempPressure;
IF _N_ = 1 THEN SET TempBar;
RUN;


ods graphics on;
PROC MCMC data=TempPressure seed=17 nmc=10000 outpost=out1 diagnostics=ALL plots=ALL DIC monitor=(slopeGT0 beta0 beta1 sigma2);
BY response;
ODS OUTPUT PostSumInt=SummaryStats MCSE=MC_Errors DIC=DIC2;

parms beta0 0 beta1 0;
parms sigma2 1;

slopeGT0 = beta1 > 0;

prior beta0 beta1 ~ normal(mean=0, var=1e6);
prior sigma2 ~ igamma(shape=.001, scale=.001);

model y ~ normal(beta0 + beta1 * (temperature - avgTemp), var=sigma2);
run;
ods graphics off;

DATA Stats;
MERGE SummaryStats MC_Errors;
BY response;
RUN;


PROC PRINT data=Stats;
RUN;
PROC PRINT data=DIC2;
RUN;



* For comparison with frequentist;
DATA Regular;
	SET TempPressure;
	IF response = "pressure";
	y = y - avgTemp;
RUN;
ods graphics on;   
proc reg;
	model y = temperature;
run;
   
ods graphics off;
