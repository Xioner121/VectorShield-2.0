
package vector.shield;

import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.scene.control.Label;
import javafx.stage.Modality;
import javafx.geometry.Pos;
import javafx.geometry.Insets;


public class AlertBox {
//User returned input of yes or no
static boolean answer;

//Method to display alertBox
public static boolean display(String title, String warning, String button1, String button2){
   Stage window = new Stage();
   // Sets stage so that it blocks inputs outside of window.
   window.initModality(Modality.APPLICATION_MODAL);
   window.setTitle(title);
   window.setMinWidth(360);
   //VBox layout of Alert box
   VBox layout = new VBox(10);
   //Label to be displayed
   Label message = new Label();
   //Message fed into current method to be displayed
   message.setText(warning);
   //If user presses yes button, set answer to true and close
   Button action = new Button(button1);
         action.setOnAction(e -> {
         answer=true;
         window.close();
         }
        );
   //If user presses no button, set answer to false and close
   Button close = new Button(button2);
         close.setOnAction(e -> {
         answer=false;
         window.close();
         });
   //Setting application components to ones fed into method
   close.setText(button2);    
   layout.getChildren().addAll(message, action, close);
   layout.setAlignment(Pos.CENTER);
   layout.setPadding(new Insets(10));
   Scene scene = new Scene(layout);
   scene.getStylesheets().add("alertTheme.css");
   window.setScene(scene);
   //Display and wait for user input
   window.showAndWait();
   //Return chosen answer as boolean
   return answer;
}

}
