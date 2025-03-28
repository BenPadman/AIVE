
package AIVE;
import ij.IJ;
import ij.plugin.PlugIn;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import javax.swing.*;
import java.util.HashMap;

public class Membrane_Prediction implements PlugIn, ActionListener {

   // init variables
   static String pluginPath, macroPath;
   static Boolean testPath;

   static JButton b1;
   static JPanel aivepan;

   //Prepare panel and buttons
   public JPanel MakePanel() {

   	     JPanel aivepan = new JPanel(new GridBagLayout());

          GridBagConstraints c = new GridBagConstraints();
          c.fill = GridBagConstraints.HORIZONTAL;
          c.anchor = GridBagConstraints.PAGE_START;
          c.weightx = 0.5;
          c.insets = new Insets(5,5,5,5);
       
          JButton b1 = new JButton("Info");
          b1.addActionListener(this);
          c.gridx=4; c.gridy=1; c.gridwidth=1;
          aivepan.add(b1,c);

          c.gridx=1; c.gridy=1; c.gridwidth=1;
          aivepan.add(new JLabel("  ",JLabel.CENTER ),c);

          c.gridx=0; c.gridy=2;
          aivepan.add(new JLabel("Make the feature stacks: ",JLabel.CENTER ),c);

          JButton bMP1 = new JButton("2D Feats");
          bMP1.addActionListener(this);
          c.gridx=1; c.gridy=2; c.gridwidth=1;
          aivepan.add(bMP1,c);

          JButton bMP2 = new JButton("3D Feats");
          bMP2.addActionListener(this);
          c.gridx=2; c.gridy=2; c.gridwidth=1;
          aivepan.add(bMP2,c);

          JButton bMP3 = new JButton("Merge Feats");
          bMP3.addActionListener(this);
          c.gridx=1; c.gridy=3; c.gridwidth=2;
          aivepan.add(bMP3,c);

          c.gridx=0; c.gridy=4; c.gridwidth=1;
          aivepan.add(new JLabel("Train a model:",JLabel.CENTER ),c);

          JButton bMP4 = new JButton("Core A");
          bMP4.addActionListener(this);
          c.gridx=1; c.gridy=4;
          aivepan.add(bMP4,c); 

          c.gridx=0; c.gridy=5;
          aivepan.add(new JLabel("Apply a model:",JLabel.CENTER ),c);

          JButton bMP5 = new JButton("Core B");
          bMP5.addActionListener(this);
          c.gridx=1; c.gridy=5; c.gridwidth=1;
          aivepan.add(bMP5,c);
       
          aivepan.setBackground(Color.decode("#ffc7a3"));

   	     return aivepan;
     }

   public void actionPerformed(ActionEvent e) {

         String name = e.getActionCommand();

         HashMap<String, String> AIVEMemPr = new HashMap<String, String>();

         //Add Buttons as Keys and Macro names as values
         AIVEMemPr.put("Info", "AIVE-ML-Info.txt");
         AIVEMemPr.put("2D Feats", "ML-Features-PART2-2DFeatSplitter.bsh");
         AIVEMemPr.put("3D Feats", "ML-Features-PART1-3DFeatSplitter-Sigma8.bsh");
         AIVEMemPr.put("Merge Feats", "ML-Features-PART3-Combine3Dand2DFeatures.bsh");
         AIVEMemPr.put("Core A", "ML-CorePartA-ExtractTrainingDataFromFeatures.bsh");
         AIVEMemPr.put("Core B", "ML-CorePartB-ApplyClassifierToFeatures.bsh");
         
         if (AIVEMemPr.containsKey(name)==true) {
         IJ.log("running: " + name );
         openBsh(AIVEMemPr.get(name));
         }
    }

    public void openBsh(String name) {
         IJ.open(macroPath + name);
    }

    public void runMacros(String pthyr) {
         IJ.runMacroFile(macroPath + pthyr);
    }

    public void mainFrame(String arg) {
          macroPath = arg;
     	//Creates Main Panel
          JFrame mainframe = new JFrame("AIVE: Membrane Prediction");
                 mainframe.setPreferredSize(new Dimension(560,190));
                 mainframe.setLayout(new BorderLayout());
                 mainframe.setResizable(true);
 
           //Add buttons
            JPanel newPanel = MakePanel();
            
            mainframe.add(newPanel,BorderLayout.CENTER);
            mainframe.pack();
            mainframe.setVisible(true);
    }

   public void run(String arg) { 

          pluginPath = ij.Menus.getPlugInsPath();
          // Check location of macros 
          try {
               testPath = new File(pluginPath+"AIVE-Plugin/Macros/").exists();
               if (testPath == true) {
	            if (arg.equals("") || arg.equals("run")) {
                mainFrame(pluginPath+"AIVE-Plugin/Macros/");
	            } else {
                IJ.log("Path not found");
                }
               }
          }
          catch (NullPointerException v) {
            IJ.log("File not found, check path and file names");
          }
    }
   }


   
