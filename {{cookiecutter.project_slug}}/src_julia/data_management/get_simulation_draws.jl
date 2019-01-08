using DelimitedFiles
using Random


Random.seed!(42)

n_types = 2
n_draws = 30000

initial_locations = rand(n_types, n_draws)

writedlm("out/data/initial_locations.csv", initial_locations, ",")

