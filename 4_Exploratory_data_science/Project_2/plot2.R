## Plot 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 𝟻𝟷𝟶") from 1999 to 2008? 

totalNEI <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

png(filename='plot2.png', width=480, height=480)
barplot(totalNEI[, Emissions],
        names = totalNEI[, year],
        xlab = "Year", ylab = "Total PM2.5 emissions per year /tons",
        main = "Emissions change between years (Baltimore City)")
dev.off()