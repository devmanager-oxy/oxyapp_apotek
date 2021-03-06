/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.report;
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
import com.project.simprop.property.DbSalesData;
import com.project.simprop.session.RptCustomer;
import com.project.simprop.session.RptPayment;

/**
 *
 * @author Roy Andika
 */
public class RptPaymentXls extends HttpServlet {
    
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

    String XMLSafe(String in) {
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
        long compId = JSPRequestValue.requestLong(request, "oid");
        int lang = 0;
        
        System.out.println("CompanyId : " + compId);
        Vector vCompany = DbCompany.listAll();
        Company company = new Company();
        
        try {
            company = (Company)vCompany.get(0);
        } catch (Exception e) {
            System.out.println(e);
        }
        
        Vector result = new Vector();
        try {
            HttpSession session = request.getSession();
            result = (Vector) session.getValue("RPT_PAYMENT");
            lang = JSPRequestValue.requestInt(request, "lang"); 
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        String title = "";
        if(lang == 0){
            title = "LAPORAN PENJUALAN";
        }else{
            title = "SALES REPORT";
        }
        
        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }
        
        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));
        
        
        wb.println("      <?xml version=\"1.0\"?>");
        wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>PNCI</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2012-08-05T12:57:30Z</Created>");
        wb.println("      <Company>PNCI</Company>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8895</WindowHeight>");
        wb.println("      <WindowWidth>18975</WindowWidth>");
        wb.println("      <WindowTopX>120</WindowTopX>");
        wb.println("      <WindowTopY>120</WindowTopY>");
        wb.println("      <ProtectStructure>False</ProtectStructure>");
        wb.println("      <ProtectWindows>False</ProtectWindows>");
        wb.println("      </ExcelWorkbook>");
        wb.println("      <Styles>");
        wb.println("      <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Borders>");    
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"32.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"81\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:Index=\"5\" ss:AutoFitWidth=\"0\" ss:Width=\"64.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"105\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"118.5\"/>");
        wb.println("      <Row ss:Index=\"2\">");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+title+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\" ss:StyleID=\"s63\">");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "No":"No")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Penjual":"Sales Person")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Customer":"Customer")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Lot":"Lot")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Tanggal Faktur":"Inv. Date")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Nomor Faktur":"Inv. Number")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Penjelasan Faktur":"Inv. Description")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Jumlah Faktur":"Amount Inv.")+"(Rp)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Tanggal Pembayaran":"Payment Date")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Pembayaran#":"Payment#")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+(lang==0 ? "Jumlah Pembayaran":"Payment Amount")+"(Rp)</Data></Cell>");
        wb.println("      </Row>");
    double totInv = 0;
    double totPemb = 0;
    long stiOid = 0;
    int no = 1;
    for (int i = 0; i < result.size(); i++) {
        RptPayment rptPay = (RptPayment) result.get(i);        
        totPemb = totPemb + rptPay.getPaymentAmount();  
        
        wb.println("      <Row>");
        if(stiOid == 0 || rptPay.getInvoiceId() != stiOid){ 
            stiOid = rptPay.getInvoiceId();
            totInv = totInv + rptPay.getInvAmount();
            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">"+no+"</Data></Cell>");
            no++;
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+rptPay.getSalesPerson()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+rptPay.getCustomer()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+rptPay.getProperty()+","+rptPay.getTower()+","+rptPay.getFloor()+","+rptPay.getLot()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(rptPay.getInvDate(), "dd MMMM yyyy")+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+rptPay.getInvNo()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+rptPay.getInvDesc()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rptPay.getInvAmount(), "#,###.##")+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(rptPay.getPaymentDate(), "dd MMMM yyyy")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">"+rptPay.getPaymentNo()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rptPay.getPaymentAmount(), "#,###.##")+"</Data></Cell>");
        wb.println("      </Row>");
    
    }
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"7\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(totInv, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(totPemb, "#,###.##")+"</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>13</ActiveRow>");
        wb.println("      <ActiveCol>6</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet3\">");
        wb.println("      <Table>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      </Workbook>");
        
        wb.flush();
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

    public static void main(String[] arg) {
        try {
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

}
