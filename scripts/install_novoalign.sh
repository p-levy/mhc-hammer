#!/bin/bash -eu

# Declare vars. 
proj_dir=""
bin_dir=""
singularity_image=""
novocraft_download=""

while getopts ":p:h:" opt; do
    case $opt in
        p)
            proj_dir=$OPTARG
            ;;

        h) 
            novocraft_download=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            exit 1
    esac
done
shift $((OPTIND-1))

# check the proj_dir exists
if [ ! -d "$proj_dir" ]; then
    echo "Error: project directory does not exist"
    exit 1
fi

# if hlahd_download is a full path, only keep the filename
if [[ $novocraft_download == */* ]]; then
    novocraft_download=$(basename $novocraft_download)
fi

bin_dir="$proj_dir/bin"
assets_dir="$proj_dir/assets"
novocraft_download="$bin_dir/$novocraft_download"
singularity_image=$proj_dir/singularity_images/mhc_hammer_preprocessing_latest.sif

# check the hlahd_download exists
if [ ! -f "$novocraft_download" ]; then
    echo "Error: Novocraft download does not exist"
    exit 1
fi

# check the singularity image exists
if [ ! -f "$singularity_image" ]; then
    echo "Error: singularity image does not exist"
    exit 1
fi

singularity_command="singularity exec -B $proj_dir:$proj_dir $singularity_image"

# move to the bin directory
cd "$bin_dir"

echo "Installing Novocraft"

$singularity_command tar -xvf "$novocraft_download"
# rm "$novocraft_download"