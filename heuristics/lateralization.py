import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where
    allowed template fields - follow python string module:
    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    """
    create keys for all the different sequences
    this is telling it the eventual path from the BIDS-formatted experiment directory
    note organization into different sub folders: anat, func, fmap, dwi

    also note there is no session format here, a session formatted floc key would look like:
    floc = create_key(os.path.join('sub-{subject}', 'func', 'ses-{session}', 'sub-{subject}_ses-{session}_task-floc_run-{item:02d}_bold'))

    """
    t1w = create_key(os.path.join('sub-{subject}','anat', 'sub-{subject}_T1w'))
    floc = create_key(os.path.join('sub-{subject}', 'func', 'sub-{subject}_task-floc_run-{item:02d}_bold'))
    fmap = create_key(os.path.join('sub-{subject}', 'fmap', 'sub-{subject}_acq-opp-phase-epi_dir-PA_epi'))
    b0_PA = create_key(os.path.join('sub-{subject}', 'dwi', 'sub-{subject}_acq-B0_PA'))
    b0_PA_TRACEW = create_key(os.path.join('sub-{subject}', 'dwi', 'sub-{subject}_acq-B0_PA_TRACEW'))
    b500 = create_key(os.path.join('sub-{subject}', 'dwi', 'sub-{subject}_acq-dti_64d_b500'))
    b1500 = create_key(os.path.join('sub-{subject}', 'dwi', 'sub-{subject}_acq-dti_64d_b1500'))
    b3000 = create_key(os.path.join('sub-{subject}', 'dwi', 'sub-{subject}_acq-dti_64d_b3000'))

    info = {t1w: [], floc: [], fmap:[], b0_PA: [], b0_PA_TRACEW: [], b500: [], b1500: [], b3000: []}
    for idx, s in enumerate(seqinfo):
        if ('mprage' in s.dcm_dir_name.lower()):
            info[t1w] = [s.series_id]
        if ('floc' in s.dcm_dir_name.lower()) or ('lateralization' in s.dcm_dir_name.lower()):
            info[floc].append(s.series_id)
        if 'epi' in s.dcm_dir_name.lower():
            info[fmap].append(s.series_id)
        if s.dcm_dir_name == 'dwi_acq-b0_PA':
            info[b0_PA].append(s.series_id)
        if s.dcm_dir_name == 'dwi_acq-b0_PA_TRACEW':
            info[b0_PA_TRACEW].append(s.series_id)
        if s.dcm_dir_name == 'dwi_acq-dti_20d_b500':
            info[b500].append(s.series_id)
        if s.dcm_dir_name == 'dwi_acq-dti_64d_b1500':
            info[b1500].append(s.series_id)
        if s.dcm_dir_name == 'dwi_acq-dti_64d_b3000':
            info[b3000].append(s.series_id)

    for key,val in info.items():
        print('found {} scans for sequence {}'.format(len(val), key))
    return info
