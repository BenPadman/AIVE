**Basic scripts and macros for implementing AIVE: AI-directed Voxel Extraction.**

More Details TBA

## FIJI/imageJ plugin
The AIVE code has been packaged into a plugin to allow users to access the key macros via a set of buttons within a control panel window.

Alternatively, if you just want to find and use an individual macro file, all of them are easily available in the /AIVE-Plugin/Macros folder here.

The plugin can be run locally by adding the AIVE-Plugin folder into the plugins folder of your local version of FIJI/ImageJ. 
Additionally, the open source code for the AIVE plugin is available in the src folder. 

### Dependencies
The AIVE approach to training a machine learning model may use some features of the Trainable Weka Segmentation plugin. If you would like to follow our method for training an AI model, you will need to include this as an update site in your local FIJI/imageJ, as well as the 3D Image suite, and ImageScience sites.

As per the paper, the output of our AI training macro should be imported in to the WEKA standalone software to train the model using the full software features. However, any approach to training a membrane prediction model can be supported. The only requirement is that the output is a prediction map with probabilities (range: 0-1.0) saved as a 32-bit tiff.

### Plugin set up
To set up the plugin in your local version of FIJI/imageJ, the whole "AIVE-Plugin" folder should be copied directly into the plugins folder in your local FIJI application. This folder is available within this repo exactely as required. 

e.g. ~/Fiji.app/plugins/AIVE-Plugin/

This folder currently contains:
- The AIVE plugin .jar (AIVE_.jar)
-  A folder containing all of the FIJI/ImageJ macro files. 

The plugin expects to find the macro code within this subfolder (i.e. ~/fiji.../plugins/AIVE-Plugin/Macros/example-file.ijm). If the expected file path does not match you will be prompted to manually fix this, or given an option to set a temporary path (*in development*).

Note: The Fiji software contains many "macros" folders, however, you do not need to move the AIVE /Macros/ subfolder elsewhere. 

If you download the code as a .zip file etc, upon extraction, just double check that the "AIVE-Plugin" folder is pasted into the plugins folder without any additional folders in the path name. Otherwise this will result in a "missing files" error.

### Plugin structure
We are strong supporters of open science and open software. By using the open folder structure (instead of packaging them within a .jar) all the macro code is instantly accessible. We also chose this format to allow users to update and optimise the code for their own datasets without needing to recompile the plugin. 

Modified code will still run via the plugin as long as the file names are unchanged.  
We recognise that each new dataset comes with its own challenges and unique features and users may need a slightly different approach. Users are free to copy and modify files for their own purposes in accordance with the licensing terms. Additionally, specific versions could be saved elsewhere to distinguish them from the original plugin code.

Advanced users may choose to optimise and recompile the code to fit their unique analysis requirements. The source code is available as a starting point.
This java based plugin was compiled using VS Code and the Maven extension.

### Compatibility
This plugin has been tested on Windows, Linux based HPC, and MacOS with FIJI version 1.53t and 1.54h. It should be compatible with many older versions. 

## Future directions
This is the early version of the AIVE plugin. We aim to develop the plugin to be even more user friendly. 
Additional features will be considered and updated as we go through the development process.
