/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.Sales;
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

public class RptSalesOutletXLS extends HttpServlet {
    
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
        String whereClausa="";
        String order="";
        Vector result = new Vector();
        String userName = "";
        String filter = "";
        try{
            HttpSession session = request.getSession();
            whereClausa = (String)session.getValue("REPORT_COGS");
            order = (String)session.getValue("REPORT_COGS_ORDER");
            
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        boolean gzip = false ;
        result = DbSales.list(0, 0, whereClausa, order);
       // response.setCharacterEncoding( "UTF-8" ) ;
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
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\" ");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\" ");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>Eka DS</Author>");
        wb.println("<LastAuthor>Eka D</LastAuthor>");
        wb.println("<Created>2014-08-27T03:45:36Z</Created>");
        wb.println("<LastSaved>2014-08-27T03:36:41Z</LastSaved>");
        wb.println("<Version>14.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<AllowPNG/>");
        wb.println("</OfficeDocumentSettings>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>6405</WindowHeight>");
        wb.println("<WindowWidth>19635</WindowWidth>");
        wb.println("<WindowTopX>720</WindowTopX>");
        wb.println("<WindowTopY>705</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s63\" ss:Parent=\"s16\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s65\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"7.5\" ss:Color=\"#FF0000\" ");
        wb.println("ss:Bold=\"1\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s68\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println("ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s80\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println("ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#DAEEF3\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s81\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println("ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#DAEEF3\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s83\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s84\" ss:Parent=\"s16\">");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s85\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"a4\">");
        wb.println("<Table ss:ExpandedColumnCount=\"8\" x:FullColumns=\"1\" ");
        wb.println("x:FullRows=\"1\" ss:StyleID=\"s63\" ss:DefaultRowHeight=\"15\">");
        wb.println("<Column ss:Index=\"2\" ss:StyleID=\"s63\" ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");
        wb.println("<Column ss:StyleID=\"s63\" ss:Width=\"150\"/>");
        wb.println("<Column ss:StyleID=\"s63\" ss:Width=\"150\"/>");
        wb.println("<Column ss:StyleID=\"s63\" ss:AutoFitWidth=\"0\" ss:Width=\"100\"/>");
        wb.println("<Column ss:StyleID=\"s63\" ss:Width=\"75\" ss:Span=\"1\"/>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+cmp.getName().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">REPORT SALES SUMMARY</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\" ss:StyleID=\"s85\">");
        wb.println("<Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Number</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Customer</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Total</Data></Cell>");
        
        wb.println("</Row>");
        
        if(result!=null && result.size()>0){
            
            double totSales = 0;
            


            for(int i=0; i<result.size(); i++){

                    Sales sales = (Sales)result.get(i);

                   Customer cus = new Customer();
                    try{
                       cus = DbCustomer.fetchExc(sales.getCustomerId());
                    }catch(Exception ex){
                    }
                    totSales = totSales + (sales.getAmount()-sales.getDiscountAmount());
        
                    wb.println("<Row>");
                    wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+(i+1)+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(sales.getDate(), "dd-MM-yyyy")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\">"+sales.getNumber()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\">"+cus.getName()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber((sales.getAmount()+sales.getDiscountAmount()), "#,###.##")+"</Data></Cell>");
                    
                    wb.println("</Row>"); 
                    
            }
        
                    
            wb.println("<Row>");
            wb.println("<Cell ss:StyleID=\"s80\"/>");
            wb.println("<Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(totSales, "#,###.##")+"</Data></Cell>");
            
            wb.println("</Row>");
        }
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s65\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"5\" ss:StyleID=\"s65\"/>");
        wb.println("</Row>");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<VerticalResolution>0</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>19</ActiveRow>");
        wb.println("<ActiveCol>1</ActiveCol>");
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
