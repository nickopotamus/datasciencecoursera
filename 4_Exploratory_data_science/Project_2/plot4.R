## Plot 4 - Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Subset coal combustion data
combustionRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
coalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
combustionSCC <- SCC[combustionRelated & coalRelated, SCC]
combustionNEI <- NEI[NEI[,SCC] %in% combustionSCC]

png("plot4.png", width=480, height=480)
ggplot(combustionNEI,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#FF9999", width=0.75) +
  labs(x="Year", y=expression("Total PM"[2.5]*" emission /tons x10^5")) + 
  labs(title=expression("PM"[2.5]*" emissions change between years from Coal Combustion Source (US)"))
dev.off()