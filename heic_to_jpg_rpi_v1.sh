#!/bin/bash

echo "Checking if libheif is installed"
libheif=$(dpkg -s libheif-examples | grep Status | awk '{ print $4}');
		if [ "$libheif" = "installed" ]; then
			echo "libheif-examples is already installed";
		else
			echo "Installing libheif-examples"
			sudo apt install libheif-examples -y
		fi


# Folder where the HEIC files are located
input_folder="input_folder"

if [ -d "$input_folder" ]; then
    echo "Directory exists!"
else
    echo "directory does not exist"
    echo "Please set input directory"
    exit 0
fi


# Folder where you want the JPG files to be saved
output_folder="output_folder"

# Create output directory if does not exist
mkdir -p "$output_folder"

# Loop over the files in the input folder
for file in "$input_folder"/*.HEIC
do
  # Extract the file name
  filename=$(basename "$file")
  base="${filename%.HEIC}"

  # Convert the file to JPG
  if heif-convert "$file" "$output_folder/$base.jpg"; then
    echo "Converted: $file -> $output_folder/$base.jpg"
  else
    echo "Error in the conversion of: $file"
  fi
done  
echo "Conversione completata."
