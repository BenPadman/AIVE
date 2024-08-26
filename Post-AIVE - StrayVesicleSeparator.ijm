
macro "Separate vesicles from larger structures [F9]"{
//Do the AIVE results for one of your organelles contain stray structures or vesicles you want to clean up?... then this is the script for you!
//This script will use the pre-processed class masks with the ML membrane outputs to re-evaluate your AIVE results.
//Anything unusually small (defined by "AbsoluteMinimumSize") will be discarded from the result entirely.
//Anything smaller than the structure of interest (defined by "VescCutoffSize") will be treated as a stray membrane (i.e. vesicle).
//Anything larger than those categories will be returned as a cleaned AIVE result.

//If Required, the following parameters can be changed below:
RadiusInNanometers=10;//This defines the radius of the current filter in nanometers.
AbsoluteMinimumSize=5;//Anything smaller than this is unlikely to be anything relevant.
VescCutoffSize = 5000;//This defines the volume cutoff (in voxels) for differentiating between vesicles and larger structures.
NonVescSize=VescCutoffSize+1;
THRESHVAL=64;//The intensity threshold value normally used for 3D AIVE results; can be altered if using in different context.


   requires("1.53a"); 
   MembsFilePath = File.openDialog("The membranes");
   SeparationInputDir = getDirectory("Directory containing preprocessed (Gaussian filtered) binary class masks");
   SeparationFileList = getFileList(SeparationInputDir);
   Array.sort(SeparationFileList);
   dir = getDirectory("Choose the folder with the AIVE data");
   outdir = getDirectory("Output Directory");
   setBatchMode(true);

   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);


   
   function countFiles(dir) {
      list = getFileList(dir);
      Array.sort(list);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
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

print("Loading separation mask");
open(SeparationInputDir+File.separator+SeparationFileList[i]);
rename("SEPARATIONMASK");

getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );
print("Input image voxel size is "+VOXwidth+"/"+VOXheight+" "+VOXunit+" in X/Y "+VOXdepth+" "+VOXunit+" in Z");
RadiusXY=round((RadiusInNanometers/VOXwidth)*10)*0.1;	//Multiplications to adjust round function padding.
RadiusZ=round((RadiusInNanometers/VOXdepth)*10)*0.1;	//Multiplications to adjust round function padding.

//This is to create a buffer zone around the class mask, to avoid altering the AIVE results.
run("Maximum 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ);
setMinAndMax(32, 224);
run("Apply LUT", "stack");
run("Invert", "stack");
print("separation mask preproc complete");
open(path);
FIBMergedName = File.getName(path);
imageCalculator("Subtract create stack", FIBMergedName,"SEPARATIONMASK");
rename("input image");

open(MembsFilePath);
MembsName = File.getName(MembsFilePath);
imageCalculator("Multiply create stack", "input image", MembsName);
selectWindow("Result of input image");
saveAs("tif", outdir+"Tempfile.tif");
			print("TempfileReady");
run("Close All");

open(outdir+"Tempfile.tif");
//**TO ISOLATE STRAYS**
//Simple segmentation to extract structures larger than the cutoff size
run("3D Simple Segmentation", "low_threshold="+THRESHVAL+" min_size="+AbsoluteMinimumSize+" max_size="+VescCutoffSize);
selectWindow("Seg");
saveAs("tif", outdir+"SegTEMP.tif");
           wait(10);
           run("Duplicate...", "title=TEMP ignore duplicate");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("MAX_TEMP");
getStatistics(area, mean, min, max, std, histogram);
roiManager("reset");
rename("TEMP1");
setThreshold(1, 255);
           wait(100); 
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Create Selection");
run("Enlarge...", "enlarge=8 pixel");//just to get some breathing room
roiManager("Add");
roiManager("Select", 0);
selectWindow("TEMP1");
close();
			print("Getting Stray Structures");
run("Close All");
print(FIBMergedName);
open(outdir+"SegTEMP.tif");
rename("TEMP2a");  	
roiManager("Select", 0);
run("Maximum 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ); //To avoid altering AIVE values in structures you want to keep.
setThreshold(1, max);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
rename("TEMP2"); 
           wait(10);
run("32-bit");
           wait(20); 
run("Divide...", "value=255.000 stack"); //Normalization to merge with the original AIVE data without altering the pixel values.
open(path);
rename("TEMP1");  	
imageCalculator("Multiply create 32-bit stack", "TEMP2", "TEMP1");
selectWindow("Result of TEMP2");
rename("OUTPUTRESULT");
selectWindow("OUTPUTRESULT");
           wait(50); 
setMinAndMax(0, 255);
           wait(50); 
run("8-bit");
           wait(50);
setVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
saveAs("tif", outdir+list[i]+"_Strays.tif");
run("Close All");
run("Collect Garbage");
           wait(100);
run("Collect Garbage");
           wait(50);
run("Collect Garbage");
           wait(100);
run("Close All");

open(outdir+"Tempfile.tif");
//Simple segmentation to extract structures larger than the cutoff size
run("3D Simple Segmentation", "low_threshold="+THRESHVAL+" min_size="+NonVescSize+" max_size=-1");
selectWindow("Seg");
saveAs("tif", outdir+"SegTEMP.tif");
           wait(10);
           run("Duplicate...", "title=TEMP ignore duplicate");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("MAX_TEMP");
getStatistics(area, mean, min, max, std, histogram);
roiManager("reset");
rename("TEMP1");
setThreshold(1, 255);
           wait(100); 
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Create Selection");
run("Enlarge...", "enlarge=8 pixel");//just to get some breathing room
roiManager("Add");
roiManager("Select", 0);
selectWindow("TEMP1");
close();
			print("Getting Cleaned Structures");
run("Close All");
print(FIBMergedName);



//EXTRACT CLEANED STRUCTURE
open(outdir+"SegTEMP.tif");
rename("TEMP2a");  	
roiManager("Select", 0);
run("Maximum 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ); //To avoid altering AIVE values in structures you want to keep.
setThreshold(1, max);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
rename("TEMP2"); 
           wait(10);
run("32-bit");
           wait(20); 
run("Divide...", "value=255.000 stack"); //Normalization to merge with the original AIVE data without altering the pixel values.
open(path);
rename("TEMP1");  	
imageCalculator("Multiply create 32-bit stack", "TEMP2", "TEMP1");
selectWindow("Result of TEMP2");
rename("OUTPUTRESULT");
selectWindow("OUTPUTRESULT");
           wait(50); 
setMinAndMax(0, 255);
           wait(50); 
run("8-bit");
           wait(50);
setVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
saveAs("tif", outdir+list[i]+"_Cleaned.tif");
run("Close All");
run("Collect Garbage");
           wait(100);
run("Collect Garbage");
           wait(50);
run("Collect Garbage");
           wait(100);

print("Deleting old tempfiles");
File.delete(outdir+"Tempfile.tif");
File.delete(outdir+"SegTEMP.tif");

  }

run("Close All");


      }
}

}
}
