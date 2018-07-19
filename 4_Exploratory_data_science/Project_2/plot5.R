## Plot 5 - How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
  
# Subset vehicle related data
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]
  
# Subset vehicle data to Baltimore
baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510",]
  
png("plot5.png", width=480, height=480)
ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill ="#FF9999" ,width=0.75) +
  labs(x="Year", y=expression("Total PM"[2.5]*" Emission /tons x10^5")) + 
  labs(title=expression("PM"[2.5]*" emissions change between years from vehicles (Baltimore)"))
dev.off()

