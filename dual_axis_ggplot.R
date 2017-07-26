###############################################################
####  ggplot does not support creating dual                ####
####  axis barplot. This is a plotting theory              ####
####  issue for Hadley. However, if situation dictates,    ####
####  the following can be used to create one.             ####
###############################################################

p1 <- ggplot(df_processed_Gen, aes(x = FYE, y = SumGen, fill = "#4B92DB")) +   # having a fill is
  geom_bar(stat = 'identity') +                                                # is important for bar
  labs(x="FYE", y="Sum of Generation") +                                       # and area if you want legends
  scale_fill_identity(name="", guide="legend", labels=c("sum(generation)")) +
  theme(legend.position="bottom") +
  ggtitle('Generator and CF information')


p2 <- ggplot(df_processed_CF, aes(x = FYE, y = SumCF, colour = 'sum(CF)')) + 
  geom_line(stat = 'identity') + 
  labs(x="FYE", y="Sum of Capacity Factor") +
  theme_few() %+replace% 
  theme(panel.background = element_rect(fill = NA)) +
  theme(legend.position="bottom",
        legend.title=element_blank())

# hack for ggplots as it does not support dual axis
# due it the conpect being inherently flawed in plotting thoery
# See the discussion : https://stackoverflow.com/a/3101876/7860688

library(ggplot2)
library(gtable)
library(grid)


# extract gtable
g1 <- ggplot_gtable(ggplot_build(p1))
g2 <- ggplot_gtable(ggplot_build(p2))

# overlap the panel of 2nd plot on that of 1st plot
pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
                     pp$l, pp$b, pp$l)

# axis tweaks
ia <- which(g2$layout$name == "axis-l")   # depending on platform, this may change.
ga <- g2$grobs[[ia]]                      # use print(g$layout) to find the correct one
ax <- ga$children[[2]]
ax$widths <- rev(ax$widths)
ax$grobs <- rev(ax$grobs)
ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)


ia2 <- which(g2$layout$name == "ylab")   # depending on platform, this may change.
ga2 <- g2$grobs[[ia2]]                   # use print(g$layout) to find the correct one
ga2$rot <- 90
g <- gtable_add_cols(g, g2$widths[g2$layout[ia2, ]$l], length(g$widths) - 1)
g <- gtable_add_grob(g, ga2, pp$t, length(g$widths) - 1, pp$b)


# Extract legend. 
# Legends may not be present if they are not produced from ggplot() in p1 and p2
# In that case, go back and edit your ggplot to produce legends. Otherwise, omit the following.   
leg1 <- g1$grobs[[which(g1$layout$name == "guide-box")]]
leg2 <- g2$grobs[[which(g2$layout$name == "guide-box")]]

g$grobs[[which(g$layout$name == "guide-box")]] <- gtable:::cbind_gtable(leg1, leg2, "first")


# g is the grob that should be used to draw the plot. We need grid package for that.
library(grid)
grid.newpage()
grid.draw(g)