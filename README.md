# Matlab script for reading the PROBA-V S1/S10

This is a Matlab script for reading the PROBA-V S1/S10 products in an easy and handy way. It is developed because there was a high need from end users to be able to extract and read the PROBA-V images and convert them to an easy format to work with (e.g standard IDL/ENVI format).

## Getting Started

These instructions will guide you to use the PROBA-V S1/S10 reader

### Prerequisites

Matlab already installed


### Installing

* Download the Matlab script and copy it in your local folder.

* Unzip to your local folder

### Folder Content

In the zip folder, you will find the following folder/files:

* FOLDERS
  * bin folder : folder containing the h5dump binary executable that extracts the hdf5 data
  * cfg folder : folder containing the layers.txt ascii file for the HDF5 layer selection
  * input folder : folder to be used as input, all the HDF5  products to be converted need to be copied in this folder
  * output folder : folder used by the conversion tool to store the output files

* FILES
  * pv_read.m : the matlab script to convert the PROBA-V S1-TOC, S1-TOA and S10-TOC HDF5 files into IDL/ENVI files
  * ./cfg/layers.txt : ascii file for user HDF5 layer'selection


## Getting started

* Under the cfg folder, use the layers.txt file to select the layers that need to be extracted from the HDF5 PROBA-V product. To do that, add simply this caracter # behind the layer to be ignored (e.g. the layers.txt configuration below will extract only the TOA images from the HDF5 products, all other layers (e.g  'LEVEL3/GEOMETRY/SAA') are ignored.

	```
	#LEVEL3/GEOMETRY/SAA
	#LEVEL3/GEOMETRY/SZA
	#LEVEL3/GEOMETRY/SWIR/VZA
	#LEVEL3/GEOMETRY/SWIR/VAA
	#LEVEL3/GEOMETRY/VNIR/VZA
	#LEVEL3/GEOMETRY/VNIR/VAA
	#LEVEL3/NDVI/NDVI
	#LEVEL3/QUALITY/SM
	LEVEL3/RADIOMETRY/BLUE/TOA
	#LEVEL3/RADIOMETRY/BLUE/TOC
	LEVEL3/RADIOMETRY/RED/TOA
	#LEVEL3/RADIOMETRY/RED/TOC
	LEVEL3/RADIOMETRY/NIR/TOA
	#LEVEL3/RADIOMETRY/NIR/TOC
	LEVEL3/RADIOMETRY/SWIR/TOA
	#LEVEL3/RADIOMETRY/SWIR/TOC
	#LEVEL3/TIME/TIME
	```

* Run the matlab script pv_read.m

* The output files are stored in the output folder using this convention
    ```  
	./output/PRODUCT-NAME/PRODUCT-NAME-LAYER
	```

* Enjoy

## Built With

* [h5dump](https://support.hdfgroup.org/HDF5/docNewFeatures/FileSpace/h5dump.htm) - Tool to dump HDF5 file into a binary file


## Authors

* **Iskander Benhadj 2017** 

Please contact us in case of bug/issue or for suggestions/improvements
* [Tutorial video](https://www.youtube.com/watch?v=GRGLcG_z5iE) 

<div style="position:relative;height:0;padding-bottom:56.21%"><iframe src="https://www.youtube.com/embed/GRGLcG_z5iE?ecver=2" style="position:absolute;width:100%;height:100%;left:0" width="641" height="360" frameborder="0" allowfullscreen></iframe></div>


## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details


