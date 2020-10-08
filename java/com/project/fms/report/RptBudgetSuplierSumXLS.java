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
import com.project.system.DbSystemProperty;
import com.project.general.Approval;
import com.project.general.Bank;
import com.project.general.Company;
import com.project.general.DbApproval;
import com.project.general.DbBank;
import com.project.general.DbBank;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.util.NumberSpeller;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class RptBudgetSuplierSumXLS extends HttpServlet {

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
        int paymentType = 0;
        long userId = 0;
        User user = new User();
        
        int non = 0;
        int konsinyasi = 0;
        int komisi = 0;

        Vector dateTrans = new Vector();
        Hashtable print = new Hashtable();
        HttpSession session = request.getSession();
        long historyPrint = JSPRequestValue.requestLong(request, "history_print");

        String bankTransfer = "";
        String msgTransfer = "";

        try {
            bankTransfer = DbSystemProperty.getValueByName("BANK_TRANSFER");
        } catch (Exception e) {
        }

        try {
            msgTransfer = DbSystemProperty.getValueByName("MSG_TRANSFER");
        } catch (Exception e) {
        }

        try {
            dateTrans = (Vector) session.getValue("DATE_TRANS_DATE");
            SessReportBudgetSuplier dt1 = (SessReportBudgetSuplier) dateTrans.get(0);
            SessReportBudgetSuplier dt2 = (SessReportBudgetSuplier) dateTrans.get(1);
            dateFrom = dt1.getTransDate();
            dateTo = dt2.getTransDate();
        } catch (Exception e) {
        }

        try {
            print = (Hashtable) session.getValue("PRINT_REPORT_BUDGET");
        } catch (Exception e) {
        }

        try {
            paymentType = JSPRequestValue.requestInt(request, "payment_type");
        } catch (Exception e) {
            System.out.println(e.toString());
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
            non = JSPRequestValue.requestInt(request, "non");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            konsinyasi = JSPRequestValue.requestInt(request, "konsinyasi");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            komisi = JSPRequestValue.requestInt(request, "komisi");
        } catch (Exception e) {
            System.out.println(e.toString());
        }   

        Vector list2 = new Vector();
        try {
            list = SessReportAnggaran.getBudgetSuplierSummary(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER, paymentType,non,konsinyasi,komisi);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        Hashtable vendorIdx = new Hashtable();
        try {
            if(historyPrint == 0){
                list2 = SessReportAnggaran.getBudgetSuplier(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,non,konsinyasi,komisi);
            }else{
                vendorIdx = DbReportBudget.listNumber(historyPrint);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        String v = "";
        int numberx = 1;        
        for (int i = 0; i < list2.size(); i++) {
            SessReportBudgetSuplier srbs = (SessReportBudgetSuplier) list2.get(i);
            if (v.equalsIgnoreCase("") || v.compareToIgnoreCase(srbs.getSuplier()) != 0) {
                vendorIdx.put("" + srbs.getVendorId(), "" + numberx);
                numberx++;
            }
            v = srbs.getSuplier();
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

        if (!(pkp == 1 && nonpkp == 1)) {
            if (pkp == 1) {
                title = title + " ( PKP )";
            }
            if (nonpkp == 1) {
                title = title + " ( NON PKP )";
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
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s132\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"28.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"110.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"30.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");

        wb.println("      <Row ss:Index=\"2\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + " " + title + "</Data></Cell>");
        wb.println("      </Row>");
        if (ignore == 0) {

            String date = "";
            if (dateFrom.compareTo(dateTo) == 0) {
                date = JSPFormater.formatDate(dateFrom, "dd/MM/yyyy");
            } else {
                date = JSPFormater.formatDate(dateFrom, "dd/MM/yyyy") + " TO " + JSPFormater.formatDate(dateTo, "dd/MM/yyyy");
            }

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">DATE : " + date + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">TO : " + bankTransfer + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s132\"><Data ss:Type=\"String\">''" + msgTransfer + "''</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      </Row>");

        if (list != null && list.size() > 0) {

            wb.println("      <Row >");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">NO</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">NAME OF SUPLIER</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">BRAND OF SUPPLIER</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">REF</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">BANK</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">NO ACCOUNT</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">PAYMENT</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">Message For</Data></Cell>");
            wb.println("      </Row>");

            double totAmount = 0;
            int number = 1;

            for (int i = 0; i < list.size(); i++) {
                SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
                srbs = (SessReportBudgetSuplier) list.get(i);
                long oid = 0;
                try {
                    oid = Long.parseLong("" + print.get("" + srbs.getBankpoPaymentId()));
                } catch (Exception e) {
                }

                if (oid != 0) {
                    totAmount = totAmount + srbs.getValue();
                    Bank b = new Bank();
                    try {
                        b = DbBank.fetchExc(srbs.getBankId());
                    } catch (Exception e) {
                    }

                    String noRek = "";
                    if (srbs.getNoRek() != null) {
                        noRek = srbs.getNoRek();
                    }

                    String contact = "";
                    if (srbs.getContact() != null) {
                        contact = srbs.getContact();
                    }
                    
                    int idx = 0;
                    try{
                        idx = Integer.parseInt(String.valueOf(vendorIdx.get(""+srbs.getVendorId())));
                    }catch(Exception e){}

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + number + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">" + contact + "</Data></Cell>");
                    number = number + 1;
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">" + srbs.getSuplier() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">" + idx + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">" + b.getName() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">" + noRek + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"Number\">" + srbs.getValue() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      </Row>");
                }
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">" + totAmount + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s16\"/>");
            wb.println("      </Row>");

            String spell = "";
            try {
                String a = JSPFormater.formatNumber(totAmount, "#,###");
                NumberSpeller numberSpeller = new NumberSpeller();
                String u = a.replaceAll(",", "");
                spell = numberSpeller.spellNumberToIna(Double.parseDouble(u)) + " Rupiah";
            } catch (Exception e) {
                spell = "";
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">TERBILANG : " + spell + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s17\"><Data ss:Type=\"String\">DIPERIKSA</Data></Cell>");
            wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp.getName() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + emp.getPosition() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
        }

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
