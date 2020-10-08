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
public class RptAccReceivableXLS extends HttpServlet {
    
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
        
        // Invoice Id
        long invId = JSPRequestValue.requestLong(request, "oid");
        System.out.println("InvId : "+invId);
        
        // Load Invoice
        ARInvoice arInv = new ARInvoice();
        try{
            arInv = DbARInvoice.fetchExc(invId);
        }catch (Exception e){
            System.out.println(e);
        }
                
        // Load Customer
        Customer cust = new Customer();
        try{
            cust = DbCustomer.fetchExc(arInv.getCustomerId());
        }catch (Exception e){
            System.out.println(e);
        }
        
        // Load Company
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(arInv.getCompanyId());
        }catch (Exception e){
            System.out.println(e);
        }

        // Load Project
        Project proj = new Project();
        try{
            proj = DbProject.fetchExc(arInv.getProjectId());
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
        
        // Load Bank Account
        BankAccount bankAcc =  new BankAccount();
        try{
            bankAcc =  DbBankAccount.fetchExc(arInv.getBankAccountId());
        }catch (Exception e){
            System.out.println(e);
        }
        
        // Load Invoice Detail
        Vector vInvDetail = new Vector(1,1);	
        vInvDetail = DbARInvoiceDetail.list(0,0,"ar_invoice_id="+arInv.getOID(),"");
        
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
        wb.println("     <LastSaved>2008-10-13T08:19:39Z</LastSaved>");
        wb.println("     <Company>SUARJAYA</Company>");
        wb.println("     <Version>11.9999</Version>");
        wb.println("    </DocumentProperties>");
        wb.println("    <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <WindowHeight>9345</WindowHeight>");
        wb.println("     <WindowWidth>19020</WindowWidth>");
        wb.println("     <WindowTopX>120</WindowTopX>");
        wb.println("     <WindowTopY>105</WindowTopY>");
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
        wb.println("     <Style ss:ID=\"m15954538\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"2\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15954548\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15961932\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15961942\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15961952\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s21\">");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s22\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s25\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s26\">");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s27\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s28\">");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"2\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Color=\"#FF0000\" ss:Bold=\"1\" ss:Underline=\"Single\"/>");
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
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"2\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#FF0000\" ss:Bold=\"1\"");
        wb.println("       ss:Underline=\"Single\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s34\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s35\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s38\">");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s39\">");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s51\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s52\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s54\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s57\">");
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
        wb.println("     <Style ss:ID=\"s58\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s59\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"9\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s60\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"8\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s68\">");
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
        wb.println("     <Style ss:ID=\"s73\">");
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
        wb.println("    </Styles>");
        
        
        
        wb.println("    <Worksheet ss:Name=\"invoice\">");
        wb.println("     <Names>");
        wb.println("      <NamedRange ss:Name=\"Print_Area\"/>");
        wb.println("     </Names>");
        wb.println("     <Table ss:ExpandedColumnCount=\"256\" ss:ExpandedRowCount=\"34\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:StyleID=\"s21\" ss:DefaultRowHeight=\"0\">");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"305.25\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"35.25\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"245\"/>");
        wb.println("      <Row ss:Height=\"20.25\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">"+company.getName().toUpperCase()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress2()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s22\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s22\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\" x:Ticked=\"1\">Contact : "+company.getContact()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s22\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s22\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"5.0625\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s27\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s26\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9.9375\"/>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">Invoice To</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+cust.getName()+"</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">INVOICE</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        //wb.println("       <Cell ss:Index=\"5\"><Data ss:Type=\"String\">"+cust.getAddress()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s29\"><Data ss:Type=\"String\">Invoice Number</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+arInv.getInvoiceNumber()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s29\"><Data ss:Type=\"String\">Project Date</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(arInv.getDate(),"dd MMMM yyyy")+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">Project Number</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+proj.getNumber()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s29\"><Data ss:Type=\"String\">Currency</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+curr.getCurrencyCode()+"</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s29\"><Data ss:Type=\"String\">Due Date</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(arInv.getDueDate(),"dd MMMM yyyy")+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\" ss:StyleID=\"s23\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s25\"><Data ss:Type=\"String\">No</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m15961932\"><Data ss:Type=\"String\">Description</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">Qty</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">Amount "+curr.getCurrencyCode()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m15961942\"><Data ss:Type=\"String\">Total "+curr.getCurrencyCode()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        
        for(int i=0; i<vInvDetail.size(); i++){
            ARInvoiceDetail arInvDetail = (ARInvoiceDetail)vInvDetail.get(i);        

            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"30\" ss:StyleID=\"s52\">");
            wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s51\"");
            wb.println("        ss:Formula=\"=IF(ISNUMBER(R[-1]C),R[-1]C+1,1)\"><Data ss:Type=\"Number\">1</Data><NamedCell");
            wb.println("         ss:Name=\"Print_Area\"/></Cell>");
            wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m15961952\"><Data ss:Type=\"String\">"+arInvDetail.getItemName()+"</Data><NamedCell");
            wb.println("         ss:Name=\"Print_Area\"/></Cell>");
            wb.println("       <Cell ss:StyleID=\"s51\"><Data ss:Type=\"Number\">"+arInvDetail.getQty()+"</Data><NamedCell");
            wb.println("         ss:Name=\"Print_Area\"/></Cell>");
            wb.println("       <Cell ss:StyleID=\"s57\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(arInvDetail.getTotalAmount(),"#,###.##")+"</Data><NamedCell");
            wb.println("         ss:Name=\"Print_Area\"/></Cell>");
            wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s57\"");
            wb.println("        ss:Formula=\"=IF(AND(ISNUMBER(RC[-2]),ISNUMBER(RC[-1])),RC[-2]*RC[-1],&quot;&quot;)\"><Data");
            wb.println("         ss:Type=\"Number\">100000</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
            wb.println("      </Row>");
        
        }

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s35\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s35\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s34\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s34\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s73\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"m15954538\"><Data");
        wb.println("         ss:Type=\"String\">Grand Total</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s68\" ss:Formula=\"=SUM(R[-3]C:R[-1]C[1])\"><Data");
        wb.println("         ss:Type=\"Number\">200000</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\" x:Ticked=\"1\">Transfer By</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">Bank Account</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+bankAcc.getBankName()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">Account Number</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+bankAcc.getAccNumber()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">Name</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">:</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell><Data ss:Type=\"String\">"+bankAcc.getName()+"</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
//        wb.println("      <Row ss:Height=\"12.75\">");
//        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
//        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
//        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
//        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s59\"><Data ss:Type=\"String\"></Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:MergeAcross=\"2\" ss:StyleID=\"s58\"><Data ss:Type=\"String\">Date:_______________</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s59\"><Data ss:Type=\"String\">Approve by</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:MergeAcross=\"2\" ss:StyleID=\"s58\"><Data ss:Type=\"String\">Prepare by</Data><NamedCell");
        wb.println("         ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"3\" ss:StyleID=\"s60\"><Data ss:Type=\"String\">( Customer )</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:MergeAcross=\"2\" ss:StyleID=\"s58\"><Data ss:Type=\"String\">( Management )</Data><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"><NamedCell ss:Name=\"Print_Area\"/></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("      </Row>");
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
        wb.println("        <ActiveCol>6</ActiveCol>");
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
