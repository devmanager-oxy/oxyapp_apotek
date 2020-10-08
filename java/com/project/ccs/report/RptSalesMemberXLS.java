/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.ReportSalesMember;
import com.project.ccs.session.SessReportSales;
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;
import com.project.general.DbCustomer;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.system.DbSystemProperty;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptSalesMemberXLS extends HttpServlet {

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

        response.setContentType("application/x-msexcel");
        Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameter) session.getValue("REPORT_MEMBER");
        } catch (Exception e) {}

        try {
            result = SessReportSales.ReportSalesByMember(rp.getDateFrom(), rp.getDateTo(), rp.getIgnore(), rp.getMember(), rp.getLocationId(), rp.getCustomerId());
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
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
        wb.println("      <Created>2014-03-06T05:32:19Z</Created>");
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
        wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s62\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"125.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"108\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"128.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"111\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"94.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"98.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        if (rp.getLocationId() != 0) {
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(rp.getLocationId());
            } catch (Exception e) {
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">STORE : " + loc.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (rp.getCustomerId() != 0) {
            Customer c = new Customer();
            try {
                c = DbCustomer.fetchExc(rp.getCustomerId());
            } catch (Exception e) {
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">MEMBER : " + c.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PERIODE : " + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Member  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Store  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Invoce Date  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Invoce No  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Total  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Cash  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Debit  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Credit  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Receivable</Data></Cell>");
        wb.println("      </Row>");

        long memberId = 0;
        long locId = 0;
        Date invDt = null;

        double totAmountMember = 0;
        double totAmount = 0;
        int totMember = 0;
        int grandTotMember = 0;

        for (int i = 0; i < result.size(); i++) {

            ReportSalesMember rsm = (ReportSalesMember) result.get(i);

            if (memberId != rsm.getCustomerId() && memberId != 0) {
                wb.println("      <Row>");
                wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Total By Member</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmountMember + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmountMember + "</Data></Cell>");
                wb.println("      </Row>");
            }

            if (memberId != rsm.getCustomerId()) {
                locId = 0;
                invDt = null;
                totAmountMember = 0;
                totMember = 0;
            }

            double amount = 0;
            if (rsm.getType() == DbSales.TYPE_CASH || rsm.getType() == DbSales.TYPE_CREDIT) {
                amount = rsm.getAmount();
            } else {
                amount = rsm.getAmount() * -1;
            }

            totAmount = totAmount + amount;
            totAmountMember = totAmountMember + amount;

            String nameCst = "";
            String nameLoc = "";
            String date = "";
            if (memberId != rsm.getCustomerId()) {
                nameCst = rsm.getNameCustomer();
            }

            if (locId != rsm.getLocationId()) {
                nameLoc = rsm.getLocationName();
            }

            if (invDt == null || invDt.compareTo(rsm.getDateTransaction()) != 0) {
                date = JSPFormater.formatDate(rsm.getDateTransaction(), "yyyy-MM-dd");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + nameCst + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + nameLoc + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + date + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">" + rsm.getNumber() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">0</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">0</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">0</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
            wb.println("      </Row>");

            totMember = totMember + 1;
            grandTotMember = grandTotMember + 1;

            memberId = rsm.getCustomerId();
            invDt = rsm.getDateTransaction();
            locId = rsm.getLocationId();

        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Total by Member : " + totMember + " Invoice</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmountMember + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmountMember + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Grand Total : " + grandTotMember + " Invoice</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">0</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
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
        wb.println("      <ActiveRow>19</ActiveRow>");
        wb.println("      <ActiveCol>4</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table >");
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
        wb.println("      <Table >");
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
        wb.println("      ");
        wb.flush();
        wb.flush();

        wb.flush();

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
            String str = "";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
