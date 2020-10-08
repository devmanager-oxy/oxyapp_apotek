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
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.RptBeliPutus;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class RptCashBackXLS extends HttpServlet {

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

        // Company Id                
        Location location = new Location();
        Vector vDetail = new Vector();
        HttpSession session = request.getSession();

        Vector vpar = new Vector();
        try {
            vpar = (Vector) session.getValue("REPORT_POINT_CASH_BACK_XLS_PARAMETER");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        long locationId = Long.parseLong("" + vpar.get(0));
        Date startDate = JSPFormater.formatDate("" + vpar.get(1), "dd/MM/yyyy");
        Date endDate = JSPFormater.formatDate("" + vpar.get(2), "dd/MM/yyyy");
        String srcCode = "" + vpar.get(3);
        String srcName = "" + vpar.get(4);
        String user = "" + vpar.get(5);

        try {
            location = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        try {
            vDetail = (Vector) session.getValue("REPORT_POINT_CASH_BACK_XLS");
        } catch (Exception ex) {
            System.out.println(ex.toString());
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
        wb.println("      <Created>2015-05-18T04:48:44Z</Created>");
        wb.println("      <LastSaved>2015-05-18T04:59:10Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m34693668\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
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
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"70.5\"/>");
        wb.println("      <Column ss:Width=\"126\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"144.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:Index=\"11\" ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"3\">");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">Printed : " + user + ", date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">Period : " + JSPFormater.formatDate(startDate, "dd/MM/yyyy") + " - " + JSPFormater.formatDate(endDate, "dd/MM/yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        if (location.getOID() != 0) {
            wb.println("      <Row >");
            wb.println("      <Cell><Data ss:Type=\"String\">Location : " + location.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (srcName != null && srcName.length() > 0) {
            wb.println("      <Row >");
            wb.println("      <Cell><Data ss:Type=\"String\">Name : " + srcName + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (srcCode != null && srcCode.length() > 0) {
            wb.println("      <Row >");
            wb.println("      <Cell><Data ss:Type=\"String\">Id/Barcode : " + srcCode + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">ID/Barcode</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Name</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Reg. Date</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Location Reg.</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Address</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Telp</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Email</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Saldo Until</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Total Sales</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Cash Back In</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Cash Back Out</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Saldo</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"9\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">("+JSPFormater.formatDate(startDate, "dd/MM/yyyy")+")</Data></Cell>");
        wb.println("      </Row>");

        if (vDetail != null && vDetail.size() > 0) {
            
            double sumSaldo = 0;
            double sumPenjualan = 0;
            double sumPointIn = 0;
            double sumPointOut = 0;
            double sumEnding = 0;
            
            for (int i = 0; i < vDetail.size(); i++) {
                Vector vdt = new Vector();
                vdt = (Vector) vDetail.get(i);

                String name = "";
                String code = "";
                String address = "";
                String hp = "";
                String strReg = "";
                String email = "";
                String loc = "";

                try {
                    code = vdt.get(0).toString();
                } catch (Exception e) {
                }

                try {
                    name = vdt.get(1).toString();
                } catch (Exception e) {
                }

                try {
                    strReg = vdt.get(2).toString();
                } catch (Exception e) {
                }

                try {
                    loc = vdt.get(3).toString();
                } catch (Exception e) {
                }

                try {
                    address = vdt.get(4).toString();
                } catch (Exception e) {
                }

                try {
                    hp = vdt.get(5).toString();
                } catch (Exception e) {
                }

                try {
                    email = vdt.get(6).toString();
                } catch (Exception e) {
                }

                double saldo = 0;
                double penjualan = 0;
                double pointIn = 0;
                double pointOut = 0;

                try {
                    saldo = Double.parseDouble(vdt.get(7).toString());
                } catch (Exception e) {
                }

                try {
                    penjualan = Double.parseDouble(vdt.get(8).toString());
                } catch (Exception e) {
                }

                try {
                    pointIn = Double.parseDouble(vdt.get(9).toString());
                } catch (Exception e) {
                }

                try {
                    pointOut = Double.parseDouble(vdt.get(10).toString());
                } catch (Exception e) {
                }
                
                sumSaldo = sumSaldo + saldo;
                sumPenjualan = sumPenjualan + penjualan;
                sumPointIn = sumPointIn + pointIn;
                sumPointOut = sumPointOut + pointOut;
                double ending = saldo + pointIn - pointOut;
                sumEnding = sumEnding + ending;

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + code + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + name + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + strReg + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + loc + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + address + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + hp + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + email + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + saldo + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + penjualan + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + pointIn + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + pointOut + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + ending + "</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"m34693668\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+sumSaldo+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+sumPenjualan+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+sumPointIn+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+sumPointOut+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+sumEnding+"</Data></Cell>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>3</ActiveRow>");
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
