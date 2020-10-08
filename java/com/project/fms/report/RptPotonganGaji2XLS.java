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

public class RptPotonganGaji2XLS extends HttpServlet {
    
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
          wb.println("<Author>edarmasusila</Author>");
          wb.println("<LastAuthor>edarmasusila</LastAuthor>");
          wb.println("<Created>2009-12-28T04:48:14Z</Created>");
          wb.println("<Company>eka</Company>");
          wb.println("<Version>11.5606</Version>");
         wb.println("</DocumentProperties>");
         wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
          wb.println("<WindowHeight>8700</WindowHeight>");
          wb.println("<WindowWidth>15195</WindowWidth>");
          wb.println("<WindowTopX>480</WindowTopX>");
          wb.println("<WindowTopY>135</WindowTopY>");
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
          wb.println("<Style ss:ID=\"m14484788\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14484798\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14484808\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14484818\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14491548\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14491558\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14491568\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"m14491578\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s23\">");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s25\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s26\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s27\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s29\">");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s30\">");
           wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s31\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s32\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s39\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s40\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s43\">");
           wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s53\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s54\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s56\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s57\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s59\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s60\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s74\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s75\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s81\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s82\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s83\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s84\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
         wb.println("</Styles>");
         wb.println("<Worksheet ss:Name=\"Sheet1\">");
          wb.println("<Table x:FullColumns=\"1\" x:FullRows=\"1\">");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"5.25\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"23.25\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
           wb.println("<Column ss:StyleID=\"s25\" ss:AutoFitWidth=\"0\" ss:Width=\"56.25\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"48.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"51.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"54\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"57.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"56.25\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"54.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"49.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"52.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"51\" ss:Span=\"1\"/>");
           wb.println("<Column ss:Index=\"16\" ss:AutoFitWidth=\"0\" ss:Width=\"61.5\"/>");
           wb.println("<Column ss:Width=\"66.75\"/>");
           wb.println("<Column ss:Width=\"81.75\"/>");
           wb.println("<Row ss:Height=\"15.75\">");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"16\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">REKAP POTONGAN GAJI</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"16\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"12.9375\">");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\" x:Ticked=\"1\">PERIODE : "+rptKonstan.getPeriode()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"12.9375\">");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\" x:Ticked=\"1\">DINAS : "+rptKonstan.getDinas()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"12.9375\" ss:StyleID=\"s29\">");
            //wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\" x:Ticked=\"1\">NOMOR : J0123</Data></Cell>");
           wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s43\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s31\"/>");
            wb.println("<Cell ss:Index=\"18\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Tanggal : "+JSPFormater.formatDate(rptKonstan.getTanggal(), "dd/MM/yyyy")+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"4.5\" ss:StyleID=\"s29\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s31\"/>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s29\">");
            wb.println("<Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"m14491548\"><Data ");
              wb.println(" ss:Type=\"String\">No</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14491558\"><Data ss:Type=\"String\">Nama</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14491568\"><Data ss:Type=\"String\">NIK</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Simpanan</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Pinjaman</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14491578\"><Data ss:Type=\"String\">Minimarket</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Elektronik</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Mandiri</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14484788\"><Data ss:Type=\"String\">Fasjabtel</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14484798\"><Data ss:Type=\"String\">TTP/Lain Lain</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14484818\"><Data ss:Type=\"String\" ");
              wb.println(" x:Ticked=\"1\">Total Potongan</Data></Cell>");
            wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m14484808\"><Data ss:Type=\"String\">Keterangan</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s29\">");
            wb.println("<Cell ss:Index=\"5\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Wajib</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Sukarela</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
            wb.println("<Cell ss:Index=\"11\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Pokok</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">Bunga</Data></Cell>");
           wb.println("</Row>");
           /*wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s29\">");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s53\"><Data ss:Type=\"Number\">1</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"String\">xxxx</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s54\"><Data ss:Type=\"String\">123xxc</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s81\" ss:Formula=\"=SUM(RC[-12]:RC[-1])\"><Data ss:Type=\"Number\">144</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s53\"><Data ss:Type=\"String\">sdfs</Data></Cell>");
           wb.println("</Row>");
            */
            
           if(vDetail!=null && vDetail.size()>0){
                for(int i=0;i<vDetail.size();i++){
                    RptPotonganGajiL detail = (RptPotonganGajiL)vDetail.get(i);
                
                   wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s29\">");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s56\"><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s56\"><Data ss:Type=\"String\">"+detail.getNama()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s57\"><Data ss:Type=\"String\">"+detail.getNik()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimPokok(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimWajib(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSimSukarela(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPinPokok(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getPinBunga(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMini(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getElektroPokok(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getElektroBunga(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getManPokok(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getManBunga(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getFasjabtel(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getTtp(), "###")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s82\" ss:Formula=\"=SUM(RC[-12]:RC[-1])\"><Data ss:Type=\"Number\">144</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s56\"><Data ss:Type=\"String\">"+((detail.getKeterangan()==null)? "" :detail.getKeterangan())+"</Data></Cell>");
                   wb.println("</Row>");
                   
                }
           }
           
           /*wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s29\">");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s59\"><Data ss:Type=\"Number\">1</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"String\">xxxx</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s60\"><Data ss:Type=\"String\">123xxc</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s83\" ss:Formula=\"=SUM(RC[-12]:RC[-1])\"><Data ss:Type=\"Number\">144</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s59\"><Data ss:Type=\"String\">sdfs</Data></Cell>");
           wb.println("</Row>");
            */
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s74\"/>");
            wb.println("<Cell ss:StyleID=\"s74\"/>");
            wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">12</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">123</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">113</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">13</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s74\"/>");
           wb.println("</Row>");
           wb.println("<Row ss:Index=\"15\" ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
            wb.println("<Cell ss:Index=\"6\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">Tgl : ____________</Data></Cell>");
            wb.println("<Cell ss:Index=\"15\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">Tgl : ______________</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
            wb.println("<Cell ss:Index=\"6\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">Dibuat Oleh</Data></Cell>");
            wb.println("<Cell ss:Index=\"15\"><Data ss:Type=\"String\">Disetujui</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
            wb.println("<Cell ss:Index=\"6\" ss:StyleID=\"s32\"><Data ss:Type=\"String\" x:Ticked=\"1\">( _____________________ )</Data></Cell>");
            wb.println("<Cell ss:Index=\"15\" ss:StyleID=\"s32\"><Data ss:Type=\"String\" x:Ticked=\"1\">( _____________________ )</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:Height=\"11.25\" ss:StyleID=\"s23\">");
            wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s32\"/>");
           wb.println("</Row>");
          wb.println("</Table>");
          wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
           wb.println("<Print>");
            wb.println("<ValidPrinterInfo/>");
            wb.println("<HorizontalResolution>600</HorizontalResolution>");
            wb.println("<VerticalResolution>600</VerticalResolution>");
           wb.println("</Print>");
           wb.println("<Selected/>");
           wb.println("<DoNotDisplayGridlines/>");
           wb.println("<Panes>");
            wb.println("<Pane>");
             wb.println("<Number>3</Number>");
             wb.println("<ActiveRow>20</ActiveRow>");
             wb.println("<ActiveCol>8</ActiveCol>");
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
