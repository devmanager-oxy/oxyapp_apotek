/*
 * RptAccReceivableXLS.java
 *
 * Created on October 13, 2008, 4:22 PM
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
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
//import com.project.general.*;
import com.project.crm.project.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.Currency;
import com.project.general.DbCurrency;

import com.project.general.BankAccount;
import com.project.general.DbBankAccount;

/**
 *
 * @author  Suarjaya
 */
public class RptSaldoDpXLS extends HttpServlet {
    
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
        
        RptSaldoHD rptKonstan = new RptSaldoHD();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptSaldoHD)session.getValue("KONSTAN");
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
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-09-21T02:57:05Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-09-19T17:53:20Z</LastSaved>");
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
        wb.println("<Style ss:ID=\"m25044696\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25044706\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s23\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s39\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s44\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s46\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"256\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"18\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"203.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"57\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"136.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"248\"/>");
        
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s44\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s46\"><Data ss:Type=\"String\">"+rptKonstan.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");                
        wb.println("</Row>");
        
        wb.println("<Row ss:Index=\"6\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">Periode : "+rptKonstan.getPeriode()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        //wb.println("<Row ss:Index=\"7\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">Supplier : "+rptKonstan.getUnit()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        
        //if(rptKonstan.getAccount()!=null && rptKonstan.getAccount().length()>0){
            wb.println("<Row>");
            //wb.println("<Row ss:Index=\"8\">");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">Account : "+rptKonstan.getAccount()+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s24\"/>");
            wb.println("</Row>");
        //}
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:Index=\"11\">");
        //wb.println("<Row ss:Index=\"9\">");
        //wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">Supplier</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m25044696\"><Data ss:Type=\"String\">Saldo DP</Data></Cell>");
        wb.println("</Row>");
        
        if(vDetail!=null && vDetail.size()>0){
            for(int i=0;i<vDetail.size();i++){
            RptSaldoHDL detail = (RptSaldoHDL)vDetail.get(i);
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+detail.getUraian()+"</Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m25044706\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getSaldoTitipan(), "#,##0.00")+"</Data></Cell>");
                wb.println("</Row>");
            }
        }
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("<Cell ss:StyleID=\"s27\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rptKonstan.getTotalTitipan(), "#,##0.00")+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Prepared By</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">Approvad By</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">(���������.)</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">(���������.)</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
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
        wb.println("<ActiveCol>6</ActiveCol>");
        wb.println("<RangeSelection>C7:C256</RangeSelection>");
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
