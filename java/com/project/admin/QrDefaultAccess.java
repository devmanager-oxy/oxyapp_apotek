

package com.project.admin;

import java.util.*;

import com.project.main.db.*;
import com.project.admin.*;


public class QrDefaultAccess
{


    public static final int PRIV_GROUP_SYSTEM_ACCESS = 0;
   	    public static final int PRIV_SYSTEM_ACCESS_LOGIN	= 0;
    	public static final int PRIV_SYSTEM_ACCESS_LOGOUT	= 1;

    public static final int PRIV_GROUP_ADMIN	= 1;
   	    public static final int PRIV_ADMIN_USER		= 0;
    	public static final int PRIV_ADMIN_SYSTEM	= 1;


   public static final int PRIV_GROUP_MASTER_DATA	= 2;
    	public static final int PRIV_MASTER_DATA_PURCHASING	 	= 0;
    	public static final int PRIV_MASTER_DATA_PRODUCT	 	= 1;
        public static final int PRIV_MASTER_DATA_COMPANY		= 2;
        public static final int PRIV_MASTER_DATA_REFERENCE		= 3;


   public static final int PRIV_GROUP_PURCHASING	= 3;
    	public static final int PRIV_PURCHASING_HOUSE	 	= 0;
        public static final int PRIV_PURCHASING_SUPPLIES	= 1;
        public static final int PRIV_PURCHASING_REGULAR		= 2;
       // public static final int PRIV_PURCHASING_FINNALIZE		= 3;

	public static final int PRIV_GROUP_INVENTORY	= 4;
    	public static final int PRIV_INVENTORY_CONTROL 	= 0;
        public static final int PRIV_EXPENSE_CONTROL 	= 1;
       // public static final int PRIV_GROUP_REPORT 				= 2;

	public static final int PRIV_GROUP_PRODUCTION	= 5;
    	public static final int PRIV_PRODUCTION_PRODUCT	 	= 0;


	public static final String[] privGroupNames =
    	{ "System Access","Admin", "Master data", "Purchasing", "Inventory","Production" };

    public static final String[][] privNames =
    	{
        /*login*/		{ "Login Page", "Logout Page" },
    	/*admin*/  		{ "User Management", "System Management" },
    	/*master data */{ "Master Data Purchasing","Master Data Product", "Master Data Company", "Master Data Reference"  },
        /*purchasing */ { "Purchasing House", "Supplies Purchase", "Regular Purchase"},
        /*inventory */	{ "Inventory Control", "Expense Control"},
        /*production*/  { "Production Product " }
    	};

    public static final String[][] privDescription =
    	{
        /*login*/		{ "Login Page", "Logout Page" },
    	/*admin*/  		{ "User Management", "System Management" },
    	/*master data */{ "Administer Purchasing", "Administer Product", "Administer Company", "Administer Reference"  },
        /*purchasing */ { "Purchasing House", "Supplies Purchase", "Regular Purchase"},
        /*inventory */  { "Inventory Control", "Expense Control"  },
        /*production*/  { "Product " }
    	};

