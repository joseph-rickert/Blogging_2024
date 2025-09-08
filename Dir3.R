library(ggplot2)
library(gganimate)
library(dplyr)
library(magick)
library(MCMCpack)  # for rdirichlet

set.seed(42)

# Parameters
alpha1_values <- seq(0.5, 5, by = 0.2)
alpha2 <- 1.5
alpha3 <- 1.0
n_samples <- 1000

# Triangle vertices
v1 <- c(1, 0)  # corresponds to (1,0,0)
v2 <- c(0, 1)  # corresponds to (0,1,0)
v3 <- c(0, 0)  # corresponds to (0,0,1)

# Function to project Dirichlet sample to triangle
project_to_triangle <- function(x1, x2, x3) {
  x <- x1 * v1[1] + x2 * v2[1] + x3 * v3[1]
  y <- x1 * v1[2] + x2 * v2[2] + x3 * v3[2]
  return(data.frame(x = x, y = y))
}

# Generate animation data
animation_data <- data.frame()

for (i in seq_along(alpha1_values)) {
  alpha1 <- alpha1_values[i]
  samples <- rdirichlet(n_samples, c(alpha1, alpha2, alpha3))
  
  projected <- project_to_triangle(samples[,1], samples[,2], samples[,3])
  projected$alpha1 <- alpha1
  projected$frame <- i
  
  animation_data <- rbind(animation_data, projected)
}

# Plot
p <- ggplot(animation_data, aes(x = x, y = y)) +
  geom_point(alpha = 0.3, size = 0.8, color = "steelblue") +
  geom_density_2d(color = "red", alpha = 0.7) +
  xlim(0, 1) + ylim(0, 1) +
  labs(
    title = "Dirichlet Distribution: Effect of Changing α₁",
    subtitle = "α₁ = {closest_state}, α₂ = 1.5, α₃ = 1.0",
    x = "Projected X",
    y = "Projected Y",
    caption = "Triangle vertices: (1,0,0), (0,1,0), (0,0,1)"
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

# Animate
anim <- animate(p, 
                width = 800, 
                height = 600, 
                fps = 8, 
                duration = 12,
                renderer = gifski_renderer("dirichlet_animation.gif"))

print("Animation created successfully!")
anim

# Load required package
library(base64enc)

# Encode the GIF to base64
gif_path <- "dirichlet_animation.gif"
gif_base64 <- base64encode(gif_path)

# Create HTML string
html_img <- paste0(
  '<img src="data:image/gif;base64,',
  gif_base64,
  '" width="800" height="600"/>'
)

# Display in R Markdown or Shiny
cat(html_img)