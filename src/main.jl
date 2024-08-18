num_trials = 10_000
our_seed = 24523438

if length(ARGS) == 1
    num_trials = parse(Int, ARGS[1])
end

println("Running $num_trials trials.")

using Dates, Distributed

ENV["JULIA_WORKER_TIMEOUT"] = 2592000
ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"

@info "Starting simulation at $(now())"

# Install required Julia packages if they are not already installed
@everywhere using Pkg
@everywhere Pkg.activate(joinpath(@__DIR__, ".."))
@everywhere ENV["JULIA_WORKER_TIMEOUT"] = 2592000
Pkg.instantiate()

# Trigger download of data files
using MimiRFFSPs
MimiRFFSPs.datadep"rffsps_v5"

@everywhere include("include_main.jl")

# which CRF to use
smokecrf = "pope" #"binned" or "pope" or "2part"

# which year to pulse the emissions
pulse_yr = 2020

@sync begin
    global results_rff_scc = @spawn compute_rff_scc(num_trials, our_seed, smokecrf, pulse_yr)
    global scc_results = @spawn begin
        data = fetch(results_rff_scc)
        compute_totalscc_data(data, smokecrf, pulse_yr)
    end

    global sectoral_scc_results = @spawn begin
        data = fetch(results_rff_scc)
        compute_sectoralscc_data(data, smokecrf, pulse_yr)
    end
end

@info "Finished simulation at $(now())"