  /*  public static final int [][][][] privModules =
    {
        //login
    	{
    	 	//login Page
		    {
    		 	{ObjInfo.G1_LOGIN , ObjInfo.G2_LOGIN, ObjInfo.OBJ_LOGIN_LOGIN}
            },
            // logout Page
            {
    			{ObjInfo.G1_LOGIN , ObjInfo.G2_LOGIN, ObjInfo.OBJ_LOGIN_LOGOUT}
            }

    	},

		//admin
    	{
           //User Management
      		{
      	   		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_PRIVILEGE},
      	   		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_GROUP},
      	   		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER}
      		},
            //System Management
      		{
      	 		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_SYSTEM, ObjInfo.OBJ_ADMIN_SYSTEM_BACK_UP},
      	   		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_SYSTEM, ObjInfo.OBJ_ADMIN_SYSTEM_APP_SET},
      	   		{ObjInfo.G1_ADMIN , ObjInfo.G2_ADMIN_SYSTEM, ObjInfo.OBJ_ADMIN_SYSTEM_OBJ_LOCK}
      		}
      	},
        //master data
      	{
        	//purchasing
      		{
                {ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_ITEM_TYPE},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_ITEM_GRADE},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_ITEM_GROUP},
      			{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_SIZE_CLS_SEC},
                {ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_SIZE_CLS_LEN},
                {ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_CLS_GRADE},
                {ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PURCH, ObjInfo.OBJ_MASTER_D_PURCH_SUPPLIES_CAT}
      		},
        	//product
      	 	{
      	 		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PROD, ObjInfo.OBJ_MASTER_D_PROD_DEPARTMENT},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PROD, ObjInfo.OBJ_MASTER_D_PROD_CLASS},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PROD, ObjInfo.OBJ_MASTER_D_PROD_DESIGN},
      			{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_PROD, ObjInfo.OBJ_MASTER_D_PROD_STEPS}
      		},

      		//company
      		{
        		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_COMP, ObjInfo.OBJ_MASTER_D_COMP_EMPLOYEE},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_COMP, ObjInfo.OBJ_MASTER_D_COMP_EMP_POSITION},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_COMP, ObjInfo.OBJ_MASTER_D_COMP_CONTACT_CLS}
      	 	},
            //reference
      		{
      	 		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_REF, ObjInfo.OBJ_MASTER_D_REF_EXT_COMP},
      	   		{ObjInfo.G1_MASTER_D , ObjInfo.G2_MASTER_D_REF, ObjInfo.OBJ_MASTER_D_REF_EXT_PERSON}
      		}
      	},
        //purchasing
      	{
        	//House
      	 	{

                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_ENTRY, ObjInfo.OBJ_PURCH_ENTRY_HOUSE_HO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_ENTRY, ObjInfo.OBJ_PURCH_ENTRY_HOUSE_PO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_RECV, ObjInfo.OBJ_PURCH_RECEV_HOUSE_PO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_SPV, ObjInfo.OBJ_PURCH_SPV_HOUSE_PO} ,
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_FINAL, ObjInfo.OBJ_PURCH_FINAL_HOUSE_PO}

      		},
            //supplies
      		{
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_ENTRY, ObjInfo.OBJ_PURCH_ENTRY_SUPPLIES_PO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_RECV, ObjInfo.OBJ_PURCH_RECEV_SUPPLIES_PO}
      		},
            //regular
      		{
      	 		{ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_ENTRY, ObjInfo.OBJ_PURCH_ENTRY_REG_HO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_ENTRY, ObjInfo.OBJ_PURCH_ENTRY_REG_PO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_RECV, ObjInfo.OBJ_PURCH_RECEV_REG_PO},
                {ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_SPV, ObjInfo.OBJ_PURCH_SPV_REG_PO},
				{ObjInfo.G1_PURCH , ObjInfo.G2_PURCH_FINAL, ObjInfo.OBJ_PURCH_FINAL_REG_PO},
      		}

     	 },
         //inventory
     	 {
        	//inventory control
     	 	{
     	 		{ObjInfo.G1_INVENTORY , ObjInfo.G2_INVENTORY_CONTROL, ObjInfo.OBJ_INVENTORY_CTRL_INV_ITEM},
                {ObjInfo.G1_INVENTORY , ObjInfo.G2_INVENTORY_CONTROL, ObjInfo.OBJ_INVENTORY_CTRL_HOUSES},
                {ObjInfo.G1_INVENTORY , ObjInfo.G2_INVENTORY_CONTROL, ObjInfo.OBJ_INVENTORY_CTRL_HOUSES_SEC},
                {ObjInfo.G1_INVENTORY , ObjInfo.G2_INVENTORY_CONTROL, ObjInfo.OBJ_INVENTORY_CTRL_SUPPLIES}
     		},
            //expence control
     		{
                {ObjInfo.G1_INVENTORY , ObjInfo.G2_INVENTORY_EXPENCE_CTRL, ObjInfo.OBJ_INVENTORY_EXP_CTRL_TRAVEL_COST}
     		}

    	},
        //production
    	{
        	//product
    	 	{
        		{ObjInfo.G1_PROD , ObjInfo.G2_PROD, ObjInfo.OBJ_PROD_ITEM},
        		{ObjInfo.G1_PROD , ObjInfo.G2_PROD, ObjInfo.OBJ_PROD_BATCH},
                {ObjInfo.G1_PROD , ObjInfo.G2_PROD, ObjInfo.OBJ_PROD_COST_ANALYSIS},
                {ObjInfo.G1_PROD , ObjInfo.G2_PROD, ObjInfo.OBJ_PROD_COST_BREAK_DWN}
    	 	}
    	}
	};   */



