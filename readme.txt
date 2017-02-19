Contact iskander.benhadj@vito.be
---------------------------------
FOLDERS
---------
->bin folder : folder containing the h5dump binary executable for HDF5 data extraction
->cfg folder : folder containing the layers.txt ascii file for the HDF5 layer selection
->input folder : folder to be used as input, all the HDF5 to be converted need to be copied in this folder (two samples are present)
->output folder : folder used by the conversion tool to store the output files

FILES
-------
pv_read.m : Matlab script to convert the PROBA-V S1-TOC, S1-TOA and S10-TOC HDF5 files into IDL/ENVI files
./cfg/layers.txt : ascii file for user HDF5 layer's selection


PROCEDURE
-----------

1- Under the cfg folder, use the layers.txt file to select the layers that need to be extracted from the HDF5 PROBA-V product. 
to do that, add simply this character # behind the layer to be ignored
e.g. the layers.txt configuration below will extract only the TOA images from the HDF5 products, all other layers (e.g  'LEVEL3/GEOMETRY/SAA') are ignored

	#LEVEL3/GEOMETRY/SAA
	#LEVEL3/GEOMETRY/SZA
	#LEVEL3/GEOMETRY/SWIR/VZA
	#LEVEL3/GEOMETRY/SWIR/VAA
	#LEVEL3/GEOMETRY/VNIR/VZA
	#LEVEL3/GEOMETRY/VNIR/VAA
	#LEVEL3/NDVI/NDVI
	#LEVEL3/QUALITY/SM
	LEVEL3/RADIOMETRY/BLUE/TOA
	LEVEL3/RADIOMETRY/BLUE/TOC
	#LEVEL3/RADIOMETRY/RED/TOA
	#LEVEL3/RADIOMETRY/RED/TOC
	LEVEL3/RADIOMETRY/NIR/TOA
	#LEVEL3/RADIOMETRY/NIR/TOC
	LEVEL3/RADIOMETRY/SWIR/TOA
	#LEVEL3/RADIOMETRY/SWIR/TOC
	LEVEL3/TIME/TIME

2- Run the matlab script pv_read.m 
3- The output files are stored in the output folder using this convention
 ./output/PRODUCT-NAME/PRODUCT-NAME-LAYER
4- Enjoy