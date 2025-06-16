
# fix the position matrix so that the code runs with our error. Put 2 dodes in the first row, two nowes in the second row and the absorbing node in the third row.
library(diagram)
stateNames <- c("STW","UTW", "Hex", "Pex", "TF")
TM <- matrix(nrow = 5, ncol = 5, byrow = TRUE, data =
               c(0,12,13,14,15,
                 21,0,23,24,25,
                 31,32,0,34,35,
                 41,42,43,0,45,
                 0,0,0,0,0))
row.names(TM) <- stateNames; colnames(TM) <- stateNames
TM

par(mar = c(2,4,4,2))
pos <- c(1,1,2.,1)
plotmat(t(TM), pos = pos,
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
        prefix = "",
        main = " Asthma Markov Model State Transition Diagram",)
# Now the code should work without errors and display the state transition diagram with the absorbing state correctly.
# suggest a position matrix that will work with the coefficient matirx

#Modify the code so that lables are not printed on the edges
par(mar = c(2,4,4,2))
plotmat(t(TM), pos = pos,
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
        prefix = "",
        main = " State Transition Diagram with Absorbing State",
        lcol = "transparent") # Set lcol to transparent to hide edge labels
