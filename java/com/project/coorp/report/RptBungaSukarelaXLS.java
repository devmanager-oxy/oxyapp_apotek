/*
 * RptAccReceivableAgingXLS.java
 *
 * Created on October 30, 2008, 8:26 AM
 */

package com.project.coorp.report;

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
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
//import com.project.general.*;
import com.project.crm.project.*;
import com.project.I_Project;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.Currency;
import com.project.general.DbCurrency;

import com.project.general.BankAccount;
import com.project.general.DbBankAccount;
import com.project.coorp.member.*;
import com.project.coorp.pinjaman.*;

/**
 *
 * @author  Suarjaya
 */
public class RptBungaSukarelaXLS extends HttpServlet {
    
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
        
        // Company Id
        Company company = new Company();
        try{
            company = DbCompany.getCompany();
        }catch (Exception e){
            System.out.println(e);
        }

        // Load Vector Data Aging
        Vector vectorList = new Vector(1,1);
        String periodeName = "";
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("SALDO_BUNGA_ANGGOTA");
            periodeName = (String)session.getValue("SALDO_BUNGA_PERIODE");
        } catch (Exception e) { 
            System.out.println(e); 
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
         wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
         wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
         wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
         wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
         wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
          wb.println("<Author>edarmasusila</Author>");
          wb.println("<LastAuthor>edarmasusila</LastAuthor>");
          wb.println("<Created>2010-03-07T09:57:07Z</Created>");
          wb.println("<LastSaved>2010-03-07T10:07:32Z</LastSaved>");
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
          wb.println("<Style ss:ID=\"s22\">");
           wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s25\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s27\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s36\" ss:Parent=\"s16\">");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s37\" ss:Parent=\"s16\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s38\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s39\">");
           wb.println("<Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
          wb.println("</Style>");
         wb.println("</Styles>");
         wb.println("<Worksheet ss:Name=\"Sheet1\">");
          wb.println("<Table>");// ss:ExpandedColumnCount=\"4\" x:FullColumns=\"1\"");
           //wb.println(" x:FullRows=\"1\">");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"27\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"228\"/>");
           wb.println("<Column ss:StyleID=\"s36\" ss:AutoFitWidth=\"0\" ss:Width=\"79.5\"/>");
           wb.println("<Row ss:Height=\"15.75\">");
            wb.println("<Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\">BIAYA BUNGA TABUNGAN SUKARELA</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell><Data ss:Type=\"String\">"+company.getAddress()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:Index=\"5\">");
            wb.println("<Cell><Data ss:Type=\"String\">Tanggal : "+JSPFormater.formatDate(new Date(), "dd/MM/yyyy")+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell><Data ss:Type=\"String\">Periode : "+periodeName+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:Index=\"8\">");
            wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">No</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">NIK</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">Nama</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s37\"><Data ss:Type=\"String\">Total Bunga</Data></Cell>");
           wb.println("</Row>");
           
           double total = 0;
           if(vectorList!=null && vectorList.size()>0){
           for(int i=0; i<vectorList.size(); i++){
               
                Vector temp = (Vector)vectorList.get(i);
                Member member = (Member)temp.get(0);
                TabunganSukarela tb = (TabunganSukarela)temp.get(1);

                total = total + tb.getSaldo();
               
               wb.println("<Row>");
                wb.println("<Cell><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell><Data ss:Type=\"String\">"+member.getNoMember()+"</Data></Cell>");
                wb.println("<Cell><Data ss:Type=\"String\">"+member.getNama()+"</Data></Cell>");
                wb.println("<Cell><Data ss:Type=\"Number\">"+tb.getSaldo()+"</Data></Cell>");
               wb.println("</Row>");
           }}
           
           
           wb.println("<Row>");
            wb.println("<Cell ss:StyleID=\"s27\"/>");
            wb.println("<Cell ss:StyleID=\"s27\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s38\"><Data ss:Type=\"Number\">"+total+"</Data></Cell>");
           wb.println("</Row>");
          wb.println("</Table>");
          wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
           wb.println("<Print>");
            wb.println("<ValidPrinterInfo/>");
            wb.println("<HorizontalResolution>600</HorizontalResolution>");
            wb.println("<VerticalResolution>600</VerticalResolution>");
           wb.println("</Print>");
           wb.println("<Selected/>");
           wb.println("<Panes>");
            wb.println("<Pane>");
             wb.println("<Number>3</Number>");
             wb.println("<ActiveRow>15</ActiveRow>");
             wb.println("<ActiveCol>2</ActiveCol>");
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

