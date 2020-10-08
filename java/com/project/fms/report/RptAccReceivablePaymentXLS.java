/*
 * RptAccReceivablePaymentXLS.java
 *
 * Created on October 38, 2008, 4:22 PM
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
public class RptAccReceivablePaymentXLS extends HttpServlet {
    
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
        
        // Payment Id
        long payId = JSPRequestValue.requestLong(request, "oid");
        System.out.println("PayId : "+payId);
        
        // Load AR Payment
        ArPayment arPay = new ArPayment();
        try{
            arPay = DbArPayment.fetchExc(payId);
        }catch (Exception e){
            System.out.println(e);
        }
        // Load Invoice
        ARInvoice arInv = new ARInvoice();
        try{
            arInv = DbARInvoice.fetchExc(arPay.getArInvoiceId());
        }catch (Exception e){
            System.out.println(e);
        }
                
        // Load Customer
        Customer cust = new Customer();
        try{
            cust = DbCustomer.fetchExc(arPay.getCustomerId());
        }catch (Exception e){
            System.out.println(e);
        }
        
        // Load Company
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(arPay.getCompanyId());
        }catch (Exception e){
            System.out.println(e);
        }

        // Load Project
        Project proj = new Project();
        try{
            proj = DbProject.fetchExc(arPay.getProjectId());
        }catch (Exception e){
            System.out.println(e);
        }
              
        // Load Currency
        Currency curr = new Currency();
        try{
            curr = DbCurrency.fetchExc(arInv.getCurrencyId());
        }catch (Exception e){
            System.out.println(e);
        }
        
        // Load Currency Payment
        Currency currPay = new Currency();
        try{
            currPay = DbCurrency.fetchExc(arPay.getCurrencyId());
        }catch (Exception e){
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

        //PrintWriter wb = response.getWriter() ;

        wb.println("   <?xml version=\"1.0\"?>");
        wb.println("   <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("   <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("    xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("    xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("    <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("     <Author>Suarjaya_Laptop</Author>");
        wb.println("     <LastAuthor>Suarjaya_Laptop</LastAuthor>");
        wb.println("     <LastPrinted>2008-10-13T07:36:35Z</LastPrinted>");
        wb.println("     <Created>2008-10-13T06:41:38Z</Created>");
        wb.println("     <LastSaved>2008-10-28T01:16:14Z</LastSaved>");
        wb.println("     <Company>SUARJAYA</Company>");
        wb.println("     <Version>11.9999</Version>");
        wb.println("    </DocumentProperties>");
        wb.println("    <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <WindowHeight>9840</WindowHeight>");
        wb.println("     <WindowWidth>19200</WindowWidth>");
        wb.println("     <WindowTopX>0</WindowTopX>");
        wb.println("     <WindowTopY>255</WindowTopY>");
        wb.println("     <ProtectStructure>False</ProtectStructure>");
        wb.println("     <ProtectWindows>False</ProtectWindows>");
        wb.println("    </ExcelWorkbook>");
        wb.println("    <Styles>");
        wb.println("     <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577704\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577714\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577724\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"2\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577734\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577552\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577562\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577572\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m14577582\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\" ss:Indent=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s21\">");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s22\">");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s25\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s26\">");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s27\">");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"2\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#FF0000\" ss:Bold=\"1\"");
        wb.println("       ss:Underline=\"Single\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Color=\"#FF0000\" ss:Bold=\"1\" ss:Underline=\"Single\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"2\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s32\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"d\\ mmmm\\ yyyy\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s33\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s34\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s41\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s42\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s50\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\" ss:Indent=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s56\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s63\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s84\">");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s87\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"9\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s95\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s97\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s116\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"11\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"11\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s136\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s137\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s144\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"7\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s145\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"9\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("    </Styles>");
        wb.println("    <Worksheet ss:Name=\"payment\">");
        wb.println("     <Table ss:ExpandedColumnCount=\"256\" ss:ExpandedRowCount=\"32\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:StyleID=\"s21\" ss:DefaultRowHeight=\"0\">");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"213.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:Index=\"8\" ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"245\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress2()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s23\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s23\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">Contact : "+company.getContact()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s23\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s23\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"5.0625\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s26\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9.9375\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Invoice To</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+cust.getName()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">PAYMENT</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        //wb.println("       <Cell ss:Index=\"5\"><Data ss:Type=\"String\">"+cust.getAddress()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s30\"><Data ss:Type=\"String\" x:Ticked=\"1\">Payment Number</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+arPay.getJournalNumber()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Invoice Number</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+arInv.getInvoiceNumber()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Project Number</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+proj.getNumber()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Currency</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+currPay.getCurrencyCode()+"</Data></Cell>");
        wb.println("      </Row>");       
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(arPay.getDate(),"dd MMMM yyyy")+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\" ss:StyleID=\"s33\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m14577552\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\" x:Ticked=\"1\">Pay Amount "+currPay.getCurrencyCode()+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">Exchange Rate</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m14577562\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">Total "+curr.getCurrencyCode()+"</Data></Cell>");
        wb.println("      </Row>");
        
        //Detail
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"50\" ss:StyleID=\"s41\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s42\"");
        wb.println("        ss:Formula=\"=IF(ISNUMBER(R[-1]C),R[-1]C+1,1)\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m14577572\"><Data ss:Type=\"String\">"+arPay.getNotes()+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(arPay.getAmount(),"#,###.##")+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(arPay.getExchangeRate(),"#,###.##")+"</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m14577582\"");
        wb.println("        ss:Formula=\"=IF(AND(ISNUMBER(RC[-2]),ISNUMBER(RC[-1])),RC[-2]*RC[-1],&quot;&quot;)\"><Data");
        wb.println("         ss:Type=\"Number\">10000</Data></Cell>");
        wb.println("      </Row>");
        
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s56\"/>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m14577704\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m14577714\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"m14577724\"><Data");
        wb.println("         ss:Type=\"String\">Grand Total</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m14577734\"");
        wb.println("        ss:Formula=\"=SUM(R[-3]C:R[-1]C[1])\"><Data ss:Type=\"Number\">10000</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\" x:Ticked=\"1\">Transfer By</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s95\"><Data ss:Type=\"String\" x:Ticked=\"1\">Bank Transfer Number  :  "+arPay.getBankTransferNumber()+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s84\"/>");
        wb.println("       <Cell ss:StyleID=\"s84\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s87\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:MergeAcross=\"2\" ss:StyleID=\"s116\"><Data ss:Type=\"String\">Date:_______________</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s136\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">        Check by</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s97\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s145\"><Data ss:Type=\"String\" x:Ticked=\"1\">  Approve by </Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s117\"><Data ss:Type=\"String\" x:Ticked=\"1\">   Prepare by</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("       <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s137\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">(                           )</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s144\"><Data ss:Type=\"String\" x:Ticked=\"1\">(                           )</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s116\"><Data ss:Type=\"String\">( Management )</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("       <Cell ss:StyleID=\"s85\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\" ss:Hidden=\"1\" ss:Span=\"1\"/>");
        wb.println("     </Table>");
        wb.println("     <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("       <Layout x:CenterHorizontal=\"1\"/>");
        wb.println("       <PageMargins x:Bottom=\"0.5\" x:Left=\"0\" x:Right=\"0\" x:Top=\"0.5\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ZeroHeight/>");
        wb.println("      <Print>");
        wb.println("       <ValidPrinterInfo/>");
        wb.println("       <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("       <Scale>80</Scale>");
        wb.println("       <HorizontalResolution>-3</HorizontalResolution>");
        wb.println("       <VerticalResolution>0</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("       <Pane>");
        wb.println("        <Number>3</Number>");
        wb.println("        <ActiveRow>14</ActiveRow>");
        wb.println("        <ActiveCol>7</ActiveCol>");
        wb.println("        <RangeSelection>R15C8:R15C9</RangeSelection>");
        wb.println("       </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("     </WorksheetOptions>");
        wb.println("    </Worksheet>");
        wb.println("   </Workbook>");
        
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
