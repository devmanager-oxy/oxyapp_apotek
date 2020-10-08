/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
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
import com.project.crm.project.*;
import com.project.admin.DbUser;
import com.project.admin.User;

import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.session.ReportParameter;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.payroll.Employee;
import com.project.payroll.DbEmployee;
import com.project.util.NumberSpeller;

/**
 *
 * @author Roy
 */
public class RptCogsXLS extends HttpServlet {

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

        ReportParameter parameter = new ReportParameter();
        Vector list = new Vector();
        HttpSession session = request.getSession();

        try {
            parameter = (ReportParameter) session.getValue("REPORT_BALANCE_COGS_PARAMETER");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            list = (Vector) session.getValue("REPORT_BALANCE_COGS");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        Location l = new Location();
        try {
            l = DbLocation.fetchExc(parameter.getLocationId());
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <Created>2015-04-24T19:11:43Z</Created>");
        wb.println("      <LastSaved>2015-04-24T19:18:10Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>3345</WindowHeight>");
        wb.println("      <WindowWidth>14295</WindowWidth>");
        wb.println("      <WindowTopX>480</WindowTopX>");
        wb.println("      <WindowTopY>90</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s17\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s20\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s21\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s22\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27.75\"/>");
        wb.println("      <Column ss:Width=\"101.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"106.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"100.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">location :" + l.getName() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">Periode :" + JSPFormater.formatDate(parameter.getDateFrom()) + " - " + JSPFormater.formatDate(parameter.getDateTo()) + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">item_master_id</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">sku</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">total system</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">total real</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">diff</Data></Cell>");
        wb.println("      </Row>");
        if (list != null && list.size() > 0) {

            double tot1 = 0;
            double tot2 = 0;
            double tot3 = 0;
            for (int i = 0; i < list.size(); i++) {

                Vector print = (Vector) list.get(i);
                tot1 = tot1 + Double.parseDouble(String.valueOf(print.get(3)));
                tot2 = tot2 + Double.parseDouble(String.valueOf(print.get(4)));
                tot3 = tot3 + Double.parseDouble(String.valueOf(print.get(5)));

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + print.get(0) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + print.get(1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + print.get(2) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + Double.parseDouble(String.valueOf(print.get(3))) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + Double.parseDouble(String.valueOf(print.get(4))) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + Double.parseDouble(String.valueOf(print.get(5))) + "</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + tot1 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + tot2 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + tot3 + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>6</ActiveRow>");
        wb.println("      <ActiveCol>1</ActiveCol>");
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
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
