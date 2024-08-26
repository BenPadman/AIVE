
macro "Batch measure structures [F9]"{
//A simple script to measure a variety of metrics for all structures in a folder of AIVE datasets.
//Requires the MorpholibJ plugin for ImageJ/Fiji (https://imagej.net/plugins/morpholibj)
//If Required, the following parameters can be changed:
   MINIMUMSIZE=0; //IN VOXELS;	DEFAULT = 0 (NO LIMIT);		Defines minimum size of measured structures; useful for honing in on a specific size range.
   MAXIMUMSIZE=-1; //IN VOXELS;	DEFAULT = -1 (NO LIMIT);	Defines maximum size of measured structures; useful for honing in on a specific size range.
   THRESHVAL=64; //The intensity threshold value normally used for 3D AIVE results; can be altered if using in different context.

   requires("1.53a"); 
   dir = getDirectory("Choose the folder with the AIVE data");
   outdir = getDirectory("Where should the measurements go?");

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
      getDateAndTime(year, month, week, day, hour, min, sec, msec);
 print("Start Time: "+hour+":"+min+":"+sec+":"+floor(msec/100)); 
   setBatchMode(true);
                  open(path);
	imgname = getTitle();
	Cleanimgname = replace(File.getName(path), ".tif", "");
	ParentSubDir = File.getParent(path);
print(ParentSubDir);
print(imgname);
	getVoxelSize(VOXwidth, VOXheight, VOXdepth, VOXunit);
	getDimensions(width, height, channels, slices, frames);

run("3D Simple Segmentation", "low_threshold="+THRESHVAL+" min_size="+MINIMUMSIZE+" max_size="+MAXIMUMSIZE);
selectWindow("Seg");
run("Properties...", "unit="+VOXunit+" pixel_width="+VOXwidth+" pixel_height="+VOXheight+" voxel_depth="+VOXdepth); 
selectWindow(imgname);
run("Close");
selectWindow("Seg");
run("Analyze Regions 3D", "voxel_count volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=26");

saveAs("Results", outdir+Cleanimgname+".csv");
run("Close All");
close(Cleanimgname+".csv");

      }
}

}