#
# ahonen2015.R, 20 Sep 20
# Data from:
# Reported project management effort, project size, and contract type
# Jarmo J. Ahonen and Paula Savolainen and Helena Merikoski and Jaana Nevalainen
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG management_effort project_management project_effort project_duration team_size


source("ESEUR_config.r")


pal_col=rainbow(2)


fit_contract=function(df, col_str)
{
# fp_mod=nls(l_Management ~ SSfpl(Project_size, a, b, c, d),
# SSfpl does not work:
#  step factor 0.000488281 reduced below 'minFactor' of 0.000976562
# The following converges, but the result is effectively no better than SSlogis
# fp_mod=nls(l_Management ~ a+(b-a)/(1+exp((c-Project_size)/d)),
#                 data=tm, trace=TRUE,
#                 start=list(a=1.3, b=13, c=3000, d=900))
fp_mod=nls(l_Management ~ SSlogis(Project_size, a, b, c), # trace=TRUE,
                data=df)
# print(summary(fp_mod))

pred=predict(fp_mod, newdata=data.frame(Project_size=x_range))
lines(x_range/1e3, exp(pred), col=col_str)
}

# Duration is in working days
# Project size is in hours
ah=read.csv(paste0(ESEUR_dir, "projects/ahonen2015.csv.xz"), as.is=TRUE)

ah$l_Management=log(ah$Management)

# plot(ah$Duration, ah$Management, log="xy", col=point_col)
# plot(ah$Team_size, ah$Management, log="xy", col=point_col)

fp=subset(ah, Contract == "FP")
tm=subset(ah, Contract == "TM")

plot(1, type="n", log="xy",
	xlim=range(ah$Project_size)/1e3, ylim=range(ah$Management),
	xlab="Effort (thousand hours)", ylab="Management (percentage)\n")

points(fp$Project_size/1e3, fp$Management, col=pal_col[1])
points(tm$Project_size/1e3, tm$Management, col=pal_col[2])

legend(x="bottomright", legend=c("Fixed-price", "Time-and-materials"), bty="n", fill=pal_col, cex=1.2)

x_range=exp(seq(0, log(max(ah$Project_size)), by=0.1))

# loess_mod=loess(Management ~ log(Project_size), span=0.3, data=fp)
# loess_pred=predict(loess_mod, newdata=data.frame(Project_size=x_range))
# lines(x_range/1e3, loess_pred, col=pal_col[1])

# Michaelis-Menten has potential...
# fp_mod=nls(l_Management ~ a+b*Project_size/(1+c*Project_size), data=fp, trace=TRUE,
# 				# control=list(minFactor=1e-4),
# 				start=list(a=0.3, b=0.15, c=0.01))

fit_contract(fp, pal_col[1])
fit_contract(tm, pal_col[2])

# A completely different fitted model.
# Replacing Project_size by Duration explains less of the deviance
# man_mod=glm(log(Management) ~ Contract+log(Project_size)+log(Team_size)
# 				+log(Project_size):log(Team_size),
# 					data=ah)
# summary(man_mod)

