#/bin/bash -f
usage="$0 [-s subnum] [-e experiment]
DICOM->BIDS"

OPTIND=1
while getopts "hs:e:" opt; do
  case $opt in
    s) sub=${OPTARG} ;;
    e) experiment=${OPTARG} ;;
    h) echo "$usage"; exit ;;
  esac
done

echo 'sub:' $subnum
echo 'experiment: ' $experiment

# first rename file series
matlab -nodisplay -nosplash -r "renameDicomSeries('${BIDS}/${experiment}/sourcedata/sub-${sub}')"

#  do heudiconv (dcm2niix plus bids conversion)
sudo docker run --rm -it \
-v ~/git/bids_code/${experiment}:/code \
-v ${BIDS}/${experiment}:/data \
nipy/heudiconv:debian \
-d '/data/sourcedata/sub-{subject}/*/*.dcm*' \
-s $subnum -f /code/heuristics/${experiment}.py -c dcm2niix -b -o /data --minmeta

# --------  fill field map .json intended for field --------------
sudo chown $USER ${BIDS}/${experiment}/sub-${sub}/fmap/sub-${sub}_acq-opp-phase-epi_dir-PA_epi.json

# edit {'floc'} to be a cell array of all tasks you want to look at
matlab -nodisplay -nosplash -r "bids_fill_fmap_jsons("${experiment}","${subnum}",0,{'floc'}); exit;"
