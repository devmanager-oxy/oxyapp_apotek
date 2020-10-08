/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

/**
 *
 * @author Roy Andika
 */
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
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.session.ReportConsigCost;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessLastPriceKonsinyasi;
import com.project.ccs.session.SessReportSales;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.util.Hashtable;

public class RptKonsinyasiPriceXls_1 extends HttpServlet {

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
        ReportParameter rp = new ReportParameter();
        String addrReport = DbSystemProperty.getValueByName("ADDRESS_REPORT");
        
        long userId = 0;
        User user = new User();
        Vector result = new Vector();
        Hashtable sBegin = new Hashtable();
        Hashtable sReceive = new Hashtable();
        Hashtable sSold = new Hashtable();
        Hashtable sRetur = new Hashtable();
        Hashtable sTransIn = new Hashtable();
        Hashtable sTransOut = new Hashtable();
        Hashtable sAdjustment = new Hashtable();
        HttpSession session = request.getSession();

        try {
            rp = (ReportParameter) session.getValue("REPORT_KONSINYASI_PRICE");
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
            result = (Vector) session.getValue("REPORT_KONSINYASI_RESULT");
        } catch (Exception e) {
        }

        try {
            sBegin = (Hashtable) session.getValue("REPORT_KONSINYASI_BEGIN");
        } catch (Exception e) {
        }

        try {
            sReceive = (Hashtable) session.getValue("REPORT_KONSINYASI_RECEIVE");
        } catch (Exception e) {
        }

        try {
            sSold = (Hashtable) session.getValue("REPORT_KONSINYASI_SOLD");
        } catch (Exception e) {
        }

        try {
            sRetur = (Hashtable) session.getValue("REPORT_KONSINYASI_RETUR");
        } catch (Exception e) {
        }

        try {
            sTransIn = (Hashtable) session.getValue("REPORT_KONSINYASI_TRANS_IN");
        } catch (Exception e) {
        }

        try {
            sTransOut = (Hashtable) session.getValue("REPORT_KONSINYASI_TRANS_OUT");
        } catch (Exception e) {
        }

