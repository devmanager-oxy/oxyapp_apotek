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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy Andika
 */
public class RptSalesLocationXLS extends HttpServlet {

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
        Vector vlocation = new Vector();
        try {
            HttpSession session = request.getSession();
            rp = (ReportParameterLocation) session.getValue("REPORT_SALES_LOCATION");
            vlocation = (Vector) session.getValue("VECTOR_LOCATION");
        } catch (Exception e) {
        }

        Vector vLoca = new Vector();
        Vector vLoc = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);

        //if (rp.getLocationId() == 0) {
        //    if (vLoc != null && vLoc.size() > 0) {
        //        vLoca = vLoc;
        //    }
        // } else {//
        //vLoca = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + rp.getLocationId(), "");
        // }
        vLoca = vlocation;

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
        wb.println("      <Created>2013-05-05T06:08:59Z</Created>");
        wb.println("      <LastSaved>2013-05-05T06:22:52Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s62\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s65\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
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
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
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


        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"36\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"68.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("      <Column ss:Index=\"9\" ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"105.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"68.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:Index=\"17\" ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");

        wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">REPORT BY LOCATION</Data></Cell>");
        wb.println("      </Row>");

        String period = JSPFormater.formatDate(rp.getStartDate(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getEndDate(), "dd-MMM-yyyy");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PERIODE : " + period + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        for (int a = 0; a < vLoca.size(); a++) {

            Location loc = new Location();
            loc = (Location) vLoca.get(a);

            String whereClause = "";

            if (whereClause != null && whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(rp.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and " + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(rp.getEndDate(), "yyyy-MM-dd") + " 23:59:59'";


            if (whereClause != null && whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + loc.getOID();

            if (rp.getSalesType() != -1) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbSales.colNames[DbSales.COL_TYPE] + " =" + rp.getSalesType();
            }
            if (whereClause != null && whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbSales.colNames[DbSales.COL_SALES_TYPE] + " = " + DbSales.TYPE_NON_CONSIGMENT;
            Vector listSales = DbSales.list(0, 0, whereClause, DbSales.colNames[DbSales.COL_DATE] + "," + DbSales.colNames[DbSales.COL_NUMBER]);

            if (listSales != null && listSales.size() > 0) {


                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">LOCATION : " + loc.getName().toUpperCase() + "</Data></Cell>");
                wb.println("      </Row>");

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">No  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Date  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Sales No.  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">User</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Description  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Group  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Customer  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Qty  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Price  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Amount  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Discount%  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Discount Amount  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">PPN  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Kwitansi  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">HPP  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">Laba  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">PPH%  </Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">PPH Amount</Data></Cell>");
                wb.println("      </Row>");

                double totalQty = 0;
                double totalAmount = 0;
                double totalDiscountPercent = 0;

                double totalVat = 0;
                double grandTotal = 0;
                double grandDiscountAmount = 0;
                double grandTotalKwitansi = 0;
                double grandTotalHpp = 0;
                double granTotalLaba = 0;
                double totallaba = 0;
                double grandTotalDiscountPercen = 0;
                double totalhpp = 0;
                double totalKwitansi = 0;
                double totalDiscount_invoice = 0;

                if (listSales != null && listSales.size() > 0) {
                    for (int i = 0; i < listSales.size(); i++) {

                        Sales sales = (Sales) listSales.get(i);
                        Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");
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

                        totalDiscount_invoice = 0;
                        totalDiscountPercent = 0;
                        totalhpp = 0;
                        totallaba = 0;
                        totalKwitansi = 0;

                        double dAmount = 0;
                        double dQty = 0;
                        double dDiscount = 0;
                        double dDiscountAmount = 0;
                        double dPpn = 0;
                        double dPpnAmount = 0;

                        if (temp != null && temp.size() > 0) {

                            for (int xx = 0; xx < temp.size(); xx++) {

                                SalesDetail sd = (SalesDetail) temp.get(xx);

                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    totalQty = totalQty - sd.getQty();
                                } else {
                                    totalQty = totalQty + sd.getQty();
                                }

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

                                totalAmount = totalAmount + sd.getTotal();
                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    totalhpp = totalhpp - (sd.getCogs() * sd.getQty());
                                    totallaba = totallaba - (sd.getTotal() - (sd.getCogs() * sd.getQty()));
                                } else {
                                    totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                    totallaba = totallaba + (sd.getTotal() - (sd.getCogs() * sd.getQty()));
                                }

                                if (sd.getDiscountPercent() == 0 && sd.getDiscountAmount() != 0) {
                                    sd.setDiscountPercent(((sd.getDiscountAmount() / (sd.getTotal() + sd.getDiscountAmount())) * 100));
                                }

                                totalVat = totalVat + sales.getVatAmount();
                                totalDiscountPercent = totalDiscountPercent + sd.getDiscountPercent();
                                totalDiscount_invoice = totalDiscount_invoice + sd.getDiscountAmount();

                                //untk total semua invoice
                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    grandTotal = grandTotal - (sd.getQty() * sd.getSellingPrice());
                                } else {
                                    grandTotal = grandTotal + (sd.getQty() * sd.getSellingPrice());
                                }
                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    totalKwitansi = totalKwitansi - (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                } else {
                                    totalKwitansi = totalKwitansi + (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                }

                                if (xx == 0) {
                                    wb.println("      <Row>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + sales.getNumber() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + usr.getFullName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + im.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + ig.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + cus.getName() + "</Data></Cell>");
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + (sd.getQty() * -1) + "</Data></Cell>");
                                        dQty = dQty + (sd.getQty() * -1);
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sd.getQty() + "</Data></Cell>");
                                        dQty = dQty + (sd.getQty());
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sd.getSellingPrice() + "</Data></Cell>");
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getTotal() + sd.getDiscountAmount()) * -1) + "</Data></Cell>");
                                        dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()) * -1);
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getTotal() + sd.getDiscountAmount()) + "</Data></Cell>");
                                        dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()));
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sd.getDiscountPercent() + "</Data></Cell>");
                                    dDiscount = dDiscount + sd.getDiscountPercent();

                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sd.getDiscountAmount() + "</Data></Cell>");
                                    dDiscountAmount = dDiscountAmount + sd.getDiscountAmount();
                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sales.getVatAmount() + "</Data></Cell>");
                                    dPpn = dPpn + sales.getVatAmount();
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) * -1) + "</Data></Cell>");

                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount())) + "</Data></Cell>");

                                    }

                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getCogs() * sd.getQty()) * -1) + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getCogs() * sd.getQty()) + "</Data></Cell>");
                                    }
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getTotal() - (sd.getCogs() * sd.getQty())) * -1) + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getTotal() - (sd.getCogs() * sd.getQty())) + "</Data></Cell>");
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sales.getPphPercent() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sales.getPphAmount() + "</Data></Cell>");
                                    wb.println("      </Row>");

                                } else {

                                    wb.println("      <Row>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + im.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + ig.getName() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + (sd.getQty() * -1) + "</Data></Cell>");
                                        dQty = dQty + (sd.getQty() * -1);
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sd.getQty() + "</Data></Cell>");
                                        dQty = dQty + (sd.getQty());
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sd.getSellingPrice() + "</Data></Cell>");

                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getTotal() + sd.getDiscountAmount()) * -1) + "</Data></Cell>");
                                        dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()) * -1);
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getTotal() + sd.getDiscountAmount()) + "</Data></Cell>");
                                        dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()));
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sd.getDiscountPercent() + "</Data></Cell>");
                                    dDiscount = dDiscount + sd.getDiscountPercent();
                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sd.getDiscountAmount() + "</Data></Cell>");
                                    dDiscountAmount = dDiscountAmount + sd.getDiscountAmount();
                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sales.getVatAmount() + "</Data></Cell>");
                                    dPpn = dPpn + sales.getVatAmount();
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) * -1) + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount())) + "</Data></Cell>");

                                    }
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getCogs() * sd.getQty()) * -1) + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getCogs() * sd.getQty()) + "</Data></Cell>");
                                    }
                                    if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + ((sd.getTotal() - (sd.getCogs() * sd.getQty())) * -1) + "</Data></Cell>");
                                    } else {
                                        wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (sd.getTotal() - (sd.getCogs() * sd.getQty())) + "</Data></Cell>");
                                    }

                                    wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + sales.getPphPercent() + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + sales.getPphAmount() + "</Data></Cell>");
                                    wb.println("      </Row>");
                                }
                            }

                            if (temp.size() > 1) {

                                wb.println("      <Row>");
                                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s79\"/>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + (dQty) + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"/>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + (dAmount) + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + (dDiscount) + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + dDiscountAmount + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + sales.getVatAmount() + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + totalKwitansi + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + totalhpp + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + totallaba + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + sales.getPphPercent() + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + sales.getPphAmount() + "</Data></Cell>");
                                wb.println("      </Row>");

                            }
                        }
                        grandDiscountAmount = grandDiscountAmount + totalDiscount_invoice + sales.getDiscountAmount();
                        grandTotalDiscountPercen = grandTotalDiscountPercen + totalDiscountPercent + sales.getDiscountPercent();
                        grandTotalKwitansi = grandTotalKwitansi + totalKwitansi;
                        grandTotalHpp = grandTotalHpp + totalhpp;
                        granTotalLaba = granTotalLaba + totallaba;
                    }
                }

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                wb.println("      <Cell ss:StyleID=\"s63\"/>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"/>");
                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + totalQty + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"/>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + grandTotalDiscountPercen + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + grandDiscountAmount + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + totalVat + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + grandTotalKwitansi + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + grandTotalHpp + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + granTotalLaba + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s80\"/>");
                wb.println("      <Cell ss:StyleID=\"s81\"/>");
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
        wb.println("      <LeftColumnVisible>3</LeftColumnVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>23</ActiveRow>");
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
