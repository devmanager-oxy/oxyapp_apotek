
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspRecipe extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Recipe recipe;

	public static final String JSP_NAME_RECIPE		=  "JSP_NAME_RECIPE" ;

	public static final int JSP_RECIPE_ID			=  0 ;
	public static final int JSP_ITEM_MASTER_ID			=  1 ;
	public static final int JSP_ITEM_RECIPE_ID			=  2 ;
	public static final int JSP_QTY			=  3 ;
	public static final int JSP_UOM_ID			=  4 ;
	public static final int JSP_COST			=  5 ;
	public static final int JSP_TYPE			=  6 ;
	public static final int JSP_LAST_UPDATE			=  7 ;
        
        public static final int JSP_DESCRIPTION                 =  8 ;
        

	public static String[] colNames = {
		"JSP_RECIPE_ID",  "JSP_ITEM_MASTER_ID",
		"JSP_ITEM_RECIPE_ID",  "JSP_QTY",
		"JSP_UOM_ID",  "JSP_COST",
		"JSP_TYPE",  "JSP_LAST_UPDATE",
                "JSP_DESCRIPTION"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_DATE,
                TYPE_STRING
	} ;

	public JspRecipe(){
	}
	public JspRecipe(Recipe recipe){
		this.recipe = recipe;
	}

	public JspRecipe(HttpServletRequest request, Recipe recipe){
		super(new JspRecipe(recipe), request);
		this.recipe = recipe;
	}

	public String getFormName() { return JSP_NAME_RECIPE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Recipe getEntityObject(){ return recipe; }

	public void requestEntityObject(Recipe recipe) {
		try{
			this.requestParam();
			recipe.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			recipe.setItemRecipeId(getLong(JSP_ITEM_RECIPE_ID));
			recipe.setQty(getDouble(JSP_QTY));
			recipe.setUomId(getLong(JSP_UOM_ID));
			recipe.setCost(getDouble(JSP_COST));
			recipe.setType(getString(JSP_TYPE));
			recipe.setLastUpdate(getDate(JSP_LAST_UPDATE));
                        recipe.setDescription(getString(JSP_DESCRIPTION));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
