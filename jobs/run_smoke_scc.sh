#!/usr/bin/bash
#SBATCH --job-name=GIVE_Smoke
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=48:00:00
#SBATCH -p diffenbaugh
#SBATCH --mem=24GB
#SBATCH -c 12
#SBATCH --mail-type=ALL

cd /oak/stanford/groups/omramom/group_members/ccallahan/Smoke_SCC/GIVE-Smoke/jobs/
module load julia/1.6.2
julia --procs auto ../src/main.jl
