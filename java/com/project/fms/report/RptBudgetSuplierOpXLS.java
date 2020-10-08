/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.report;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.io.Writer;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.I_Project;

import com.project.admin.DbUser;
import com.project.admin.User;

import com.project.fms.session.SessReportAnggaran;
import com.project.fms.session.SessReportBudgetSuplier;
import com.project.general.Approval;
import com.project.general.Company;
import com.project.general.DbApproval;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;

/**
 *
 * @author Roy
 */
public class RptBudgetSuplierOpXLS extends HttpServlet {
    
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
        int lang = 0;

        long vendorId = 0;
        Date dateFrom = new Date();
        Date dateTo = new Date();
        int ignore = 0;
        int pkp = 0;
        int nonpkp = 0;
        Vector list = new Vector();

        long userId = 0;
        User user = new User();

        Vector dateTrans = new Vector();
        try {
            HttpSession session = request.getSession();
            dateTrans = (Vector) session.getValue("DATE_TRANS_DATE");
            SessReportBudgetSuplier dt1 = (SessReportBudgetSuplier) dateTrans.get(0);
            SessReportBudgetSuplier dt2 = (SessReportBudgetSuplier) dateTrans.get(1);
            dateFrom = dt1.getTransDate();
            dateTo = dt2.getTransDate();
        } catch (Exception e) {
        }

        try {
            vendorId = JSPRequestValue.requestLong(request, "vendorId");
        } catch (Exception e) {
            System.out.println(e.toString());
        }


        try {
            ignore = JSPRequestValue.requestInt(request, "ignore");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            pkp = JSPRequestValue.requestInt(request, "pkp");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            nonpkp = JSPRequestValue.requestInt(request, "nonpkp");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            list = SessReportAnggaran.getBudgetSuplier(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp,DbVendor.VENDOR_TYPE_GA);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Employee emp = new Employee();
        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
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

        String title = "";
        String title1 = "";
        
        if (lang == 0) {
            title = "BUDGET PEMBAYARAN SUPLIER OPERATIONAL";
        } else {
            title = "OPERATIONAL BUDGET SUPLIER PAYMENT";
        }

        if (!(pkp == 1 && nonpkp == 1)) {
            if (pkp == 1) {
                title1 = " PKP)";
            }
            if (nonpkp == 1) {
                title1 = " NON PKP ";
            }
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
        wb.println("      <LastPrinted>2013-01-14T11:38:05Z</LastPrinted>");
        wb.println("      <Created>2013-01-14T11:08:58Z</Created>");
        wb.println("      <LastSaved>2013-01-14T11:42:51Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s17\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s19\">");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s20\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s21\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s24\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s29\">");
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
        wb.println("      <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Underline=\"Single\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s32\">");
        wb.println("      <Alignment ss:Horizontal=\"Justify\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s33\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s34\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s35\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
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
        wb.println("      <Style ss:ID=\"s38\">");
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
        wb.println("      <Style ss:ID=\"s39\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s40\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s41\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"28.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Row ss:Index=\"2\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">" + title + "</Data></Cell>");
        wb.println("      </Row>");

        if (ignore == 0) {

            String date = "";
            if (dateFrom.compareTo(dateTo) == 0) {
                date = JSPFormater.formatDate(dateFrom, "dd-MM-yyyy");
            } else {
                date = JSPFormater.formatDate(dateFrom, "dd-MM-yyyy") + " TO " + JSPFormater.formatDate(dateTo, "dd-MM-yyyy");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">PERIODE : " + date + "</Data></Cell>");
            wb.println("      </Row>");
        }
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s39\"><Data ss:Type=\"String\">" + title1 + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s39\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        if (list != null && list.size() > 0) {

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">NO</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">NAMA SUPLIER</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">DIVISI</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">NO. TT</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s38\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">JUMLAH YANG</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:Index=\"6\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">DIBAYAR</Data></Cell>");
            wb.println("      </Row>");

            String v = "";
            double tot = 0;
            double totAmount = 0;
            int number = 1;

            for (int i = 0; i < list.size(); i++) {
                SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
                srbs = (SessReportBudgetSuplier) list.get(i);

                int count = 0;
                int counter = 0;
                for (int t = 0; t < list.size(); t++) {
                    SessReportBudgetSuplier ck = new SessReportBudgetSuplier();
                    ck = (SessReportBudgetSuplier) list.get(t);
                    if (ck.getSuplier().compareToIgnoreCase(srbs.getSuplier()) == 0) {
                        count++;
                        counter = ck.getCounter();
                    }
                }
                if (v.compareToIgnoreCase(srbs.getSuplier()) != 0) {
                    tot = 0;
                }

                tot = tot + srbs.getValue();



                wb.println("      <Row>");

                if (v.equalsIgnoreCase("") || v.compareToIgnoreCase(srbs.getSuplier()) != 0) {
                    wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + number + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">" + srbs.getSuplier() + "</Data></Cell>");
                    number = number + 1;
                } else {
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
                }

                wb.println("      <Cell ss:StyleID=\"s20\"/>");
                wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"String\">" + srbs.getNoTT() + "</Data></Cell>");
                if (count > 1) {
                    wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"Number\">" + srbs.getValue() + "</Data></Cell>");
                } else {
                    wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"String\"></Data></Cell>");
                }

                if (count == 1) {
                    wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"Number\">" + srbs.getValue() + "</Data></Cell>");
                    totAmount = totAmount + srbs.getValue();
                } else {
                    wb.println("      <Cell ss:StyleID=\"s16\"/>");
                }

