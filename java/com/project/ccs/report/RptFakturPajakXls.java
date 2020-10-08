/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.ccs.postransaction.transfer.FakturPajakDetail;
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

public class RptFakturPajakXls extends HttpServlet {
    
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
        
        RptFaktur rptKonstan = new RptFaktur();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptFaktur)session.getValue("KONSTAN");
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

        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-07-19T04:36:43Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-07-19T04:37:48Z</LastSaved>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9300</WindowHeight>");
        wb.println("<WindowWidth>15135</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>120</WindowTopY>");
        wb.println("<AcceptLabelsInFormulas/>");
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
        
        wb.println("<Style ss:ID=\"m25167260\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s31\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s32\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s33\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
       
        
        wb.println("<Style ss:ID=\"y33\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" />");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
         wb.println("<Style ss:ID=\"y3344\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" />");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
        
          wb.println("<Style ss:ID=\"ykanan\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" />");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
           wb.println("<Style ss:ID=\"ykiri\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" />");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
         wb.println("<Style ss:ID=\"ykiri1\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        //wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
         wb.println("<Style ss:ID=\"ykanan1\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        //wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
         wb.println("<Style ss:ID=\"ybawah\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        //wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
         wb.println("<Style ss:ID=\"yatasbawah\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        //wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
         wb.println("<Style ss:ID=\"yatas\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        //wb.println("<Interior ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        
        
        wb.println("<Style ss:ID=\"s36\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"y36\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        
        wb.println("<Style ss:ID=\"s37\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"y37\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"y45\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        //wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\"/>");
        wb.println("</Style>");
        
        
        wb.println("<Style ss:ID=\"s38\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s44\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s45\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s46\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s47\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s48\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s49\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s52\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s54\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"11\" x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"4.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"35\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"40\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"110\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"105\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"40\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"95\"/>");
        //wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");
        //wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y3344\"><Data ss:Type=\"String\">Lembar ke-1 :</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y3344\"><Data ss:Type=\"String\">Untuk Pembeli BKP/Penerima JKP</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y3344\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y3344\"><Data ss:Type=\"String\">sebagai bukti Pajak Masukan</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
       
        
        wb.println("<Row ss:Index=\"5\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">FAKTUR PAJAK STANDAR</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
        
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s46\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"ykanan\"><Data ss:Type=\"String\">Kode dan Nomor Seri Faktur Pajak</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"ykiri\"><Data ss:Type=\"String\">: "+rptKonstan.getNumberFaktur()+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
        //vendor
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Pengusaha Kena Pajak</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+ig.getVendor()+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        //vendor
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">: "+cmp.getName()+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">: "+cmp.getAddress()+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">: 31.252.679.1-901.000</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
             
        
       //vendor
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Pembeli Barang Kena Pajak/Penerima Jasa Kena Pajak</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+ig.getVendor()+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        //vendor
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">:</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">:</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">:</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">          Receive In</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
       
        
        
       
        
        //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"ykiri1\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"ykanan1\"/>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\"  ss:StyleID=\"ybawah\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"ybawah\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"ybawah\"><Data ss:Type=\"String\">Harga Jual/Penggantian/Uang</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\"  ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">Urut</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">Nama Barang Kena Pajak/Jasa Kena Pajak</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">Muka/Termin</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\"  ss:StyleID=\"yatas\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"yatas\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"yatas\"><Data ss:Type=\"String\">(Rp)</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ig.getReceiveIn()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
       
        
        /*if(vDetail!=null && vDetail.size()>0){
            for(int i=0;i<vDetail.size();i++){
                FakturPajakDetail igL = (FakturPajakDetail)vDetail.get(i);
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">"+igL.getItemName() +"</Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\"></Data></Cell>");
               
               wb.println("</Row>");
            }
        }*/
        
        
        //if(vDetail!=null && vDetail.size()>0){
            for(int i=0;i<15;i++){
               // FakturPajakDetail igL = (FakturPajakDetail)vDetail.get(i);
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\"></Data></Cell>");
               
               wb.println("</Row>");
            }
        //}
        
        
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Harga Jual/Penggantian/Uang Muka/Termin *)</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Dikurangi Potongan Harga</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Dikurangi Uang Muka yang telah diterima</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">PPN = 10% x Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
        
        
       wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"ykiri1\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"ykanan1\"/>");
        wb.println("</Row>");
        
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Pajak Penjualan Atas Barang Mewah</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">-</Data></Cell>");
        wb.println("</Row>");
       
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"ykiri1\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"ykanan1\"/>");
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Tarif</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">DPP</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">PPn BM</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"y45\"><Data ss:Type=\"String\">Denpasar, </Data></Cell>");
        wb.println("</Row>");
       
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">…….. %</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\"> </Data></Cell>");
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">…….. %</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\"> </Data></Cell>");
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">…….. %</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\"> </Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"yatasbawah\"><Data ss:Type=\"String\">…….. %</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\"> </Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"y33\"><Data ss:Type=\"String\">Jumlah</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\"> </Data></Cell>");
        wb.println("</Row>");
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"ykiri1\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"ykanan1\"/>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"ykiri1\"><Data ss:Type=\"String\"></Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"y45\"><Data ss:Type=\"String\">Direktur</Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"yatas\"><Data ss:Type=\"String\"></Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">Direktur</Data></Cell>");
        wb.println("</Row>");
        
        
         wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"> *) Coret yang tidak perlu</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"y33\"><Data ss:Type=\"String\">Rp. ………………</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"ykanan1\"><Data ss:Type=\"String\">Direktur</Data></Cell>");
        wb.println("</Row>");
        
        
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<DisplayPageBreak/>");
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
        wb.println("<ActiveRow>12</ActiveRow>");
        wb.println("<ActiveCol>6</ActiveCol>");
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
