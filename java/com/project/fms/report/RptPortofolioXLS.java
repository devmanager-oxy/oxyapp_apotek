/*
 * Report Profit & Loss XLS.java
 *
 * Created on March 15, 2008, 1:33 AM
 */

package com.project.fms.report;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.io.Writer;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.general.DbCompany;
import com.project.general.Company;


public class RptPortofolioXLS extends HttpServlet {
    
    /** Initializes the servlet.
    */  
    public static String formatDate = "dd MMMM yyyy";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
    */  
    public void destroy() {

    }

    String XMLSafe ( String in )
    {
        return in;
    	//return HTMLEncoder.encode(in);
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    * 
    * Why not use a DOM? Because we want to be able to create the spreadsheet on-the-fly, without
    * having to use up a lot of memory before hand
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");
        
        // Load User Login
        String loginId = JSPRequestValue.requestString(request, "oid");
        System.out.println("UserId : "+loginId);
        
        
        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();           
        System.out.println("oidCompany : "+oidCompany);   
        
        //obj
        RptPortofolio rptKonstan = new RptPortofolio();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptPortofolio)session.getValue("KONSTAN");
        } catch (Exception ex) { System.out.println(ex); }
        

        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("DETAIL");
        } catch (Exception e) { System.out.println(e); }
        //System.out.println(vectorList);       
        
	//Count total Column
	int colSpan = 0;
        System.out.println(colSpan);
        
        boolean gzip = false ;
        
        //response.setCharacterEncoding( "UTF-8" ) ;
        OutputStream gzo ;
        if ( gzip ) {
            response.setHeader( "Content-Encoding", "gzip" ) ;
            gzo = new GZIPOutputStream( response.getOutputStream() ) ;
        } else {
            gzo = response.getOutputStream() ;
        }
        PrintWriter wb = new PrintWriter( new OutputStreamWriter( gzo, "UTF-8" ) ) ;

        //PrintWriter wb = response.getWriter() ;
        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>Victor</Author>");
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-09-24T04:26:42Z</LastPrinted>");
        wb.println("<Created>2009-09-24T03:06:53Z</Created>");
        wb.println("<LastSaved>2009-09-24T04:31:40Z</LastSaved>");
        wb.println("<Company>Victory</Company>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9210</WindowHeight>");
        wb.println("<WindowWidth>15195</WindowWidth>");
        wb.println("<WindowTopX>360</WindowTopX>");
        wb.println("<WindowTopY>15</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        
        /*
        wb.println("<Style ss:ID=\"s17\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s51\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s85\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s86\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s89\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s90\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s91\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s94\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s108\">");
        wb.println("<Interior/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s147\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        //wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s149\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s152\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        //wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s153\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"0%\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s154\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s155\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s156\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s167\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s178\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s192\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s193\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s195\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        //wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        /*
        wb.println("<Style ss:ID=\"s196\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Font ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s196\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        //wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
        
        wb.println("<Style ss:ID=\"s201\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s202\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s203\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s204\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s205\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s206\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s216\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s217\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s218\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s219\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s220\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s221\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s222\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        //wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s223\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        //wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s224\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s225\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s226\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s227\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s228\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s229\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s230\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s231\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s232\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s233\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s234\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s235\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s236\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s237\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        
        //========================================= untuk warna ==============================
        //kuning
        /*
        wb.println("<Style ss:ID=\"s84\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"Percent\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s84\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        //merah
        /*
        wb.println("<Style ss:ID=\"s87\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"Percent\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s87\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        //putih
        /*
        wb.println("<Style ss:ID=\"s83\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat ss:Format=\"Percent\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s83\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        /*
        wb.println("<Style ss:ID=\"s110\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"Percent\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s110\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        //for akhir total
        wb.println("<Style ss:ID=\"m25038086\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s177\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s333\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        /*
        wb.println("<Style ss:ID=\"s150\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"Percent\"/>");
        wb.println("</Style>");
         */
        
        wb.println("<Style ss:ID=\"s150\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        //======================================= end ================================
        
        wb.println("</Styles>");
        
        wb.println("<Worksheet ss:Name=\"portofolio\">");
        wb.println("<Table ss:ExpandedColumnCount=\"256\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"6.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"210.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"98.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"100.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\" ss:Span=\"3\"/>");
        wb.println("<Column ss:Index=\"11\" ss:AutoFitWidth=\"0\" ss:Width=\"96.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\" ss:Span=\"2\"/>");
        wb.println("<Column ss:Index=\"15\" ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"135\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"2.25\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"238\"/>");
        wb.println("<Row ss:Index=\"2\" ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">PORTOFOLIO USAHA "+company.getName()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">BULAN "+JSPFormater.formatDate(rptKonstan.getPeriode(), "MMMM yyyy").toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"21\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data");
        wb.println("ss:Type=\"String\">NAMA PERKIRAAN</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TARGET LABA        THN "+JSPFormater.formatDate(rptKonstan.getPeriode(), "yyyy").toUpperCase()+"</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TARGET LABA SD BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TARGET LABA BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">REALISASI SD BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">PENCAPAIAN PROSENTASE LABA S/D</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TARGET LABA BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">REALISASI BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">PENCAPAIAN PROSENTASE LABA BLN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">KETERANGAN</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"21.75\">");
        wb.println("<Cell ss:Index=\"7\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">PDPT</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\">BIAYA</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\">LABA</Data></Cell>");
        wb.println("<Cell ss:Index=\"12\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">PDPT</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\">BIAYA</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\">LABA</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"13.5\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s90\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">2</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">3</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">3</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">4</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">5</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">6</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">7</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">8</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">9</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">10</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">11</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">9</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s94\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s224\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s167\"/>");
        wb.println("<Cell ss:StyleID=\"s237\"/>");
        wb.println("</Row>");
        
        if(vectorList!=null && vectorList.size()>0){
            
            int pfType = 9;
            
            for(int i=0;i<vectorList.size();i++){
                RptPortofolioL detail = (RptPortofolioL)vectorList.get(i);
                
                // Style table
                String xStr = "";
                String xC = "";
                String xN = "";
                String xK = "";
                String xT = "";
                
                if(detail.getType()==1){
                     xStr = "s152";
                     xC = "s216";
                     xN = "s201";
                     xK = "s229";
                     xT = "s84";
                }else if(detail.getType()==2){
                     xStr = "s195";
                     xC = "s217";
                     xN = "s202";
                     xK = "s155";
                     xT = "s87";
                }else{
                     xStr = "s196";
                     xC = "s218";
                     xN = "s203";
                     xK = "s156";
                     xT = "s83";
                }
                
                    
                
                    if(detail.getTypes()==9){
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s222\"/>");
                        wb.println("<Cell ss:StyleID=\"s206\"><Data ss:Type=\"String\">TOTAL USAHA</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtTargetLaba()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtTargetLabaSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtTargetLabaBulanIni()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtPdptSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtBiayaSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtLabaSd()+"</Data></Cell>");
                        //wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s110\" ss:Formula=\"=RC[-1]/RC[-5]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtTargetLabaBulanIni2()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtPdpt()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtBiaya()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">"+detail.getTtLaba()+"</Data></Cell>");
                        //wb.println("<Cell ss:StyleID=\"s147\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s110\" ss:Formula=\"=RC[-1]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s234\"/>");
                        wb.println("</Row>");

                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\" ss:StyleID=\"s108\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s223\"/>");
                        wb.println("<Cell ss:StyleID=\"s192\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s193\"/>");
                        wb.println("<Cell ss:StyleID=\"s235\"/>");
                        wb.println("</Row>");
                    }
                    else{
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\""+xC+"\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+detail.getCode()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xN+"\"><Data ss:Type=\"String\">"+detail.getName()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTargetLaba(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTargetLabaSd(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTargetLabaBulanIni(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPdptSd(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getBiayaSd(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getLabaSd(), "###.##")+"</Data></Cell>");
                        //wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"String\">"+detail.getPersenLabaSd()+"%</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xT+"\" ss:Formula=\"=RC[-1]/RC[-5]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTargetLabaBulanIni2(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPdpt(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getBiaya(), "###.##")+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getLaba(), "###.##")+"</Data></Cell>");
                        //wb.println("<Cell ss:StyleID=\""+xStr+"\"><Data ss:Type=\"String\">"+detail.getPersenLaba()+"%</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xT+"\" ss:Formula=\"=RC[-1]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\""+xK+"\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s108\"/>");
                        wb.println("</Row>");
                    }
                
            }
        }
        
        /*
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\" ss:StyleID=\"s108\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s223\"/>");
        wb.println("<Cell ss:StyleID=\"s192\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s193\"/>");
        wb.println("<Cell ss:StyleID=\"s235\"/>");
        wb.println("</Row>");
         */

        //rptKonstan.getTotalPersenLabaSd()
        //rptKonstan.getTotalPersenLaba()
        
        
        //total akhir
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
        //wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s222\"/>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m25038086\"><Data ss:Type=\"String\">LABA SETELAH BUNGA DAN PAJAK</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalTargetLaba()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalTargetLabaSd()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalTargetLabaBulanIni()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalPdptSd()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalBiayaSd()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalLabaSd()+"</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s150\" ss:Formula=\"=RC[-1]/RC[-5]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalTargetLabaBulanIni2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalPdpt()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalBiaya()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalLaba()+"</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s177\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s150\" ss:Formula=\"=RC[-1]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s333\"/>");
        wb.println("</Row>");
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("<Header x:Margin=\"0.13\"/>");
        wb.println("<Footer x:Margin=\"0.19\"/>");
        wb.println("<PageMargins x:Bottom=\"0.22\" x:Left=\"0.13\" x:Right=\"0.49\" x:Top=\"0.17\"/>");
        wb.println("</PageSetup>");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<Scale>41</Scale>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<FreezePanes/>");
        wb.println("<FrozenNoSplit/>");
        wb.println("<SplitHorizontal>7</SplitHorizontal>");
        wb.println("<TopRowBottomPane>7</TopRowBottomPane>");
        wb.println("<SplitVertical>3</SplitVertical>");
        wb.println("<LeftColumnRightPane>3</LeftColumnRightPane>");
        wb.println("<ActivePane>0</ActivePane>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>1</Number>");
        wb.println("<ActiveCol>5</ActiveCol>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>2</Number>");
        wb.println("<ActiveRow>17</ActiveRow>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>0</Number>");
        wb.println("<ActiveRow>0</ActiveRow>");
        wb.println("<ActiveCol>9</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("</Workbook>");
        wb.flush() ;
    }
    
    
    /** Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    } 

    /** Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
    */
    public String getServletInfo() {
        return "Short description";
    }
    
    public static void main(String[] arg){
        try{
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
    }

    
}
