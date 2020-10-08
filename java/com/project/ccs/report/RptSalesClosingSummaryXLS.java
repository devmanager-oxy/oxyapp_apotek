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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;

/**
 *
 * @author Roy
 */
public class RptSalesClosingSummaryXLS extends HttpServlet {

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

        HttpSession session = request.getSession();
        String strDate = "";
        try {
            vList = (Vector) session.getValue("REPORT_SALES_CLOSING_SUMMARY");
        } catch (Exception e) {
        }
        
        try{
            strDate = (String) session.getValue("PARAMETER_SALES_CLOSING_SUMMARY");
        }catch(Exception e){}

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
        wb.println("      <Created>2014-12-22T22:48:33Z</Created>");
        wb.println("      <LastSaved>2014-12-22T23:00:27Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8445</WindowHeight>");
        wb.println("      <WindowWidth>20055</WindowWidth>");
        wb.println("      <WindowTopX>240</WindowTopX>");
        wb.println("      <WindowTopY>105</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
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
        wb.println("      <Style ss:ID=\"s87\">");
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
        wb.println("      <Style ss:ID=\"s89\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s93\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s95\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s98\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s99\" ss:Parent=\"s16\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s104\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s106\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s111\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"147.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"114\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"68.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"64.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s106\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if(cmp.getAddress() != null && cmp.getAddress().length() > 0){
            wb.println("      <Row ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">Date : " + strDate + "</Data></Cell>");
        wb.println("      </Row>");        
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s104\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        if (vList != null && vList.size() > 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">LOCATION </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">SHIFT </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">USER </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">AMOUNT </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">DISCOUNT </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">TOTAL </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">CASH </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">CREDIT CARD </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">DEBIT CARD </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">CASH BACK </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">CREDIT (BON) </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">RETUR</Data></Cell>");
            wb.println("      </Row>");

            double totCash = 0;
            double totCard = 0;
            double totDebit = 0;
            double totCashBack = 0;
            double totBon = 0;
            double totDiscount = 0;
            double totRetur = 0;
            double totAmount = 0;
            double totKwitansi = 0;

            for (int i = 0; i < vList.size(); i++) {
                Vector tmpPrint = (Vector) vList.get(i);

                double subCash = 0;
                double subCard = 0;
                double subDebit = 0;
                double subCashBack = 0;
                double subBon = 0;
                double subDiscount = 0;
                double subRetur = 0;
                double subAmount = 0;
                double subKwitansi = 0;

                if (tmpPrint != null && tmpPrint.size() > 0) {
                    for (int x = 0; x < tmpPrint.size(); x++) {
                        Vector print = (Vector) tmpPrint.get(x);

                        String locName = "";
                        String shift = "";
                        String user = "";

                        double amount = 0;
                        double discount = 0;
                        double total = 0;
                        double cash = 0;
                        double creditCard = 0;
                        double debitCard = 0;
                        double cashBack = 0;
                        double credit = 0;
                        double retur = 0;

                        try {
                            locName = String.valueOf(print.get(0));
                        } catch (Exception e) {
                        }

                        try {
                            shift = String.valueOf(print.get(1));
                        } catch (Exception e) {
                        }

                        try {
                            user = String.valueOf(print.get(2));
                        } catch (Exception e) {
                        }

                        try {
                            amount = Double.parseDouble(String.valueOf(print.get(3)));
                        } catch (Exception e) {
                        }

                        try {
                            discount = Double.parseDouble(String.valueOf(print.get(4)));
                        } catch (Exception e) {
                        }

                        try {
                            total = Double.parseDouble(String.valueOf(print.get(5)));
                        } catch (Exception e) {
                        }

                        try {
                            cash = Double.parseDouble(String.valueOf(print.get(6)));
                        } catch (Exception e) {
                        }

                        try {
                            creditCard = Double.parseDouble(String.valueOf(print.get(7)));
                        } catch (Exception e) {
                        }

                        try {
                            debitCard = Double.parseDouble(String.valueOf(print.get(8)));
                        } catch (Exception e) {
                        }

                        try {
                            cashBack = Double.parseDouble(String.valueOf(print.get(9)));
                        } catch (Exception e) {
                        }

                        try {
                            credit = Double.parseDouble(String.valueOf(print.get(10)));
                        } catch (Exception e) {
                        }

                        try {
                            retur = Double.parseDouble(String.valueOf(print.get(11)));
                        } catch (Exception e) {
                        }

                        subAmount = subAmount + amount;
                        subDiscount = subDiscount + discount;
                        subKwitansi = subKwitansi + total;
                        subCash = subCash + cash;
                        subCard = subCard + creditCard;
                        subDebit = subDebit + debitCard;
                        subCashBack = subCashBack + cashBack;
                        subBon = subBon + credit;
                        subRetur = subRetur + retur;

                        totAmount = totAmount + amount;
                        totDiscount = totDiscount + discount;
                        totKwitansi = totKwitansi + total;
                        totCash = totCash + cash;
                        totCard = totCard + creditCard;
                        totDebit = totDebit + debitCard;
                        totCashBack = totCashBack + cashBack;
                        totBon = totBon + credit;
                        totRetur = totRetur + retur;

                        wb.println("      <Row>");
                        if (x == 0) {
                            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + locName + "</Data></Cell>");
                        } else {
                            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
                        }
                        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + shift + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + user + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + discount + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + cash + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + creditCard + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + debitCard + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + cashBack + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + credit + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + retur + "</Data></Cell>");
                        wb.println("      </Row>");
                    }

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">SUB TOTAL</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subDiscount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subKwitansi + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subCash + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subCard + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subDebit + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subCashBack + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subBon + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + subRetur + "</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s98\"/>");
                    wb.println("      <Cell ss:StyleID=\"s98\"/>");
                    wb.println("      <Cell ss:StyleID=\"s98\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      <Cell ss:StyleID=\"s99\"/>");
                    wb.println("      </Row>");
                }
            }
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totDiscount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totKwitansi + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totCash + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totCard + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totDebit + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totCashBack + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totBon + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">" + totRetur + "</Data></Cell>");
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
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <VerticalResolution>0</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>19</ActiveRow>");
        wb.println("      <ActiveCol>1</ActiveCol>");
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

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
