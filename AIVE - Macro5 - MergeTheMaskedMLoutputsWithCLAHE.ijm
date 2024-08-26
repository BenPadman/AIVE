macro "Extract AIVE data [F9]"{
// This is the final script for AIVE.
// If you have done all prior stages correctly, this macro will merge the class masked ML predictions with the CLAHE preprocessed FIB data.

   requires("1.53a"); 
   //Location of the preprocessed CLAHE stack (as a 3D tiff).
   CLAHEFilePath = File.openDialog("Select the pre-processed CLAHE stack (i.e. +MedianBlur).");
   //Location of the class masked ML predictions, as generated by the previous script.
   dir = getDirectory("Choose the folder with class-masked ML predictions");
   //Destination for the final file outputs. Happy hunting.
   outdir = getDirectory("AIVE Output Directory");
   
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
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
Classname = File.getName(path);
open(CLAHEFilePath);
SOURCEname = File.getName(CLAHEFilePath);
imageCalculator("Multiply create 32-bit stack", SOURCEname, Classname);
selectWindow("Result of "+SOURCEname);
setMinAndMax(0, 255);
run("Grays");
run("8-bit");
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