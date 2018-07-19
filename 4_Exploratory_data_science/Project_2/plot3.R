## Plot 3 - Of the four types of sources which have seen decreases and increases in emissions from 1999–2008 for Baltimore City?

baltimoreNEI <- NEI[fips=="24510",]

png("plot3.png", width=480, height=480)
ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="Year", y=expression("Total PM"[2.5]*" emission /tons")) + 
  labs(title=expression("PM"[2.5]*" emissions change between years by Source Type (Baltimore City)"))
dev.off()