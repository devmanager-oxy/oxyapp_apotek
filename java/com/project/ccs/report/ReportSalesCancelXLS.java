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

import com.project.general.DbLocation;
import com.project.general.Location;
import java.util.Date;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class ReportSalesCancelXLS extends HttpServlet {

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
        long userId = JSPRequestValue.requestLong(request, "user_id");

        Vector rp = new Vector();
        HttpSession session = request.getSession();
        try {
            rp = (Vector) session.getValue("REPORT_SALES_CANCEL_PARAMETER");
        } catch (Exception e) {
        }

        Vector list = new Vector();
        try {
            list = (Vector) session.getValue("REPORT_SALES_CANCEL");
        } catch (Exception e) {
        }

        try {
            User u = DbUser.fetch(userId);
        } catch (Exception e) {
        }


        String company = "";
        String address = "";
        long locationId = 0;
        Date start = new Date();
        Date end = new Date();

        try {
            company = String.valueOf("" + rp.get(0));
        } catch (Exception e) {
        }

        try {
            address = String.valueOf("" + rp.get(1));
        } catch (Exception e) {
        }

        String locName = "All Location";
        try {
            locationId = Long.parseLong(String.valueOf("" + rp.get(2)));
            if (locationId != 0) {
                Location location = DbLocation.fetchExc(locationId);
                locName = location.getName();
            }
        } catch (Exception e) {
        }

        try {
            start = JSPFormater.formatDate(String.valueOf("" + rp.get(3)), "dd/MM/yyyy");
        } catch (Exception e) {
        }

        try {
            end = JSPFormater.formatDate(String.valueOf("" + rp.get(4)), "dd/MM/yyyy");
        } catch (Exception e) {
        }

        User u = new User();
        try {
            u = DbUser.fetch(userId);
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
        wb.println("      <LastPrinted>2015-12-08T21:19:35Z</LastPrinted>");
        wb.println("      <Created>2015-12-08T21:11:15Z</Created>");
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
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s106\">");
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
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s108\">");
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
        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s118\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s119\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s129\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s135\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s137\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"26.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"111.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"59.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"92.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"118.5\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s137\"><Data ss:Type=\"String\">" + company + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s129\"><Data ss:Type=\"String\">Printed By " + u.getFullName() + ", " + JSPFormater.formatDate(new Date(), "dd MMM yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s137\"><Data ss:Type=\"String\">" + address + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s129\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s137\"><Data ss:Type=\"String\">Report Sales Cancel</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Transaction Date : " + JSPFormater.formatDate(start, "dd MMM yyyy") + " to " + JSPFormater.formatDate(end, "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"6\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Location : " + locName + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"7\">");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Number</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Location</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Member</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Cashier</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Approved By</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s86\"/>");
        wb.println("      </Row>");

        int no = 1;
        double totalSub = 0;
        double totalGrand = 0;
        long tmp = 0;
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {

                Vector tmpResult = (Vector) list.get(i);

                String number = "";
                String locxName = "";
                Date datex = new Date();
                String customerName = "";
                String cashier = "";
                double total = 0;
                String approved = "";
                long locId = 0;

                try {
                    number = String.valueOf(tmpResult.get(1));
                } catch (Exception e) {
                }

                try {
                    locId = Long.parseLong(String.valueOf(tmpResult.get(2)));
                } catch (Exception e) {
                }

                try {
                    locxName = String.valueOf(tmpResult.get(3));
                } catch (Exception e) {
                }

                try {
                    datex = JSPFormater.formatDate(String.valueOf("" + tmpResult.get(4)), "dd/MM/yyyy");
                } catch (Exception e) {
                }

                try {
                    customerName = String.valueOf(tmpResult.get(5));
                } catch (Exception e) {
                }

                try {
                    cashier = String.valueOf(tmpResult.get(6));
                } catch (Exception e) {
                }

                try {
                    total = Double.parseDouble(String.valueOf(tmpResult.get(7)));
                } catch (Exception e) {
                }

                try {
                    approved = String.valueOf(tmpResult.get(8));
                } catch (Exception e) {
                }

                if (tmp != 0 && tmp != locId) {

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">Sub Total</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s119\"><Data ss:Type=\"Number\">" + totalSub + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s107\"/>");
                    wb.println("      </Row>");

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s137\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      </Row>");

                    wb.println("      <Row >");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">No</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Number</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Location</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Date</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Member</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Cashier</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Total</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">Approved By</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s86\"/>");
                    wb.println("      </Row>");

                    totalSub = 0;
                }


                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s106\"><Data ss:Type=\"Number\">" + no + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s106\"><Data ss:Type=\"String\">" + number + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + locxName + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + JSPFormater.formatDate(datex, "yyyy-MM-dd") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + customerName + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + cashier + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">" + approved + "</Data></Cell>");
                wb.println("      </Row>");


                no++;
                tmp = locId;
                totalSub = totalSub + total;
                totalGrand = totalGrand + total;
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">Sub Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s119\"><Data ss:Type=\"Number\">" + totalSub + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s107\"/>");
            wb.println("      </Row>");

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s119\"><Data ss:Type=\"Number\">" + totalGrand + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s107\"/>");
            wb.println("      </Row>");

        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Layout x:Orientation=\"Landscape\"/>");
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
        wb.println("      <ActiveRow>11</ActiveRow>");
        wb.println("      <ActiveCol>3</ActiveCol>");
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
