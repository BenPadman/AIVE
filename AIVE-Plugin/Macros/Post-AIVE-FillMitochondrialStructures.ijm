macro "Basic mitochondrion filler [F9]"{
//Mitochondrial membranes are useful, but some analyses requires the bulk mitochondrion.
//If you want to know the volume of mitochondrial matrix, or the bulk mitochondrion, then this is the script for you!
//This script will use the ML membrane outputs with the pre-processed class masks (FOR MITOCHONDRIA ONLY) to re-evaluate your AIVE results (FOR MITOCHONDRIA ONLY).
//Annotated regions that fall within the mitochondrial membranes SHOULD be filled to reveal the mitochondrial morphology.
// WARNING: Performance may vary... A LOT. Always inspect the results before doing anything with them.
// Segmentation may occur outside the mitochondrion may occur if the mitochondrion folds back upon itself.
// Exterior filling may also occur if the class labels extend VERY far from the mitochondrion.

//If Required, the following parameters can be changed below:
RadiusInNanometers=10;//This defines the radius of the filters in nanometers.
minsizematrixchunk=2048; //Minimum size for a chunk of matrix, in voxels
THRESHVAL=64;//The intensity threshold value normally used for 3D AIVE results; can be altered if using in different context.

print("\\Clear");
   requires("1.53a"); 
   MembsFilePath = File.openDialog("Select the 32-bit ML tiff stack for membrane probabilities");
   dir = getDirectory("Choose the folder with PRE-PROCESSED class binaries; FOR MITOS ONLY");
   dir2 = getDirectory("Choose the folder with the AIVE data; FOR MITOS ONLY");
   AIVElist = getFileList(dir2);
   Array.sort(AIVElist);
      outdir = getDirectory("Output Directory");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      Array.sort(list);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }



  function processFile(path) {
roiManager("reset");


open(path);
MITOMASKNAME = File.getName(path);
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );
print("Input image voxel size is "+VOXwidth+"/"+VOXheight+" "+VOXunit+" in X/Y "+VOXdepth+" "+VOXunit+" in Z");
RadiusXY=round((RadiusInNanometers/VOXwidth)*10)*0.1;	//Multiplications to adjust round function padding.
RadiusZ=round((RadiusInNanometers/VOXdepth)*10)*0.1;	//Multiplications to adjust round function padding.

run("Minimum 3D...", "x="+RadiusXY*2+" y="+RadiusXY*2+" z="+RadiusZ*2);

open(MembsFilePath);
MembsName = File.getName(MembsFilePath);
run("Invert", "stack"); 
imageCalculator("Multiply create stack", MITOMASKNAME, MembsName);
selectWindow("Result of "+MITOMASKNAME);
run("Gaussian Blur 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ);



//Then use simple segmentation on the result to extract the largest structures
run("3D Simple Segmentation", "low_threshold=128 min_size="+minsizematrixchunk+" max_size=-1");
selectWindow(MITOMASKNAME);
run("Close");
selectWindow("Seg");
rename("FILTERED MATRIX PARTICLES");
setThreshold(1, 1024);
run("Options...", "iterations=1 count=1 black");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark black");
rename("FINAL PREP");

imageCalculator("Multiply create stack", "FINAL PREP", MembsName);
selectWindow("Result of FINAL PREP");

rename("FINAL RESULT");
setMinAndMax(0, 255);
run("8-bit");
saveAs("tif", outdir+MITOMASKNAME+"_MATRIX.tif");
run("Close All");
 call("java.lang.System.gc");
           wait(100);     

//MERGE THE MITO AIVE DATA WITH THE MATRIX DATA
print("stage1 for "+MITOMASKNAME+" complete");
AIVEpath = dir2+AIVElist[i];
open(AIVEpath);
MITOAIVENAME = File.getName(AIVEpath);
open(outdir+MITOMASKNAME+"_MATRIX.tif");
rename("CORRESPONDING MATRIX");
//TO FILL ACTUAL VOIDS
imageCalculator("Add create stack", MITOAIVENAME, "CORRESPONDING MATRIX");
rename("MATRIX TO FILL");
setThreshold(THRESHVAL, 255);
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Fill Holes");
selectWindow(MITOAIVENAME);
//MITOAIVENAME
setThreshold(THRESHVAL, 255);
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark black");
rename("AIVETHRESH");
imageCalculator("Subtract create stack", "MATRIX TO FILL", "AIVETHRESH");
saveAs("tif", outdir+MITOMASKNAME+"_MATRIX2.tif");
run("Close All");
 call("java.lang.System.gc");
           wait(100);     


//MERGE THE MITO AIVE DATA WITH THE MATRIX DATA
print("stage1B for "+MITOMASKNAME+" complete");
AIVEpath = dir2+AIVElist[i];
open(AIVEpath);
MITOAIVENAME = File.getName(AIVEpath);
open(outdir+MITOMASKNAME+"_MATRIX2.tif");
rename("CORRESPONDING MATRIX");
//roiManager("Select", 0);
run("Gaussian Blur 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ);
imageCalculator("Add create stack", MITOAIVENAME, "CORRESPONDING MATRIX");
saveAs("tif", outdir+MITOAIVENAME+"_FILLED.tif");
print("stage2 for "+MITOMASKNAME+" complete");
run("Close All");
 call("java.lang.System.gc");
           wait(100);     




//TO DELETE OLD MATRIX ALONE IMAGE
print("Deleting old matrix for "+MITOMASKNAME);
File.delete(outdir+MITOMASKNAME+"_MATRIX.tif");
File.delete(outdir+MITOMASKNAME+"_MATRIX2.tif");


      }
}

}
}
