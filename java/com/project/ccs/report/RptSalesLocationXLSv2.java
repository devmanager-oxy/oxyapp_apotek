/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.sales.SalesDetail;
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
import com.project.ccs.session.SessCreditPayment;
import com.project.ccs.session.SessReportSales;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy Andika
 */
public class RptSalesLocationXLSv2 extends HttpServlet {

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

        ReportParameterLocation rp = new ReportParameterLocation();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameterLocation) session.getValue("REPORT_SALES_LOCATION");
        } catch (Exception e) {
        }

        Vector vLoca = new Vector();
        Vector vLoc = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);

        if (rp.getLocationId() == 0) {
            if (vLoc != null && vLoc.size() > 0) {
                vLoca = vLoc;
            }
        } else {
            vLoca = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + rp.getLocationId(), "");
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
        wb.println("      <Created>2014-04-10T15:09:47Z</Created>");
        wb.println("      <LastSaved>2014-04-10T15:37:51Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s107\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s108\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s109\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s115\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s116\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s118\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s120\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s125\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s126\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s127\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"81.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"102.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"97.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"99\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"39\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"81\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"79.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"42.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"83.25\"/>");
        wb.println("      <Row ss:Index=\"2\">");
        wb.println("      <Cell ss:StyleID=\"s125\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"3\">");
        wb.println("      <Cell ss:StyleID=\"s125\"><Data ss:Type=\"String\">REPORT BY LOCATION</Data></Cell>");
        wb.println("      </Row>");
        String period = JSPFormater.formatDate(rp.getStartDate(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getEndDate(), "dd-MMM-yyyy");
        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:StyleID=\"s125\"><Data ss:Type=\"String\">PERIODE : " + period + "</Data></Cell>");
        wb.println("      </Row>");



        for (int a = 0; a < vLoca.size(); a++) {

            Location loc = new Location();
            loc = (Location) vLoca.get(a);
            Vector listSales = SessReportSales.listSalesByLocation(rp.getStartDate(), rp.getEndDate(), loc.getOID(), rp.getSalesType(), rp.getPayType(), rp.getUserId());

            if (listSales != null && listSales.size() > 0) {

                try {
                    wb.println("      <Row >");
                    wb.println("      <Cell ss:StyleID=\"s125\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row >");
                    wb.println("      <Cell ss:StyleID=\"s125\"><Data ss:Type=\"String\">LOCATION : " + loc.getName().toUpperCase() + "</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">NO</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">DATE</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">NUMBER</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">CASHIER</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">DESCRIPTION</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">GROUP</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">CUSTOMER</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">QTY</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">AMOUNT</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s115\"><Data ss:Type=\"String\">DISC. ITEM</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">DISC. GLOBAL</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">SERVICE</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">PPN</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">CARD FEE</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">CARD DISC.</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">KWITANSI</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">HPP</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">PROFIT</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">PPH</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s116\"><Data ss:Type=\"String\">( % )</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s116\"><Data ss:Type=\"String\">AMOUNT</Data></Cell>");
                    wb.println("      <Cell ss:Index=\"21\" ss:StyleID=\"s117\"><Data ss:Type=\"String\">( % )</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">AMOUNT</Data></Cell>");
                    wb.println("      </Row>");

                    double gQty = 0;
                    double gAmount = 0;
                    double gDiscountAmount = 0;
                    double gDiscountGlolbalAmount = 0;
                    double gServiceGlolbalAmount = 0;
                    double gPpnGlolbalAmount = 0;
                    double gHpp = 0;
                    double gProfit = 0;
                    double gKwitansi = 0;
                    double gPphAmount = 0;
                    double gCardFee = 0;
                    double gCardDisc = 0;
                    double gKwitansiTot = 0;

                    if (listSales != null && listSales.size() > 0) {
                        for (int i = 0; i < listSales.size(); i++) {

                            Sales sales = (Sales) listSales.get(i);

                            Vector temp = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = " + sales.getOID(), "");
                            Customer cus = new Customer();
                            try {
                                cus = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception e) {
                            }

                            User usr = new User();
                            try {
                                usr = DbUser.fetch(sales.getUserId());
                            } catch (Exception e) {
                            }

                            if (temp != null && temp.size() > 0) {

                                double sQty = 0;
                                double sAmount = 0;
                                double sDiscountAmount = 0;
                                double sDiscountGlolbalAmount = 0;
                                double sServiceGlolbalAmount = 0;
                                double sPpnGlolbalAmount = 0;
                                double sHpp = 0;
                                double sProfit = 0;
                                double sKwitansi = 0;
                                double sPphAmount = 0;
                                //cc fee
                                double sCardFee = sales.getBiayaKartu();
                                int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());

                                gCardFee = gCardFee + sCardFee;

                                //cc diskon
                                double sCardDisc = sales.getDiskonKartu();
                                gCardDisc = gCardDisc + sCardDisc;

                                double amountTot = 0;
                                double dicGlobal = 0;

                                for (int xx = 0; xx < temp.size(); xx++) {
                                    SalesDetail sd = (SalesDetail) temp.get(xx);
                                    amountTot = amountTot + ((sd.getQty() * sd.getSellingPrice()) - sd.getDiscountAmount());
                                }

                                dicGlobal = (sales.getGlobalDiskon() * 100) / amountTot;

                                for (int xx = 0; xx < temp.size(); xx++) {

                                    SalesDetail sd = (SalesDetail) temp.get(xx);

                                    ItemMaster im = new ItemMaster();
                                    try {
                                        im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                    } catch (Exception e) {
                                    }

                                    ItemGroup ig = new ItemGroup();
                                    try {
                                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                    } catch (Exception e) {
                                    }

                                    double dQty = 0;
                                    double dPrice = 0;
                                    double dAmount = 0;
                                    double dDiscountPercent = 0;
                                    double dDiscountAmount = 0;
                                    double dDiscountGlolbalAmount = 0;
                                    double dServiceGlolbalAmount = 0;
                                    double dPpnGlolbalAmount = 0;
                                    double dHpp = 0;
                                    double dProfit = 0;
                                    double dKwitansi = 0;
                                    double dPphPercent = 0;
                                    double dPphAmount = 0;

                                    dQty = sd.getQty();
                                    dPrice = sd.getSellingPrice();
                                    dAmount = dQty * dPrice;
                                    dDiscountPercent = sd.getDiscountPercent();
                                    dDiscountAmount = sd.getDiscountAmount();

                                    dKwitansi = dAmount - dDiscountAmount;

                                    dDiscountGlolbalAmount = 0;
                                    if (sales.getGlobalDiskon() != 0) {
                                        dDiscountGlolbalAmount = dKwitansi * (dicGlobal / 100);
                                    }
                                    dServiceGlolbalAmount = 0;
                                    dKwitansi = dKwitansi - dDiscountGlolbalAmount;
                                    if (sales.getServicePercent() != 0) {
                                        dServiceGlolbalAmount = dKwitansi * (sales.getServicePercent() / 100);
                                    }
                                    dKwitansi = dKwitansi + dServiceGlolbalAmount;
                                    dPpnGlolbalAmount = 0;
                                    if (sales.getVatPercent() != 0) {
                                        dPpnGlolbalAmount = dKwitansi * (sales.getVatPercent() / 100);
                                    }
                                    dKwitansi = dKwitansi + dPpnGlolbalAmount;
                                    dHpp = dQty * sd.getCogs();
                                    dProfit = dKwitansi - dHpp;
                                    dPphPercent = 0;
                                    dPphAmount = 0;

                                    //jika retur maka minus
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        dQty = dQty * -1;
                                        dPrice = dPrice * -1;
                                        dAmount = dAmount * -1;
                                        dDiscountPercent = dDiscountPercent * -1;
                                        dDiscountAmount = dDiscountAmount * -1;
                                        dDiscountGlolbalAmount = dDiscountGlolbalAmount * -1;
                                        dServiceGlolbalAmount = dServiceGlolbalAmount * -1;
                                        dPpnGlolbalAmount = dPpnGlolbalAmount * -1;
                                        dHpp = dHpp * -1;
                                        dProfit = dProfit * -1;
                                        dKwitansi = dKwitansi * -1;
                                        dPphPercent = 0;
                                        dPphAmount = 0;
                                    }

                                    //sub total
                                    sQty = sQty + dQty;
                                    sAmount = sAmount + dAmount;
                                    sDiscountAmount = sDiscountAmount + dDiscountAmount;
                                    sDiscountGlolbalAmount = sDiscountGlolbalAmount + dDiscountGlolbalAmount;
                                    sServiceGlolbalAmount = sServiceGlolbalAmount + dServiceGlolbalAmount;
                                    sPpnGlolbalAmount = sPpnGlolbalAmount + dPpnGlolbalAmount;
                                    sHpp = sHpp + dHpp;
                                    sProfit = sProfit + dProfit;
                                    sKwitansi = sKwitansi + dKwitansi;
                                    //sPphPercent = 0;
                                    sPphAmount = 0;

                                    //grand total
                                    gQty = gQty + dQty;
                                    gAmount = gAmount + dAmount;
                                    gDiscountAmount = gDiscountAmount + dDiscountAmount;
                                    gDiscountGlolbalAmount = gDiscountGlolbalAmount + dDiscountGlolbalAmount;
                                    gServiceGlolbalAmount = gServiceGlolbalAmount + dServiceGlolbalAmount;
                                    gPpnGlolbalAmount = gPpnGlolbalAmount + dPpnGlolbalAmount;
                                    gHpp = gHpp + dHpp;
                                    gProfit = gProfit + dProfit;
                                    gKwitansi = gKwitansi + dKwitansi;
                                    gPphAmount = 0;

                                    wb.println("      <Row>");
                                    if (xx == 0) {
                                        wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + sales.getNumber() + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\">" + usr.getFullName() + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    }
                                    wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\">" + im.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\">" + ig.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\">" + cus.getName() + "</Data></Cell>");

                                    if (temp.size() == 1) {
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dQty + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dPrice + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dDiscountPercent + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dDiscountAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dDiscountGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dServiceGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dPpnGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sCardFee + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sCardDisc + "</Data></Cell>");
                                        if (isFeePaidByComp == 0) {
                                            gKwitansiTot = gKwitansiTot + (dKwitansi - sCardDisc + sCardFee);
                                            wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + (dKwitansi - sCardDisc + sCardFee) + "</Data></Cell>");
                                        } else {
                                            gKwitansiTot = gKwitansiTot + (sKwitansi - sCardDisc);
                                            wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + (dKwitansi - sCardDisc) + "</Data></Cell>");
                                        }
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dHpp + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dProfit + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dPphPercent + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + dPphAmount + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dQty + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dPrice + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dDiscountPercent + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dDiscountAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dDiscountGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dServiceGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dPpnGlolbalAmount + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                        if (isFeePaidByComp == 0) {
                                            wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + (dKwitansi - sCardDisc + sCardFee) + "</Data></Cell>");
                                        } else {
                                            wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + (dKwitansi - sCardDisc) + "</Data></Cell>");
                                        }
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dHpp + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dProfit + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dPphPercent + "</Data></Cell>");
                                        wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + dPphAmount + "</Data></Cell>");
                                    }
                                    wb.println("      </Row>");
                                }

                                if (temp.size() > 1) {
                                    wb.println("      <Row>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sQty + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sAmount + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sDiscountAmount + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sDiscountGlolbalAmount + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sServiceGlolbalAmount + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sPpnGlolbalAmount + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sCardFee + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sCardDisc + "</Data></Cell>");
                                    if (isFeePaidByComp == 0) {
                                        gKwitansiTot = gKwitansiTot + (sKwitansi - sCardDisc + sCardFee);
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + (sKwitansi - sCardDisc + sCardFee) + "</Data></Cell>");
                                    } else {
                                        gKwitansiTot = gKwitansiTot + (sKwitansi - sCardDisc);
                                        wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + (sKwitansi - sCardDisc) + "</Data></Cell>");
                                    }
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sHpp + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sProfit + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + sPphAmount + "</Data></Cell>");
                                    wb.println("      </Row>");
                                }
                            }
                        }
                    }

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s115\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gQty + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s127\"/>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gDiscountAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gDiscountGlolbalAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gServiceGlolbalAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gPpnGlolbalAmount + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gCardFee + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gCardDisc + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + (gKwitansiTot) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gHpp + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gProfit + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s118\"><Data ss:Type=\"Number\">" + gPphAmount + "</Data></Cell>");
                    wb.println("      </Row>");

                } catch (Exception e) {
                }
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
        wb.println("      <ActiveRow>21</ActiveRow>");
        wb.println("      <ActiveCol>12</ActiveCol>");
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
            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
