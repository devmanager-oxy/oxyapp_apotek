/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemGroup;
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

import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.VendorItem;
import com.project.ccs.session.ReportBeliPutus;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.ReportParameterTopSales;
import com.project.ccs.sql.SQLGeneral;
import com.project.ccs.sql.SalesClosing;
import com.project.general.Company;
import com.project.general.DbCompany;

import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.util.Hashtable;
/**
 *
 * @author Roy
 */
public class RptIncomingItemXLS extends HttpServlet {
    
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

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        Vector vpar = new Vector();
        Vector vDetail = new Vector();
        HttpSession session = request.getSession();
        try {
            vpar = (Vector) session.getValue("PARAMETER_INCOMING_ITEM");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        try {
            vDetail = (Vector) session.getValue("DETAIL_INCOMING_ITEM");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        long locationId = Long.parseLong("" + vpar.get(0));        
        int ignore = Integer.parseInt("" + vpar.get(1));
        Date startDate = JSPFormater.formatDate("" + vpar.get(2), "dd/MM/yyyy");
        Date endDate = JSPFormater.formatDate("" + vpar.get(3), "dd/MM/yyyy");
        String srcStatus = "" + vpar.get(4);
        String srcCode = "" + vpar.get(5);
        String srcName = "" + vpar.get(6);
        String user = "" + vpar.get(7);
        String grp = "" + vpar.get(8);

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
        wb.println("      <LastPrinted>2014-12-18T04:32:24Z</LastPrinted>");
        wb.println("      <Created>2014-12-18T04:21:42Z</Created>");
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
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
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
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s91\">");
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
        wb.println("      <Style ss:ID=\"s92\">");
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
        wb.println("      <Style ss:ID=\"s93\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"130\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"170.25\"/>");
        wb.println("      <Column ss:Index=\"9\" ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:Index=\"3\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">Printed by : " + user + ", date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");

        if (locationId != 0) {
            try {
                Location l = DbLocation.fetchExc(locationId);
                wb.println("      <Row>");
                wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">Location : " + l.getName() + "</Data></Cell>");
                wb.println("      </Row>");
            } catch (Exception e) {
            }
        }

        if (ignore == 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">Period : " + JSPFormater.formatDate(startDate, "dd/MM/yyyy") + " - " + JSPFormater.formatDate(endDate, "dd/MM/yyyy") + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if ((srcCode != null && srcCode.length() > 0) || (srcName != null && srcName.length() > 0)) {
            String parameter = "";
            if (srcName != null && srcName.length() > 0) {
                if (parameter.length() > 0) {
                    parameter = parameter + " / ";
                }
                parameter = parameter + " Item Name : " + srcName;
            }
            if (srcCode != null && srcCode.length() > 0) {
                if (parameter.length() > 0) {
                    parameter = parameter + " / ";
                }
                parameter = parameter + "SKU : " + srcCode;
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + parameter + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (grp != null && grp.length() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">Group : " + grp + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">No </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Location </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Date </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Number </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">SKU </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Barcode </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Item Name </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Qty </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Unit Price </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Discount</Data></Cell>");
        
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("      </Row>");
        if (vDetail != null && vDetail.size() > 0) {
            double subQty = 0;
            double subTotal = 0;
            double subDiscount = 0;
            for (int i = 0; i < vDetail.size(); i++) {
                Vector tmpPrint = (Vector) vDetail.get(i);

                String location = "";
                String code = "";
                String barcode = "";
                String number = "";
                String itemName = "";
                Date date = new Date();
                double qty = 0;
                double price = 0;
                double discount = 0;

                try {
                    location = String.valueOf(tmpPrint.get(0));
                } catch (Exception e) {
                }

                try {
                    code = String.valueOf(tmpPrint.get(1));
                } catch (Exception e) {
                }

                try {
                    barcode = String.valueOf(tmpPrint.get(2));
                } catch (Exception e) {
                }

                try {
                    number = String.valueOf(tmpPrint.get(3));
                } catch (Exception e) {
                }

                try {
                    itemName = String.valueOf(tmpPrint.get(4));
                } catch (Exception e) {
                }

                try {
                    date = JSPFormater.formatDate("" + tmpPrint.get(5), "dd/MM/yyyy");
                } catch (Exception e) {
                }

                try {
                    qty = Double.parseDouble(String.valueOf(tmpPrint.get(6)));
                } catch (Exception e) {
                }

                try {
                    price = Double.parseDouble(String.valueOf(tmpPrint.get(7)));
                } catch (Exception e) {
                }
                
                try {
                    discount = Double.parseDouble(String.valueOf(tmpPrint.get(8)));
                } catch (Exception e) {
                }

                double total = (qty * price)-discount;
                subQty = subQty + qty;
                subTotal = subTotal + total;
                subDiscount = subDiscount + discount;

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + location + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(date, "dd/MM/yyyy") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">" + number + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">" + code + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">" + barcode + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + itemName + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + price + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + discount + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s91\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + subQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s93\"/>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + subDiscount+ "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
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
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>15</ActiveRow>");
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
