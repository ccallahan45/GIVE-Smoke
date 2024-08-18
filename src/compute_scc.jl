using MimiGIVE, Mimi, DataFrames, CSVFiles, VegaLite, Query, Statistics, Printf
import Random

function compute_rff_scc(num_trials, seed, smoke_crf, pulse_yr)
    Random.seed!(seed)

    m = MimiGIVE.get_model(socioeconomics_source = :RFF, smoke_damages_crf=smoke_crf)

    results = MimiGIVE.compute_scc(m;
        year = pulse_yr,
        last_year = 2300,
        discount_rates = discount_rates,
        fair_parameter_set = :random,
        rffsp_sampling = :random,
        n = num_trials,
        gas = :CO2,
        output_dir = nothing,
        save_md = false,
        save_cpc = false,
        compute_sectoral_values = true,
        compute_domestic_values = true,
        CIAM_foresight = :perfect,
        CIAM_GDPcap = true,
        pulse_size = 1e-4
    )

    return results
end



function compute_totalscc_data(results, smoke_crf, pulse_yr)
    df_final = DataFrame(scc = Float64[], dr = String[], region = Symbol[])

    for (k, v) in results[:scc]
        if k.sector == :total
            df = DataFrame(scc = v.sccs .* pricelevel_2005_to_2020)
            df[!, :dr] .= k.dr_label
            df[!, :region] .= k.region

            append!(df_final, df)
        end
    end
    
    output_dir = joinpath(@__DIR__, "..", "output")
    mkpath(output_dir)
    df_final |> save(joinpath(output_dir,"rffplussmoke_scc_domestic_poly2_"*smoke_crf*"CRF_"*string(pulse_yr)*"_2300.csv"))

    return nothing
end

function compute_sectoralscc_data(results, smoke_crf, pulse_yr)
    df_final = DataFrame(scc = Float64[], sector = Symbol[], dr = String[], region = Symbol[])

    for (k, v) in results[:scc]
        df = DataFrame(scc = v.sccs .* pricelevel_2005_to_2020)
        df[!, :sector] .= k.sector
        df[!, :dr] .= k.dr_label
        df[!, :region] .= k.region

        append!(df_final, df)
    end
    
    output_dir = joinpath(@__DIR__, "..", "output")
    df_final |> save(joinpath(output_dir,"rffplussmoke_scc_sectors_domestic_poly2_"*smoke_crf*"CRF_"*string(pulse_yr)*"_2300.csv"))

    return nothing
end

