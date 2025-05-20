package AIVE;
// Source code is decompiled from a .class file using FernFlower decompiler.
import ij.IJ;
import ij.ImagePlus;
import ij.Undo;
import ij.gui.GenericDialog;
import ij.gui.Roi;
import ij.plugin.PlugIn;
import ij.process.ByteProcessor;
import ij.process.ImageProcessor;
import java.awt.Rectangle;

public class CLAHE_Anisotropic implements PlugIn {
   private static int blockRadiusX = 63;
   private static int blockRadiusY = 63;
   private static int bins = 255;
   private static float slope = 3.0F;

   public CLAHE_Anisotropic() {
   }

   static final boolean setup() {
      GenericDialog var0 = new GenericDialog("CLAHE");
      var0.addNumericField("blocksize X: ", (double)(blockRadiusX * 2 + 1), 0);
      var0.addNumericField("blocksize Y: ", (double)(blockRadiusY * 2 + 1), 0);
      var0.addNumericField("histogram bins : ", (double)(bins + 1), 0);
      var0.addNumericField("maximum slope : ", (double)slope, 2);
      var0.addHelp("http://pacific.mpi-cbg.de/wiki/index.php/Enhance_Local_Contrast_(CLAHE)");
      var0.showDialog();
      if (var0.wasCanceled()) {
         return false;
      } else {
         blockRadiusX = ((int)var0.getNextNumber() - 1) / 2;
         blockRadiusY = ((int)var0.getNextNumber() - 1) / 2;
         bins = (int)var0.getNextNumber() - 1;
         slope = (float)var0.getNextNumber();
         return true;
      }
   }

   public final void run(String var1) {
      ImagePlus var2 = IJ.getImage();
      synchronized(var2) {
         if (var2.isLocked()) {
            IJ.error("The image '" + var2.getTitle() + "' is in use currently.\nPlease wait until the process is done and try again.");
            return;
         }

         var2.lock();
      }

      if (!setup()) {
         var2.unlock();
      } else {
         Undo.setup(6, var2);
         run(var2);
         var2.unlock();
      }
   }

   public static final void run(ImagePlus var0) {
      run(var0, blockRadiusX, blockRadiusY, bins, slope);
   }

   public static final void run(ImagePlus var0, int var1, int var2, int var3, float var4) {
      Roi var5 = var0.getRoi();
      if (var5 == null) {
         run(var0, var1, var2, var3, var4, (Rectangle)null, (ByteProcessor)null);
      } else {
         Rectangle var6 = var5.getBounds();
         ImageProcessor var7 = var5.getMask();
         if (var7 != null) {
            run(var0, var1, var2, var3, var4, var6, (ByteProcessor)var7.convertToByte(false));
         } else {
            run(var0, var1, var2, var3, var4, var6, (ByteProcessor)null);
         }
      }

   }

