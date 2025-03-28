
package AIVE;
import ij.IJ;
import ij.gui.GenericDialog;
import ij.plugin.PlugIn;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import javax.swing.*;
import java.util.HashMap;

public class AIVE_ implements PlugIn, ActionListener {
   
   static String pluginPath, macroPath;
   static String newDir = null;
   static Boolean testPath, testPath1;

   JButton b1;
   JLabel mLab, mLab1, mLab2, mLab3, mLab4;
   static JPanel aivepan1, aivepan2, aivepan3;
   static JFrame mainframe, accframe;

   public JPanel MakePanel1() {
      // Makes info and settings component
   	JPanel aivepan1 = new JPanel(new GridBagLayout());

       GridBagConstraints c = new GridBagConstraints();
       c.fill = GridBagConstraints.HORIZONTAL;
       c.anchor = GridBagConstraints.PAGE_START;
       c.weightx = 0.5;
       c.insets = new Insets(10,20,10,20);

       c.gridx=1; c.gridy=0; c.gridwidth=3;
       aivepan1.add(mLab1 = new JLabel("Welcome to the AIVE Control Panel!",JLabel.CENTER) ,c);
       mLab1.setBorder(BorderFactory.createLineBorder(Color.BLACK , 2));

       JButton b1 = new JButton("Info");
       b1.addActionListener(this);
       c.gridx=0; c.gridy=0; c.gridwidth=1;
       aivepan1.add(b1,c);

       JButton b2 = new JButton("MacOS: See Dialogue");
       b2.addActionListener(this);
       c.gridx=5; c.gridy=0; c.gridwidth=1;
       aivepan1.add(b2,c);

       aivepan1.setBackground(Color.decode("#8ac7a3"));

       return aivepan1;
 }

   public JPanel MakePanel2() {
     // Makes image prep component
      JPanel aivepan2 = new JPanel(new GridBagLayout());

       GridBagConstraints c = new GridBagConstraints();
       c.fill = GridBagConstraints.HORIZONTAL;
       c.anchor = GridBagConstraints.PAGE_START;
       c.weightx = 0.5;
       c.insets = new Insets(1,5,1,5);

       c.gridx=0; c.gridy=2; c.gridwidth=6;
       aivepan2.add(mLab2 = new JLabel("Prepare your input images for AIVE ",JLabel.CENTER ),c);
       mLab2.setBorder(BorderFactory.createLineBorder(Color.BLACK , 2));

       c.gridx=0; c.gridy=3; c.gridwidth=1;
       aivepan2.add(new JLabel("Process Source Image: ",JLabel.CENTER ),c);

       JButton b8 = new JButton("3D CLAHE");
       b8.addActionListener(this);
       c.gridx=0; c.gridy=4;
       aivepan2.add(b8,c);

       JButton bAM4 = new JButton("Denoise CLAHE");
       bAM4.addActionListener(this);
       c.gridx=0; c.gridy=5;
       aivepan2.add(bAM4,c);

       c.gridx=2; c.gridy=3; c.gridwidth=2;
       aivepan2.add(new JLabel("Organelle class spliter:",JLabel.CENTER ),c);

       JButton bAM1 = new JButton("Binarise Classes");
       bAM1.addActionListener(this);
       c.gridx=2; c.gridy=4; c.gridwidth=1;
       aivepan2.add(bAM1,c);
       
       JButton bAM2 = new JButton("Blur Binaries");
       bAM2.addActionListener(this);
       c.gridx=2; c.gridy=5; c.gridwidth=1;
       aivepan2.add(bAM2,c);

       c.gridx=4; c.gridy=3; 
       aivepan2.add(new JLabel("Membrane Prediction:",JLabel.CENTER ),c);

       JButton bPP5 = new JButton("Train a Model");
       bPP5.addActionListener(this);
       c.gridx=4; c.gridy=4;
       aivepan2.add(bPP5,c);

       aivepan2.setBackground(Color.decode("#ffc7a3"));

   	   return aivepan2;
   }

