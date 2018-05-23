#!/bin/bash
# Copyright 2018 Ravi Sojitra. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
#
# ONE Script Argument
#  1. SAVE_DIR  # Where to create the directory to which data will be
#               #  downloaded and uncompressed.
#
# Script Outputs
#  1. Script outputs are saved to a new directory called `ilsvrc2012/`,
#      which is saved at SAVE_DIR.
#
# Usage
#  cd [path to this script]
#  ./get_ilsvrc.sh [directory]
#
# Example of Usage
#  cd get_imagenet/ilsvrc2012/
#  ./get_ilsvrc.sh ./

set -e  # Exit script if any of the following commands fail.

if [ -z "$1" ]; then
  echo "Usage: get_ilsvrc2012.sh [data dir]"
  exit
fi

./download_and_uncompress.sh \
  unique_synsets.txt \
  ./

sort_validation_set.py \
  lsvrc2012/validation_images/ \
  validation_synset_labels.txt

./get_bounding_boxes.py \
  ilsvrc2012/training_bounding_boxes/ \
  unique_synsets.txt > bounding_boxes.csv

# Optional: Create TFRecords
mkdir ilsvrc2012/tfrecords

python3.6 build_tf_records.py \
  --train_directory=ilsvrc2012/training_images/ \
  --validation_directory=ilsvrc2012/validation_images/ \
  --output_directory=ilsvrc2012/tfrecords/ \
  --imagenet_metadata_file=synset_english_key.txt \
  --labels_file=unique_synsets.txt \
  --bounding_box_file=bounding_boxes.csv
