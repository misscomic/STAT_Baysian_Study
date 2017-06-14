title 'Multivariate Normal Random-Effects Model';
data Rats;
   array days[5] (8 15 22 29 36);
   input weight @@;
   subject = ceil(_n_/5);
   index = mod(_n_-1, 5) + 1;
   age = days[index];
   drop index days:;
   datalines;
151 199 246 283 320 145 199 249 293 354
147 214 263 312 328 155 200 237 272 297
135 188 230 280 323 159 210 252 298 331
141 189 231 275 305 159 201 248 297 338
177 236 285 350 376 134 182 220 260 296
160 208 261 313 352 143 188 220 273 314
154 200 244 289 325 171 221 270 326 358
163 216 242 281 312 160 207 248 288 324
142 187 234 280 316 156 203 243 283 317
157 212 259 307 336 152 203 246 286 321
154 205 253 298 334 139 190 225 267 302
146 191 229 272 302 157 211 250 285 323
132 185 237 286 331 160 207 257 303 345
169 216 261 295 333 157 205 248 289 316
137 180 219 258 291 153 200 244 286 324
;

ODS GRAPHICS ON;
proc mcmc data=Rats nmc=10000 outpost=postout seed=17 init=random diagnostics=ALL plots=ALL DIC ;
   *ods select Parameters REParameters PostSumInt;
	ODS OUTPUT PostSumInt=SummaryStats MCSE=MC_Errors DIC=DIC2;
	

	array perRatCoefs[2] alpha beta;

   array globalCoefs[2] globalIntercept globalSlope;
   array globalCoefCovarMat[2,2];
   array mu0[2] (0 0);
   array Sig0[2,2] (1000 0 0 1000);
   array S[2,2] (0.02 0 0 20);

   parms globalCoefs globalCoefCovarMat {121 0 0 0.26} perSampleVariance;
   prior globalCoefs ~ mvn(mu0, Sig0);
   prior globalCoefCovarMat ~ iwish(2, S);
   prior perSampleVariance ~ igamma(0.01, scale=0.01);

   random perRatCoefs ~ mvn(globalCoefs, globalCoefCovarMat) subject=subject monitor=(alpha_1 beta_1 alpha_15 beta_15);


   mu = perRatCoefs[1] + perRatCoefs[2] * age;
   model weight ~ normal(mu, var=perSampleVariance);
run;
ODS GRAPHICS OFF;