   public JPanel MakePanel3() {
      // Makes AIVE merge and post component
   	JPanel aivepan3 = new JPanel(new GridBagLayout());

       GridBagConstraints c = new GridBagConstraints();
       c.fill = GridBagConstraints.HORIZONTAL;
       c.anchor = GridBagConstraints.PAGE_START;
       c.weightx = 0.5;
       c.insets = new Insets(5,5,5,5);

       c.gridx=0; c.gridy=1; c.gridwidth=4;
       aivepan3.add(mLab3 = new JLabel("AIVE Merge ",JLabel.CENTER ),c);
       mLab3.setBorder(BorderFactory.createLineBorder(Color.BLACK , 2));


       JButton bAM3 = new JButton("AIVE Merge 1");
       bAM3.addActionListener(this);
       c.gridx=0; c.gridy=2; c.gridwidth=3; c.ipady=12;
       c.insets = new Insets(5,30,5,30);
       aivepan3.add(bAM3,c);

       JButton bAM5 = new JButton("AIVE Merge 2");
       bAM5.addActionListener(this);
       c.gridx=0; c.gridy=3; c.gridwidth=3;
       aivepan3.add(bAM5,c);

       c.gridx=0; c.gridy=4; c.gridwidth=4; c.ipady=1;
       c.insets = new Insets(5,5,5,5);
       aivepan3.add(mLab4 = new JLabel("Post processing ",JLabel.CENTER ),c);
       mLab4.setBorder(BorderFactory.createLineBorder(Color.BLACK , 2));

       JButton bPP1 = new JButton("Analysis Macros");
       bPP1.addActionListener(this);
       c.gridx=0; c.gridy=5; c.gridwidth=1;
       aivepan3.add(bPP1,c);

       c.gridx=1; c.gridy=5; c.gridwidth=1;
       aivepan3.add(new JLabel("Prep for 3D Env:",JLabel.RIGHT ),c);

       JButton bPP4 = new JButton("Add Buffer");
       bPP4.addActionListener(this);
       c.gridx=2; c.gridy=5; c.gridwidth=1;
       aivepan3.add(bPP4,c);

       aivepan3.setBackground(Color.decode("#8ac7a3"));

   	   return aivepan3;
   }

   public void actionPerformed(ActionEvent e) {
         String name = e.getActionCommand();
         
         // Split and Handle macro files by type
         HashMap<String, String> getNewDir = new HashMap<String, String>();
         HashMap<String, String> AIVEMacros = new HashMap<String, String>();
         HashMap<String, String> AIVEInfo = new HashMap<String, String>();
         HashMap<String, String> AIVEExtra = new HashMap<String, String>();
         
         getNewDir.put("Change Macros Dir","Choose the AIVE Macros folder");
         // For opening info txt files
         AIVEInfo.put("Info", "AIVEInfo.txt");

         //Add main macro Buttons as Keys and Macro names as values
         AIVEMacros.put("3D CLAHE", "CLAHE - Batch_3DCLAHE_AnisotropicXYZ.ijm");
         AIVEMacros.put("Denoise CLAHE", "AIVE - Macro4 - MedianFilterTheCLAHEstacks.ijm");
         AIVEMacros.put("Binarise Classes", "AIVE - Macro1 - ConvertLabelImageToBinaryStacks.ijm");
         AIVEMacros.put("Blur Binaries", "AIVE - Macro2 - GaussianFilterTheClassBinaries.ijm");
         AIVEMacros.put("AIVE Merge 1", "AIVE - Macro3 - MergeMLoutputsWithClasses.ijm");
         AIVEMacros.put("AIVE Merge 2", "AIVE - Macro5 - MergeTheMaskedMLoutputsWithCLAHE.ijm");
         AIVEMacros.put("Add Buffer", "Post-AIVE - PrepDataFor3DEnvironments.ijm");         
         AIVEMacros.put("MacOS: See Dialogue", "JFileMacOS.ijm");

         // For opening sub-windows from control panel
         AIVEExtra.put("Train a Model", "Membrane Prediction");
         AIVEExtra.put("Analysis Macros", "Post Processing");  

         if (AIVEMacros.containsKey(name)==true) {
            IJ.log("running: " + name );
            runMacros(AIVEMacros.get(name));
         }

         if (AIVEExtra.containsKey(name)==true) {
            IJ.run(AIVEExtra.get(name));
         }

         if (AIVEInfo.containsKey(name)==true) {
            openTxt(AIVEInfo.get(name));
         }
         // Contingency for detecting macro files at the expected path
         if (getNewDir.containsKey(name)==true) {
            newDir = null;
            if (newDir == null) {
                GenericDialog gd = new GenericDialog(getNewDir.get(name));
                gd.addDirectoryField(name, pluginPath);
                gd.showDialog();
                if (gd.wasCanceled()) {
                    return;
                }
                newDir = gd.getNextString();

                testPath1 = new File(newDir+"AIVEinfo.txt").exists();
                if (testPath1 == true) {
                IJ.log("Directory temporarily set to: "+newDir);
                mainFrame(newDir);
                } else { IJ.log("AIVE macro files not found at this location, please try again");
                }
              }
            }
          }

