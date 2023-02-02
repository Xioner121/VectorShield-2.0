
package vector.shield;
    import java.io.*; //Java input output lib for file reading/writing
import java.util.ArrayList;//Util for ArrayLists 

public class WriteSettings {
//Writes security option booleans as string output to Json files
   public void writeSettings(ArrayList<ArrayList<Boolean>> array, String[] names) {
       //Looping through main ArrayList
      for (int i = 0;i < array.size(); i++) {
          //Getting ArrayList of index i
         ArrayList<Boolean> curArray = array.get(i);
          //Creating blank file/overwriting existing one with corresponding name from names array
         File file = new File(names[i] + ".json");
         //Instantiating BufferedWriter
         BufferedWriter fileOutput = null;
         try {
            //Setting BufferredWriter with created file and FileWriter
            fileOutput = new BufferedWriter(new FileWriter(file));
            //Looping through current ArrayList, writing each boolean per index as a String on s new line within created file
            for (int x = 0; x < curArray.size(); x++) {
               fileOutput.write(Boolean.toString(curArray.get(x)));//Writing Boolean as String
               fileOutput.newLine();//New line
            }
         } catch (IOException ex) {//Error Handling for creating BufferedWriter with FileWriter and writing to file
             System.out.println("File writer creation/writing failed in WriteSettings");
             System.exit(0);
         } finally {
            if (fileOutput != null) {
                //Closing buffered Writer
               try { fileOutput.close(); }
               catch (IOException ex1) { //Error Handling of closing fileOutput
             System.out.println("Failed to close BufferedWriter fileOutput");
             System.exit(0);
               }
            }
         }
      }
   }
}