    public static final int [][][][] privModuleCommands = ObjInfo.objectCommands;



	public static final int GROUP_SYSTEM_USER			 		= 0;
	public static final int GROUP_SYSTEM_ADMINISTRATOR	 		= 1;
	public static final int GROUP_ADMIN_MASTER_DATA	 			= 2;
	public static final int GROUP_PURCHASING_REGULAR			= 3;
	public static final int GROUP_PURCHASING_HOUSE				= 4;
	public static final int GROUP_PURCHASING_SUPPLIES			= 5;
    public static final int GROUP_INVENTORY						= 6;
    public static final int GROUP_PRODUCTION					= 7;

    public static final String []groupNames=
    { "System User", "Administrator", "Administer Master Data", " Purchasing Regular",
      "Purchasing House","Purchasing Supllies","Administer Inventory","Administer Production"};

    public static final String []groupDescs =
    { "System User", "Administrator", "Administer Master Data", " Purchasing Regular",
      "Purchasing House","Purchasing Supllies","Administer Inventory","Administer Production"};

    public static final int[][] groupPrivGroups=
    {
        // GROUP_SYSTEM_USER
    	{PRIV_GROUP_SYSTEM_ACCESS},
        //GROUP_SYSTEM_ADMINISTRATOR
    	{PRIV_GROUP_ADMIN},
        //GROUP_ADMIN_MASTER_DATA
    	{PRIV_GROUP_MASTER_DATA},
        //GROUP_PURCHASING_REGULAR
    	{PRIV_GROUP_PURCHASING},
    	//GROUP_PURCHASING_HOUSE
    	{PRIV_GROUP_PURCHASING},
    	//GROUP_PURCHASING_SUPPLIES
    	{PRIV_GROUP_PURCHASING},
        //GROUP_INVENTORY
    	{PRIV_GROUP_INVENTORY },
        //GROUP_PRODUCTION
    	{PRIV_GROUP_PRODUCTION}
    };

    public static final int[][][] groupPrivs=
    {
        //GROUP_SYSTEM_USER
    	{   //PRIV_GROUP_SYSTEM_ACCESS
    		{PRIV_SYSTEM_ACCESS_LOGIN , PRIV_SYSTEM_ACCESS_LOGOUT}
    	},

        //GROUP_SYSTEM_ADMINISTRATOR
    	{
	    	//PRIV_GROUP_ADMIN}
	    	 {PRIV_ADMIN_USER, PRIV_ADMIN_SYSTEM}
    	},
        //GROUP_ADMIN_MASTER_DATA
    	{
             //PRIV_GROUP_MASTER_DATA
		    {PRIV_MASTER_DATA_PRODUCT,PRIV_MASTER_DATA_PURCHASING,PRIV_MASTER_DATA_COMPANY,PRIV_MASTER_DATA_REFERENCE }
	    },
        //GROUP_PURCHASING_REGULAR
    	{
            // PRIV_GROUP_PURCHASING REGULAR
            {PRIV_PURCHASING_REGULAR}
        },
         //GROUP_PURCHASING_HOUSE
        {
	    //	 PRIV_GROUP_PURCHASING_HOUSE
        	{PRIV_PURCHASING_HOUSE}
        },
    	//GROUP_PURCHASING_SUPPLIES
    	{
            //PRIV_GROUP_PURCHASING
    		{PRIV_PURCHASING_SUPPLIES}
    	},
        //GROUP_INVENTORY
    	{
        	//PRIV_GROUP_INVENTORY
    		{PRIV_INVENTORY_CONTROL,PRIV_EXPENSE_CONTROL }
        },
        //GROUP_PRODUCTION
    	{
            //PRIV_GROUP_PRODUCTION
   			 {PRIV_PRODUCTION_PRODUCT }
        }
    };

    public static int GENERATE_FAIL = -1;
    public static int GENERATE_OK = 0;

