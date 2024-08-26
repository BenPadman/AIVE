
macro "Split class label image into binary stacks [F9]"{
//This script will convert a class label tiff stack, into individual binarized class tiff stacks representing each class.
//The class label tiff stack defines each class by voxel value; voxels with a value of 1 belong to class1, voxels with a value of 2 belong to class2, etc.
//If using Microscopy Image Browser to generate class labels, the tiff stack can be exported by saving an annotated model as a 3D Tiff.


//**NOTE:** Ensure that the physical pixel scale of your label tiff stack is correctly set.
//If the numbers indicated in the log window do not match the expected values, open the class label stack in ImageJ and set the correct pixel scale.


//This defines the location of the class label tiff stack.
TargetFile = File.openDialog("Select the class label tiff stack");

//This defines the output directory for the binary masks.
dir = getDirectory("Output directory for binary masks");

//This defines a simple prefix for the name of each mask.
//A numerical index will also be assigned later in the script.
prefix="CLASS"; 



//Processing starts here
open(TargetFile);
image = getTitle();
run("Select None");
run("Z Project...", "projection=[Max Intensity]");
getStatistics(area, mean, min, max, std, histogram);
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );
print("Input image voxel size is "+VOXwidth+"/"+VOXheight+" "+VOXunit+" in X/Y "+VOXdepth+" "+VOXunit+" in Z");
print("If these values deviate from expectation, please assign the correct pixel scale in your label image then try again.");




run("Close All");
requires("1.33s"); 

setBatchMode(true);
DIVISIONS=max;

  for (i=1; i<(DIVISIONS+1); i++) {
open(TargetFile);
if (i<10){
            index = "0" + i;
        } else {
           index = i;}
THRESH=i;

setThreshold(THRESH, THRESH);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Properties...", "unit="+VOXunit+" pixel_width="+VOXwidth+" pixel_height="+VOXheight+" voxel_depth="+VOXdepth); 
saveAs("Tiff", dir + prefix + '_' + index);
run("Close All");
      
}

}
