## Plot 1 - Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

png(filename='plot1.png', width=480, height=480)
barplot(totalNEI[, Emissions],
        names = totalNEI[, year],
        xlab = "Year", ylab = "Total US PM2.5 emissions per year /tons",
        main = "Emissions change between years (US)")
dev.off()