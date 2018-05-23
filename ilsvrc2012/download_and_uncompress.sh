# TWO Script Arguments
#  1. SYNSETS_PATH: A .txt file storing the ...
#  2. SAVE_DIR  (optional): Where to create the 'ilscvrc2012/' output.
#
# ONE Script Output
#  1. 'ilscvrc2012/' saved to SAVE_DIR/ or current working directory.
#
# Script Usage
#  $ cd [path to this script]
#  $ ./download_imagenet.sh [synsets file] [directory]
#
# Example of Script Usage
#  $ cd models/research/inception/inception/data/
#  $ ./download_imagenet.sh imagenet_lsvrc_2015_synsets.txt ./
#
# Notes on Usage
#  1. Obtain a username and access_key, by registering at image-net.org.
#  2. If URLs break, be sure to update the four corresponding variables:
#      (1) BASE_URL,
#      (2) TRAIN_BBOX_URL,
#      (3) TRAIN_IMGS_URL, and
#      (4) VALIDATION_IMGS_URL.
#
# Notes on Dataset
#  1. This only downloads images used for the ILSVRC2012 competition.
#  2. However, images used for the object localization challenges 
#      have remain unchanged since 2012 (as of 2018).
#  3. 1,283,166 images in the training set.
#  4. 50,000 images in the validation set.

set -e  # Exit script if any of the following commands fail.

# Set IMAGENET_ACCESS_KEY and IMAGENET_USERNAME.
if [ "x$IMAGENET_ACCESS_KEY" == x -o "x$IMAGENET_USERNAME" == x ]; then
  cat <<END
In order to download the imagenet data, you have to create an account with
image-net.org. This will get you a username and an access key. You can set the
IMAGENET_USERNAME and IMAGENET_ACCESS_KEY environment variables, or you can
enter the credentials here.
END
  read -p "Username: " IMAGENET_USERNAME
  read -p "Access key: " IMAGENET_ACCESS_KEY
fi

# Store the two script arguments into variables.
SYNSETS_PATH="$1"

if [ "$2" == "" ]
then
  BASE_SAVE_DIR="./ilsvrc2012/"
else
  BASE_SAVE_DIR="$2/ilsvrc2012/"
fi

# Check that BASE_SAVE_DIR does not already exist.
if [ -e "$BASE_SAVE_DIR" ]
then
   printf "The following directory already exists:\n ${BASE_SAVE_DIR}\n"
   exit 1  # Exit script if BASE_SAVE_DIR already exists.
fi

# URLs for bounding boxes, training set images, and validation set images.
BASE_URL="http://www.image-net.org/challenges/LSVRC/2012/nnoupb/"

TRAIN_BBOX_URL="${BASE_URL}ILSVRC2012_bbox_train_v2.tar.gz"
TRAIN_IMGS_URL="${BASE_URL}ILSVRC2012_img_train.tar"
VALIDATION_IMGS_URL="${BASE_URL}ILSVRC2012_img_val.tar"

# Directories for the uncompressed downloads.
TRAIN_BBOX_SAVE_DIR="${BASE_SAVE_DIR}training_bounding_boxes/"
TRAIN_IMGS_SAVE_DIR="${BASE_SAVE_DIR}training_images/"
VALIDATION_IMGS_SAVE_DIR="${BASE_SAVE_DIR}validation_images/"

# Make all the save directories.
mkdir -p "${TRAIN_BBOX_SAVE_DIR}"
mkdir -p "${TRAIN_IMGS_SAVE_DIR}"
mkdir -p "${VALIDATION_IMGS_SAVE_DIR}"

# Assign specific names to the tarballs being downloaded.
TRAIN_BBOX_SAVE_PATH="${BASE_SAVE_DIR}training_bounding_boxes.tar.gz"
TRAIN_IMGS_SAVE_PATH="${BASE_SAVE_DIR}training_images.tar"
VALIDATION_IMGS_SAVE_PATH="${BASE_SAVE_DIR}validation_images.tar"

# Download data.
echo "Downloading bounding box annotations for training images ..."
wget -nd -c "${TRAIN_BBOX_URL}" -O "${TRAIN_BBOX_SAVE_PATH}"

echo "Downloading validation set images."
wget -nd -c "${VALIDATION_IMGS_URL}" -O "${VALIDATION_IMGS_SAVE_PATH}"

echo "Downloading training set images."
wget -nd -c "${TRAIN_IMGS_URL}" -O "${TRAIN_IMGS_SAVE_PATH}"

# Uncompress data.
echo "Uncompressing bounding box annotations for training images ..."
tar xzf "${TRAIN_BBOX_SAVE_PATH}" -C "${TRAIN_BBOX_SAVE_DIR}"

echo "Uncompressing validation set images ..."
tar xf "${VALIDATION_IMGS_SAVE_PATH}" -C "${VALIDATION_IMGS_SAVE_DIR}"

echo "Uncompressing training set images ..."
while read SYNSET; do
  echo "Processing: ${SYNSET}"

  # Create a directory and delete anything there.
  mkdir -p "${TRAIN_IMGS_SAVE_DIR}/${SYNSET}"
  rm -rf "${TRAIN_IMGS_SAVE_DIR}/${SYNSET}/*"

  # Uncompress into the directory.
  tar xf "${TRAIN_IMGS_SAVE_PATH}" "${SYNSET}.tar"
  tar xf "${SYNSET}.tar" -C "${TRAIN_IMGS_SAVE_DIR}/${SYNSET}/"
  rm -f "${SYNSET}.tar"

done < "${SYNSETS_PATH}"