    public void runMacros(String name) {
      // Run ordinary ijm macros
         IJ.log(macroPath + name);      
         IJ.runMacroFile(macroPath + name);
    }

    public void openTxt (String name) {
      // Open info txt file
         IJ.open(macroPath + name);
    }


    public void mainFrame(String arg) {
      //Create main frame, using expected or temp path as arg
      macroPath = arg;

            JFrame mainframe = new JFrame("AIVE Control Panel");
                   mainframe.setPreferredSize(new Dimension(700,370));
                   mainframe.setLayout(new BorderLayout());
                   mainframe.setResizable(true);
    
            //Make and add panels
            JPanel newPanel1 = MakePanel1();
            JPanel newPanel2 = MakePanel2();
            JPanel newPanel3 = MakePanel3();
    
            mainframe.add(newPanel1,BorderLayout.PAGE_START);      
            mainframe.add(newPanel2,BorderLayout.CENTER);
            mainframe.add(newPanel3,BorderLayout.PAGE_END);
    
            mainframe.setBackground(Color.decode("#e6d7b3"));
            mainframe.getContentPane().setBackground(Color.decode("#aac97d"));
            mainframe.pack();
            mainframe.setVisible(true);
    }

    public void accFrame() {
      // Change Directory - Displayed when directory is not expected
            JFrame accframe = new JFrame("AIVE");
                   accframe.setPreferredSize(new Dimension(400,200));
                   accframe.setLayout(new BorderLayout());
                   accframe.setResizable(true);

            JPanel newPanel = setDirPane();

            accframe.add(newPanel,BorderLayout.CENTER);
            accframe.pack();
            accframe.setVisible(true);
  }

  public JPanel setDirPane() {
        
      JPanel accpan1 = new JPanel(new GridBagLayout());

      GridBagConstraints c = new GridBagConstraints();
      c.fill = GridBagConstraints.HORIZONTAL;
      c.anchor = GridBagConstraints.PAGE_START;
      c.weightx = 0.5;
      c.insets = new Insets(5,5,5,5);

      c.gridx=0; c.gridy=0;
      accpan1.add(mLab = new JLabel("Change plugin folder path",JLabel.CENTER ),c);
      mLab.setBorder(BorderFactory.createLineBorder(Color.BLACK , 2));
      c.gridx=0; c.gridy=1;
      accpan1.add(mLab1 = new JLabel("The default path expects the associated macros at: ",JLabel.CENTER ),c);

      c.gridx=0; c.gridy=2;
      accpan1.add(mLab2 = new JLabel("path: "+pluginPath+"AIVE-Plugin/Macros/",JLabel.CENTER ),c);

      c.gridx=0; c.gridy=3;
      accpan1.add(mLab3 = new JLabel("Ensure the macros folders matches the default",JLabel.CENTER ),c);

      c.gridx=0; c.gridy=4;
      accpan1.add(mLab4 = new JLabel("alternatively, if the files are saved elsewhere, set the path below",JLabel.CENTER ),c);

      JButton acpA = new JButton("Change Macros Dir");
      acpA.addActionListener(this);
      c.gridx=0; c.gridy=5;
      accpan1.add(acpA,c);

      accpan1.setBackground(Color.decode("#8ac7a3"));

      return accpan1;
   }

   public void run(String arg) { 
      //Get path to plugins folder
      pluginPath = ij.Menus.getPlugInsPath();

      // Check location of macros 
      try {
        testPath = new File(pluginPath+"AIVE-Plugin/Macros/").exists();
        if (testPath == true) {
            macroPath = (pluginPath + "AIVE-Plugin/Macros/");

            if (arg.equals("") || arg.equals("run")){
               mainFrame(macroPath);
            }

         } else {
               IJ.log("Checking expected macro path: "+pluginPath+"AIVE-Plugin/Macros/");
               IJ.log("Expected path not found");
               accFrame();
         }
      }
      catch (NullPointerException e) {
        IJ.log("Missing file or path Error");
      }
   }
}


   