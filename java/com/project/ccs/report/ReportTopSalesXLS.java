/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
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
 * @author Roy Andika
 */
public class ReportTopSalesXLS extends HttpServlet {

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
        ItemGroup ig = new ItemGroup();
        ReportParameterTopSales rp = new ReportParameterTopSales();

        HttpSession session = request.getSession();
        Vector print = new Vector();

        try {
            rp = (ReportParameterTopSales) session.getValue("REPORT_TOP_SALES_PARAMETER");
        } catch (Exception e) {
        }

        try {
            print = (Vector) session.getValue("REPORT_TOP_SALES");
        } catch (Exception e) {
        }

        Vendor vndx = new Vendor();
        try {
            vndx = DbVendor.fetchExc(rp.getVendorId());
        } catch (Exception e) {
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(rp.getLocationId());
        } catch (Exception e) {
        }

        try {
            ig = DbItemGroup.fetchExc(rp.getDepartmentId());
        } catch (Exception e) {
        }
        
        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        String strPeriode = "" + JSPFormater.formatDate(rp.getStartDate(), "dd MMM yyyy") + " S/D " + JSPFormater.formatDate(rp.getEndDate(), "dd MMM yyyy");
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
        wb.println("      <Created>2013-04-04T07:00:56Z</Created>");
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
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s65\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
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
        wb.println("      <Style ss:ID=\"s69\">");
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
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");

        wb.println("      <Worksheet ss:Name=\"Sheet1\">");

        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"40.5\"/>");
        if (rp.getLocationStatus() == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"126\"/>");
        }
        if (rp.getGroupStatus() == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"121.5\"/>");
        }
        if (rp.getVendorStatus() == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"132.75\"/>");
        }
        if (rp.getItemStatus() == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"164.25\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"164.25\"/>");
        }
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90.75\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PRINTED BY : " + user.getFullName() + ",Date "+JSPFormater.formatDate(new Date(), "dd-MM-yyyy")+"</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PERIODE : " + strPeriode + "</Data></Cell>");
        wb.println("      </Row>");

        if (rp.getLocationId() != 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">LOCATION : " + loc.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        if (rp.getDepartmentId() != 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">CATEGORY : " + ig.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (rp.getVendorId() != 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">VENDOR : " + vndx.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        if (print != null && print.size() > 0) {

            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">NO</Data></Cell>");
            if (rp.getLocationStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">LOCATION</Data></Cell>");
            }
            if (rp.getGroupStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">CATEGORY</Data></Cell>");
            }
            if (rp.getVendorStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">SUPPLIER</Data></Cell>");
            }
            if (rp.getItemStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">CODE</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">BARCODE</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">DESCRIPTION</Data></Cell>");
            }
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("      </Row>");

            double totQty = 0;
            double totAmount = 0;

            for (int k = 0; k < print.size(); k++) {

                Vector result = (Vector) print.get(k);

                String locName = String.valueOf(result.get(0));
                String groupName = String.valueOf(result.get(1));
                String vendorName = String.valueOf(result.get(2));
                String code = String.valueOf(result.get(3));
                String barcode = String.valueOf(result.get(4));
                String name = String.valueOf(result.get(5));
                double qty = Double.parseDouble("" + result.get(6));
                double total = Double.parseDouble("" + result.get(7));

                totQty = totQty + qty;
                totAmount = totAmount + total;

                int page = k + 1;
                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"Number\">" + page + "</Data></Cell>");
                if (rp.getLocationStatus() == 1) {
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + locName + "</Data></Cell>");
                }
                if (rp.getGroupStatus() == 1) {
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + groupName + "</Data></Cell>");
                }
                if (rp.getVendorStatus() == 1) {
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + vendorName + "</Data></Cell>");
                }
                if (rp.getItemStatus() == 1) {
                    wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + code + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + barcode + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + name + "</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                if(qty==0){
                    wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + 0 + "</Data></Cell>");
                }else{
                    wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + (total / qty) + "</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
            if (rp.getLocationStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            if (rp.getGroupStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            if (rp.getVendorStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            if (rp.getItemStatus() == 1) {
                wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + totQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
            wb.println("      </Row>");

        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>10</ActiveRow>");
        wb.println("      <ActiveCol>7</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table >");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet3\">");

        wb.println("      <Table >");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      </Table>");

        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      </Workbook>");


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
