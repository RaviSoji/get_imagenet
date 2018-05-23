# Downloading the ILSVRC2012 dataset
As of 2018, 
 this has been the same dataset used for the annual ILSVRC 
 object localization challenge since 2012.

The scripts and input files listed below make it a lot easier to 
 download, extract, and build the dataset in a useful format, 
 so you can focus on actual research.
Most of them were provided in some form by Google, Inc. in their 
 [Inception model repository](https://github.com/tensorflow/models/tree/master/research/inception/inception/data), 
 even though I fixed a few of their broken scripts and rewrote or renamed 
 others.

## Dependencies
- Linux Ubuntu 16.04
- python3.6
- tar
- wget
- TensorFlow1.7.0 (optional: only necessary for creating TFRecords)

The download has only been tested with the above,
 though the scripts might work with other configurations.

## Dataset Overview

### Synset (\"Concept\") Labels
Example: 
 `n00017222` is a _label_ for the synset or concept 
 `[plant, flora, plant life]`.
1. A synset (\"synonym set\") is a list of words or phrases that
    can be substituted for one another in _some_ context.
2. [WordNet](https://wordnet.princeton.edu/) maintains a database of 
    these synsets and assigns each synset a unique ID, i.e. label.
3. These synset labels are used to label the images in ImageNet.

### Images
- 1,000 synsets are used to label the images.
- 1,283,166 images are in the training set.
  -  _Most_ concepts, i.e. synsets, are represented by 1300 images.
- 50,000 images are in the validation set.
  -  _All_ concepts, i.e. synsets, are represented by 50 images.

### More Information
- Make sure you have ~150-450GB of space on your computer.
- See the dataset [summary and statistics](http://image-net.org/about-stats).

## Download Instructions
### Easy installation 
1. Create an ImageNet account at 
    [http://www.image-net.org/](http://www.image-net.org/)
    to obtain an ImageNet username and access key.
2. cd into the directory containing this README.md file.
   ``` shell
   cd get_imagenet/ilsvrc2012/  # README.md should be in here.
   ```
3. Set the environment variables with your ImageNet username and access key.
    If you do not set these, the `download_and_uncompress.sh` script will
    prompt you to enter these on the command line.
   ``` shell
   IMAGENET_USERNAME=...  # Replace ... with the username.
   IMAGENET_ACCESS_KEY=...  # Replace ... with the access key.
   ```
4. Create the dataset directory in `get_imagenet/ilsvrc2012/`.
   ```
   get_ilsvrc2012.sh ./
   ```

### Custom installation
1. Create an ImageNet account at 
    [http://www.image-net.org/](http://www.image-net.org/)
    to obtain an ImageNet username and access key.
2. cd into the directory containing this README.md file.
   ``` shell
   cd get_imagenet/ilsvrc2012/  # README.md should be in here.
   ```
3. Set the environment variables with your ImageNet username and access key.
    If you do not set these, the `download_and_uncompress.sh` script will
    prompt you to enter these on the command line.
   ``` shell
   IMAGENET_USERNAME=...  # Replace ... with the username.
   IMAGENET_ACCESS_KEY=...  # Replace ... with the access key.
   ```
4. Download and uncompress the training and validation images into 
    `.get_imagenet/ilsvrc2012/ilsvrc2012/`.
   ``` shell
   ./download_and_uncompress.sh \
     unique_synsets.txt \
     ./
   ```
5. Rearrange the validation set directory to match the training set directory.
   ``` shell
   ./sort_validation_set.py \
     ilsvrc2012/validation_images/ \
     validation_synset_labels.txt
   ```
6. Extract & save bounding box data to a CSV called `bounding_boxes.csv`.
   ``` shell
   ./get_bounding_boxes.py \
     ilsvrc2012/training_bounding_boxes/ \
     unique_synsets.txt > bounding_boxes.csv
   ```
7. Optional: Create TensorFlow record files for fast IO during 
    model training.
   ``` shell
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
    builds TensorFlow records to speed up IO for model training.
5. `get_ilsvrc.sh`:
    if nothing is broken, this script lets the user download the dataset
     in usable format without having to understand the dataset details.

### Input Files
1. `unique_synsets.txt`
  - Each of the 1000 lines contains a unique synset label.
  - They have the form `nXXXXXXXX`, e.g. `n01751748`.
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
- `ilsvrc2012/training_bounding_boxes.tar.gz`
- `ilsvrc2012/training_images.tar`
- `ilsvrc2012/validation_images.tar`
- `bounding_boxes.csv`
