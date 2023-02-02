/*
Vector Shield 2.0, A windows Server System hardening application.
Made using the JavaFX library and Apache Netbeans IDE.
Created by: Justin Vogel
*/

package vector.shield;//Setting code apart of Netbeans package so it can be compilied into a jar

import java.io.*;
import java.util.concurrent.CountDownLatch;
import java.util.ArrayList; // imports util for ArrayList class
//Imports JavaFX, the ibrary used for the gui.
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ToggleButton;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;
import javafx.scene.control.Label;
import javafx.geometry.Pos;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ListView;
import javafx.scene.control.TreeView;
import javafx.scene.control.TreeItem;
import javafx.geometry.Insets;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.MenuBar;
import javafx.scene.control.SeparatorMenuItem;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Group;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.Toggle;
import javafx.beans.value.ObservableValue;
import javafx.beans.value.ChangeListener;
import javafx.util.Duration;
import javafx.animation.RotateTransition; 
import javafx.animation.Interpolator;
import javafx.concurrent.Service;
import javafx.concurrent.Task;
import javafx.application.Platform;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.StackPane;
import javafx.scene.text.TextAlignment;

public class VectorShield extends Application {
// sets a stage
   Stage window;
//For user input on whether to harden
   boolean harden = false;
//To track when script has ended as to close non-essential threads
   boolean scriptRunning = false;
//Imports WriteSettings as a constructor
   static WriteSettings printToJson = new WriteSettings();

    //Arraylist containing the below set Arraylists for the writeSettings method
    //(changed from Array as mentioned in crit. B due to combatibility issues between the two data types)
    ArrayList<ArrayList<Boolean> > arrayLists =  new ArrayList< >(); 
    
   //Seperate Arraylists of all security options, containing their selected states as booleans
   ArrayList<Boolean> Preliminary = new ArrayList<>();
   ArrayList<Boolean> Secpol = new ArrayList<>();
   ArrayList<Boolean> Services = new ArrayList<>();

