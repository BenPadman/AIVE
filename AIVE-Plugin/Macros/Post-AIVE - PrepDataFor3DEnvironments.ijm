macro "Additional preparation of AIVE data for 3D environments [F9]"{
//Did your AIVE results look odd when you loaded them into your favourite 3D program?
//Maybe they're facing the wrong way? or the surfaces aren't fully sealed?
//There are several reasons for this, and this macro is designed to account for them...

//		Problem 1: 	The membranes appear to be "open" (unsealed) at the boundaries of the dataset.
//		This can be prevented by adding an empty border around the dataset, which defines where dataset ends and where membranes should close.
//		You can fix that here:
BorderExpansionDistance=2;//Thickness of empty border in voxels.

//		Problem 2: 	The data orientation is flipped in X/Y/Z when viewed in 3D
//		This can happen because X/Y/Z can be defined differently depending on your 3D program of choice. You can fix that here.
//		NOTE: X/Y/Z are defined here according to their definition in ImageJ:
FlippedX=0;	//Is it flipped in X (Left-Right in ImageJ)? 		0=no	1=yes
FlippedY=0;	//Is it flipped in Y (Up-Down in ImageJ)? 			0=no	1=yes
FlippedZ=1;	//Is it flipped in Z (Forward-Backward in ImageJ)? 	0=no	1=yes



   requires("1.53a"); 
   dir = getDirectory("Choose the folder with the AIVE data");
   outdir = getDirectory("Output folder for where the modified data");
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
imgname = getTitle();
run("8-bit");
getDimensions(width, height, channels, slices, frames);
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);

if (BorderExpansionDistance>0) {
newWidth=width+(BorderExpansionDistance*2);
newHeight=height+(BorderExpansionDistance*2);
run("Canvas Size...", "width="+newWidth+" height="+newHeight+" position=Center zero");
newImage("Front", "8-bit black", newWidth, newHeight, BorderExpansionDistance);
newImage("Back", "8-bit black", newWidth, newHeight, BorderExpansionDistance);
run("Concatenate...", "  image1=Front image2=["+imgname+"] image3=Back");
}

if (FlippedX>0) { 
run("Flip Horizontally", "stack");
}

if (FlippedY>0) { 
run("Flip Vertically", "stack");
}

if (FlippedZ>0) { 
	run("Reverse");
}

setVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
saveAs("tif", outdir+list[i]+".tif");

run("Close All");

      }
}

}