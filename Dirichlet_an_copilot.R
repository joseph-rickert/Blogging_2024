
# Dirichlet Distribution Animation in R using Co-pilot
library(dplyr)
library(ggplot2)
library(gganimate)
library(dirichlet) # Use the dkahle/dirichlet package from GitHub

create_dirichlet_plot_data <- function(alpha_vec) {
  # Generate a mesh of points on the simplex
  mesh <- simplex_mesh(.01) %>% as.data.frame() %>% tbl_df()
  
  # Calculate Dirichlet density for each point
  mesh$density <- apply(mesh, 1, function(v) ddirichlet(bary2simp(v), alpha_vec))
  
  return(mesh)
}
# Define the sequence of alpha vectors
alpha_sequence <- list(c(1, 1, 1), c(5, 1, 1), c(1, 5, 1), c(1, 1, 5), c(2, 2, 2))

# Generate data for each frame
animation_data <- bind_rows(
  lapply(seq_along(alpha_sequence), function(i) {
    data <- create_dirichlet_plot_data(alpha_sequence[[i]])
    data$frame <- i
    return(data)
  })
)

# Create the ggplot object
dirichlet_plot <- ggplot(animation_data, aes(x, y)) +
  geom_raster(aes(fill = density)) +
  coord_equal(xlim = c(0, 1), ylim = c(0, .85)) +
  scale_fill_viridis_c() +
  labs(title = "Dirichlet Distribution Animation (Alpha = {alpha_sequence[[frame]]})",
       x = "X1", y = "X2") +
  theme_bw()

# Add the animation layer using gganimate
animated_plot <- dirichlet_plot +
  transition_states(
    frame,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() +
  exit_shrink()

# Render the animation
anim_save("dirichlet_animation.gif", animated_plot)
# Note: The above code will save the animation as a GIF file named "dirichlet_animation.gif"
