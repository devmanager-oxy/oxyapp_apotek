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

import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.ccs.session.ReportParameterLocation;
import com.project.ccs.sql.SQLGeneral;
import com.project.ccs.sql.SalesClosing;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;

/**
 *
 * @author Roy Andika
 */
public class RptSalesClosingXLS extends HttpServlet {

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
        Vector vList = new Vector();
        Vector vList2 = new Vector();

        HttpSession session = request.getSession();
        try {
            vList = (Vector) session.getValue("REPORT_SALES_CLOSING");
        } catch (Exception e) {
        }

        try {
            vList2 = (Vector) session.getValue("REPORT_SALES_CLOSING2");
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
        wb.println("      <Author>PNCI</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2013-05-11T14:26:40Z</Created>");
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
        wb.println("      <Style ss:ID=\"s66\">");
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
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
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
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:Index=\"2\" ss:AutoFitWidth=\"0\" ss:Width=\"81.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"68.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"81.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"79.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63.75\"/>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">CLOSING SALES DATA</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        // tootal
        double totSubCash = 0;
        double totSubCard = 0;
        double totSubBon = 0;
        double totSubDiscount = 0;
        double totSubRetur = 0;
        double totSubAmount = 0;

        // sub total
        double subCash = 0;
        double subCard = 0;
        double subBon = 0;
        double subDiscount = 0;
        double subRetur = 0;
        double subAmount = 0;
        boolean isOK = false;

        if (vList != null && vList.size() > 0) {
            isOK = true;
            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">SALES DATA</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">NO  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">INVOICE  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">DATE  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">MEMBER  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CASH  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CREDIT CARD  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CREDIT(BON)  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">DISCOUNT  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">RETUR  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">AMOUNT</Data></Cell>");
            wb.println("      </Row>");
            for (int k = 0; k < vList.size(); k++) {
                SalesClosing salesClosing = (SalesClosing) vList.get(k);

                subCash = subCash + salesClosing.getCash();
                subCard = subCard + salesClosing.getCCard();
                subBon = subBon + salesClosing.getBon();
                subDiscount = subDiscount + salesClosing.getDiscount();
                subRetur = subRetur + salesClosing.getRetur();
                subAmount = subAmount + salesClosing.getAmount();

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + (k + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">" + salesClosing.getInvoiceNumber() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">" + salesClosing.getTglJam() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">" + salesClosing.getMember() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getCash() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getCCard() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getBon() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getDiscount() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getRetur() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getAmount() + "</Data></Cell>");
                wb.println("      </Row>");
            }

            totSubCash = subCash;
            totSubCard = subCard;
            totSubBon = subBon;
            totSubDiscount = subDiscount;
            totSubRetur = subRetur;
            totSubAmount = subAmount;
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">SUB TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subCash + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subCard + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subBon + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subDiscount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subRetur + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subAmount + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
        }

        if (vList2 != null && vList2.size() > 0) {
            isOK = true;
            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">GROOMING</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">NO  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">INVOICE  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">DATE  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">MEMBER  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CASH  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CREDIT CARD  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">CREDIT(BON)  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">DISCOUNT  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">RETUR  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">AMOUNT</Data></Cell>");
            wb.println("      </Row>");
            for (int k = 0; k < vList2.size(); k++) {
                SalesClosing salesClosing = (SalesClosing) vList2.get(k);

                subCash = subCash + salesClosing.getCash();
                subCard = subCard + salesClosing.getCCard();
                subBon = subBon + salesClosing.getBon();
                subDiscount = subDiscount + salesClosing.getDiscount();
                subRetur = subRetur + salesClosing.getRetur();
                subAmount = subAmount + salesClosing.getAmount();

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + (k + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">" + salesClosing.getInvoiceNumber() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">" + salesClosing.getTglJam() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">" + salesClosing.getMember() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getCash() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getCCard() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getBon() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getDiscount() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getRetur() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + salesClosing.getAmount() + "</Data></Cell>");
                wb.println("      </Row>");
            }

            totSubCash = subCash;
            totSubCard = subCard;
            totSubBon = subBon;
            totSubDiscount = subDiscount;
            totSubRetur = subRetur;
            totSubAmount = subAmount;
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">SUB TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subCash + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subCard + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subBon + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subDiscount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subRetur + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + subAmount + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
        }

        if (isOK) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubCash + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubCard + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubBon + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubDiscount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubRetur + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"Number\">" + totSubAmount + "</Data></Cell>");
            wb.println("      </Row>");

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
        wb.println("      <ActiveRow>16</ActiveRow>");
        wb.println("      <ActiveCol>2</ActiveCol>");
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
