/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
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
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;

public class RptPotonganGajiXLS extends HttpServlet {
    
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
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        RptPotonganGaji rptKonstan = new RptPotonganGaji();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptPotonganGaji)session.getValue("KONSTAN");
        }catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        Vector vDetail = new Vector();
        try{
            HttpSession session = request.getSession();
            vDetail = (Vector)session.getValue("DETAIL");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
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
        wb.println("<LastPrinted>2009-07-14T06:13:53Z</LastPrinted>");
        wb.println("<Created>2009-07-10T05:56:39Z</Created>");
        wb.println("<LastSaved>2009-07-16T03:19:54Z</LastSaved>");
        wb.println("<Company>Victory</Company>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9210</WindowHeight>");
        wb.println("<WindowWidth>15195</WindowWidth>");
        wb.println("<WindowTopX>480</WindowTopX>");
        wb.println("<WindowTopY>75</WindowTopY>");
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
        wb.println("<Style ss:ID=\"m25170088\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25169946\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25169956\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25170026\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175704\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175714\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175724\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175734\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175612\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175622\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175642\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s23\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s39\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s41\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s44\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s47\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s48\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s49\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s50\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s51\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s55\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s56\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s57\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s60\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s76\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s77\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s78\">");
        wb.println("<Borders/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s80\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"7\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"17\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"15.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"32.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"39\" ss:Span=\"9\"/>");
        wb.println("<Column ss:Index=\"14\" ss:AutoFitWidth=\"0\" ss:Width=\"40.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"39\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"42\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"39\"/>");
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:MergeAcross=\"16\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"11.25\">");
        wb.println("<Cell ss:MergeAcross=\"16\" ss:StyleID=\"s60\"><Data ss:Type=\"String\">DAFTAR POTONGAN GAJI PEGAWAI PT.TELEKOMUNIKASI DENPASAR</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"11.25\">");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Dinas / Unit</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">: "+rptKonstan.getDinas()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"><Data ss:Type=\"String\">Tanggal Rekap</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">: "+JSPFormater.formatDate(rptKonstan.getTanggal(), "dd/MM/yyyy")+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Periode</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">: "+rptKonstan.getPeriode()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s29\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">Nomor</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">: "+rptKonstan.getNomor()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\">");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25169956\"><Data ss:Type=\"String\">NAMA</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25175642\"><Data ss:Type=\"String\">NIK</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m25175704\"><Data ss:Type=\"String\">SIMPANAN</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m25175714\"><Data ss:Type=\"String\">PINJAMAN</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25175724\"><Data ss:Type=\"String\">Mini             Market</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m25175734\"><Data ss:Type=\"String\">ELEKTRONIK</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m25170026\"><Data ss:Type=\"String\">MANDIRI</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25170088\"><Data ss:Type=\"String\">Fasjabtel</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25175612\"><Data ss:Type=\"String\">TTP           /Lain-lain</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25175622\"><Data ss:Type=\"String\">Jumlah Potongan</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m25169946\"><Data ss:Type=\"String\">Ket.</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">Wajib</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">Sukarela</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
        wb.println("<Cell ss:Index=\"10\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
        wb.println("</Row>");
        
        if(vDetail!=null && vDetail.size()>0){
            for(int i=0;i<vDetail.size();i++){
                RptPotonganGajiL detail = (RptPotonganGajiL)vDetail.get(i);
                
                wb.println("<Row>");
                wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"Number\">"+(1+i)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+detail.getNama()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"Number\">"+detail.getNik()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s43\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimPokok(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimWajib(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimSukarela(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPinPokok(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s43\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPinBunga(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s43\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMini(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getElektroPokok(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getElektroBunga(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getManPokok(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s43\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getManBunga(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getFasjabtel(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTtp(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getJmlhPotongan(), "###")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+((detail.getKeterangan()==null)? "" :detail.getKeterangan())+"</Data></Cell>");
                wb.println("</Row>");
                
            }
        }
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3\">");
        wb.println("<Cell ss:StyleID=\"s47\"/>");
        wb.println("<Cell ss:StyleID=\"s76\"/>");
        wb.println("<Cell ss:StyleID=\"s47\"/>");
        wb.println("<Cell ss:StyleID=\"s77\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s77\"/>");
        wb.println("<Cell ss:StyleID=\"s77\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s77\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s78\"/>");
        wb.println("<Cell ss:StyleID=\"s80\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s48\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s49\"/>");
        wb.println("<Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalSimPokok(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalSimWajib(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalSimSukarela(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalPinPokok(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalPinBunga(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalMini(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalElektroPokok(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalElektroBunga(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalManPokok(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalManBunga(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalFasjabtel(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalTtp(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalJmlhPotongan(), "###")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s49\"/>");
        wb.println("</Row>");
        
        //==========================================Batas
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        // end ================================== batas

        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Kopegtel &quot;Insan&quot; Denpasar</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s56\"><Data ss:Type=\"String\">Denpasar, "+JSPFormater.formatDate(new Date(), "dd/MMMM/yyyy")+"</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s56\"><Data ss:Type=\"String\">Yang Mengerjakan :</Data></Cell>");
        wb.println("</Row>");
        
        //==========================================Batas
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        // end ================================== batas
        
        //==========================================Batas
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        // end ================================== batas
        
        //==========================================Batas
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        // end ================================== batas
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s55\"><Data ss:Type=\"String\">______________________</Data></Cell>");
        wb.println("<Cell ss:Index=\"14\" ss:MergeAcross=\"2\" ss:StyleID=\"s57\"><Data ss:Type=\"String\">________________</Data></Cell>");
        wb.println("</Row>");
        wb.println("</Table>");
        
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Layout x:Orientation=\"Landscape\"/>");
        wb.println("</PageSetup>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>9</ActiveRow>");
        wb.println("<ActiveCol>16</ActiveCol>");
        wb.println("<RangeSelection>R10C17:R11C17</RangeSelection>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
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