   //Names of the Files that will be printed. Written In same order as the arrayLists arrayList.
   String[] settingNames = {"Preliminary", "SecPol", "Services"};

   
//Beginning of script
   @Override
   //Gui Code:
    public void start(Stage primaryStage) throws Exception {
      Scene mainScreen;//Setting scenes
      primaryStage.setTitle("Vector Shield 2.0");//window title
      window = primaryStage;//Setting window to first Stage
      window.setOnCloseRequest(e -> {//Actions to be taken when exiting window
      e.consume();//Stopping main process
      exitProgram(); //Exiting program method( utilizes alert box)
      });
                                    
         
       //Initiating Preliminary options as checkboxes. They will be organized per security type for ease of use, constituting Cyberpatriot focused 
       //orginzation as desc. in Crit. A
       //Check boxes can be selected/unselected the same way a button is.
      CheckBox Prelimroot = new CheckBox("Preliminary");//Preliminary options selection checkbox
        CheckBox Networking = new CheckBox("Networking");//Networking catagory selection checkbox
          //Security options checkboxes
            CheckBox P0 = new CheckBox("Enable 'Allow Local System to use computer identity for NTLM'");
            CheckBox P1 = new CheckBox("Disable 'Allow LocalSystem NULL session fallback'");
            CheckBox P2 = new CheckBox("Disable 'Allow PKU2U authentication requests to this computer to use online identities'");
            CheckBox P3 = new CheckBox("Set 'Configure encryption types allowed for Kerberos' to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'");
            CheckBox P4 = new CheckBox("Enable 'Do not store LAN Manager hash value on next password change'");
            CheckBox P5 = new CheckBox("'LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'");
            CheckBox P6 = new CheckBox("'LDAP client signing requirements' is set to 'Negotiate signing'");
            CheckBox P7 = new CheckBox("Require NTLMv2 session security & Require 128-bit encryption for NTLM SSP based servers & clients.");
            CheckBox P8 = new CheckBox("Disable Telnet protocol");
            CheckBox P9 = new CheckBox("Disable Trivial File Transfer Protocol");
            CheckBox P10 = new CheckBox("Disable Fax & Scan services & protocols");
            CheckBox P11 = new CheckBox("Disable IPv6 networking protocol");
            CheckBox P12 = new CheckBox("Enable Windows Smartscreen");
            CheckBox[] NetworkingBoxes = {P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12};//Array holding Preliminary options under Networking catagory
        CheckBox Lusrmgr = new CheckBox("Local user manager/group policy");//Local user manager selection checkbox
            CheckBox LusrmgrAccount = new CheckBox("Account Disabling");
                CheckBox P13 = new CheckBox("Disable Defualt Admin Account");
                CheckBox P14 = new CheckBox("Disable Guest Account");
                CheckBox[] LusrmgrAccountBoxes = {P13, P14};
            CheckBox LusrmgrAccess = new CheckBox("Computer Access");
                CheckBox P15 = new CheckBox("For 'Access Credential Manager as a trusted caller' allow 'No One'");
                CheckBox P16 = new CheckBox("For 'Access this computer from the network' allow 'Administrators, Remote Desktop Users'");
                CheckBox P17 = new CheckBox("For 'Act as part of the operating system' allow 'No One'");
                CheckBox[] LusrmgrAccessBoxes = {P15, P16, P17};
            CheckBox LusrmgrAction = new CheckBox("General Action Restrictions");
                CheckBox P18 = new CheckBox("For 'Adjust memory quotas for a process' allow 'Administrators, LOCAL SERVICE, NETWORK SERVICE'");
                CheckBox P21 = new CheckBox("Restrict Object Creation(Pagfiles, Global, Token, Shared)");
                CheckBox P22 = new CheckBox("Configure 'Create symbolic links'");
                CheckBox P23 = new CheckBox("For 'Debug programs' allow 'Administrators'");
                CheckBox P27 = new CheckBox("For 'Enable computer and user accounts to be trusted for delegation' allow 'No One");
                CheckBox P28 = new CheckBox("For 'Force shutdown from a remote system' allow 'Administrators'");
                CheckBox P29 = new CheckBox("For 'Generate security audits' allow 'LOCAL SERVICE, NETWORK SERVICE'");
                CheckBox P30 = new CheckBox("For 'Impersonate a client after authentication' allow 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'"); 
                CheckBox[] LusrmgrActionBoxes = {P18, P21, P22, P23, P27, P28, P29, P30};
            CheckBox LusrmgrLogon = new CheckBox("Logon Privileges");
                CheckBox P24 = new CheckBox("Deny Logon to guests completely");
                CheckBox P25 = new CheckBox("For 'Log on as a batch job' allow 'Administrators");
                CheckBox P26 = new CheckBox("For 'Log on as a service' allow 'No One'");
                CheckBox[] LusrmgrLogonBoxes = {P24, P25, P26};
            CheckBox LusrmgrMaintenance = new CheckBox("Maintenance Privileges");
                CheckBox P31 = new CheckBox("For 'Increase scheduling priority' allow 'Administrators, Window Manager|Window Manager Group'");
                CheckBox P32 = new CheckBox("For 'Load and unload device drivers' allow 'Administrators'");
                CheckBox P33 = new CheckBox("For 'Lock pages in memory' allow 'No One'");
                CheckBox P34 = new CheckBox("For 'Modify an object label' allow 'No One'");
                CheckBox P35 = new CheckBox("For 'Modify firmware environment values' allow 'Administrators'");
                CheckBox P36 = new CheckBox("For 'Perform volume maintenance tasks' allow 'Administrators'");
                CheckBox P37 = new CheckBox("Restrict Profile single process & system performance");
                CheckBox P38 = new CheckBox("For 'Replace a process level token' allow 'LOCAL SERVICE, NETWORK SERVICE'");
                CheckBox[] LusrmgrMaintenanceBoxes = {P31, P32, P33, P34, P35, P36, P37, P38};
            CheckBox LusrmgrBasic = new CheckBox("Basic Privileges");   
                CheckBox P19 = new CheckBox("For 'Back up files and directories' allow 'Administrators'");
                CheckBox P20  = new CheckBox("For 'Change the time zone' allow 'Administrators, LOCAL SERVICE, Users'"); 
                CheckBox P39 = new CheckBox("For 'Restore files and directories' allow 'Administrators'");
                CheckBox P40 = new CheckBox("For 'Shut down the system' allow 'Administrators, Users'");
                CheckBox P41 = new CheckBox("For 'Take ownership of files or other objects' allow 'Administrators'");
                CheckBox[] LusrmgrBasicBoxes = {P19, P20, P39, P40, P41};
                //Array holding preliminary options under Lusrmgr catagory
                CheckBox[] LusrmgrBoxes = {LusrmgrAccount, LusrmgrAccess, LusrmgrAction, LusrmgrLogon, LusrmgrMaintenance, LusrmgrBasic, P13, P14, P15, P16, P17, P18, P19, P20, P21, P22, P23, P24, P25, P26, P27, P28, P29, P30, P31, P32, P33, P34, P35, P36, P37, P38, P39, P40, P41};
        CheckBox Cypat = new CheckBox("Basic Cyberpatriot actions");//Cypat selection checkbox
            CheckBox P42 = new CheckBox("Change user passwords to Password.json");
            CheckBox P43 = new CheckBox("Delete all .mp3 files");
            CheckBox P44 = new CheckBox("Rename Admin account to name 'VS1'");
            CheckBox P45 = new CheckBox("Rename guest account to name 'VS2'");
            CheckBox[] CypatBoxes = {P42, P43, P44, P45};
        //holds all checkboxes for Peliminary options
        CheckBox PreliminaryBoxes [] = {P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P21, P22, P23, P24, P25, P26, P27, P28, P29, P30, P31, P32, P33, P34, P35, P36, P37, P38, P39, P40, P41, P42, P43, P44, P45};
        CheckBox[] PreliminaryCatagoryBoxes = {Prelimroot, Networking, Lusrmgr, LusrmgrAccount, LusrmgrAccess, LusrmgrAction, LusrmgrLogon, LusrmgrMaintenance, LusrmgrBasic, Cypat};//Array holding all main catagory checkboxes for the catagory
      //Setting checkboxes as nested TreeItems for best orginized presentation
    TreeItem<CheckBox> PreliminaryRoot = new TreeItem<>(Prelimroot);//Main Tree
    PreliminaryRoot.setExpanded(true);//Setting to expanded for visibility
    
      TreeItem<CheckBox> PreliminaryNetworking = new TreeItem<>(Networking);//Networking catagory sub-Tree
          PreliminaryRoot.getChildren().add(PreliminaryNetworking);//Adding networking sub-Tree to main
          PreliminaryNetworking.setExpanded(true);
          CheckBoxAdd(NetworkingBoxes, PreliminaryNetworking);//Adding NetworkingBoxes array checkboxes to PreliminaryNetworking tree
      TreeItem<CheckBox> PreliminaryLusrmgr = new TreeItem<>(Lusrmgr); //Lusrmgr catagory sub-Tree
          PreliminaryRoot.getChildren().add(PreliminaryLusrmgr);//Adding Lusrmgr sub-Tree to main
          PreliminaryLusrmgr.setExpanded(true);
            TreeItem<CheckBox> LocalusrmgrAccount = new TreeItem<>(LusrmgrAccount);//Lusrmgr accounts sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrAccount);//Adding to Lusrmgr sub-Tree
                LocalusrmgrAccount.setExpanded(true);
                CheckBoxAdd(LusrmgrAccountBoxes, LocalusrmgrAccount);//Adding checkboxes to sub-sub Tree
            TreeItem<CheckBox> LocalusrmgrAccess = new TreeItem<>(LusrmgrAccess);//Lusrmgr access sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrAccess);
                LocalusrmgrAccess.setExpanded(true);
                CheckBoxAdd(LusrmgrAccessBoxes, LocalusrmgrAccess);
            TreeItem<CheckBox> LocalusrmgrAction = new TreeItem<>(LusrmgrAction);//Lusrmgr action sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrAction);
                LocalusrmgrAction.setExpanded(true);
                CheckBoxAdd(LusrmgrActionBoxes, LocalusrmgrAction);
            TreeItem<CheckBox> LocalusrmgrLogon = new TreeItem<>(LusrmgrLogon);//Lusrmgr logon sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrLogon);
                LocalusrmgrLogon.setExpanded(true);
                CheckBoxAdd(LusrmgrLogonBoxes, LocalusrmgrLogon);
            TreeItem<CheckBox> LocalusrmgrMaintenance = new TreeItem<>(LusrmgrMaintenance);//Lusrmgr maintenance sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrMaintenance);
                LocalusrmgrMaintenance.setExpanded(true);
                CheckBoxAdd(LusrmgrMaintenanceBoxes, LocalusrmgrMaintenance);
            TreeItem<CheckBox> LocalusrmgrBasic = new TreeItem<>(LusrmgrBasic);//Lusrmgr basic sub-sub-Tree
                PreliminaryLusrmgr.getChildren().add(LocalusrmgrBasic);
                LocalusrmgrBasic.setExpanded(true);
                CheckBoxAdd(LusrmgrBasicBoxes, LocalusrmgrBasic);
      TreeItem<CheckBox> PreliminaryCypat = new TreeItem<>(Cypat);//Cypat sub-Tree
          PreliminaryRoot.getChildren().add(PreliminaryCypat);//Adding to Preliminary main Tree
          PreliminaryCypat.setExpanded(true);
          CheckBoxAdd(CypatBoxes, PreliminaryCypat);//Adding checkboxes to sub Tree
          
       //Setting checkbox actions for each catagory, so all under it are selected if main checkbox is selected
       //All of Preliminary options
        Prelimroot.setOnAction(e -> {
           //Looping through array all checkboxes to seleected/unselected if Prelimroot selected/unselected
                 for (int x = 0; x<PreliminaryBoxes.length; x++) {
            PreliminaryBoxes[x].setSelected(Prelimroot.isSelected()); 
              }
           //Looping through catagory array and setting all catagory checkboxes to seleected/unselected if Prelimroot selected/unselected
                 for(int i = 0; i<PreliminaryCatagoryBoxes.length; i++) {
            PreliminaryCatagoryBoxes[i].setSelected(Prelimroot.isSelected());  
                 }
       });   

            //Networking catagory
            Networking.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to Networking checkbox selection state
                      for (int x = 0; x<NetworkingBoxes.length; x++) {
                 NetworkingBoxes[x].setSelected(Networking.isSelected()); 
                   }
            });
            
            //Lusrmgr catagory
                   Lusrmgr.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to Lusrmgr checkbox selection state
                      for (int x = 0; x<LusrmgrBoxes.length; x++) {
                 LusrmgrBoxes[x].setSelected(Lusrmgr.isSelected()); 
                   }
            });
                  //Lusrmgr account catagory
                        LusrmgrAccount.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrAccount checkbox selection state
                           for (int x = 0; x<LusrmgrAccountBoxes.length; x++) {
                      LusrmgrAccountBoxes[x].setSelected(LusrmgrAccount.isSelected()); 
                        }
                 });
                  //Lusrmgr access catagory
                        LusrmgrAccess.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrAccess checkbox selection state
                           for (int x = 0; x<LusrmgrAccessBoxes.length; x++) {
                      LusrmgrAccessBoxes[x].setSelected(LusrmgrAccess.isSelected()); 
                        }
                 });
                  //Lusrmgr action catagory
                        LusrmgrAction.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrAction checkbox selection state
                           for (int x = 0; x<LusrmgrActionBoxes.length; x++) {
                      LusrmgrActionBoxes[x].setSelected(LusrmgrAction.isSelected()); 
                        }
                 });
                  //Lusrmgr logon catagory
                        LusrmgrLogon.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrLogon checkbox selection state
                           for (int x = 0; x<LusrmgrLogonBoxes.length; x++) {
                      LusrmgrLogonBoxes[x].setSelected(LusrmgrLogon.isSelected()); 
                        }
                 });
                  //Lusrmgr maintenance catagory
                        LusrmgrMaintenance.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrMaintenance checkbox selection state
                           for (int x = 0; x<LusrmgrMaintenanceBoxes.length; x++) {
                      LusrmgrMaintenanceBoxes[x].setSelected(LusrmgrMaintenance.isSelected()); 
                        }
                 });
                  //Lusrmgr basic catagory
                        LusrmgrBasic.setOnAction(e -> {
                     //Looping through Array, turn each Checkbox to LusrmgrBasic checkbox selection state
                           for (int x = 0; x<LusrmgrBasicBoxes.length; x++) {
                      LusrmgrBasicBoxes[x].setSelected(LusrmgrBasic.isSelected()); 
                        }
                 });
                        
            //Cypat catagory
                   Cypat.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to Cypat checkbox selection state
                      for (int x = 0; x<CypatBoxes.length; x++) {
                 CypatBoxes[x].setSelected(Cypat.isSelected()); 
                   }
            });
         
            //Local Security Policy Checkboxes, same process as before, albeit without ArrayList
        CheckBox SecpolRoot = new CheckBox("Local Security Policy");
          CheckBox SecpolSecurity = new CheckBox("General Security");
            CheckBox S0 = new CheckBox("Set Windows Firewall As Enabled");
            CheckBox S1 = new CheckBox("Enable full Auditing for success and failures");
            CheckBox S2 = new CheckBox("Block Microsoft accounts from signing in");
            CheckBox S3 = new CheckBox("Additional restrictions for anonymous connections 'Do not allow enumeration of SAM accounts and shares'");
            CheckBox S4 = new CheckBox("Enable 'Digitally sign server communication (when possible)'");
            CheckBox S5 = new CheckBox("Enable 'Do not display last username in logon screen'");
            CheckBox S7 = new CheckBox("'Number of previous logons to cache' set to '0 logons'");
            CheckBox[] SecpolSecurityBoxes = {S0, S1, S2, S3, S4, S5, S7};
          CheckBox SecpolMedia = new CheckBox("Media Restrictions");
            CheckBox S8 = new CheckBox("Enable 'Restrict CD-ROM/floppy access to locally logged on user'");
            CheckBox S9 = new CheckBox("set 'Smart card removal behavior' as 'Lock Workstation'");
            CheckBox S10 = new CheckBox("set 'Unsigned driver/non-driver installation behavior' as 'Warn'");
            CheckBox[] SecpolMediaBoxes = {S8, S9, S10};
          CheckBox SecpolClient = new CheckBox("Client & User Security");
            CheckBox S6 = new CheckBox("'LAN Manager authentication level' Send LM & NTLM - use NTLMv2 if negotiated");
            CheckBox S11 = new CheckBox("Enable 'Clear virtual memory pagefile'");
            CheckBox S12 = new CheckBox("Enable 'RDP network level authentication Enabled'");
            CheckBox S13 = new CheckBox("Enable 'Limit local use of blank passwords to local console only'");
            CheckBox S14 = new CheckBox("Enable 'Updates for other microsoft products'");
            CheckBox S15 = new CheckBox("Disable Remote Services");
            CheckBox S20 = new CheckBox("Network security: Enable 'Do not store LAN Manager hash value on next password change'");
            CheckBox S21 = new CheckBox("Microsoft network client: Disable 'Send unencrypted password to third-party SMB servers'");
            CheckBox[] SecpolClientBoxes = {S11, S12, S13, S14, S21};
          CheckBox SecpolUser = new CheckBox("User restrictions");
            CheckBox S16 = new CheckBox("Admin Services: Enforce Control-Alt-Delete");
            CheckBox S17 = new CheckBox("Enable 'Restrict anonymous access to Named Pipes and Shares'");
            CheckBox S18 = new CheckBox("User Account Control: Enforce secure desktop");
            CheckBox S19 = new CheckBox("Recovery console: Disable 'Allow automatic administrative logon'");
            CheckBox S22 = new CheckBox("Devices: Enable 'Prevent users from installing printer drivers'");
            CheckBox[] SecpolUserBoxes = {S16, S17, S18, S19, S22};
               CheckBox[] SecpolBoxes = {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22};
               CheckBox[] SecpolCatagoryBoxes = {SecpolRoot, SecpolSecurity, SecpolMedia, SecpolClient, SecpolUser};
      TreeItem<CheckBox> LocalSecPolRoot = new TreeItem<>(SecpolRoot);
      LocalSecPolRoot.setExpanded(true);
       TreeItem<CheckBox> LocalSecPolSecurity = new TreeItem<>(SecpolSecurity);
         LocalSecPolRoot.getChildren().add(LocalSecPolSecurity);
         LocalSecPolSecurity.setExpanded(true);
         CheckBoxAdd(SecpolSecurityBoxes, LocalSecPolSecurity);
       TreeItem<CheckBox> LocalSecPolMedia = new TreeItem<>(SecpolMedia);
         LocalSecPolRoot.getChildren().add(LocalSecPolMedia);
         LocalSecPolMedia.setExpanded(true);
         CheckBoxAdd(SecpolMediaBoxes, LocalSecPolMedia);
       TreeItem<CheckBox> LocalSecPolClient = new TreeItem<>(SecpolClient);
         LocalSecPolRoot.getChildren().add(LocalSecPolClient);
         LocalSecPolClient.setExpanded(true);
         CheckBoxAdd(SecpolClientBoxes, LocalSecPolClient);    
       TreeItem<CheckBox> LocalSecPolUser = new TreeItem<>(SecpolUser);
         LocalSecPolRoot.getChildren().add(LocalSecPolUser);
         LocalSecPolUser.setExpanded(true);
         CheckBoxAdd(SecpolUserBoxes, LocalSecPolUser);
         
       //Setting checkbox actions for each catagory, so all under it are selected if main checkbox is selected
       //All of Local Security Policy options
       SecpolRoot.setOnAction(e -> {
           //Looping through array all checkboxes to seleected/unselected if SecpolRoot selected/unselected
                 for (int x = 0; x<SecpolBoxes.length; x++) {
            SecpolBoxes[x].setSelected(SecpolRoot.isSelected()); 
              }
           //Looping through catagory array and setting all catagory checkboxes to seleected/unselected if SecpolRoot selected/unselected
                 for(int i = 0; i<SecpolCatagoryBoxes.length; i++) {
            SecpolCatagoryBoxes[i].setSelected(SecpolRoot.isSelected());  
                 }
       });
       
          //Security catagory
            SecpolSecurity.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to SecpolSecurity checkbox selection state
                      for (int x = 0; x<SecpolSecurityBoxes.length; x++) {
                 SecpolSecurityBoxes[x].setSelected(SecpolSecurity.isSelected()); 
                   }
            });
          //Media catagory
            SecpolMedia.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to SecpolMedia checkbox selection state
                      for (int x = 0; x<SecpolMediaBoxes.length; x++) {
                 SecpolMediaBoxes[x].setSelected(SecpolMedia.isSelected()); 
                   }
            });
          //Clientside catagory
            SecpolClient.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to SecpolClient checkbox selection state
                      for (int x = 0; x<SecpolClientBoxes.length; x++) {
                 SecpolClientBoxes[x].setSelected(SecpolClient.isSelected()); 
                   }
            });
          //User catagory
            SecpolUser.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to SecpolUser checkbox selection state
                      for (int x = 0; x<SecpolUserBoxes.length; x++) {
                 SecpolUserBoxes[x].setSelected(SecpolUser.isSelected()); 
                   }
            });
       
       
                //Service Checkboxes, same process as before
        CheckBox ServiceRoot = new CheckBox("Services");
          CheckBox ServiceNetwork = new CheckBox("Networking services");
             CheckBox ServiceShare = new CheckBox("Network discovery services");
               CheckBox R0 = new CheckBox("Disable Bluetooth services");
               CheckBox R1 = new CheckBox("Disable 'Downloaded Maps Manager (MapsBroker)'");
               CheckBox R2 = new CheckBox("Disable 'Geolocation Service (lfsvc)'");
               CheckBox R3 = new CheckBox("Disable 'IIS Admin Service (IISADMIN)'");
               CheckBox R4 = new CheckBox("Disable 'Infrared monitor service (irmon)'");
               CheckBox R5 = new CheckBox("Disable 'Internet Connection Sharing (ICS) (SharedAccess)'");
               CheckBox R6 = new CheckBox("Disable 'Link-Layer Topology Discovery Mapper (lltdsvc)'");
               CheckBox R21 = new CheckBox("Disable 'SNMP Service (SNMP)'");
               CheckBox R22 = new CheckBox("Disable 'SSDP Discovery (SSDPSRV)'");
               CheckBox[] ServiceShareBoxes = {R0, R1, R2, R3, R4, R5, R6, R21, R22};
             CheckBox ServiceAccess = new CheckBox("Remote Access services");
               CheckBox R14 = new CheckBox("Disable 'Remote Access Auto Connection Manager (RasAuto)'");
               CheckBox R15 = new CheckBox("Disable all Remote Desktop services");
               CheckBox R16 = new CheckBox("Disable 'Remote Procedure Call (RPC) Locator (RpcLocator)'");
               CheckBox R17 = new CheckBox("Disable 'Remote Registry (RemoteRegistry)'");
               CheckBox R18 = new CheckBox("Disable 'Routing and Remote Access (RemoteAccess)'");
               CheckBox[] ServiceAccessBoxes = {R14, R15, R16, R17, R18};
             CheckBox ServiceNetpro = new CheckBox("Networking protocols & server sevices");
               CheckBox R8 = new CheckBox("Disable 'Microsoft FTP Service (FTPSVC)'");
               CheckBox R9 = new CheckBox("Disable 'Microsoft iSCSI Initiator Service (MSiSCSI)'");
               CheckBox R11 = new CheckBox("Disable 'OpenSSH SSH Server (sshd)'");
               CheckBox R12 = new CheckBox("Disable peer networking services");
               CheckBox R19 = new CheckBox("Disable 'Server (LanmanServer)'");
               CheckBox R20 = new CheckBox("Disable 'Simple TCP/IP Services (simptcp)'");
               CheckBox R24 = new CheckBox("Disable 'Web Management Service (WMSvc)'");
               CheckBox R35 = new CheckBox("Disable 'Net.Tcp Port Sharing Service(NetTcpPortSharing)'");
               CheckBox R36 = new CheckBox("Disable 'WebClient' service");
               CheckBox[] ServiceNetproBoxes = {R8, R9, R11, R12, R19, R20, R24, R35, R36};
            CheckBox[] ServiceNetworkBoxes = {ServiceShare, ServiceAccess, ServiceNetpro, R0, R1, R2, R3, R4, R5, R6, R21, R22, R14, R15, R16, R17, R18, R8, R9, R11, R12, R19, R20, R24, R35, R36};
          CheckBox ServiceWindows = new CheckBox("Windows services");
            CheckBox R25 = new CheckBox("Disable 'Windows Error Reporting Service (WerSvc)'");
            CheckBox R26 = new CheckBox("Disable 'Windows Event Collector (Wecsvc)'");
            CheckBox R27 = new CheckBox("Disable 'Windows Media Player Network Sharing Service (WMPNetworkSvc)'");
            CheckBox R28 = new CheckBox("Disable 'Windows Mobile Hotspot Service (icssvc)'");
            CheckBox R29 = new CheckBox("Disable 'Windows Push Notifications System Service (WpnService)'");
            CheckBox R30 = new CheckBox("Disable 'Windows PushToInstall Service (PushToInstall)'");
            CheckBox R31 = new CheckBox("Disable 'Windows Remote Management (WS-Management) (WinRM)'");
            CheckBox R33 = new CheckBox("Ensure Windows Updates are enabled as automatic on startup");
            CheckBox[] ServiceWindowsBoxes = {R25, R26, R27, R28, R29, R30, R31, R33};
          CheckBox ServiceGeneric = new CheckBox("Miscellaneous services");
            CheckBox R7 = new CheckBox("Disable 'LxssManager (LxssManager)'");
            CheckBox R10 = new CheckBox("Disable 'Microsoft Store Install Service (InstallService)'");
            CheckBox R13 = new CheckBox("Disable 'Problem Reports and Solutions Control Panel Support (wercplsupport)'");
            CheckBox R23 = new CheckBox("Disable 'UPnP Device Host (upnphost)'");
            CheckBox R32 = new CheckBox("Disable Xbox services");
            CheckBox R34 = new CheckBox("Disable 'Printer Spooler'");
            CheckBox[] ServiceGenericBoxes = {R7, R10, R13, R23, R32, R34};
               CheckBox[] ServiceBoxes = {R0, R1, R2, R3, R4, R5, R6, R21, R22, R14, R15, R16, R17, R18, R8, R9, R11, R12, R19, R20, R24, R25, R26, R27, R28, R29, R30, R31, R33, R7, R10, R13, R23, R32, R34, R35, R36};
               CheckBox[] ServiceCatagoryBoxes = {ServiceRoot, ServiceNetwork, ServiceShare, ServiceAccess, ServiceNetpro, ServiceWindows, ServiceGeneric};
               
      TreeItem<CheckBox> ServicesRoot = new TreeItem<>(ServiceRoot);
      ServicesRoot.setExpanded(true);
         TreeItem<CheckBox> ServicesNetwork = new TreeItem<>(ServiceNetwork);
         ServicesRoot.getChildren().add(ServicesNetwork);
         ServicesNetwork.setExpanded(true);
            TreeItem<CheckBox> ServicesShare = new TreeItem<>(ServiceShare);
            ServicesNetwork.getChildren().add(ServicesShare);
            ServicesShare.setExpanded(true);
            CheckBoxAdd(ServiceShareBoxes, ServicesShare);
          TreeItem<CheckBox> ServicesAccess = new TreeItem<>(ServiceAccess);
            ServicesNetwork.getChildren().add(ServicesAccess);
            ServicesAccess.setExpanded(true);
            CheckBoxAdd(ServiceAccessBoxes, ServicesAccess); 
          TreeItem<CheckBox> ServicesNetpro = new TreeItem<>(ServiceNetpro);
            ServicesNetwork.getChildren().add(ServicesNetpro);
            ServicesNetpro.setExpanded(true);
            CheckBoxAdd(ServiceNetproBoxes, ServicesNetpro);
      TreeItem<CheckBox> ServicesWindows = new TreeItem<>(ServiceWindows);
        ServicesRoot.getChildren().add(ServicesWindows);
        ServicesWindows.setExpanded(true);
        CheckBoxAdd(ServiceWindowsBoxes, ServicesWindows);
      TreeItem<CheckBox> ServicesGeneric = new TreeItem<>(ServiceGeneric);
        ServicesRoot.getChildren().add(ServicesGeneric);
        ServicesGeneric.setExpanded(true);
        CheckBoxAdd(ServiceGenericBoxes, ServicesGeneric);
        
       //Setting checkbox actions for each catagory, so all under it are selected if main checkbox is selected
       //All of Services options
       ServiceRoot.setOnAction(e -> {
           //Looping through array all checkboxes to seleected/unselected if ServiceRoot selected/unselected
                 for (int x = 0; x<ServiceBoxes.length; x++) {
            ServiceBoxes[x].setSelected(ServiceRoot.isSelected()); 
              }
           //Looping through catagory array and setting all catagory checkboxes to seleected/unselected if ServiceRoot selected/unselected
                 for(int i = 0; i<ServiceCatagoryBoxes.length; i++) {
            ServiceCatagoryBoxes[i].setSelected(ServiceRoot.isSelected());  
                 }
       });
       
       
          //networking Services catagory
            ServiceNetwork.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceNetwork checkbox selection state
                      for (int x = 0; x<ServiceNetworkBoxes.length; x++) {
                 ServiceNetworkBoxes[x].setSelected(ServiceNetwork.isSelected()); 
                   }
            }); 
          //Sharing Services catagory
            ServiceShare.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceShare checkbox selection state
                      for (int x = 0; x<ServiceShareBoxes.length; x++) {
                 ServiceShareBoxes[x].setSelected(ServiceShare.isSelected()); 
                   }
            }); 
          //Access Services catagory
            ServiceAccess.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceAccess checkbox selection state
                      for (int x = 0; x<ServiceAccessBoxes.length; x++) {
                 ServiceAccessBoxes[x].setSelected(ServiceAccess.isSelected()); 
                   }
            });                    
          //protocol Services catagory
            ServiceNetpro.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceNetpro checkbox selection state
                      for (int x = 0; x<ServiceNetproBoxes.length; x++) {
                 ServiceNetproBoxes[x].setSelected(ServiceNetpro.isSelected()); 
                   }
            });   
          //windows Services catagory
            ServiceWindows.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceWindows checkbox selection state
                      for (int x = 0; x<ServiceWindowsBoxes.length; x++) {
                 ServiceWindowsBoxes[x].setSelected(ServiceWindows.isSelected()); 
                   }
            }); 
          //generic Services catagory
            ServiceGeneric.setOnAction(e -> {
                //Looping through Array, turn each Checkbox to ServiceGeneric checkbox selection state
                      for (int x = 0; x<ServiceGenericBoxes.length; x++) {
                 ServiceGenericBoxes[x].setSelected(ServiceGeneric.isSelected()); 
                   }
            });   
      
      //Setting main visibible TreeView of each TreeItem containing their respective Secuirty options
      TreeView<CheckBox> PreliminaryOptions = new TreeView<>(PreliminaryRoot); //Preliminary
      TreeView<CheckBox> LocalSecPolOptions = new TreeView<>(LocalSecPolRoot); //Secpol
      TreeView<CheckBox> ServicesOptions = new TreeView<>(ServicesRoot);       //Services
      
      
      
                                            //GUI Compononets
      // homeScreen GUI components
            //Images
            
            ImageView vectorShieldLogo = new ImageView(new Image(getClass().getResourceAsStream("/VectorShield.png")));//ImageView of main logo graphic
            //vectorShieldLogo.setLayoutX(0);//setting Xpos of image
            //vectorShieldLogo.setLayoutY(0);//setting Ypos of image
            vectorShieldLogo.setFitHeight(600); //setting Height of image in GUI
            vectorShieldLogo.setFitWidth(750); //setting Width of image in GUI
            vectorShieldLogo.setPreserveRatio(true);//Preserving Ratio
            
            ImageView selectAllGraphic = new ImageView(new Image(getClass().getResourceAsStream("/selectAllIcon.png")));//Graphic of SelectAll button
            selectAllGraphic.setFitHeight(150); //setting Height of image
            selectAllGraphic.setFitWidth(150); //setting Width of image
            selectAllGraphic.setPreserveRatio(true);//Preserving Ratio
            
            //Buttons
            Button hardenSyst = new Button("Secure my system");//Main button to intiiate back-end script. Basically, secures user's system
            
            ToggleButton selectAll = new ToggleButton();//Button to select all scurity options
                selectAll.setGraphic(selectAllGraphic);//Setting graphic to ImageView
                selectAll.getStyleClass().add("buttonSpecial");//Selected Styling through CSS
                
      //Menu screen components
            //Preliminary Menu Options
                    //Buttons
                    ToggleButton PrelimOption = new ToggleButton("Preliminary");
                    PrelimOption.setUserData("preliminary");//Setting userData(for future computation of selections)
                    //Source 3&4&8 Utilized in CSS code of StyleClass 'buttonMenu' for structure
                    PrelimOption.getStyleClass().add("buttonMenu");//Setting Button Style & Shape
                    PrelimOption.setPickOnBounds(false);//Setting bounds for selection computation to shape of button
                    //Source 5 helped demonstrate the neccesity of this, applies to all setAlighnments
                    PrelimOption.setAlignment(Pos.BASELINE_LEFT);//Setting Text to left 
                    PrelimOption.setMinWidth(220);//Minimum button width
                    //Labels
                    Label PrelimDesc = new Label ("Preliminary Options");//Main Label
                    PrelimDesc.setMaxWidth(360);//Setting Label Width
                    PrelimDesc.setMinHeight(2-0);//Setting Label Height
                    PrelimDesc.setWrapText(true);//Wrap text for overlap
                    PrelimDesc.getStyleClass().add("labels");//Setting look from CSS styling sheet 'labels'
            //Secpol Menu Options
                    //Buttons
                    ToggleButton SecpolOption = new ToggleButton("Secpol");
                    SecpolOption.setUserData("secpol");//Setting userData
                    SecpolOption.getStyleClass().add("buttonMenu");//Setting Button Style & Shape
                    SecpolOption.setPickOnBounds(false);//Setting bounds for selection computation to shape of button
                    SecpolOption.setAlignment(Pos.BASELINE_LEFT);//Setting Text to left 
                    SecpolOption.setMinWidth(220);//Minimum button width
                    //Labels
                    Label SecpolDesc = new Label ("Local Sec. Pol Options");//Main Label
                    SecpolDesc.setMaxWidth(360);//Setting Label Width
                    SecpolDesc.setMinHeight(2-0);//Setting Label Height
                    SecpolDesc.setWrapText(true);//Wrap text for overlap
                    SecpolDesc.getStyleClass().add("labels");//Setting look from CSS styling sheet 'labels'
            //Services Menu Options
                    //Buttons
                    ToggleButton ServicesOption = new ToggleButton("Services");
                    ServicesOption.setUserData("services");//Setting userData
                    ServicesOption.getStyleClass().add("buttonMenu");//Setting Button Style & Shape
                    ServicesOption.setPickOnBounds(false);//Setting bounds for selection computation to shape of button
                    ServicesOption.setAlignment(Pos.BASELINE_LEFT);//Setting Text to left 
                    ServicesOption.setMinWidth(220);//Minimum button width
                    //Labels
                    Label ServicesDesc = new Label ("Services");//Main Label
                    ServicesDesc.setMaxWidth(360);//Setting Label Width
                    ServicesDesc.setMinHeight(2-0);//Setting Label Height
                    ServicesDesc.setWrapText(true);//Wrap text for overlap
                    ServicesDesc.getStyleClass().add("labels");//Setting look from CSS styling sheet 'labels'
            //Homepage Menu Options
                    //Buttons
                    ToggleButton HomeOption = new ToggleButton("Home");
                    HomeOption.setUserData("home");//Setting userData
                    HomeOption.getStyleClass().add("buttonMenu");
                    HomeOption.setPickOnBounds(false);//Setting bounds for selection computation to shape of button
                    HomeOption.setAlignment(Pos.BASELINE_LEFT);//Setting Text to left 
                    HomeOption.setMinWidth(220);//Minimum button width                          
                //Creating ToggleGroup of menuButtons(Allowing only one to be selected at once)
                final ToggleGroup menuButtons = new ToggleGroup();//Setting ToggleGroup
                        PrelimOption.setToggleGroup(menuButtons);//Adding PrelimOption ToggleButton to group
                        SecpolOption.setToggleGroup(menuButtons);//Adding SecpolOption ToggleButton to group
                        ServicesOption.setToggleGroup(menuButtons);//Adding ServicesOption ToggleButton to group
                        HomeOption.setToggleGroup(menuButtons);//Adding HomeOption to group
                            HomeOption.setSelected(true);//Making HomeOption selected(As the user starts on the home page)            
                                   
      //Progress Screen components
            //Labels
            Label LoadingLabel = new Label("Securing...");//Label above loading animation
                  LoadingLabel.getStyleClass().add("labels");//Style
            Label DashboardLabel = new Label("Actions Complete:");//Label above dashboard
                  DashboardLabel.getStyleClass().add("labels");//Style
            //Images
            ImageView loadingCircle = new ImageView(new Image(getClass().getResourceAsStream("/loading.png")));//Loading circle ImageView to be animated
                  loadingCircle.setFitHeight(200);//height
                  loadingCircle.setFitWidth(200);//width
                  loadingCircle.setPreserveRatio(true);//Preserving aspect ratio              
            //Dashboard                
            ListView ProgressDashboard = new ListView<>();//Main progress dashbaord as ListView. Will display strings exported from backend script to show progress. 
             
                                //GUI Layouts
      //MainGUI Layout
      //StackPane understanding and usage from Source 7
      StackPane MainLayout = new StackPane();//Overall layout of GUI as a StackPane
        
        //Active Layer
        BorderPane ActiveLayer = new BorderPane();//First layer in stack. Holds all interactables.
           VBox ActiveLayerLeft = new VBox(80);//Left of ActiveLayer. Will hold Menu Buttons
           ActiveLayerLeft.setAlignment(Pos.CENTER_LEFT);//Starting Allighnment of ActiveLayerLeft components
           ActiveLayerLeft.setPadding(new Insets(20));//Insets from edge for components
           
           //Layouts To switch between in ActiveLayerCenter
                //Home layout
                VBox homeLayout = new VBox(100);//Setting homeLayout as a VBox
                homeLayout.setAlignment(Pos.CENTER);//Allighnmet
                homeLayout.setPadding(new Insets(80, 200, 20, 20));//Insets from edge for components

                //Preliminary layout
                VBox prelimLayout = new VBox();//Setting PrelimLayout as a VBox
                prelimLayout.setAlignment(Pos.CENTER);//Allighnmet
                prelimLayout.setPadding(new Insets(120, 120, 20, 20));//Insets from edge for components

                //Secpol layout
                VBox secpolLayout = new VBox();//Setting PrelimLayout as a VBox
                secpolLayout.setAlignment(Pos.CENTER);//Allighnmet
                secpolLayout.setPadding(new Insets(120, 120, 20, 20));//Insets from edge for components

                //Services layout
                VBox servicesLayout = new VBox();//Setting PrelimLayout as a VBox
                servicesLayout.setAlignment(Pos.CENTER);//Allighnmet
                servicesLayout.setPadding(new Insets(120, 120, 20, 20));//Insets from edge for components

                        //Progress layout
                            BorderPane progressLayout = new BorderPane();//Main progresslayout as BorderPane
                                VBox progressLayoutLeft = new VBox(20);//Left of progressLayout as VBox
                                progressLayoutLeft.setAlignment(Pos.CENTER);//Setting component allighntment to center
                                progressLayoutLeft.setPadding(new Insets(120, 0, 0, 220));//Insets from edge for components
                                VBox progressLayoutRight = new VBox(20);//Right of progressLayout as VBox
                                progressLayoutRight.setAlignment(Pos.CENTER);//Setting component allighntment to center
                                progressLayoutRight.setPadding(new Insets(120, 220, 0, 0));//Insets from edge for components
                
        //Logo Layer        
        AnchorPane LogoLayer = new AnchorPane();//Second layer in stack. AnchorPane, will hold logo
            AnchorPane.setTopAnchor(vectorShieldLogo, 0.0);//Anchor distance to top
            AnchorPane.setRightAnchor(vectorShieldLogo, 50.0);//Anchor distance to right
            AnchorPane.setLeftAnchor(vectorShieldLogo, 200.0);//Anchor distance to left
            AnchorPane.setBottomAnchor(vectorShieldLogo, 50.0);//Anchor distance to bottom
            
        //Color Layer
        BorderPane ColorLayer = new BorderPane();//Thrid layer in stack, Borderpane. Holds background colorations and style.
            BorderPane ColorLayerTop = new BorderPane();//Borderpane for top of ColorLayer, holds blue line.
                VBox ColorLayerToptop = new VBox();//Acts as background coloration
                ColorLayerToptop.setPadding(new Insets(10));//Size of coloration
                ColorLayerToptop.getStyleClass().add("backgroundBlue");//Color
                VBox ColorLayerTopCenter = new VBox();//Padding after Line
                ColorLayerTopCenter.setPadding(new Insets(40));//Padding
                
            VBox ColorLayerRight = new VBox();//Right section of ColorLayer BorderPane
            ColorLayerRight.setPadding(new Insets(40));//Padding
            VBox ColorLayerLeft = new VBox();//Left section of ColorLayer BorderPane
            ColorLayerLeft.setPadding(new Insets(40));//Padding
            VBox ColorLayerBottom = new VBox();//Left section of ColorLayer BorderPane
            ColorLayerBottom.setPadding(new Insets(40));//Padding
            BorderPane ColorLayerCenter = new BorderPane();//Right section of ColorLayer BorderPane
            ColorLayerCenter.getStyleClass().add("backgroundBlue");//Color
            ColorLayerCenter.setPadding(new Insets(20));//Padding
                VBox ColorLayerCentercenter = new VBox();
                ColorLayerCentercenter.getStyleClass().add("backgroundLightBlue");//Color

           
           
                        //Adding Components to layouts
      //Main Layout
      MainLayout.getChildren().addAll(ColorLayer, LogoLayer, ActiveLayer);//Adding Layers to main StackPane
      
            //Active Layer
            ActiveLayer.setCenter(homeLayout);//Setting homeLayout as first screen
            ActiveLayer.setLeft(ActiveLayerLeft);//Setting ActiveLayerLeft to Left
                ActiveLayerLeft.getChildren().addAll(PrelimOption, SecpolOption, ServicesOption, HomeOption);//Adding MenuButtons to ActiveLayerLeft
            //Layouts that ActiveLayer switches between
            //Home Layout
            homeLayout.getChildren().addAll(selectAll, hardenSyst);//adding Home components
            //Prelim Layout
            prelimLayout.getChildren().addAll(PrelimDesc, PreliminaryOptions);//adding menu Labels and options
            //Secpol Layout
            secpolLayout.getChildren().addAll(SecpolDesc, LocalSecPolOptions);//adding menu Labels and options
            //Services layout
            servicesLayout.getChildren().addAll(ServicesDesc, ServicesOptions);//adding menu Labels and options    
                    //Progress layout
                    progressLayout.setLeft(progressLayoutLeft);//Setting left side of progressLayout
                        progressLayoutLeft.getChildren().addAll(LoadingLabel, loadingCircle);//Adding loading aniamtion & Label to Left
                    progressLayout.setRight(progressLayoutRight);//Setting right side of progressLayout
                        progressLayoutRight.getChildren().addAll(DashboardLabel, ProgressDashboard);//Adding Dashboard & Label to Right
            //Logo Layer
            LogoLayer.getChildren().addAll(vectorShieldLogo);//Adding logo
            
            //Color Layer
            ColorLayer.setTop(ColorLayerTop);//Setting layouts withhin colorLayer
                ColorLayerTop.setTop(ColorLayerToptop);
                ColorLayerTop.setCenter(ColorLayerTopCenter);
            ColorLayer.setCenter(ColorLayerCenter);
                ColorLayerCenter.setCenter(ColorLayerCentercenter);
            ColorLayer.setRight(ColorLayerRight);
            ColorLayer.setLeft(ColorLayerLeft);
            ColorLayer.setBottom(ColorLayerBottom);
            
      
            //Components for when securing has stopped. (The Batch Script finishes and closes)
                    //Images
                    ImageView checkMark = new ImageView(new Image(getClass().getResourceAsStream("/loading1.png")));//Checkmark to replace loading circle
                        checkMark.setFitHeight(200);//Height
                        checkMark.setFitWidth(200);//Width
                        checkMark.setPreserveRatio(true);//Preserving aspect ratio
                    //Buttons
                    Button exit = new Button("Exit");//Exit Button
                    //Labels
                    Label FinishedLabel = new Label("Complete!");//Label displayed when progress finishes
                    FinishedLabel.getStyleClass().add("labels");//Style
                    //Animation
                    RotateTransition rotateTransition = new RotateTransition();//Setting a new rotational transisition
                    rotateTransition.setDuration(Duration.millis(1500));//Duration of animation cycle
                    rotateTransition.setNode(loadingCircle);//Setting loadingCircle as image to rotate
                    rotateTransition.setToAngle(360);//angle of rotation
                    rotateTransition.setCycleCount(rotateTransition.INDEFINITE);//Duration of animation
                    rotateTransition.setAutoReverse(false);//Start from beginning, don't reverse play
                    rotateTransition.setInterpolator(Interpolator.LINEAR);//Interpoltation
                                      

            //Creating scenes
      mainScreen = new Scene(MainLayout, 1200, 800);//Main screen with Mainlayout
      mainScreen.getStylesheets().add("homeTheme.css");//Styling from CSS
      
       //Actions to take when 'hardensyst' button is pressed. Practically next phase of program
      hardenSyst.setOnAction(
         e -> {
            harden = AlertBox.display("Warning!", "Changes have to be manually reversed! Check settings before proceeding.", "Secure my system", "Cancel");//Making sure user is sure with alertbox
            if (harden == true) {// If User is sure, Harden system. Handles checkboxes, modifying the array based on their state.
                scriptRunning=true;//Setting ScriptRunning to true, for to be set threads
                handleOptions(PreliminaryBoxes, SecpolBoxes, ServiceBoxes);//Converting all user options to booleans and exporting with method
                ActiveLayer.setCenter(progressLayout);//Setting progress screen to center of mainLayout
                //Source 9 helped understand usage of .clear() method and subsequent uses
                ActiveLayerLeft.getChildren().clear();//Removing menu options
                    //Playing loading animation
                        rotateTransition.play();
                        
                        
            //Setting daemon thread to update dashboard as a do-while loop
            ArrayList<String> oldActions = new ArrayList<String>();//ArrayList of old actions
                Runnable updateDashboard = new Runnable() {//Creating new Runnable to update dashboard and be run as a daemon
        public void run() {
            do {
                         ArrayList<String> actions = getCompletedActions(oldActions); //Setting actions from Json file into ArrayList with getCompletedActions() method
                         //Adding new actions to old actions
                            for (int i = 0; i<actions.size(); i++) {//Looping through new action array
                                oldActions.add(actions.get(i));//Adding new actions to old
                            }
                            //Updating Dashboard on JavaFX mainthread
                            Platform.runLater(new Runnable() {
                                @Override
                        public void run() {
                                 ProgressDashboard.getItems().addAll(actions);//Adding newly retreived actions
                            }
                        });

                                                 try {
                         Thread.sleep(300);//Causing thread to pause for 0.3 seconds as to reduce processing stress
                                                   } catch (InterruptedException ex) {//Interruption to sleep error handling
                              System.out.println("Interruption in Dashboard update waiting");
                              System.exit(0);
                          }
                       } while (scriptRunning);
            };
                  };
                   //Setting Dashboard update thread
        //Source 14 helped demonstrate how to set daemon Thread
        ProgressDashboard.getItems().clear();//Clearing Dashboard
        Thread dashboardThread = new Thread(updateDashboard);//Setting new thread with updateDashboard Runnable
        dashboardThread.setDaemon(true);//Setting as daemon
        dashboardThread.start();//Starting thread
        
        
        //Running batch script  
          //Multi-Threaded solution code partly courtesy of dan1st from Stack Overflow. Link to original question as source 10.
                          Runtime runtime = Runtime.getRuntime();
                          try {
    final Process scriptProcess = runtime.exec("cmd /c start /min /wait core.bat");//Creating Process to track batch script. Running script aswell.    
    Thread scriptThread =new Thread(()->{//Creating new daemon thread to track progress(Neccesary to not hinder loading animation, which is running on main thread)
        try{
            scriptProcess.waitFor();//Waiting for scriptProcess to end
            Service<Void> service = new Service<Void>() {
        @Override
        protected Task<Void> createTask() {
            return new Task<Void>() {           
                @Override
                protected Void call() throws Exception {
                    //Background work                       
                    final CountDownLatch latch = new CountDownLatch(1);
                    Platform.runLater(new Runnable() {                          
                        @Override
                        public void run() {
                            try{
                                //Actions taken after script closes
                                scriptRunning = false;//Closing Dashboard update thread
                                progressLayoutLeft.getChildren().clear();//Removing loading anim from left side
                                progressLayoutLeft.getChildren().addAll(FinishedLabel, checkMark, exit);//Adding post-progress components
                                
                            }finally{
                                latch.countDown();
                            }
                        }
                    });
                    latch.await();                      
                    //Keep with the background work
                    return null;
                }
            };
        }
    };
    service.start();            
        }catch(InterruptedException ex){
        }
    });
    scriptThread.setDaemon(true);//Setting thread as daemon
    scriptThread.start();//Starting thread
} catch(IOException ioException) {System.out.println("Error in thread creation, IO with batch script failure"); System.exit(0); //Error handling should thread/process creation fail
}                  
        }
        });

       //Actions for whn user chooses to exit
       exit.setOnAction(e -> {
           exitProgram();
       });      

       //Actions taken when selectAll button is select/deslected
       CheckBox[][] AllBoxes= {PreliminaryBoxes, SecpolBoxes, ServiceBoxes};//Nested Array of all options 
       CheckBox[][] AllCatBoxes= {PreliminaryCatagoryBoxes, SecpolCatagoryBoxes, ServiceCatagoryBoxes};//Nested Array of all catagory options 
                          selectAll.setOnAction(e -> {
         changeBoxes(AllBoxes, AllCatBoxes, selectAll.isSelected());//Setting all boxes to selection state
       });
       
           //Handling aztions when a menu button is pressed of toggle group SettingsButtons