                wb.println("      </Row>");

                if (count > 1 && counter == srbs.getCounter()) {
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      <Cell ss:StyleID=\"s32\"/>");
                    wb.println("      <Cell ss:StyleID=\"s16\"/>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
                    if (counter == srbs.getCounter()) {
                        totAmount = totAmount + tot;
                        wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"Number\">" + tot + "</Data></Cell>");
                    } else {
                        wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                    }
                    wb.println("      </Row>");
                }

                v = srbs.getSuplier();

            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s16\"/>");
            wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
            wb.println("      </Row>");
        }

        int intDt = new Date().getDate();
        int month = new Date().getMonth();
        int year = new Date().getYear() + 1900;

        String mth = "";

        if (month == 0) {
            mth = "Januari";
        } else if (month == 1) {
            mth = "Februari";
        } else if (month == 2) {
            mth = "Maret";
        } else if (month == 3) {
            mth = "April";
        } else if (month == 4) {
            mth = "Mei";
        } else if (month == 5) {
            mth = "Juni";
        } else if (month == 6) {
            mth = "Juli";
        } else if (month == 7) {
            mth = "Agustus";
        } else if (month == 8) {
            mth = "September";
        } else if (month == 9) {
            mth = "Oktober";
        } else if (month == 10) {
            mth = "November";
        } else if (month == 11) {
            mth = "Desember";
        }

        String header = "";

        try {
            Approval approval = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_0);
            header = approval.getKeterangan();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        wb.println("      <Row >");
        wb.println("      <Cell ss:Index=\"2\"><Data ss:Type=\"String\">" + header + ", " + intDt + " " + mth + " " + year + "</Data></Cell>");
        wb.println("      </Row>");

        String header1 = "";

        try {
            Approval approval1 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_1);
            header1 = approval1.getKeterangan();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String header2 = "";
        String emp2 = "";
        String footer2 = "";

        try {
            Approval approval2 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_2);
            try {
                Employee employee2 = DbEmployee.fetchExc(approval2.getEmployeeId());
                emp2 = employee2.getName();
            } catch (Exception e) {
            }
            header2 = approval2.getKeterangan();
            footer2 = approval2.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String header3 = "";
        String emp3 = "";
        String footer3 = "";

        try {
            Approval approval3 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_3);
            try {
                Employee employee3 = DbEmployee.fetchExc(approval3.getEmployeeId());
                emp3 = employee3.getName();
            } catch (Exception e) {
            }
            header3 = approval3.getKeterangan();
            footer3 = approval3.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String emp4 = "";
        String footer4 = "";

        try {
            Approval approval4 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_4);
            try {
                Employee employee4 = DbEmployee.fetchExc(approval4.getEmployeeId());
                emp4 = employee4.getName();
            } catch (Exception e) {
            }
            footer4 = approval4.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String header5 = "";
        String emp5 = "";
        String footer5 = "";

        try {
            Approval approval5 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_5);
            try {
                Employee employee5 = DbEmployee.fetchExc(approval5.getEmployeeId());
                emp5 = employee5.getName();
            } catch (Exception e) {
            }
            header5 = approval5.getKeterangan();
            footer5 = approval5.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + header1 + ",</Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\">" + header2 + ",</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + header3 + ",</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + header5 + ",</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp.getName() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp2 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp3 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp4 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp5 + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + emp.getPosition() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + footer2 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + footer3 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + footer4 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">" + footer5 + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.47\" x:Right=\"0.23\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>7</ActiveRow>");
        wb.println("      <ActiveCol>7</ActiveCol>");
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
