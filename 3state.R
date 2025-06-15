library(diagram)
stateNames <- c("dyn1","dyn2","dyn3")
TM <- matrix(nrow = 3, ncol = 3, byrow = TRUE, data =
               c(0,12,0,
                 21,0,23,
                 0,32,0))



row.names(TM) <- stateNames; colnames(TM) <- stateNames
par(mar = c(2,4,4,2))
plotmat(t(TM), pos = 3,
        lwd = 3, box.lwd = 2,
        curve = .3,
        cex.txt = 0.8,
        box.size = 0.1,
        box.type = "circle",
        box.prop = 0.5,
        box.col = "light grey",
        arr.length =.1,
        arr.type = "curved",
        arr.width =.1,
        arr.lwd = .2,
        self.cex = .4,
        self.shifty = -.01,
        self.shiftx = .13,
        prefix = "q",
        main = " State Transition Diagram")