menuButtons.selectedToggleProperty().addListener((ObservableValue<? extends Toggle> ov, Toggle old_toggle, Toggle new_toggle) -> {
    if (menuButtons.getSelectedToggle() != null) {//If Current toggle exists...
        String choice = menuButtons.getSelectedToggle().getUserData().toString();//Setting current menu choice to String of button user data
        switch (choice) {
            case "preliminary"://Preliminary options
                ActiveLayer.setCenter(prelimLayout);
                break;
            case "secpol"://Secpol options
                ActiveLayer.setCenter(secpolLayout);
                break;
            case "services"://Services options
                ActiveLayer.setCenter(servicesLayout);
                break;
            case "home"://home menu option
                ActiveLayer.setCenter(homeLayout);
                break;
            default: System.out.println("ERROR: Invalid setting choice");//Error if user data doesnt match any option
            System.exit(0);
            break;
        }
    }
      });
      //Sets primary stage to home page
      window.setScene(mainScreen);
      primaryStage.show();
   }

   //Actions taken when exiting program
   private void exitProgram() {
      boolean exit = AlertBox.display("Confirm", "Are you sure you wish to exit?", "Yes", "No");//Presenting double check to user
      if (exit == true) {//If alertbox returns confirmation
      window.close();//exit program
      }
   }
   //Concerts Array of Checkboxes of user options into ArrayList of booleans
      public void handleOptions(CheckBox[] preliminary, CheckBox[] localSecPol, CheckBox[] services) {
   //Converting preliminary options into arrayList of booleans
        //Looping through array, changing each checkbox into boolean of its respective state, then addign to arrayList
  //Preliminary converting
      for (int x = 0; x<preliminary.length; x++) {
   boolean state = preliminary[x].isSelected();
   Preliminary.add(state);//Adding boolean to arrayList
    }
  //LocalSecPol checking
      for (int x = 0; x<localSecPol.length; x++) {
   boolean state = localSecPol[x].isSelected();
   Secpol.add(state);//Adding boolean to arrayList
    }
  //Services checking
      for (int x = 0; x<services.length; x++) {
   boolean state = services[x].isSelected();
   Services.add(state);//Adding boolean to arrayList
    }
      //Adding filled array lists to main arrayLists
      arrayLists.add(Preliminary);
      arrayLists.add(Secpol);
      arrayLists.add(Services);
   //writing .json files---
   printToJson.writeSettings(arrayLists, settingNames);
   }
   
      //Method used to convert all checkboxes to selected/deselected
      public void changeBoxes(CheckBox[][] All, CheckBox[][] AllCat, boolean toState) {//Nested looping to select/deselect all boxes
          
                                          for (int x = 0; x<All.length; x++) {//Looping thorugh All Array
                                              for(int i =0; i<All[x].length; i++) {//Looping through Nested Array
                                                  All[x][i].setSelected(toState); //Setting box in Nested Array to boolean toState
                                              }
              }
                                          for (int x = 0; x<AllCat.length; x++) {//Looping thorugh AllCat Array
                                              for(int i =0; i<AllCat[x].length; i++) {//Looping through Nested Array
                                                  AllCat[x][i].setSelected(toState); //Setting box in Nested Array to boolean toState
                                              }
              }
          
      }
      
     // method for turning Checkbox Array to TreeView with said checkboxes as TreeItems
     public void CheckBoxAdd(CheckBox[] boxes, TreeItem<CheckBox> view) {
               for (int x = 0; x<boxes.length; x++) {
            TreeItem<CheckBox> item = new TreeItem<>(boxes[x]);//Creating treeItem with checkBox
            view.getChildren().add(item);//Adding to TreeView
              }
     }
     //method fro importing CompletedActions.json and coverting to an arrayList of strings(each line being a string).
     public ArrayList getCompletedActions(ArrayList<String> oldActions) {
         ArrayList<String> actions = new ArrayList<>();//Setting ArrayList
         try {
             try (BufferedReader fileInput = new BufferedReader(new FileReader("CompletedActions.json")) //Setting BufferedReader with FileReader for proper json file
             ) {
                 String action = fileInput.readLine();//Setting String action as new line
                 while (action != null) {//while not empty
                     actions.add(action);//Add to actions ArrayList
                     action = fileInput.readLine();//Setting string to new line
                 }   }
         } catch (IOException ex1) {//Missing file error handling
             System.out.println("Error: CompletedActions.json not found while setting BufferedReader/Parsing error");
             System.exit(0);
         }
         //Comparing new actions to old ones to remove duplicates
         actions.removeAll(oldActions);
         return actions;//Returning new actions
     }
       public static void main(String[] args) throws IOException {
   // Starting GUI
      launch(args);
   //Note to self: Any Code below will run after the GUI is closed
   new FileOutputStream("CompletedActions.json").close();//Clearing out old Action file
   }
}