    private static Vector privOIDs= new Vector(); // vector of vector of priv of oids grouped
	private static Vector groupOIDs =new Vector();

  /*  private static int genPrivileges(){
        privOIDs= new Vector();
        int maxPrivGrp = privGroupNames.length;

        for(int privGrp=0; privGrp<maxPrivGrp; privGrp++){
        	int maxPriv = privNames[privGrp].length;
            // get privilege
            Vector vprivOID= new Vector();

        	for(int priv=0; priv<maxPriv; priv++){
               //
            	String privName =privNames[privGrp][priv];
                String privDesc =privDescription[privGrp][priv];

                long privOID = insertPriv(privName, privDesc);

                if(privOID==0)
                    System.out.println(" Priv. insert failed at " + priv+ " name ="+ privName);

                vprivOID.add( new Long(privOID));

	        	int maxPrivMod = privModules[privGrp][priv].length;
                Vector privMdl = new Vector();
	        	for(int privMod=0; privMod<maxPrivMod; privMod++){
                    // get G1, G2 , object index  and compose object code
                    int G1 = privModules[privGrp][priv][privMod][0];
                    int G2 = privModules[privGrp][priv][privMod][1];
                    int objIdx = privModules[privGrp][priv][privMod][2];
                    int objCode =  ObjInfo.composeObjCode( G1, G2 , objIdx );
                    System.out.println("objCode"+objCode);
                    privMdl.add(new Integer(objCode));
                	// get commands
		        	int maxPrivModCmds = privModuleCommands[G1][G2][objIdx].length;
                    System.out.println("maxPrivModCmds"+maxPrivModCmds);
                    Vector objCmds = new Vector();
		        	for(int privModCmd=0; privModCmd<maxPrivModCmds; privModCmd++){
		               objCmds.add( new Integer(privModuleCommands[G1][G2][objIdx][privModCmd]));
		        	}

                    long objID = insertObjAccess(privOID, objCode, objCmds);
                    if (objID == 0)
                        return GENERATE_FAIL;
	        	}
        	}
          privOIDs.add(vprivOID);
        }
        return  GENERATE_OK;
    }  */

	private static long insertPriv(String privName, String privDesc){
        Priv priv =  new  Priv();
        priv.setPrivName(privName);
        priv.setDescr(privDesc);
        long privID = DbPriv.insert(priv);

        return privID;
    }

    private static long insertObjAccess(long privOID, int objCode, Vector objCmds){
        PrivilegeObj privObj = new PrivilegeObj();
        privObj.setPrivId(privOID);
        privObj.setCode(objCode);
        privObj.setCommands(objCmds);

        long PrivOID = DbPrivilegeObj.insert(privObj);
        return PrivOID;

    }

    private static int genGroup(){
        groupOIDs = new Vector();
		int maxGroup = groupNames.length;
        for(int group=0; group < maxGroup;group++){
           String groupName = groupNames[group];
           String groupDesc = groupDescs[group];

           long groupOID = insertGroup(groupName, groupDesc);
            if(groupOID==0)
                System.out.println(" Group. insert failed at " + group+ " name ="+ groupName);
            groupOIDs.add( new Long(groupOID));

           int maxGroupPrivGrp = groupPrivGroups[group].length;
           //System.out.println("maxGroupPrivGrp"+maxGroupPrivGrp);
           for(int groupPrivGrp=0 ; groupPrivGrp < maxGroupPrivGrp ; groupPrivGrp++ ){
            	int  idxPrivGrp =groupPrivGroups[group][groupPrivGrp];

                    Vector privGroup = (Vector)privOIDs.get(0);
                    long privOID = 0;
                    long grpPrivID = 0;
                    for(int i=0;i<privGroup.size();i++){
                    	privOID = ((Long) privGroup.get(i)).longValue();
                        grpPrivID = insertGroupPriv(groupOID, privOID);
                         if(grpPrivID == 0 )
	                       return GENERATE_FAIL;
                    }

                    if(idxPrivGrp != 0){
			                int maxGrpPriv = groupPrivs[group][groupPrivGrp].length;
			                for(int grpPriv = 0;grpPriv < maxGrpPriv ;grpPriv++){
			            		int  idxPriv =groupPrivs[group][groupPrivGrp][grpPriv];
		
			                     privGroup = (Vector)privOIDs.get(idxPrivGrp);
		
		                         privOID = ((Long) privGroup.get(idxPriv)).longValue();

		                         //System.out.println("privOID="+privOID);
		                         grpPrivID = insertGroupPriv(groupOID, privOID);
		                          if(grpPrivID == 0 )
				                       return GENERATE_FAIL;
                            }
	                }
           }

        }
         return  GENERATE_OK;

    }

