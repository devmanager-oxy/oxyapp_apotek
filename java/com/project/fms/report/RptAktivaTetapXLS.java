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


public class RptAktivaTetapXLS extends HttpServlet {
    
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

        
        // header aktiva tetap
        RptAktivaTetap rptKonstan = new RptAktivaTetap();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptAktivaTetap)session.getValue("KONSTAN");
        } catch (Exception ex) { System.out.println(ex); }
       
        
        
        // Load aktiva tetap
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("DETAIL");
        } catch (Exception e) { System.out.println(e); }
           
        
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
        wb.println("<LastPrinted>2009-09-30T11:34:03Z</LastPrinted>");
        wb.println("<Created>2009-09-30T05:30:37Z</Created>");
        wb.println("<LastSaved>2009-09-30T11:31:48Z</LastSaved>");
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
        wb.println("<Style ss:ID=\"s20\" ss:Name=\"Percent\">");
        wb.println("<NumberFormat ss:Format=\"0%\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17369580\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17369590\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384854\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384864\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384874\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384884\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384894\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384904\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m17384914\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s45\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s47\" ss:Parent=\"s20\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s49\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s50\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"Medium Date\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s51\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s52\" ss:Parent=\"s20\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s53\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s54\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"Medium Date\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s55\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s56\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s56b\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s57\" ss:Parent=\"s20\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s57b\" ss:Parent=\"s20\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
        wb.println("<Style ss:ID=\"s58b\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s58\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s59\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s60\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s61\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        //new style
        wb.println("<Style ss:ID=\"s47b\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        //wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        wb.println("</Styles>");

        wb.println("<Worksheet ss:Name=\"AKT TTP\">");
        wb.println("<Table ss:ExpandedColumnCount=\"256\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"7.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"160.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"191.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"60.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"53.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70.5\" ss:Span=\"1\"/>");
        wb.println("<Column ss:Index=\"13\" ss:AutoFitWidth=\"0\" ss:Width=\"69\" ss:Span=\"1\"/>");
        wb.println("<Column ss:Index=\"15\" ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"168\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"6\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"236\"/>");
        
        wb.println("<Row ss:Index=\"2\" ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">"+company.getAddress()+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"16\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">"+rptKonstan.getTitle1().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"16\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">"+rptKonstan.getTitle2().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"21\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"16\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">POSISI :  "+rptKonstan.getPeriode().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"m17384854\"><Data");
        wb.println("ss:Type=\"String\">NOMOR INVENTARIS</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17384864\"><Data ss:Type=\"String\">AKTIVA</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17384874\"><Data ss:Type=\"String\">DALAM PROSENTASE</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17384884\"><Data ss:Type=\"String\">JUMLAH UNIT/BH/ SET</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17384894\"><Data ss:Type=\"String\">TAHUN PEROLEHAN</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m17384904\"><Data ss:Type=\"String\">NILAI PEROLEHAN</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"6\" ss:StyleID=\"m17384914\"><Data ss:Type=\"String\">AKUMULASI PENYUSUTAN</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17369580\"><Data ss:Type=\"String\">NILAI BUKU</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17369590\"><Data ss:Type=\"String\">LOKASI</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"27.75\">");
        wb.println("<Cell ss:Index=\"7\" ss:StyleID=\"s25\"><Data ss:Type=\"String\">S/D   "+JSPFormater.formatDate(rptKonstan.getPerolehanSd(), "dd/MM/yyyy")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">PENAMBAH</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">SALDO  S/D SAAT INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">PER "+JSPFormater.formatDate(rptKonstan.getPenyusutanPer(), "dd/MM/yyyy")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">SALDO "+JSPFormater.formatDate(rptKonstan.getPenyusutanSaldo1(), "MMMM yy").toUpperCase()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">SO.S/D "+JSPFormater.formatDate(rptKonstan.getPenyusutanSo(), "MMMM yy").toUpperCase()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">PENAMBAH</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">PENGURANG</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">SALDO "+JSPFormater.formatDate(rptKonstan.getPenyusutanSaldo2(), "MMMM yy").toUpperCase()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">SALDO S/D "+JSPFormater.formatDate(rptKonstan.getPenyusutanSaldo3(), "MMMM yy").toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s42\"/>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">2</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">3</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">4</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">5</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">6</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">7</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">8</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">9</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">10</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"/>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">11</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">12</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">13</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">14</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">15</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s42\"/>");
        wb.println("</Row>");
        
        if(vectorList!=null && vectorList.size()>0){
            for(int i=0;i<vectorList.size();i++){
                RptAktivaTetapL detail = (RptAktivaTetapL)vectorList.get(i);
                
                if(detail.getLevel()==1){ 
                  
                        //===== header 1
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">"+detail.getHeader1().toUpperCase()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("</Row>");

                        //=== header 2
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">"+detail.getHeader2().toUpperCase()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("<Cell ss:StyleID=\"s45\"/>");
                        wb.println("</Row>");
                  
                    
                    //=== contents
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">"+detail.getNomor()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s45\"><Data ss:Type=\"String\">* "+detail.getAktiva()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s47b\"><Data ss:Type=\"Number\">"+detail.getPersentase()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getJumlahUnit()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s50\"><Data ss:Type=\"DateTime\">"+detail.getTahunPerolehan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanSd()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanPenambahan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPer()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanSaldo()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPenambah()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPengurang()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-2]-RC[-1]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-3]-RC[-2]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-8]-RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                    wb.println("</Row>");
                    
                }else if(detail.getLevel()==2){
                    //=== header 2
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">"+detail.getHeader2().toUpperCase()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("<Cell ss:StyleID=\"s45\"/>");
                    wb.println("</Row>");
                  
                    
                    //=== contents
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">"+detail.getNomor()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s45\"><Data ss:Type=\"String\">* "+detail.getAktiva()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s47b\"><Data ss:Type=\"Number\">"+detail.getPersentase()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getJumlahUnit()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s50\"><Data ss:Type=\"DateTime\">"+detail.getTahunPerolehan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanSd()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanPenambahan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPer()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanSaldo()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPenambah()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPengurang()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-2]-RC[-1]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-3]-RC[-2]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-8]-RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                    wb.println("</Row>");
                    
                }else if(detail.getLevel()==3){
                    
                     //=== contents
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">"+detail.getNomor()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s45\"><Data ss:Type=\"String\">* "+detail.getAktiva()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s47b\"><Data ss:Type=\"Number\">"+detail.getPersentase()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getJumlahUnit()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s50\"><Data ss:Type=\"DateTime\">"+detail.getTahunPerolehan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanSd()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPerolehanPenambahan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPer()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanSaldo()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-2]+RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPenambah()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">"+detail.getPenyusutanPengurang()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-2]-RC[-1]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-4]+RC[-3]-RC[-2]\"><Data");
                    wb.println("ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\" ss:Formula=\"=RC[-8]-RC[-1]\"><Data ss:Type=\"Number\">0</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                    wb.println("</Row>");
                    
                }else if(detail.getLevel()==7){
                    
                    //=== total
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s55\"/>");
                    wb.println("<Cell ss:StyleID=\"s56\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s57\"/>");
                    wb.println("<Cell ss:StyleID=\"s58\"/>");
                    wb.println("<Cell ss:StyleID=\"s58\"/>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanSd()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanPenambah()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanSaldoSaatIni()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPer()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo1()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSo()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPenambah()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPengurang()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo3()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTotalNilaiBuku()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58\"/>");
                    wb.println("</Row>");
                    
                }else if(detail.getLevel()==8){
                    
                    //=== grand total
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s55\"/>");
                    wb.println("<Cell ss:StyleID=\"s56b\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s57b\"/>");
                    wb.println("<Cell ss:StyleID=\"s58b\"/>");
                    wb.println("<Cell ss:StyleID=\"s58b\"/>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanSd2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanPenambah2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPerolehanSaldoSaatIni2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPer2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo11()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSo2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPenambah2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanPengurang2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo21()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalPenyusutanSaldo31()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"><Data ss:Type=\"Number\">"+detail.getTotalNilaiBuku2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s58b\"/>");
                    wb.println("</Row>");
                    
                }else{
                    
                    //=== total akhir
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.25\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s59\"/>");
                    wb.println("<Cell ss:StyleID=\"s60\"><Data ss:Type=\"String\">TOTAL AKHIR INVENTARIS</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"/>");
                    wb.println("<Cell ss:StyleID=\"s61\"/>");
                    wb.println("<Cell ss:StyleID=\"s61\"/>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPerolehanSd()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPerolehanPenambahan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPerolehanSaldoSaatIni()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanPer()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanSaldo1()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanSo()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanPenambahan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanPengurangan()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanSaldo2()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaPenyusutanSaldo3()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"><Data ss:Type=\"Number\">"+detail.getTaNilaiBuku()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s61\"/>");
                    wb.println("</Row>");
                    
                }
                
            }
        }

        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("<Header x:Margin=\"0.13\"/>");
        wb.println("<Footer x:Margin=\"0.17\"/>");
        wb.println("<PageMargins x:Bottom=\"0.19\" x:Left=\"0.22\" x:Right=\"0.49\" x:Top=\"0.17\"/>");
        wb.println("</PageSetup>");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<Scale>50</Scale>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<FreezePanes/>");
        wb.println("<FrozenNoSplit/>");
        wb.println("<SplitHorizontal>11</SplitHorizontal>");
        wb.println("<TopRowBottomPane>11</TopRowBottomPane>");
        wb.println("<SplitVertical>3</SplitVertical>");
        wb.println("<LeftColumnRightPane>3</LeftColumnRightPane>");
        wb.println("<ActivePane>0</ActivePane>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>1</Number>");
        wb.println("<ActiveCol>6</ActiveCol>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>2</Number>");
        wb.println("<ActiveRow>7</ActiveRow>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>0</Number>");
        wb.println("<ActiveRow>0</ActiveRow>");
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
