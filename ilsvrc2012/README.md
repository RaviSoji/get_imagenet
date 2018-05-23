# Downloading the ILSVRC2012 dataset
Note: As of 2018, 
       this has been the same dataset used for the annual ILSVRC 
       object localization challenge since 2012.

## Dataset Overview

### Images
- 1,283,166 images are in the training set.
  -  _Most_ concepts, i.e. synsets, are represented by 1300 images.
- 50,000 images are in the validation set.
  -  _All_ concepts, i.e. synsets, are represented by 50 images.
- 1,000 synsets are used to label the images.

### Synset (\"Concept\") Labels
Example: 
 `n00017222` is a _label_ for the synset or concept 
 `[plant, flora, plant life]`.
1. A synset (\"synonym set\") is a list of words or phrases that
    can be substituted for one another in _some_ context.
2. [WordNet](https://wordnet.princeton.edu/) maintains a database of 
    these synsets and assigns each synset a unique ID, i.e. label.
3. These synset labels are used to label the images in ImageNet.

### More Information
See the dataset [summary and statistics](http://image-net.org/about-stats).

## Download Instructions
1. Create an imagenet account at 
    [http://www.image-net.org/](http://www.image-net.org/).
2. cd into the directory containing this README.md file.
   ```
   cd get_imagenet/
   ```
2. Set the environment variables with your username and access key
   ```
   ```
3. Download and uncompress the training and validation images into of
    `./ilsvrc2012/`.
   ```
   ./download_and_uncompress.sh \
     unique_synsets.txt \
     ./
   ```
4. Rearrange the validation set directory to match the training set.
   ```
   sort_validation_set.py \
     lsvrc2012/validation_images/ \
     validation_synset_labels.txt
   ```
5. Extract & save bounding box data to a CSV called `bounding_boxes.csv` 
    with all the bounding box data.
   ```
   ./get_bounding_boxes.py ilsvrc2012/training_bounding_boxes/ unique_synsets.txt > bounding_boxes.csv
   ```
6. Optional: Create TensorFlow record files for fast IO during 
    model training.
   ```
   mkdir ilsvrc2012/tfrecords
   python3.6 build_tf_records.py \
     --train_directory=ilsvrc2012/training_images/ \
     --validation_directory=ilsvrc2012/validation_images/ \
     --output_directory=ilsvrc2012/tfrecords/ \
     --imagenet_metadata_file=synset_english_key.txt \
     --labels_file=unique_synsets.txt \
     --bounding_box_file=bounding_boxes.csv
   ```

## Project Structure
The scripts and input files listed below make it a lot easier to 
 download, extract, and build the dataset in a useful format, 
 so you can focus on actual research.
Most of them were provided by Google, Inc. in their 
 [Inception model repository](https://github.com/tensorflow/models/tree/master/research/inception/inception/data), 
 even though I fixed a few of their broken scripts and rewrote or renamed 
 others for readability and maintainability.

### Scripts
1. `download_and_uncompress.sh`:
    downloads and uncompresses the training and validation set "tarballs".
2. `sort_validation_set.py`:
    makes the directory structure of the validation set 
    consistent with the training set.
3. `get_bounding_boxes.py`:
    extracts the bounding data from the XML files. 
    See `get_ilsvrc.sh` for usage.
4. `build_tf_records.py`:
    builds TensorFlow records for speed up IO for model training.
5. `get_ilsvrc.sh`:
    if nothing is broken, this script lets the user download the dataset
     in usable format without having to understand the dataset details.

### Input Files
1. `unique_synsets.txt`
  - Each of the 1000 lines contains a unique synset label.
  - They have the form `nXXXXXXXXXX`, e.g. `n01751748`.
2. `validation_synset_labels.txt`
  - Ground truth synset labels for the validation set images.
  - Each of the 50000 lines corresponds to a specific image: 
     for example, line 1 of this file is the synset label `n01751748`,
     so it labels image 1, whose file name is
     `ILSVRC2012_val_00000001.JPEG`.
  - Since there are 50,000 lines in this file, the validation set
     filenames should range from 
     `ILSVRC2012_val_00000001.JPEG` to `ILSVRC2012_val_00050000.JPEG`.
3. `synset_english_key.txt`
  - List of synset labels and the actual English synsets.

### Output
Together, the scripts create a directory called `ilsvrc2012/` at the 
 user specified directory, 
 which is set to the current working directory by default.
- `ilsvrc2012/training_images/`
- `ilsvrc2012/validation_images/`
- `ilsvrc2012/training_bounding_boxes/`
- `ilsvrc2012/tfrecords/`
- `ilsvrc2012/training_bbox_annotations.tar.gz`
- `ilsvrc2012/training_images.tar`
- `ilsvrc2012/validation_images.tar`
- `ilsvrc2012/bounding_boxes.csv`
