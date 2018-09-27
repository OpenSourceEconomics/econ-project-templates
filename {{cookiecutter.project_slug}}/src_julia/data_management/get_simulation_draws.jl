# Currently need to run these two lines manually upfront.
# 
# Pkg.add("NPZ")
# Pkg.add("PyPlot")

using NPZ

srand(42)  # set seed for random numbers. Reproducible output

n_types = 2
n_draws = 30000

initial_locations = rand(n_types, n_draws)

npzwrite("out/data/initial_locations.npz", initial_locations)

