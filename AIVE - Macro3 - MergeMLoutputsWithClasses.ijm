macro "Merge the classes with ML outputs [F9]"{
// This is the semi-final script for AIVE.
// If you have done all prior stages correctly, this macro will merge the class masked ML predictions with the CLAHE preprocessed FIB data.

   requires("1.53a"); 
   //Location of the raw machine learning outputs (as a 3D Tiff), as 32-bit probability maps.
   StructFilePath = File.openDialog("Select the 32-bit ML probability tiff stack");
   //Location of the pre-processed class binary tiffs.
   dir = getDirectory("Choose the folder with PRE-PROCESSED class binaries");
   //Destination for file outputs.
   outdir = getDirectory("ML-Merged Output Directory");
   
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
//If Required, the radius of the final filter can be changed below:
RadiusInNanometers=10;//This defines the radius of the current filter in nanometers.

                      open(path);
ClassName = File.getName(path);
//Identifying the correct spatial size of image filters.
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );
AspectRatio=VOXwidth/VOXdepth;
RadiusXY=round((RadiusInNanometers/VOXwidth)*10)*0.1;	//Multiplications to adjust round function padding.
RadiusZ=round((RadiusInNanometers/VOXdepth)*10)*0.1;	//Multiplications to adjust round function padding.

open(StructFilePath);
SOURCEname = File.getName(StructFilePath);
imageCalculator("Multiply create 32-bit stack", SOURCEname, ClassName);
selectWindow("Result of "+SOURCEname);
run("Gaussian Blur 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ);

//To convert scalar values back to a range between 0 and 1.
setMinAndMax(0, 255);
run("Grays");
run("Divide...", "value=255 stack");
setMinAndMax(0, 1);
           saveAs("tif", outdir+list[i]);

run("Close All");
run("Collect Garbage");
           wait(100);
call("java.lang.System.gc");
           wait(50);
run("Collect Garbage");
           wait(100);

      }
}

}