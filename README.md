# The social cost of CO2 for wildfire smoke in the GIVE model

This code runs the a modified version of the GIVE IAM from Rennert et al., Nature, 2022, to calculate a domestic (i.e., within-US) social cost of CO2. Four sectors (ag, temperature-driven mortality, energy use, and sea level rise) were originally included. We have added a component to include monetized damages from smoke-related mortality.

This code was run using Julia 1.6.2, the closest version available to 1.6.4, on which the code was originally tested by Rennert et al.

Running the code with 10000 Monte Carlo iterations on Stanford's Sherlock computing cluster took about 12-14 hours. You can speed this up substantially by running fewer iterations.

## Running the replication script

To recreate the SCC values reported in the paper this paper, open a OS shell and change into the folder where you downloaded the content of this replication repository. Then run the following command to compute all results:

```
julia --procs auto src/main.jl
```

You can set the smoke-health concentration-response function and the year of CO2 pulse in `main.jl` as well, which will then be reflected in the calculations and the name of the output file. 

The script is configured such that it automatically downloads and installs any required Julia packages.

## Result files

Spreadsheets with results will be stored in the folder `output`. The output needed to reproduce the numbers in the paper will be saved in files titled "rffplussmoke_scc_sectors_domestic_{CRF}_{pulseyear}_2300.csv".