        try {
            sAdjustment = (Hashtable) session.getValue("REPORT_KONSINYASI_ADJ");
        } catch (Exception e) {
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_KOSNINYASI_HARGA_JUAL");
        } catch (Exception e) {
        }
        Employee emp = new Employee();
        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
            if(user.getEmployeeId() != 0){
                emp = DbEmployee.fetchExc(user.getEmployeeId());
            }
        } catch (Exception e) {
        }
        
        String month = "";
        if(new Date().getMonth() == 0){
            month = "Januari";
        }else if(new Date().getMonth() == 1){
            month = "Februari";
        }else if(new Date().getMonth() == 2){
            month = "Maret";
        }else if(new Date().getMonth() == 3){
            month = "April";
        }else if(new Date().getMonth() == 4){
            month = "Mei";
        }else if(new Date().getMonth() == 5){
            month = "Juni";
        }else if(new Date().getMonth() == 6){
            month = "Juli";
        }else if(new Date().getMonth() == 7){
            month = "Agustus";
        }else if(new Date().getMonth() == 8){
            month = "September";
        }else if(new Date().getMonth() == 9){
            month = "Oktober";
        }else if(new Date().getMonth() == 10){
            month = "November";
        }else if(new Date().getMonth() == 11){
            month = "Desember";
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
        wb.println("      <Created>2013-03-12T02:47:22Z</Created>");
        wb.println("      <LastSaved>2013-03-12T03:05:14Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m41953064\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m41953084\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m41953104\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m41951904\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
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
        
        wb.println("      <Style ss:ID=\"s64i\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");        
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"\\R\\p\\ #,##0_);[Red]\\(\\R\\p\\ #,##0\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s97\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s98\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s99\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s102n\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\" ss:Horizontal=\"Right\"/>"); 
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      />");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"192.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"30\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"81\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"79.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"92.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102n\"><Data ss:Type=\"String\">Printed By : " + user.getFullName() + ",Date : " + JSPFormater.formatDate(new Date(), "dd MMM yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">" + titleRpt.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        
        if (vndx.getOID() != 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">SUPLIER :" + vndx.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">PERIOD : " + period.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        if (loc.getOID() != 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"16\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">LOCATION    : " + loc.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        
        if (result != null && result.size() > 0) {

            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">SKU </Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m41953064\"><Data ss:Type=\"String\">Description  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Price  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Begining  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Receiving  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Sold  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Retur  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Transfer In  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Transfer Out  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Adjustment  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Ending  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Selling Value  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Margin ( " + vndx.getPercentMargin() + " )</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Margin</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Stock Value</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">PPN</Data></Cell>");
            wb.println("      </Row>");

            double tot1 = 0;
            double tot2 = 0;
            double tot3 = 0;
            double tot4 = 0;
            double tot5 = 0;
            double tot6 = 0;
            double tot7 = 0;
            double tot8 = 0;
            double tot9 = 0;
            double tot10 = 0;
            double tot11 = 0;

            double tot12 = 0;
            double tot13 = 0;

            for (int i = 0; i < result.size(); i++) {

                ReportConsigCost rsm = (ReportConsigCost) result.get(i);

                double price = 0;

                ItemMaster im = new ItemMaster();
                double discount = 0;
                try {
                    im = DbItemMaster.fetchExc(rsm.getItemMasterId());
                    Vendor vnd = new Vendor();
                    vnd = DbVendor.fetchExc(im.getDefaultVendorId());
                    discount = vnd.getPercentMargin();
                } catch (Exception e) {
                }

                ReportConsigCost begin = new ReportConsigCost();
                try {
                    begin = (ReportConsigCost) sBegin.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    begin = new ReportConsigCost();
                }
                ReportConsigCost receive = new ReportConsigCost();
                try {
                    receive = (ReportConsigCost) sReceive.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }
                if (receive == null) {
                    receive = new ReportConsigCost();
                }
                if (begin == null) {
                    begin = new ReportConsigCost();
                }

                ReportConsigCost sold = new ReportConsigCost();
                try {
                    sold = (ReportConsigCost) sSold.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }

                if (sold == null) {
                    sold = new ReportConsigCost();
                }

                double lastPrice = 0;
                try {
                    //lastPrice = DbSales.getLastPrice(rp.getLocationId(), rsm.getItemMasterId(), rp.getDateTo());
                    lastPrice = SessLastPriceKonsinyasi.getLastPrice(rp.getLocationId(), rsm.getItemMasterId(), rp.getDateTo());
                } catch (Exception e) {
                }

                price = lastPrice;
                if (price == 0) {
                    double tmpPrice = 0;
                    try {
                        tmpPrice = SessReportSales.reportConsignedBySellingPrice(rp.getLocationId(), rsm.getItemMasterId());
                    } catch (Exception e) {
                    }
                    price = tmpPrice;
                }

                ReportConsigCost retur = new ReportConsigCost();
                try {
                    retur = (ReportConsigCost) sRetur.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }
                if (retur == null) {
                    retur = new ReportConsigCost();
                }
                ReportConsigCost transIn = new ReportConsigCost();
                try {
                    transIn = (ReportConsigCost) sTransIn.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }
                if (transIn == null) {
                    transIn = new ReportConsigCost();
                }

                ReportConsigCost transOut = new ReportConsigCost();
                try {
                    transOut = (ReportConsigCost) sTransOut.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }
                if (transOut == null) {
                    transOut = new ReportConsigCost();
                }

                ReportConsigCost adjustment = new ReportConsigCost();
                try {
                    adjustment = (ReportConsigCost) sAdjustment.get("" + rsm.getItemMasterId());
                } catch (Exception e) {
                    System.out.println("exception " + e.toString());
                }
                if (adjustment == null) {
                    adjustment = new ReportConsigCost();
                }

                double stock = begin.getQty() + receive.getQty() + sold.getQty() + retur.getQty() + transIn.getQty() + transOut.getQty() + adjustment.getQty();
                double sellingV = 0;
                if (sold.getQty() != 0) {
                    sellingV = sold.getQty() * -1 * price;
                } else {
                    sellingV = sold.getQty() * price;
                }

                double vEnding2 = 0;
                vEnding2 = stock * price;

                double tmpAmountDisc = (sellingV * discount) / 100;

                tot1 = tot1 + begin.getQty();
                tot2 = tot2 + receive.getQty();
                double tot3x = sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty();
                tot3 = tot3 + tot3x;
                double tot4x = retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty();
                tot4 = tot4 + tot4x;
                tot5 = tot5 + transIn.getQty();
                double tot6x = transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty();
                tot6 = tot6 + tot6x;
                tot7 = tot7 + adjustment.getQty();
                tot8 = tot8 + stock;
                tot9 = tot9 + sellingV;
                tot10 = tot10 + vEnding2;
                tot11 = tot11 + tmpAmountDisc;

                double marg = vndx.getPercentMargin() * sellingV / 100;
                tot12 = tot12 + marg;

                double ppn = 0;
                if (vndx.getIsPKP() == 1) {
                    ppn = sellingV - ((100*sellingV)/110);
                }
                tot13 = tot13 + ppn;

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"Number\">" + rsm.getSku() + "</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m41953084\"><Data ss:Type=\"String\">" + rsm.getDescription() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + price + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + begin.getQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + receive.getQty() + "</Data></Cell>");
                double qtx = sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty();
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + qtx + "</Data></Cell>");
                double qty = retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty();
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + transIn.getQty() + "</Data></Cell>");
                double qtz = transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty();
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + qtz + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + adjustment.getQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + stock + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + sellingV + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + vndx.getPercentMargin() + " %</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + marg + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + vEnding2 + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + ppn + "</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m41951904\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot1 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot2 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot3 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot4 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot5 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot6 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot7 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + tot8 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + tot9 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + vndx.getPercentMargin() + " %</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"Number\">" + tot12 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + tot10 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + tot13 + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s84\"/>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Total Selling Price</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"/>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + tot9 + "</Data></Cell>");
            wb.println("      <Cell ss:Index=\"14\" ss:MergeAcross=\"1\" ss:StyleID=\"s64i\"><Data ss:Type=\"String\">"+addrReport+","+new Date().getDate()+" "+month+" "+(new Date().getYear()+1900)+"</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">VAT Out</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"/>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">RP.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + tot13 + "</Data></Cell>");
            wb.println("      <Cell ss:Index=\"14\" ss:MergeAcross=\"1\" ss:StyleID=\"s64i\"><Data ss:Type=\"String\">Created by</Data></Cell>");
            wb.println("      </Row>");
            double margin = 0;
            margin = (vndx.getPercentMargin() * (tot9-tot13))/100;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Margin " + JSPFormater.formatNumber(vndx.getPercentMargin(), "#,###") + "%</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"/>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">RP.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + margin + "</Data></Cell>");
            wb.println("      </Row>");

            double tot = tot9 - tot13 - margin;
            double vatin = 0;
            if (vndx.getIsPKP() == 1) {
                vatin = (10 * tot)/100;
            }
            double subtotal2 = tot + vatin;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Subtotal 1</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"/>");
            wb.println("      <Cell ss:Index=\"5\" ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + tot + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s84\"/>");
            wb.println("      </Row>");

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">VAT In</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"/>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">RP.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + vatin + "</Data></Cell>");
            wb.println("      <Cell ss:Index=\"14\" ss:MergeAcross=\"1\" ss:StyleID=\"s64i\"><Data ss:Type=\"String\">"+user.getFullName()+"</Data></Cell>");
            wb.println("      </Row>");
            
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Subtotal 2</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"/>");
            wb.println("      <Cell ss:Index=\"5\" ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + subtotal2 + "</Data></Cell>");
            wb.println("      <Cell ss:Index=\"14\" ss:MergeAcross=\"1\" ss:StyleID=\"s64i\"><Data ss:Type=\"String\">"+emp.getPosition()+"</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s84\"/>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Potongan</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"/>");
            wb.println("      </Row>");
            double promot = (tot9 / 100) * vndx.getPercentPromosi();
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Promosi " + vndx.getPercentPromosi() + "%</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + promot + "</Data></Cell>");
            wb.println("      </Row>");
            double barcode = vndx.getPercentBarcode() * (tot2 + tot5);
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Barcode @Rp. " + vndx.getPercentBarcode() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + barcode + "</Data></Cell>");
            wb.println("      </Row>");
            double totPotongan = promot + barcode;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Total Potongan</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"/>");
            wb.println("      <Cell ss:Index=\"4\" ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + totPotongan + "</Data></Cell>");
            wb.println("      </Row>");
            double grandTotal = subtotal2 - totPotongan;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s85\"/>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s98\"><Data ss:Type=\"String\">Total Bayar</Data></Cell>");
            wb.println("      <Cell ss:Index=\"4\" ss:StyleID=\"s99\"><Data ss:Type=\"String\">=</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      </Table>");
        }
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
        wb.println("      <ActiveRow>17</ActiveRow>");
        wb.println("      <ActiveCol>9</ActiveCol>");
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
