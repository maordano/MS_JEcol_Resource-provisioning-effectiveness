#Include the dataset
library(readr)
RPE <- read_delim("code/Regression body-fruit mass/RPE_data_imputation.csv", ";", 
                  escape_double = FALSE, col_types = cols(frug = col_factor(levels = c()), 
                  frug_family = col_factor(levels = c()), 
                  fruit_visit = col_number(), 
                  plant = col_factor(levels = c()),  
                  plant_family = col_factor(levels = c())), trim_ws = TRUE)
RPE
str(RPE)

#Plotting relation body mass and fruits/visit*FRFM
plot(RPE$body_mass, RPE$fruit_visit*RPE$FRFM)
plot(log(RPE$body_mass), log(RPE$fruit_visit*RPE$FRFM)) #convert to logarythm to normalize
model <- lm(log(fruit_visit*FRFM)~log(body_mass), RPE)
abline(model)
summary(model)
par(mfrow=c(2,2)) #model checking
plot(model)
par(mfrow=c(1,1))


# Correlation test. Ommitting just the pairwise NA's 
cor.test(log(RPE$fruit_visit*RPE$FRFM), log(RPE$body_mass), method="pearson", use= "pairwise.complete.obs")
#pairs(log(RPE$fruit_visit*RPE$FRFM), log(RPE$body_mass), method="pearson", use= "pairwise.complete.obs")


#Infer estimated values of fruit mass ingested (frugivore mean mass of fruit ingested) 
#for frugivore body mass
frug_capacity <- exp(predict(model, RPE))
RPE_capacity <- cbind(RPE, frug_capacity)
str(RPE_capacity)

#save results in data.csv
#write.csv(RPE_capacity, "code/Regression body-fruit mass/RPE_capacity.csv")

#plot in ggplot
library(ggplot2)
ggplot(RPE, aes(body_mass, fruit_visit*FRFM)) + geom_point(size=1.2) + geom_smooth(color="grey", method="lm", se=F) +
  scale_x_log10(breaks=c(0.01, 0.1, 1, 10)) + scale_y_log10(breaks=c(0.01, 0.1, 1, 10))+
  theme(axis.text = element_text(size = rel(0.8)), 
        axis.ticks = element_line(colour = "black"), 
        panel.background = element_rect(fill = "white", colour = NA), 
        panel.border = element_rect(fill = NA, colour = "black"), 
        panel.grid.major = element_line(colour = "grey90", size = 0.2), 
        panel.grid.minor = element_line(colour = "grey98", size = 0.4), 
        strip.background = element_rect(fill = "grey80", 
                                        colour = "grey50", size = 0.2))+
  labs(x = "Log body mass", y="Log fruit mass per visit")

