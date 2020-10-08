/*
 * I_Ims.java
 *
 * Created on November 13, 2008, 9:37 AM
 */

package com.project.ccs;

/**
 *
 * @author  Suarjaya
 */
public class I_Ccs {
    
    //Product Type    
    public static final int TYPE_CATEGORY_FINISH_GOODS          = 0;       //raw material
    public static final int TYPE_CATEGORY_RAW_MATERIAL          = 1;   //finish good
    public static final int TYPE_CATEGORY_PLUMBING_MATERIAL     = 2;    //component
    public static final int TYPE_CATEGORY_ELECTRICAL_MATERIAL   = 3;
    public static final int TYPE_CATEGORY_BUILDING_MATERIAL     = 4;
    public static final int TYPE_CATEGORY_CIVIL_WORK            = 5;
    public static final int TYPE_CATEGORY_COMPONENT             = 6;
    public static final int TYPE_CATEGORY_SPAREPART             = 7;
    public static final int TYPE_CATEGORY_ASSET                 = 8;
    public static final int TYPE_CATEGORY_SPBU_MATERIAL         = 9;
    public static final int TYPE_CATEGORY_ROOM                  = 10;
    public static final int TYPE_CATEGORY_SPA_MATERIAL          = 11;
    public static final int TYPE_CATEGORY_HANDPHONE             = 12;
    public static final int TYPE_CATEGORY_HANDPHONE_ACCESORRIES = 13;
    
    public static final String[] strCategoryType = {
        "Product/Recipe", "Raw Material", "Plumbing Material", "Electrical Material",
        "Building Material", "Civil Work", "Component", "Sparepart",
        "Asset","SPBU Material","Room","SPA Material", "Handphone/Tablet", "HP Accesorries"
        
    };
    public static final String[] strType = {"0", "1", "2", "3","4", "5", "6", "7"};
    public static final String[] strTypeCode = {
        "FG","RM","PM", "EM",
        "BM", "CW", "CP", "SP"
    };
    
              
    //UOM Type
    public static final int UOM_VOLUME = 0;
    public static final int UOM_LENGTH = 1;
    public static final int UOM_WEIGHT = 2;
    public static final int UOM_SQUARE = 3;
    public static final int UOM_TIME = 4;
    public static final int UOM_QUANTITY = 5;
    public static final int UOM_NOT_AVAILABLE = 6;    
    public static final String[] strUomType = {"UOM Volume", "UOM Length", "UOM Weight", "UOM Square", "UOM Time", "UOM Quantity", "Not Available"};
    
    //Group Type
    public static final int NO_GROUP = 0;    
    public static final int GROUP_1 = 1;    
    public static final int GROUP_2 = 2;    
    public static final int GROUP_3 = 3;    
    public static final int GROUP_4 = 4;    
    public static final int GROUP_5 = 5;    
    public static final int GROUP_6 = 6;    
    public static final int GROUP_7 = 7;    
    public static final int GROUP_8 = 8;    
    public static final int GROUP_9 = 9;    
    public static final int GROUP_10 = 10;    
    public static final String[] strGroupType = {"No Group", "Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6", "Group 7", "Group 8", "Group 9", "Group 10"};
    
    //Table Type
    public static final int NO_TABLE = 0;    
    public static final int TABLE_1 = 1;    
    public static final int TABLE_2 = 2;    
    public static final String[] strTableType = {"No Table", "Table 1", "Table 2"};
    
    //Alignment Type
    public static final int LEFT = 0;    
    public static final int CENTER = 1;    
    public static final int RIGHT = 2;    
    public static final String[] strAlignType = {"Left", "Center", "Right"};
    
    public static final int SALES_STATUS_DRAFT          = 0;    
    public static final int SALES_STATUS_POSTED         = 1;
    
    public static final String[] strSalesStatus = {"Draft", "Posted"};
    
    public static int TYPE_INCOMING_GOODS   = 0;
    public static int TYPE_RETUR_GOODS      = 1;
    public static int TYPE_TRANSFER         = 2;
    public static int TYPE_TRANSFER_IN      = 3;
    public static int TYPE_ADJUSTMENT       = 4;
    public static int TYPE_OPNAME           = 5;
    public static int TYPE_PROJECT_INSTALL  = 6;
    public static int TYPE_SALES            = 7;
    public static int TYPE_COSTING          = 8;
    public static int TYPE_REPACK           = 9;
    public static int TYPE_REC_ADJ          =10;
    public static int TYPE_GA               =11;
    
}
