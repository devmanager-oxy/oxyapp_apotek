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


public class RptKinerjaXLS extends HttpServlet {
    
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
        RptKinerjaL detail = new RptKinerjaL();
        try{
            HttpSession session = request.getSession();
            detail = (RptKinerjaL)session.getValue("DETAIL");
        } catch (Exception ex) { System.out.println(ex); }
        

        /*
        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("DETAIL");
        } catch (Exception e) { System.out.println(e); }
        //System.out.println(vectorList);    
         */   
        
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
        wb.println("<LastPrinted>2009-09-25T11:12:07Z</LastPrinted>");
        wb.println("<Created>2009-09-25T10:46:10Z</Created>");
        wb.println("<LastSaved>2009-09-26T04:17:14Z</LastSaved>");
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

        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s22\">");
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
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s32\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s33\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s34\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s35\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s39\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CC99FF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s52\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s53\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s54\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s55\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s58\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s59\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s60\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s61\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s62\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CC99FF\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s63\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
        wb.println("</Style>");
        
        wb.println("</Styles>");

        wb.println("<Worksheet ss:Name=\"Kinerja\">");
        wb.println("<Table ss:ExpandedColumnCount=\"256\" ss:ExpandedRowCount=\"27\" x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\" ss:DefaultRowHeight=\"0\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"6.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"228.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"93\" ss:Span=\"4\"/>");
        wb.println("<Column ss:Index=\"9\" ss:AutoFitWidth=\"0\" ss:Width=\"65.25\" ss:Span=\"2\"/>");
        wb.println("<Column ss:Index=\"12\" ss:AutoFitWidth=\"0\" ss:Width=\"3.75\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"243\"/>");
        wb.println("<Row ss:Height=\"12.75\"/>");
        wb.println("<Row ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"><Data ss:Type=\"String\">KINERJA USAHA KOPEGTEL &quot;INSAN&quot;</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"><Data ss:Type=\"String\">BULAN "+detail.getPeriode().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"13.5\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"24\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data");
        wb.println("ss:Type=\"String\">NAMA PERKIRAAN</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">TARGET THN "+detail.getTahun()+"</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">TARGET SD BULAN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">TARGET BULAN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">REALISASI S/D BULAN INI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">REALISASI  BULAN INI</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">% PENCAPAIAN</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        wb.println("<Cell ss:Index=\"9\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">SD BULAN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">BULAN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">THN 2009</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"Number\">2</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"Number\">3</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"Number\">4</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"Number\">5</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"Number\">6</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">7=5/3</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">8=6/4</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">9=5/2</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"12.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s30\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">I</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s35\"><Data ss:Type=\"String\">TOTAL PENDAPATAN</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s52\"><Data ss:Type=\"Number\">"+detail.getTargetTahun()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getTargetSd()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getRealSd()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-4]/RC[-7]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s54\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">II</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s35\"><Data ss:Type=\"String\">TOTAL BIAYA </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s52\"><Data ss:Type=\"Number\">"+detail.getTargetTahun2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getTargetSd2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getRealSd2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni2()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s60\" ss:Formula=\"=RC[-4]/RC[-7]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s54\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">III</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">OR</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"Number\">"+detail.getTargetTahun3()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"Number\">"+detail.getTargetSd3()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni3()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"Number\">"+detail.getRealSd3()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni3()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0.5</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0.32051282051282054</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s62\" ss:Formula=\"=RC[-4]/RC[-7]*100\"><Data ss:Type=\"Number\">0.2</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"15.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s54\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s55\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("<Cell ss:StyleID=\"s61\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"16.5\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">IV</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s43\"><Data ss:Type=\"String\">LABA SEBELUM PAJAK</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s58\"><Data ss:Type=\"Number\">"+detail.getTargetTahun4()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"Number\">"+detail.getTargetSd4()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni4()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"Number\">"+detail.getRealSd4()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni4()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s63\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s63\" ss:Formula=\"=RC[-2]/RC[-4]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s63\" ss:Formula=\"=RC[-4]/RC[-7]*100\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Height=\"12.75\" ss:Span=\"9\"/>");
        wb.println("<Row ss:Index=\"26\" ss:AutoFitHeight=\"0\" ss:Height=\"17.25\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"4.5\"/>");

        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("<Header x:Margin=\"0.13\"/>");
        wb.println("<Footer x:Margin=\"0.19\"/>");
        wb.println("<PageMargins x:Bottom=\"0.22\" x:Left=\"0.13\" x:Right=\"0.49\" x:Top=\"0.17\"/>");
        wb.println("</PageSetup>");
        wb.println("<ZeroHeight/>");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<Scale>70</Scale>");
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
        wb.println("<ActiveCol>10</ActiveCol>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>2</Number>");
        wb.println("<ActiveRow>17</ActiveRow>");
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
