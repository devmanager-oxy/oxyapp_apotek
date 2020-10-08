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
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;

import com.project.general.DbCustomer;
import com.project.general.DbIndukCustomer;
import com.project.general.DbLocation;
import com.project.general.IndukCustomer;
import com.project.general.Location;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class ReportSetoranXLS extends HttpServlet {

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

        long userId = 0;
        User user = new User();
        Vector result = new Vector();
        Vector resultParameter = new Vector();
        Location location = new Location();
        HttpSession session = request.getSession();
        try {
            result = (Vector) session.getValue("REPORT_SETORAN_KASIR");
        } catch (Exception e) {
        }

        Date startDate = new Date();
        Date endDate = new Date();
        long locationId = 0;
        try {
            resultParameter = (Vector) session.getValue("REPORT_SETORAN_KASIR_PARAMETER");
            locationId = Long.parseLong(String.valueOf("" + resultParameter.get(0)));
            startDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(1)), "dd/MM/yyyy");
            endDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(2)), "dd/MM/yyyy");
        } catch (Exception e) {
        }

        try {
            location = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
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
        wb.println("      <LastPrinted>2015-03-02T03:54:07Z</LastPrinted>");
        wb.println("      <Created>2015-03-02T03:41:47Z</Created>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>3345</WindowHeight>");
        wb.println("      <WindowWidth>11415</WindowWidth>");
        wb.println("      <WindowTopX>0</WindowTopX>");
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
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"54.75\"/>");
        wb.println("      <Column ss:Width=\"72.75\" ss:Span=\"2\"/>");
        wb.println("      <Column ss:Index=\"5\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63\"/>");
        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">SELISIH SETORAN KASIR</Data></Cell>");
        wb.println("      </Row>");
        if(location.getOID() != 0){
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">LOCATION : "+location.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        }
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">PERIODE " + JSPFormater.formatDate(startDate, "dd MMM") + " - " + JSPFormater.formatDate(endDate, "dd MMM") + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:Index=\"6\" ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">TANGGAL</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">SYSTEM</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">CASH</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">CREDIT CARD</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">DEBIT CARD</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">CREDIT (BON)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">CASH BACK</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">SETORAN TOKO</Data></Cell>");        
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">SELISIH</Data></Cell>");
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {
            double totCash = 0;
            double totCard = 0;
            double totCashBack = 0;
            double totSetoran = 0;
            double totSystem = 0;
            double totSelisih = 0;
            double totDebit = 0;
            double totBon = 0;

            for (int i = 0; i < result.size(); i++) {
                Vector tmp = (Vector) result.get(i);
                Date date = JSPFormater.formatDate(String.valueOf("" + tmp.get(0)), "dd/MM/yyyy");
                double cash = Double.parseDouble(String.valueOf("" + tmp.get(1)));
                double card = Double.parseDouble(String.valueOf("" + tmp.get(2)));
                double cashBack = Double.parseDouble(String.valueOf("" + tmp.get(3)));
                double setoran = Double.parseDouble(String.valueOf("" + tmp.get(4)));
                double system = Double.parseDouble(String.valueOf("" + tmp.get(5)));
                double selisih = Double.parseDouble(String.valueOf("" + tmp.get(6)));
                double debit = Double.parseDouble(String.valueOf("" + tmp.get(7)));
                double bon = Double.parseDouble(String.valueOf("" + tmp.get(8)));

                totCash = totCash + cash;
                totCard = totCard + card;
                totCashBack = totCashBack + cashBack;
                totSetoran = totSetoran + setoran;
                totSystem = totSystem + system;
                totSelisih = totSelisih + selisih;
                totDebit = totDebit + debit;
                totBon = totBon + bon;                

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(date, "dd-MMM") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + system + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + cash + "</Data></Cell>");                
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + card + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + debit + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + bon + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + cashBack + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + setoran + "</Data></Cell>");                
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + selisih + "</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
            wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totSystem + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totCash + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totCard + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totDebit + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totBon + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totCashBack + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totSetoran + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + totSelisih + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">Jimbaran, "+JSPFormater.formatDate(new Date(), "dd MMMM yyyy")+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\">Dibuat Oleh,</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">"+user.getFullName()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>4</ActiveRow>");
        wb.println("      <ActiveCol>9</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}

