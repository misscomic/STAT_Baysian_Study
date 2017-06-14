s138.plot.beta<-
function()
{
	cat("Input alpha and beta parameters for the beta density, on separate lines, followed by return key :\n"
		)
	parms <- scan(what = numeric(), sep = "\n", strip.white = T)
	
	x <- seq(0.005, 0.995, by = 0.01)
	plot(x, dbeta(x, parms[1], parms[2]), type = "l", xlab = "Value", ylab
		 = "Density", main = paste("Beta density,\nalpha = ", parms[
		1], ", beta = ", parms[2]))
	cat("To remove the graphics window, enter \n dev.off() \n at the prompt. \n"
		)
}
