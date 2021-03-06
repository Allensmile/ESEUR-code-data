#
# 24b1e.R, 27 May 20
# Data from:
# Evaluation of Procedures for Adjusting Problem-Discovery Rates Estimated From Small Samples
# James R. Lewis
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG experiment_human experiment_usability problem-discovery

source("ESEUR_config.r")


library("plyr")


par(mar=MAR_default+c(0.0, 0.7, 0, 0))

pal_col=rainbow(4)


# How many issues were found by the subjects selected?
probs_found=function(df)
{
# For each row, did at least one subject find the issue?
t=apply(df, 1, function(X) as.numeric(sum(X) != 0))

return(sum(t))
}


# Generate all possible combinations of subjects, counting all issues
# found, and plot the probability of finding a given number of issues.
plot_group=function(grp_size)
{
# Generate all combinations of n elements, taken m at a time
g=combn(num_subj, grp_size, function(X) probs_found(usis[ , X]))

totals=count(g)
lines(totals$x, totals$freq/length(g), col=pal_col[grp_size-1])
}

# Impact
# 1. Scenario failure. Participants failed to successfully complete a scenario
# if they either requested help to complete it or produced an incorrect output
# (excluding minor typographical errors).
# 2. Considerable recovery effort. The participant either worked on error
# recovery for more than a minute or repeated the error within a scenario.
# 3. Minor recovery effort. The participant experienced the problem only once
# within a scenario and required less than a minute to recover.
# 4. Inefficiency. The participant worked toward the scenario’s goal but deviated
# from the most efficient path.

usis=read.csv(paste0(ESEUR_dir, "reliability/24b1e.csv.xz"), as.is=TRUE)

usis$Prob=NULL
usis$Impact=NULL

# rs=rowSums(usis)
# table(rs)

num_subj=ncol(usis)

# p2=combn(num_subj, 2, function(X) probs_found(usis[ , X]))
# plot(table(p2))
# 
# p3=combn(num_subj, 3, function(X) probs_found(usis[ , X]))
# plot(table(p3))


plot(1, type="n", log="y",
	xaxs="i", yaxs="i",
	xlim=c(15, 100), ylim=c(3e-4, 1e-1),
	xlab="Issues found", ylab="Probability\n\n")

plot_group(5)
plot_group(4)
plot_group(3)
plot_group(2)

legend(x="bottomright", legend=paste0("Reviewers=", 2:5),
			inset=c(0.03, 0), bty="n", fill=pal_col, cex=1.2)

