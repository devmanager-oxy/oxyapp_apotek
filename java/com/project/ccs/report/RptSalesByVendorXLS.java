/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */
package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemCategory;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.ItemCategory;
import com.project.ccs.posmaster.ItemGroup;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import java.util.StringTokenizer;

public class RptSalesByVendorXLS extends HttpServlet {

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

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        Vector result = new Vector();
        Vector params = new Vector();
        String userName = "";
        String filter = "";
        Date startDate = new Date();
        Date endDate = new Date();
        try {
            HttpSession session = request.getSession();
            result = (Vector) session.getValue("REPORT_VENDOR");
            params = (Vector) session.getValue("REPORT_PARAM");
            startDate = (Date) params.get(0);
            endDate = (Date) params.get(1);
            userName = (String) params.get(2);
            long locId = Long.parseLong((String) params.get(3));
            String groupCat = (String) params.get(4);
            if (locId != 0) {
                try {
                    Location loc = DbLocation.fetchExc(locId);
                    filter = "Filtered by Location : " + loc.getName();
                } catch (Exception e) {
                }
            } else {
                filter = "Filtered by Location : All";
            }

            if (groupCat != null && groupCat.length() > 0) {
                StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                Vector temp = new Vector();
                while (strTok.hasMoreElements()) {
                    temp.add((String) strTok.nextToken());
                }
                String grId = (String) temp.get(0);
                String ctId = (String) temp.get(1);

                if (!grId.equals("0")) {
                    locId = Long.parseLong(grId);
                    try {
                        ItemGroup ig = DbItemGroup.fetchExc(locId);
                        filter = filter + ", Item Group : " + ig.getName();
                    } catch (Exception e) {
                    }
                } else {
                    filter = filter + ", Item Group : All";
                }

                if (!ctId.equals("0")) {
                    locId = Long.parseLong(ctId);
                    try {
                        ItemCategory ig = DbItemCategory.fetchExc(locId);
                        filter = filter + ", Item Category : " + ig.getName();
                    } catch (Exception e) {
                    }
                } else {
                    filter = filter + ", Item Category : All";
                }
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        }

        boolean gzip = false;

        // response.setCharacterEncoding( "UTF-8\" ) ;
        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }
        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));


        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\" ");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" ");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>Eka D</Author>");
        wb.println("<LastAuthor>Eka D</LastAuthor>");
        wb.println("<Created>2014-09-12T07:34:31Z</Created>");
        wb.println("<Company>Toshiba</Company>");
        wb.println("<Version>14.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<AllowPNG/>");
        wb.println("</OfficeDocumentSettings>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>8505</WindowHeight>");
        wb.println("<WindowWidth>20115</WindowWidth>");
        wb.println("<WindowTopX>240</WindowTopX>");
        wb.println("<WindowTopY>105</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s77\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s84\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s85\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s89\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s90\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s97\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#FFFFFF\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#16365C\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s101\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s103\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#FFFFFF\"/>");
        wb.println("<Interior ss:Color=\"#16365C\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s106\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s107\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s114\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println(" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s115\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        wb.println("<Table ss:ExpandedColumnCount=\"7\" x:FullColumns=\"1\" ");
        wb.println(" x:FullRows=\"1\" ss:StyleID=\"s77\">");
        wb.println("<Column ss:StyleID=\"s77\" ss:AutoFitWidth=\"0\" ss:Width=\"54\"/>");
        wb.println("<Column ss:StyleID=\"s77\" ss:AutoFitWidth=\"0\" ss:Width=\"159\"/>");
        wb.println("<Column ss:StyleID=\"s77\" ss:AutoFitWidth=\"0\" ss:Width=\"80.25\" ss:Span=\"4\"/>");
        wb.println("<Row ss:Height=\"15\" ss:StyleID=\"s115\">");
        wb.println("<Cell ss:MergeAcross=\"6\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"15\" ss:StyleID=\"s115\">");
        wb.println("<Cell ss:MergeAcross=\"6\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">REPORT SALES BY SUPPLIER / VENDOR</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"6\" ss:StyleID=\"s107\"><Data ss:Type=\"String\">PERIOD " + JSPFormater.formatDate(startDate, "dd/MM/yyyy") + " - " + JSPFormater.formatDate(endDate, "dd/MM/yyyy") + "</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell><Data ss:Type=\"String\">Print date : " + JSPFormater.formatDate(new Date(), "dd/MM/yyyy") + ", by " + userName + "</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell><Data ss:Type=\"String\">" + filter + "</Data></Cell>");
        wb.println("</Row>");
        if (result != null && result.size() > 0) {
            for (int i = 0; i < result.size(); i++) {
                Vector temp = (Vector) result.get(i);
                Vendor vend = (Vendor) temp.get(0);
                Vector details = (Vector) temp.get(1);

                wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\"/>");
                wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\" ss:StyleID=\"s101\">");
                wb.println("<Cell ss:MergeAcross=\"6\" ss:StyleID=\"s97\"><Data ss:Type=\"String\">" + vend.getName().toUpperCase() + "</Data></Cell>");
                wb.println("</Row>");
                wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"13.5\">");
                wb.println("<Cell ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + vend.getAddress() + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("<Cell ss:StyleID=\"s103\"/>");
                wb.println("</Row>");
                wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.25\" ss:StyleID=\"s107\">");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">SKU</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Item</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Sales Qty</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Sales Cogs</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Sales Amount</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Profit</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">Margin %</Data></Cell>");
                wb.println("</Row>");
                if (details != null && details.size() > 0) {

                    double subQty = 0;
                    double subCogs = 0;
                    double subAmount = 0;
                    double subProfit = 0;
                    double subMargin = 0;

                    for (int x = 0; x < details.size(); x++) {
                        Vector tempDet = (Vector) details.get(x);
                        String sku = (String) tempDet.get(1);
                        String itemName = (String) tempDet.get(3);
                        double qty = Double.parseDouble((String) tempDet.get(5));
                        double sales = Double.parseDouble((String) tempDet.get(6));
                        double hpp = Double.parseDouble((String) tempDet.get(8));
                        double margin = (hpp > 0) ? ((sales - hpp) / hpp) * 100 : 0;

                        subQty = subQty + qty;
                        subCogs = subCogs + hpp;
                        subAmount = subAmount + sales;
                        subProfit = subProfit + (sales - hpp);
                        subMargin = subMargin + margin;

                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.25\">");
                        wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\">" + sku + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + itemName + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + hpp + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + sales + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + (sales - hpp) + "</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + margin + "</Data></Cell>");
                        wb.println("</Row>");
                    }
                    wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"14.25\">");
                    wb.println("<Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\">Total</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + subQty + "</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + subCogs + "</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + subAmount + "</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + subProfit + "</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + subMargin + "</Data></Cell>");
                    wb.println("</Row>");                    
                }
            }
        }

        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<VerticalResolution>0</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>15</ActiveRow>");
        wb.println("<ActiveCol>1</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("</Workbook>");

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