   public static final void run(ImagePlus var0, int var1, int var2, int var3, float var4, Rectangle var5, ByteProcessor var6) {
      Rectangle var7;
      if (var5 == null) {
         if (var6 == null) {
            var7 = new Rectangle(0, 0, var0.getWidth(), var0.getHeight());
         } else {
            var7 = new Rectangle(0, 0, Math.min(var0.getWidth(), var6.getWidth()), Math.min(var0.getHeight(), var6.getHeight()));
         }
      } else {
         var7 = var5;
      }

      if (var6 != null) {
         var7.width = Math.min(var6.getWidth(), var7.width);
         var7.height = Math.min(var6.getHeight(), var7.height);
      }

      var7.width = Math.min(var0.getWidth() - var7.x, var7.width);
      var7.height = Math.min(var0.getHeight() - var7.y, var7.height);
      int var8 = var7.x + var7.width;
      int var9 = var7.y + var7.height;
      ImageProcessor var10;
      if (var0.getType() == 3) {
         var10 = var0.getProcessor().convertToRGB();
         var0.setProcessor(var0.getTitle(), var10);
      } else {
         var10 = var0.getProcessor();
      }

      ByteProcessor var11;
      if (var0.getType() == 0) {
         var11 = (ByteProcessor)var10.convertToByte(true).duplicate();
      } else {
         var11 = (ByteProcessor)var10.convertToByte(true);
      }

      ByteProcessor var12 = (ByteProcessor)var11.duplicate();

      for(int var13 = var7.y; var13 < var9; ++var13) {
         int var14 = Math.max(0, var13 - var2);
         int var15 = Math.min(var0.getHeight(), var13 + var2 + 1);
         int var16 = var15 - var14;
         int var17 = Math.max(0, var7.x - var1);
         int var18 = Math.min(var0.getWidth() - 1, var7.x + var1);
         int[] var19 = new int[var3 + 1];
         int[] var20 = new int[var3 + 1];

         int var21;
         int var22;
         for(var21 = var14; var21 < var15; ++var21) {
            for(var22 = var17; var22 < var18; ++var22) {
               ++var19[roundPositive((float)var11.get(var22, var21) / 255.0F * (float)var3)];
            }
         }

         int var23;
         int var24;
         int var25;
         int var26;
         int var27;
         int var28;
         for(var21 = var7.x; var21 < var8; ++var21) {
            var22 = roundPositive((float)var11.get(var21, var13) / 255.0F * (float)var3);
            var23 = Math.max(0, var21 - var1);
            var24 = var21 + var1 + 1;
            var25 = Math.min(var0.getWidth(), var24) - var23;
            var26 = var16 * var25;
            if (var6 == null) {
               var27 = (int)(var4 * (float)var26 / (float)var3 + 0.5F);
            } else {
               var27 = (int)((1.0F + (float)var6.get(var21 - var7.x, var13 - var7.y) / 255.0F * (var4 - 1.0F)) * (float)var26 / (float)var3 + 0.5F);
            }

            int var29;
            if (var23 > 0) {
               var28 = var23 - 1;

               for(var29 = var14; var29 < var15; ++var29) {
                  --var19[roundPositive((float)var11.get(var28, var29) / 255.0F * (float)var3)];
               }
            }

            if (var24 <= var0.getWidth()) {
               var28 = var24 - 1;

               for(var29 = var14; var29 < var15; ++var29) {
                  ++var19[roundPositive((float)var11.get(var28, var29) / 255.0F * (float)var3)];
               }
            }

            System.arraycopy(var19, 0, var20, 0, var19.length);
            var28 = 0;

            int var30;
            int var31;
            int var32;
            int var33;
            do {
               var29 = var28;
               var28 = 0;

               for(var30 = 0; var30 <= var3; ++var30) {
                  var31 = var20[var30] - var27;
                  if (var31 > 0) {
                     var28 += var31;
                     var20[var30] = var27;
                  }
               }

               var30 = var28 / (var3 + 1);
               var31 = var28 % (var3 + 1);

               for(var32 = 0; var32 <= var3; ++var32) {
                  var20[var32] += var30;
               }

               if (var31 != 0) {
                  var32 = var3 / var31;

                  for(var33 = 0; var33 <= var3; var33 += var32) {
                     int var10002 = var20[var33]++;
                  }
               }
            } while(var28 != var29);

            var30 = var3;

            for(var31 = 0; var31 < var30; ++var31) {
               if (var20[var31] != 0) {
                  var30 = var31;
               }
            }

            var31 = 0;

            for(var32 = var30; var32 <= var22; ++var32) {
               var31 += var20[var32];
            }

            var32 = var31;

            for(var33 = var22 + 1; var33 <= var3; ++var33) {
               var32 += var20[var33];
            }

            var33 = var20[var30];
            var12.set(var21, var13, roundPositive((float)(var31 - var33) / (float)(var32 - var33) * 255.0F));
         }

         var21 = var13 * var0.getWidth();
         if (var0.getType() == 0) {
            for(var22 = var7.x; var22 < var8; ++var22) {
               var23 = var21 + var22;
               var10.set(var23, var12.get(var23));
            }
         } else {
            float var36;
            if (var0.getType() == 1) {
               var22 = (int)var10.getMin();

               for(var23 = var7.x; var23 < var8; ++var23) {
                  var24 = var21 + var23;
                  var25 = var10.get(var24);
                  var36 = (float)var12.get(var24) / (float)var11.get(var24);
                  var10.set(var24, Math.max(0, Math.min(65535, roundPositive(var36 * (float)(var25 - var22) + (float)var22))));
               }
            } else {
               float var35;
               if (var0.getType() == 2) {
                  float var34 = (float)var10.getMin();

                  for(var23 = var7.x; var23 < var8; ++var23) {
                     var24 = var21 + var23;
                     var35 = var10.getf(var24);
                     var36 = (float)var12.get(var24) / (float)var11.get(var24);
                     var10.setf(var24, var36 * (var35 - var34) + var34);
                  }
               } else if (var0.getType() == 4) {
                  for(var22 = var7.x; var22 < var8; ++var22) {
                     var23 = var21 + var22;
                     var24 = var10.get(var23);
                     var35 = (float)var12.get(var23) / (float)var11.get(var23);
                     var26 = Math.max(0, Math.min(255, roundPositive(var35 * (float)(var24 >> 16 & 255))));
                     var27 = Math.max(0, Math.min(255, roundPositive(var35 * (float)(var24 >> 8 & 255))));
                     var28 = Math.max(0, Math.min(255, roundPositive(var35 * (float)(var24 & 255))));
                     var10.set(var23, var26 << 16 | var27 << 8 | var28);
                  }
               }
            }
         }

         var0.updateAndDraw();
      }

   }

   private static final int roundPositive(float var0) {
      return (int)(var0 + 0.5F);
   }
}
