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
public class RptCustomerXls extends HttpServlet {

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
        Company company = new Company();
        try {
            company = DbCompany.fetchExc(compId);
        } catch (Exception e) {
            System.out.println(e);
        }
        
        Vector result = new Vector();
        try {
            HttpSession session = request.getSession();
            result = (Vector) session.getValue("RPT_CUSTOMER");
            lang = JSPRequestValue.requestInt(request, "lang"); 
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        String title = "";
        if(lang == 0){
            title = "LAPORAN KONSUMEN";
        }else{
            title = "CUSTOMER REPORT";
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
        wb.println("      <Created>2012-07-28T14:56:55Z</Created>");
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
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior ss:Color=\"#D7E4BC\" ss:Pattern=\"Solid\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Medium Date\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:Index=\"2\" ss:AutoFitWidth=\"0\" ss:Width=\"76.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"83.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+title+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "No":"No")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Tangg. Registrasi":"Reg. Date")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Penjual":"Sales Person")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Customer":"Customer")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Alamat":"Address")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Nomor Id":"ID Number")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Nomor Ph.":"Ph. Number")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Hp":"Hp")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Email":"Email")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Project":"Project")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Tower":"Tower")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Lot":"Lot")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Tipe":"Type")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+(lang==0 ? "Status":"Status")+"</Data></Cell>");
        wb.println("      </Row>");
        
        if (result != null && result.size() > 0) {
             for (int i = 0; i < result.size(); i++) {

                    RptCustomer rptCust = (RptCustomer) result.get(i);
                    int number = i + 1;
                    String dt = rptCust.getRegDate()==null? " " : JSPFormater.formatDate(rptCust.getRegDate(), "dd MMMM yyyy");
            
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">"+number+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+dt+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getSalesPerson()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getCustomerName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getAlamat()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getIdNumber()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getPhNumber()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getHp()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getEmail()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getProject()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getTower()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+rptCust.getLot()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+DbSalesData.paymentTypeKey[rptCust.getPaymentType()]+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+DbSalesData.statusKey[rptCust.getDataStatus()]+"</Data></Cell>");
        wb.println("      </Row>");
             }
        }
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
        wb.println("      <ActiveRow>11</ActiveRow>");
        wb.println("      <ActiveCol>5</ActiveCol>");
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
