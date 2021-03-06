#
# ff-ms-predict.R, 17 Dec 19
#
# Data from:
# W3Counter global web stats
# www.w3counter.com
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG

source("ESEUR_config.r")


study_start=as.Date("9-November-2004", format="%d-%B-%Y")
study_end=as.Date("1-October-2010", format="%d-%B-%Y")
last_estimate=as.Date("30-April-2007", format="%d-%B-%Y")


# browser market share
browser_ms=read.csv(paste0(ESEUR_dir, "faults/w3stats_browser.csv.xz"), as.is=TRUE)
browser_ms$date=as.numeric(as.Date(browser_ms$date, format="%m/%d/%Y")-study_start)

plot_market_share=function(ver_str, color, span_val)
{
t=subset(browser_ms, browser == ver_str)

l_mod=loess(market_share ~ date, data=t, span=span_val)
every_day=seq(min(t$date), max(t$date))
day_pred=predict(l_mod, newdata=data.frame(date=every_day))

lines(every_day, day_pred, col=color)
}

brew_col=rainbow(4)

v3=subset(browser_ms, browser == "v3.0")

plot(v3$date, v3$market_share, col=point_col,
	xlab="Days since version 1.0 released", ylab="Firefox v3 percentage market share\n")

plot_market_share("v3.0", brew_col[1], 0.75)
plot_market_share("v3.0", brew_col[2], 0.6)
plot_market_share("v3.0", brew_col[3], 0.4)
plot_market_share("v3.0", brew_col[4], 0.25)

