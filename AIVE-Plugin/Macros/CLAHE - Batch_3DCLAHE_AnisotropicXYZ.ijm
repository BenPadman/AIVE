macro "Calculate CLAHE result and average from all angles on a folder [F9]"{
//**NOTE1:** You must install "CLAHE_Anisotropic.class" in ImageJ/FIJI before using this script.

//**NOTE2:** Ensure that the physical pixel scale of your label tiff stack is correctly set.
//If the numbers indicated in the log window do not match the expected values, open the original stack in ImageJ and set the correct pixel scale.

//**NOTE3:** DO NOT INTERACT WITH YOUR COMPUTER WHILE THIS SCRIPT IS RUNNING.**

   requires("1.53a"); 
   dir = getDirectory("Choose a Directory ");
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
           rename("input image");
getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
getDimensions( width, height, channels, slices, frames );

AspectRatio=VOXwidth/VOXdepth;
RadiusInNanometers=500;//This defines the radius of the CLAHE filter in nanometers.
Radius=round(RadiusInNanometers/VOXwidth);//IMAGE SCALE UNITS NEED TO BE IN NANOMETERS.
DepthCorrectedRadius=round((RadiusInNanometers/VOXwidth)*AspectRatio);
//Radius=128; //800nm
StandardDevs=3;
histoBins=128;
print("Input image voxel size is "+VOXwidth+"/"+VOXheight+" "+VOXunit+" in X/Y "+VOXdepth+" "+VOXunit+" in Z");
print("If these values deviate from expectation, please assign the correct pixel scale in your original image then try again.");
run("Close All");

       //    open(path);
           run("TIFF Virtual Stack...", "open=["+path+"]");
           rename("input image");

//CLAHE IN XY
run("Duplicate...", "title=XY duplicate");
  for ( s=1; s<=slices; s++ ) {
    Stack.setSlice( s );
      run("CLAHE Anisotropic", "blocksize="+Radius+" blocksize_0="+Radius+" histogram="+histoBins+" maximum="+StandardDevs);
    }
rename("XY CLAHE");
saveAs("Tiff", path+"XY.tif");
run("Close All");

       //    open(path);
           run("TIFF Virtual Stack...", "open=["+path+"]");
           rename("input image");        
//CLAHE IN XZ
selectWindow("input image");
run("Duplicate...", "title=XZ duplicate");
run("Reslice [/]...", "output="+VOXdepth+" start=Top avoid");
  for ( s=1; s<=nSlices; s++ ) {
    Stack.setSlice( s );
          run("CLAHE Anisotropic", "blocksize="+Radius+" blocksize_0="+DepthCorrectedRadius+" histogram="+histoBins+" maximum="+StandardDevs);
  }
run("Reslice [/]...", "output="+VOXwidth+" start=Top avoid");
rename("XZ CLAHE");
//RENAME TO XZ CLAHE
run("Collect Garbage");
saveAs("Tiff", path+"XZ.tif");
run("Close All");
run("Collect Garbage");
       
       
           run("TIFF Virtual Stack...", "open=["+path+"]");
           rename("input image"); 	   
selectWindow("input image");
run("Duplicate...", "title=YZ duplicate");
run("Rotate 90 Degrees Right");
run("Reslice [/]...", "output="+VOXdepth+" start=Top avoid");
  for ( s=1; s<=nSlices; s++ ) {
    Stack.setSlice( s );
          run("CLAHE Anisotropic", "blocksize="+Radius+" blocksize_0="+DepthCorrectedRadius+" histogram="+histoBins+" maximum="+StandardDevs);
  }
selectWindow("Reslice of YZ");
run("Reslice [/]...", "output="+VOXwidth+" start=Top avoid");
run("Rotate 90 Degrees Left");
rename("YZ CLAHE");
//RENAME TO YZ CLAHE
saveAs("Tiff", path+"YZ.tif");
run("Close All");
run("Collect Garbage");

           run("TIFF Virtual Stack...", "open=["+path+"XY.tif]");
           rename("XY CLAHE");
           run("TIFF Virtual Stack...", "open=["+path+"XZ.tif]");
           rename("XZ CLAHE");
           run("TIFF Virtual Stack...", "open=["+path+"YZ.tif]");
           rename("YZ CLAHE");
//Reload and  AVERAGE THE STACKS:

imageCalculator("Add create 32-bit stack", "XY CLAHE","XZ CLAHE");
imageCalculator("Add create 32-bit stack", "Result of XY CLAHE","YZ CLAHE");
selectWindow("Result of Result of XY CLAHE");
rename("XYZ CLAHE");
run("Divide...", "value=3 stack");
setMinAndMax(0, 255);
run("8-bit");

   run("Collect Garbage");

saveAs("Tiff", path+"XYZCLAHE.tif");
run("Close All");
//run("Close");

}
//run("Save");
//run("Close");
}