    private static long insertGroup(String groupName, String groupDesc)
    {
    	Group appGrp = new Group();
        appGrp.setGroupName(groupName);
        appGrp.setGroupName(groupName);
        appGrp.setGroupName(groupDesc);

        long grpOID = DbGroup.insert(appGrp);
        return grpOID;
    }

    private static long insertGroupPriv(long groupOID, long privID)
    {
    	GroupPriv grpPriv = new GroupPriv();
        grpPriv.setGroupID(groupOID);
        grpPriv.setPrivID(privID);

        long grpPrivOID = DbGroupPriv.insert(grpPriv);
        return grpPrivOID;
    }


    private static int genAdminUser(){
		User user = new User();

        user.setLoginId("admin");
        user.setPassword("admin");
        user.setFullName("administrator");
        user.setUserStatus(User.STATUS_NEW);
        long  usrGrpID = 0;
        long usrOID = 0;
        try{
        	 usrOID = DbUser.insert(user);
        }catch(Exception exc){
        }

        long sysAdmin = ((Long)groupOIDs.get(GROUP_SYSTEM_USER)).longValue();
        //insert system_user
	    usrGrpID = insertUserGroup(usrOID, sysAdmin);

        if(usrOID != 0){
	        for ( int usr=1;usr < groupOIDs.size();usr++){
	        	long   adminID = ((Long)groupOIDs.get(usr)).longValue();
                //System.out.println("adminID"+adminID);
		        //insert user_group
		         usrGrpID = insertUserGroup(usrOID, adminID);
	        }
        }
       return  GENERATE_OK;
    }

    private static long insertUserGroup(long usrID, long adminID)
    {
        UserGroup usrGrp = new UserGroup();
        usrGrp.setUserID(usrID);
        usrGrp.setGroupID(adminID);

        long usrGrpID = DbUserGroup.insert(usrGrp);
        return usrGrpID;
    }

   /* public static String genSecurity(){
		if(genPrivileges()!= GENERATE_OK)
            return "Privilege generator is failed";
		if(genGroup()!= GENERATE_OK)
            return "Group generator is failed";

		if(genAdminUser()!= GENERATE_OK)
            return "User generator is failed";

        return "Security generator ok";
    }   */
    
    
    public static String deleteSecurity(){
        // delete app_user 
        String sql = "DELETE FROM " + DbUser.DB_APP_USER;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE USER "+ exc);
            return "Failed";
        }
        
        // delete user_group
        sql = "DELETE FROM " + DbUserGroup.DB_USER_GROUP;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE USER GROUP "+ exc);
            return "Failed";
        }
        
        // delete group
        sql = "DELETE FROM " + DbGroup.DB_APP_GROUP;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE APP GROUP "+ exc);
            return "Failed";
        }
        
        // delete group_priv
        sql = "DELETE FROM " + DbGroupPriv.DB_GROUP_PRIV;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE GROUP PRIV"+ exc);
            return "Failed";
        }
        
        // delete app_priv
        sql = "DELETE FROM " + DbPriv.DB_APP_PRIVILEGE;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE APP PRIV"+ exc);
            return "Failed";
        }
        
        // delete app_privobj
        sql = "DELETE FROM " + DbPrivilegeObj.DB_APP_PRIVILEGE_OBJ;        
        try{
        CONResultSet dbrs = CONHandler.execQueryResult(sql);
        dbrs.close(dbrs);
        } catch (Exception exc){
            System.out.println("DELETE APP PRIV OBJ"+ exc);
            return "Failed";
        }
        
        return "OK"; 
    }



 /*   public static void main(String [] args)
    {
     	String result = genSecurity();
        System.out.println("result"+result);
    }   */


}
