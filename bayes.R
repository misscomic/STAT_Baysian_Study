s138.bayes<-
function()
{
	cat("Input number of models, followed by return key\n(Leave blank and hit return to exit):\n"
		)
	mod.num <- scan(what = numeric(), sep = "\n", strip.white = T)
	cat("Input names of models, one on each line:\n")
	Models <- scan(what = character(), sep = "\n", strip.white = T)
	cat("Input prior probabilities of models, one on each line:\n")
	Prior <- scan(what = numeric(), sep = "\n", strip.white = T)
	cat("Input number of possible outcomes, followed by return key:\n")
	out.num <- scan(what = numeric(), sep = "\n", strip.white = T)
	cat("Input the name of each possible outcome, one on each line:\n")
	Outcomes <- scan(what = character(), sep = "\n", strip.white = T)
	print(c(mod.num, Models, Prior))
	cat("Input the likelihood of each possible outcome under each model:\n"
		)
	out.lik1 <- matrix(rep(0, mod.num * out.num), nrow = mod.num)
	for(i in 1:mod.num) {
		cat(paste("Model", i, ":\n"))
		out.lik1[i,  ] <- scan(what = numeric(), sep = "\n", 
			strip.white = T)
	}
	out.lik <- out.lik1
	print(c(nrow(out.lik), ncol(out.lik)))
	cat("Table of priors and likelihoods\n")
	for(i in 1:mod.num) {
		cat(i, Models[i], Prior[i], sep = "\t")
		for(j in 1:out.num)
			cat("\t", out.lik[i, j])
		cat("\n")
	}
	#	print(cbind(Models, Prior, out.lik))
	cat("Input number of observations, followed by return key:\n")
	obs.num <- scan(what = numeric(), sep = "\n", strip.white = T)
	cat("Input the names of the observations, one on each line:\n")
	Observations <- scan(what = character(), sep = "\n", strip.white = T)
	for(i in 1:obs.num) {
		cat(paste("\n\n Observation:", Observations[i], "\n"))
		for(j in 1:out.num) {
			if(Observations[i] == Outcomes[j])
				lik.col <- j
		}
		Prod <- numeric()
		for(j in 1:mod.num) {
			Prod <- c(Prod, Prior[j] * as.numeric(out.lik[j, 
				lik.col]))
		}
		Like <- out.lik[, lik.col]
		Post <- round(Prod/sum(Prod), 5)
		Prod <- round(Prod, 5)
		cat("Update Based on Bayes' Theorem\n")
		print(cbind(Models, Prior, Like, Prod, Post))
		Prior <- Post
	}
}
