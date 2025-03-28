
package AIVE;
import ij.IJ;
import ij.plugin.PlugIn;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import javax.swing.*;
import java.util.HashMap;

public class Post_Processing implements PlugIn, ActionListener {

   //Specifies where macros are stored
   static String pluginPath, macroPath;
   static Boolean testPath;

   static JButton b1;
   static JPanel aivepan;

   public JPanel MakePanel() {

   	   JPanel aivepan = new JPanel(new GridBagLayout());

       GridBagConstraints c = new GridBagConstraints();
       c.fill = GridBagConstraints.HORIZONTAL;
       c.anchor = GridBagConstraints.PAGE_START;
       c.weightx = 0.5;
       c.insets = new Insets(5,5,5,5);
       
       JButton b1 = new JButton("Info");
       b1.addActionListener(this);
       c.gridx=0; c.gridy=1; c.gridwidth=1;
       aivepan.add(b1,c);

       JButton bPP1 = new JButton("Batch Measure");
       bPP1.addActionListener(this);
       c.gridx=1; c.gridy=2;
       aivepan.add(bPP1,c);

       JButton bPP2 = new JButton("Fill Mitos");
       bPP2.addActionListener(this);
       c.gridx=1; c.gridy=3;
       aivepan.add(bPP2,c);

       JButton bPP3 = new JButton("Vesicle Separator");
       bPP3.addActionListener(this);
       c.gridx=1; c.gridy=4;
       aivepan.add(bPP3,c);
       
       aivepan.setBackground(Color.decode("#8ac7a3"));

   	   return aivepan;
   }

   public void actionPerformed(ActionEvent e) {
         
        String name = e.getActionCommand();

        HashMap<String, String> AIVEPoP = new HashMap<String, String>();
        HashMap<String, String> AIVEInfo = new HashMap<String, String>();

        //Add Buttons as Keys and Macro names as values
        AIVEInfo.put("Info", "AIVE-PP-Info.txt");
        AIVEPoP.put("Batch Measure", "Post-AIVE - BatchMorpholibJMeasurement.ijm");
        AIVEPoP.put("Fill Mitos", "Post-AIVE - FillMitochondrialStructures.ijm");
        AIVEPoP.put("Vesicle Separator", "Post-AIVE - StrayVesicleSeparator.ijm");
         
        if (AIVEPoP.containsKey(name)==true) {
            IJ.log("running: " + name );
            runMacros(AIVEPoP.get(name));
        } else if (AIVEInfo.containsKey(name)==true) {
            openFile(name);
        }   
    }

    public void openFile(String name) {
         IJ.open(macroPath + name);
    }

    public void runMacros(String name) {
         IJ.runMacroFile(macroPath + name);
    }

    public void mainFrame(String arg) {
        macroPath = arg;
         //Creates Main Panel
            JFrame mainframe = new JFrame("AIVE: Post Processing");
                   mainframe.setPreferredSize(new Dimension(300,190));
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
   

