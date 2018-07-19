## Plot 6 - Compare motor vehicle emissions in Baltimore City with Los Angeles County

# Subset data corresponding to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset vehicle data by city and combine
vehiclesBaltimoreNEI <- vehiclesNEI[fips == "24510",]
vehiclesBaltimoreNEI[, city := c("Baltimore City")]
vehiclesLANEI <- vehiclesNEI[fips == "06037",]
vehiclesLANEI[, city := c("Los Angeles")]
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)

png("plot6.png", width=480, height=480)
ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(.~city, scales = "free",space="free") +
  labs(x="Year", y=expression("Total PM"[2.5]*" emissions /ktons")) + 
  labs(title=expression("PM"[2.5]*" emissions change between years from vehicles (Baltimore vs LA)"))
dev.off()