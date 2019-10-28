# heudiconv_example
Example for using heudiconv to convert a series of DICOM folders to BIDS format

### Requirements:
- UNIX (Mac OS X or Linux)
- docker
- environment variable `BIDS=<top level directory containing bids experiments>`
- at least one subject of data inside `$BIDS/$experiment/sourcedata`

The DICOM folders in `sourcedata/sub-${sub_id}` can be the poorly named '1', '2', ... folders from fileserver2.  
My script will attempt to rename them using the Tarrlab script `renameDicomSeries.m` (author: Austin Marcus)

To convert a subject with ID '01' for BIDS experiment 'lateralization':  
`. do_heudiconv.sh -s 01 -e lateralization`

If there are multiple sessions per subject, for session 1 you can do:
`. do_heudiconv.sh -s 01 -z 01 -e lateralization`

The script will also attempt to fill the field map .json files with the 'intended for' field, specified by an array of tasks set on line 32

questions: create an issue

Author: Nicholas Blauch, viscog group @ CMU (blauch@cmu.edu)
