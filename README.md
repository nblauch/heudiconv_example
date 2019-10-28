# heudiconv_example
Example for using heudiconv to convert a series of DICOM folders to BIDS format

### Requirements:
- docker
- environment variable BIDS=\<top level directory containing bids experiments\>
- at least one subject of data inside $BIDS/$experiment/sourcedata

The DICOM folders in sourcedata can be the poorly named '1', '2', ... folders from fileserver2.  
My script will attempt to rename them using the Tarrlab script renameDicomSeries.m (author: Austin Marcus)

To convert a subject with idea '01' for BIDS experiment 'lateralization':  
`. do_heudiconv.sh -s 01 -e lateralization`

The script will also attempt to fill the field map .json files with the 'intended for' field, specified by an array of tasks set on line 32

questions: create an issue or email blauch@cmu.edu

Author: Nicholas Blauch, viscog group @ CMU
