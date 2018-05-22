# Downloading the ILSVRC2012 dataset
Note: As of 2018, 
       this has been the same dataset used for the annual ILSVRC 
       object localization challenge since 2012.

## Dataset Overview

### Images
- 1,283,166 images are in the training set.
  -  __Almost all__ concepts, i.e. synsets, are represented by 1300 images.
- 50,000 images are in the validation set.
  -  __All__ concepts, i.e. synsets, are represented by 50 images.
- 1,000 synsets are used to label the images.

### Synsets (\"Concept Labels\")
Example: `n04418357` is a specific synset _label_.
1. A _synset_ (\"synonym set\") corresponds to a concept, 
    meaning that all of the words or phrases in the synset 
    can be substituted for one another in _some_ context.
2. [WordNet](https://wordnet.princeton.edu/) maintains a database of 
    these synsets and assigns each synset a unique ID, i.e. label.
3. These synset IDs are used to label the images in the dataset.

### More Information
See the dataset [summary and statistics](http://image-net.org/about-stats).

## Project Structure
These files provided below make things a lot easier to 
 download, extract, and build the dataset in a useful format, 
 so you can focus on actual machine learning.
Most of them were provided by Google, Inc. in their 
 [Inception model repository](https://github.com/tensorflow/models/tree/master/research/inception/inception/data), 
 even though I fixed a few of their broken scripts and rewrote or renamed 
 others for readability and maintainability.

### Scripts
1. downloader.sh
2. sort_validation_set.sh
3. extract_bounding_boxes.sh
4. to_tf_records.py

### Files
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
3. `synset_english_key.txt`:
    List of synset labels and the actual synsets 
    (list of Englsih word(s) or phrases).

## Download Instructions
1. Create an imagenet account at 
    [http://www.image-net.org/](http://www.image-net.org/).
   number (in the filename).
3. Choose the directory in which you want the dataset built.
4. Created a CSV file called `bounding_boxes.csv` 
    with all the bounding box data.
```
./process_bounding_boxes.py ilsvrc2012/training_bounding_boxes/ unique_synsets.txt > bounding_boxes.csv
```

1. `./download_imagenet.sh unique_synsets.txt ./`
2. `./preprocess_imagenet_validation_data.py lsvrc2012/validation_images/ validation_synset_labels.txt`
