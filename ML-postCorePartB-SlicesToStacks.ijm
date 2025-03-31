
macro "padbatch [F9]"{

   requires("1.33s"); 
   dir = getDirectory("Choose the folder with Weka outputs");
   dir2 = getDirectory("Output Folder");
   setBatchMode(true);


      list = getFileList(dir);
      open(dir+list[0]);
      ImageName = File.getName(dir+list[0]);
                         getDimensions(width, height, channels, slices, frames);
                         nChans = channels;
                         nSlice = list.length;

                         run("Close All");



for (i=0; i<nChans; i++) {

run("Image Sequence...", "select=["+dir+"] dir=["+dir+"] sort use");
	channel = i+1;

if (i<1) {
} else {
for (n=0; n<i; n++) {
	run("Delete Slice");
}
}
run("Reduce...", "reduction="+nChans);
run("Grays");

setMinAndMax(0, 1);

saveAs("tif", dir2+ImageName+"_CHAN"+channel+".tif");

run("Close All");

}



      }


}
