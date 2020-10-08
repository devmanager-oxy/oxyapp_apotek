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

/**
 *
 * @author Roy Andika
 */
public class RptSalesXls extends HttpServlet {
    
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
            result = (Vector) session.getValue("RPT_SALES");
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
        wb.println("      <Created>2012-08-05T11:55:26Z</Created>");
        wb.println("      <LastSaved>2012-08-05T12:03:36Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior ss:Color=\"#DDD9C3\" ss:Pattern=\"Solid\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
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
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"79.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"76.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"95.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">"+title+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\">");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "No":"No")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Tgl. Transaksi":"Date Transaction")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Customer":"Customer")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Project":"Project")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Tower":"Tower")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Lot":"Lot")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Tipe":"Type")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Jumlah":"Amount")+"(Rp)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Diskon":"Discount")+"(Rp)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Ppn":"Vat")+"(Rp)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Total":"Total")+"(Rp)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+(lang==0 ? "Statu":"Status")+"</Data></Cell>");
        wb.println("      </Row>");
        
    double amount = 0;
    double discount = 0;
    double ppn = 0;
    double total = 0;

    for (int i = 0; i < result.size(); i++) {

        RptCustomer rptCust = (RptCustomer) result.get(i);
        double finalPrice = 0;
        finalPrice = rptCust.getAmount() - rptCust.getDiscount() + rptCust.getVat();

        amount = amount + rptCust.getAmount();
        discount = discount + rptCust.getDiscount();
        ppn = ppn + rptCust.getVat();
        total = total + finalPrice;
        int number = i + 1;
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+number+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(rptCust.getRegDate(), "dd MMMM yyyy")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rptCust.getCustomerName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rptCust.getProject()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rptCust.getTower()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rptCust.getFloor()+","+rptCust.getLot()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+DbSalesData.paymentTypeKey[rptCust.getPaymentType()]+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rptCust.getAmount(), "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rptCust.getDiscount(), "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rptCust.getVat(), "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(finalPrice, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+DbSalesData.statusKey[rptCust.getDataStatus()]+"</Data></Cell>");
        wb.println("      </Row>");
    }
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"7\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+(lang==0 ? "TOTAL":"TOTAL")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(amount, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(discount, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(ppn, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(total, "#,###.##")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
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
        wb.println("      <LeftColumnVisible>2</LeftColumnVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>10</ActiveRow>");
        wb.println("      <ActiveCol>10</ActiveCol>");
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
