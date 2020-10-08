/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;


// package java
import java.util.*;
import java.text.*;
import java.awt.Color;
import java.io.ByteArrayOutputStream;  
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;

// package servlet
import javax.servlet.*;
import javax.servlet.http.*;

// package lowagie
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;

import com.project.util.*;

/**
 *
 * @author Tu Roy
 */
public class RptLimbahPeriodPdf extends HttpServlet{

    // declaration constant
    public static Color blackColor = new Color(0,0,0);
    public static Color whiteColor = new Color(255,255,255);    

    // setting some fonts in the color chosen by the user 
    public static Font fontHeader = new Font(Font.HELVETICA, 14, Font.BOLD, blackColor);    
    public static Font fontContentSmall = new Font(Font.HELVETICA, 8, Font.NORMAL, blackColor);
    public static Font fontContent = new Font(Font.HELVETICA, 10, Font.NORMAL, blackColor);
    public static Font fontContentItalic = new Font(Font.HELVETICA, 10, Font.ITALIC, blackColor);
    public static Font fontContentBold = new Font(Font.HELVETICA, 10, Font.BOLD, blackColor);

    /** Initializes the servlet
    */
    public void init(ServletConfig config) throws ServletException {  
        super.init(config);
    }

    /** Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Destroys the servlet
    */
    public void destroy() {
    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        // creating the document object
        Document document = new Document(PageSize.A4, 30, 30, 70, 50);

        // creating an OutputStream
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

    }        
    
}
