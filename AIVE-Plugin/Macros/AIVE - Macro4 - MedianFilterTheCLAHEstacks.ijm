macro "Median filter the CLAHE [F9]"{
// This macro batch processes a folder containing CLAHE processed tiff stacks, to apply a median blur in preparation for AIVE.
// If you only have one file to process, you may as well just do it manually in ImageJ.
//**NOTE:** As warned in all prior scripts; The pixel scale of your tiff stacks needs to be correct.

//If Required, the radius of the filter can be changed below:
RadiusInNanometers=10;//This defines the radius of the current filter in nanometers.

   requires("1.53a"); 
   dir = getDirectory("Directory with CLAHE processed Tiffs to median filter for AIVE");
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
       
                      open(path);
run("8-bit");

print("processing "+path);
      getDateAndTime(year, month, week, day, hour, min, sec, msec);
 print("Start Time: "+hour+":"+min+":"+sec+":"+floor(msec/100)); 
//Identifying the correct spatial size of image filters.
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );
print("Input image voxel size is "+VOXwidth+"/"+VOXheight+" "+VOXunit+" in X/Y "+VOXdepth+" "+VOXunit+" in Z");
print("If these values deviate from expectation, then you ignored warnings in the previous scripts. Go back to start and try again.");

AspectRatio=VOXwidth/VOXdepth;
RadiusXY=round((RadiusInNanometers/VOXwidth)*10)*0.1;	//Multiplications to adjust round function padding.
RadiusZ=round((RadiusInNanometers/VOXdepth)*10)*0.1;	//Multiplications to adjust round function padding.

run("8-bit");
run("Median 3D...", "x="+RadiusXY+" y="+RadiusXY+" z="+RadiusZ);

           saveAs("tif", dir+list[i]+"+"+RadiusInNanometers+VOXunit+"3DMedian.tif");
run("Close All");

      }
}

}
