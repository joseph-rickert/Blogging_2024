# Install required packages if not already installed
required_packages <- c("gganimate", "ggplot2", "dplyr", "MCMCpack", "transformr")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

print("Packages loaded successfully!")

# Create animation showing effect of changing first parameter of Dirichlet distribution
library(ggplot2)
library(gganimate)
library(dplyr)
library(magick)

# Set seed for reproducibility
set.seed(42)

# Parameters for animation
alpha1_values <- seq(0.5, 5, by = 0.2)  # First parameter values to animate
alpha2 <- 1.5  # Keep second parameter constant
alpha3 <- 1.0  # Keep third parameter constant
n_samples <- 1000  # Number of samples per frame

# Create data frame to store all samples
animation_data <- data.frame()

# Generate samples for each alpha1 value
for (i in seq_along(alpha1_values)) {
  alpha1 <- alpha1_values[i]
  
  # Generate samples from Dirichlet distribution
  samples <- rdirichlet(n_samples, c(alpha1, alpha2, alpha3))
  
  # Convert to data frame
  df <- data.frame(
    x1 = samples[, 1],
    x2 = samples[, 2],
    x3 = samples[, 3],
    alpha1 = alpha1,
    frame = i
  )
  
  # Add to animation data
  animation_data <- rbind(animation_data, df)
}

# Create the animated plot
p <- ggplot(animation_data, aes(x = x1, y = x2)) +
  geom_point(alpha = 0.3, size = 0.8, color = "steelblue") +
  geom_density_2d(color = "red", alpha = 0.7) +
  xlim(0, 1) +
  ylim(0, 1) +
  labs(
    title = "Dirichlet Distribution: Effect of Changing α₁",
    subtitle = "α₁ = {closest_state}, α₂ = 1.5, α₃ = 1.0",
    x = "Component 1 (x₁)",
    y = "Component 2 (x₂)",
    caption = "Points show samples from 3D Dirichlet projected to 2D (x₁, x₂)\nNote: x₃ = 1 - x₁ - x₂"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(size = 12),
    plot.caption = element_text(size = 10, hjust = 0.5)
  ) +
  transition_states(alpha1,
                    transition_length = 1,
                    state_length = 2) +
  ease_aes('sine-in-out')

# Create the animation
anim <- animate(p, 
                width = 800, 
                height = 600, 
                fps = 8, 
                duration = 12,
                renderer = gifski_renderer("dirichlet_animation.gif"))

print("Animation created successfully!")
anim

# Create a static comparison showing different alpha1 values
library(gridExtra)

# Select a few key alpha1 values for comparison
alpha1_comparison <- c(0.5, 1.0, 2.0, 4.0)
alpha2 <- 1.5
alpha3 <- 1.0
n_samples <- 800

# Create comparison plots
plots <- list()

for (i in seq_along(alpha1_comparison)) {
  alpha1 <- alpha1_comparison[i]
  
  # Generate samples
  samples <- rdirichlet(n_samples, c(alpha1, alpha2, alpha3))
  
  # Create data frame
  df <- data.frame(
    x1 = samples[, 1],
    x2 = samples[, 2],
    x3 = samples[, 3]
  )
  
  # Create plot
  plots[[i]] <- ggplot(df, aes(x = x1, y = x2)) +
    geom_point(alpha = 0.4, size = 0.8, color = "steelblue") +
    geom_density_2d(color = "red", alpha = 0.8) +
    xlim(0, 1) +
    ylim(0, 1) +
    labs(
      title = paste("α₁ =", alpha1),
      x = "Component 1 (x₁)",
      y = "Component 2 (x₂)"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, hjust = 0.5),
      axis.title = element_text(size = 10)
    )
}

# Arrange plots in a grid
grid_plot <- grid.arrange(grobs = plots, ncol = 2, nrow = 2,
                          top = "Effect of Changing First Parameter (α₁) of Dirichlet Distribution\nα₂ = 1.5, α₃ = 1.0")

print("Static comparison plots created!")
grid_plot

# Create animation with simplex border
library(ggplot2)
library(gganimate)
library(dplyr)
library(MCMCpack)
library(magick)

# Set seed for reproducibility
set.seed(42)

# Parameters for animation
alpha1_values <- seq(0.5, 5, by = 0.2)  # First parameter values to animate
alpha2 <- 1.5  # Keep second parameter constant
alpha3 <- 1.0  # Keep third parameter constant
n_samples <- 1000  # Number of samples per frame

# Create data frame to store all samples
animation_data <- data.frame()

# Generate samples for each alpha1 value
for (i in seq_along(alpha1_values)) {
  alpha1 <- alpha1_values[i]
  
  # Generate samples from Dirichlet distribution
  samples <- rdirichlet(n_samples, c(alpha1, alpha2, alpha3))
  
  # Convert to data frame
  df <- data.frame(
    x1 = samples[, 1],
    x2 = samples[, 2],
    x3 = samples[, 3],
    alpha1 = alpha1,
    frame = i
  )
  
  # Add to animation data
  animation_data <- rbind(animation_data, df)
}

# Create simplex boundary data
# For 2D projection of 3D simplex: x1 + x2 + x3 = 1, x1,x2,x3 >= 0
# This gives us: x1 + x2 <= 1, x1 >= 0, x2 >= 0
simplex_boundary <- data.frame(
  x1 = c(0, 1, 0, 0),  # corners and back to start
  x2 = c(0, 0, 1, 0)
)

# Create the animated plot with simplex boundary
p <- ggplot(animation_data, aes(x = x1, y = x2)) +
  # Add simplex boundary first (so it's behind the points)
  geom_polygon(data = simplex_boundary, 
               aes(x = x1, y = x2), 
               fill = NA, 
               color = "black", 
               size = 1.2, 
               linetype = "solid",
               inherit.aes = FALSE) +
  # Add corner labels
  annotate("text", x = 0, y = 0, label = "(0,0,1)", 
           hjust = -0.1, vjust = -0.1, size = 3.5, color = "black") +
  annotate("text", x = 1, y = 0, label = "(1,0,0)", 
           hjust = 1.1, vjust = -0.1, size = 3.5, color = "black") +
  annotate("text", x = 0, y = 1, label = "(0,1,0)", 
           hjust = -0.1, vjust = 1.1, size = 3.5, color = "black") +
  # Add the data points
  geom_point(alpha = 0.4, size = 0.8, color = "steelblue") +
  geom_density_2d(color = "red", alpha = 0.7, size = 0.8) +
  xlim(-0.05, 1.05) +
  ylim(-0.05, 1.05) +
  labs(
    title = "Dirichlet Distribution with Simplex Boundary",
    subtitle = "α₁ = {closest_state}, α₂ = 1.5, α₃ = 1.0",
    x = "Component 1 (x₁)",
    y = "Component 2 (x₂)",
    caption = "Black triangle shows the 2-simplex boundary\nCorners represent pure components: (x₁,x₂,x₃)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(size = 12),
    plot.caption = element_text(size = 10, hjust = 0.5),
    panel.grid.minor = element_blank()
  ) +
  coord_fixed(ratio = 1) +  # Equal aspect ratio
  transition_states(alpha1,
                    transition_length = 1,
                    state_length = 2) +
  ease_aes('sine-in-out')

# Create the animation
anim_with_boundary <- animate(p, 
                             width = 900, 
                             height = 700, 
                             fps = 8, 
                             duration = 12,
                             renderer = gifski_renderer("dirichlet_simplex_animation.gif"))

print("Animation with simplex boundary created successfully!")
anim_with_boundary
gif_animation <- image_read(anim_with_boundary)
gif_animation
