/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspPropertyPictures extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private PropertyPictures propertyPictures;
    public static final String JSP_NAME_PROPERTY_PICTURES = "JSP_PROPERTY_PICTURES";
    
    public static final int JSP_PROPERTY_PICTURES_ID = 0;
    public static final int JSP_PROPERTY_ID = 1;
    public static final int JSP_NAME_PIC = 2;
    public static final int JSP_DISCRIPTION = 3;
    
    public static final String[] colNames = {
        "JSP_PROPERTY_PICTURES_ID",
        "JSP_PROPERTY_ID",
        "JSP_NAME_PIC",
        "JSP_DISCRIPTION"
    };    
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public JspPropertyPictures() {
    }

    public JspPropertyPictures(
            PropertyPictures propertyPictures) {
        this.propertyPictures = propertyPictures;
    }

    public JspPropertyPictures(HttpServletRequest request, PropertyPictures propertyPictures) {
        super(new JspPropertyPictures(propertyPictures), request);
        this.propertyPictures = propertyPictures;
    }

    public String getFormName() {
        return JSP_NAME_PROPERTY_PICTURES;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public PropertyPictures getEntityObject() {
        return propertyPictures;
    }

    public void requestEntityObject(PropertyPictures propertyPictures) {
        try {
            this.requestParam();
            
            propertyPictures.setPropertyId(getInt(JSP_PROPERTY_ID));
            propertyPictures.setNamePic(getString(JSP_NAME_PIC));
            propertyPictures.setDiscription(getString(JSP_DISCRIPTION));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
