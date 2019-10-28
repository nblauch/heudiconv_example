#/bin/bash -f
usage="$0 [-s subnum] [-z ses] [-e experiment]
DICOM->BIDS
Defaults:
-s subnum = '01'
-z ses = 0 (no session format), else specify a 2 digit string e.g. '01'
-e experiment = 'lateralization'
"

#Defaults
sub=01
ses=0
experiment='lateralization'

OPTIND=1
while getopts "hs:e:" opt; do
  case $opt in
    s) sub=${OPTARG} ;;
    e) experiment=${OPTARG} ;;
    h) echo "$usage"; exit ;;
  esac
done

echo 'experiment: ' $experiment
echo 'sub:' $subnum
session=''
sessionf=''
sessionh=''
if [ $ses -gt 0 ]; then
  echo 'ses:' $ses
  session='/ses-${ses}'
  sessionf='_ses-${ses}'
  sessionh='/ses-{session}'
  sessionhh='-ss ${ses}'
fi

# first rename file series
matlab -nodisplay -nosplash -r "renameDicomSeries('${BIDS}/${experiment}/sourcedata/sub-${sub}${session}')"

#  do heudiconv (dcm2niix plus bids conversion)
sudo docker run --rm -it \
-v heuristics:/heuristics \
-v ${BIDS}/${experiment}:/data \
nipy/heudiconv:debian \
-d '/data/sourcedata/sub-{subject}${sessionh}/*/*.dcm*' \
-s $subnum ${sessionhh} -f /heuristics/${experiment}.py -c dcm2niix -b -o /data --minmeta

# --------  fill field map .json intended for field --------------
sudo chown $USER ${BIDS}/${experiment}/sub-${sub}${session}/fmap/sub-${sub}${sessionf}_acq-opp-phase-epi_dir-PA_epi.json

# edit {'floc'} to be a cell array of all tasks you want to look at
# if
matlab -nodisplay -nosplash -r "bids_fill_fmap_jsons("${experiment}","${subnum}","${ses}",{'floc'}); exit;"
