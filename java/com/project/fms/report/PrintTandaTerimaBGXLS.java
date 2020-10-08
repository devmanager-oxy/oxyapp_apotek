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

import com.lowagie.text.Font;
import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.session.SessReportAnggaran;
import com.project.fms.session.SessReportBudgetSuplier;
import com.project.fms.transaction.*;
import com.project.general.Approval;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbApproval;
import com.project.general.DbCompany;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.DbVendor;
import com.project.general.SystemDocNumber;
import com.project.general.Vendor;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class PrintTandaTerimaBGXLS extends HttpServlet {

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
        long vendorId = 0;
        Date dateFrom = new Date();
        Date dateTo = new Date();
        int ignore = 0;
        int pkp = 0;
        int nonpkp = 0;
        Vector list = new Vector();
        int paymentType = 0;

        int non = 0;
        int konsinyasi = 0;
        int komisi = 0;

        long userId = 0;
        User user = new User();

        Vector dateTrans = new Vector();
        Hashtable print = new Hashtable();
        HttpSession session = request.getSession();

        try {
            dateTrans = (Vector) session.getValue("DATE_TRANS_DATE");
            SessReportBudgetSuplier dt1 = (SessReportBudgetSuplier) dateTrans.get(0);
            SessReportBudgetSuplier dt2 = (SessReportBudgetSuplier) dateTrans.get(1);
            dateFrom = dt1.getTransDate();
            dateTo = dt2.getTransDate();
        } catch (Exception e) {
        }

        try {
            print = (Hashtable) session.getValue("PRINT_REPORT_BUDGET_TT");
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


        try {
            paymentType = JSPRequestValue.requestInt(request, "payment_type");
        } catch (Exception e) {
        }

        try {
            list = SessReportAnggaran.getBudgetSuplierGroup(vendorId, dateFrom, dateFrom, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER, paymentType);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }
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

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

        // taruh disini excelnya
        wb.println("      <?xml version=\"1.0\"?>");
        wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>oxy-system</Author>");
        wb.println("      <LastAuthor>oxy-system</LastAuthor>");
        wb.println("      <LastPrinted>2015-10-20T14:15:26Z</LastPrinted>");
        wb.println("      <Created>2015-10-19T09:11:01Z</Created>");
        wb.println("      <LastSaved>2015-10-20T14:20:48Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>7950</WindowHeight>");
        wb.println("      <WindowWidth>20055</WindowWidth>");
        wb.println("      <WindowTopX>240</WindowTopX>");
        wb.println("      <WindowTopY>60</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"m72474664\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m72474684\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"16\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m72474784\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m72474804\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m72474824\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m72474844\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s16\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s17\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"m31482100\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"m31482120\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"m31484848\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"m31482160\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"m31482180\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"m31484868\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
        
        
        wb.println("      <Style ss:ID=\"s18\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s19\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s20\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s21\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s22\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s24\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s25\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s26\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s27\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s32\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s33\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s34\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");


        wb.println("      <Style ss:ID=\"s34i\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s35\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s36\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s37\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s33ii\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s38\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s33i\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s61\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"TandaTerimBG\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"27\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"102\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"21\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"94.5\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"99\"/>");
        wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        String vendorSelect = "";

        double total = 0;
        String numberSelect = "";
        String number = "";

        String header = "";
        String footer = "";
        try {
            Approval approval = DbApproval.getListApproval(11, DbApproval.URUTAN_0);
            header = approval.getKeterangan();
            footer = approval.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String header1 = "";
        String emp1 = "";
        String footer1 = "";
        try {
            Approval approval1 = DbApproval.getListApproval(11, DbApproval.URUTAN_1);
            try {
                Employee employee1 = DbEmployee.fetchExc(approval1.getEmployeeId());
                emp1 = employee1.getName();
            } catch (Exception e) {
            }
            header1 = approval1.getKeterangan();
            footer1 = approval1.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        String header2 = "";
        String emp2 = "";
        String footer2 = "";
        try {
            Approval approval2 = DbApproval.getListApproval(11, DbApproval.URUTAN_2);
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
            Approval approval3 = DbApproval.getListApproval(11, DbApproval.URUTAN_3);
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

        String header4 = "";
        String footer4 = "";

        try {
            Approval approval4 = DbApproval.getListApproval(11, DbApproval.URUTAN_4);
            header4 = approval4.getKeterangan();
            footer4 = approval4.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        boolean first = true;

        for (int i = 0; i < list.size(); i++) {
            SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
            srbs = (SessReportBudgetSuplier) list.get(i);

            long oidx = 0;
            try {
                oidx = Long.parseLong("" + print.get("" + srbs.getBankpoPaymentId()));
            } catch (Exception e) {
            }

            if (oidx != 0) {
                //Pengecekan number
                String where = DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(dateFrom, "yyyy-MM-dd") + " 00:00:00' and " +
                        " '" + JSPFormater.formatDate(dateTo, "yyyy-MM-dd") + " 23:59:59' and lower(" + DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_VENDOR] + ") = '" + srbs.getSuplier().toLowerCase() + "' ";
                Vector numbMains = DbTandaTerimaBGMain.list(0, 1, where, null);
                if (numbMains != null && numbMains.size() > 0) {
                    TandaTerimaBGMain ttMain = (TandaTerimaBGMain) numbMains.get(0);
                    Vector numbs = DbTandaTerimaBG.list(0, 1, DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_BANKPO_PAYMENT_ID] + " = " + srbs.getBankpoPaymentId(), null);
                    if (numbs != null && numbs.size() > 0) {
                        number = ttMain.getNumber();
                    } else {
                        TandaTerimaBG ttDetail = new TandaTerimaBG();
                        ttDetail.setAmount(srbs.getValue());
                        ttDetail.setTandaTerimaBgMainId(ttMain.getOID());
                        ttDetail.setVendorId(srbs.getVendorId());
                        ttDetail.setSupplierName(srbs.getSuplier());
                        ttDetail.setTransDate(new Date());
                        ttDetail.setBankpoPaymentId(srbs.getBankpoPaymentId());
                        try {
                            DbTandaTerimaBG.insertExc(ttDetail);
                        } catch (Exception e) {
                        }
                    }
                    number = ttMain.getNumber();
                } else {

                    Periode p = new Periode();
                    try {
                        p = DbPeriode.getPeriodByTransDate(dateFrom);
                    } catch (Exception e) {
                    }

                    //generate number
                    Date dt = new Date();
                    int periodeTaken = 0;

                    try {
                        periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                    } catch (Exception e) {
                    }

                    if (periodeTaken == 0) {
                        dt = p.getStartDate();  // untuk mendapatkan periode yang aktif
                    } else if (periodeTaken == 1) {
                        dt = p.getEndDate();  // untuk mendapatkan periode yang aktif}
                    }

                    TandaTerimaBGMain ttMain = new TandaTerimaBGMain();
                    String formatDocCode = DbSystemDocNumber.getNumberPrefix(p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_CHECK);
                    int counter = DbSystemDocNumber.getNextCounter(p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_CHECK);
                    ttMain.setCounter(counter);
                    ttMain.setPrefix(formatDocCode);
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(counter);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setPrefixNumber(formatDocCode);
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT_CHECK]);
                    systemDocNumber.setYear(dt.getYear() + 1900);

                    String journalNumber = DbSystemDocNumber.getNextNumber(counter, p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_CHECK);
                    systemDocNumber.setDocNumber(journalNumber);
                    ttMain.setNumber(journalNumber);
                    ttMain.setCreateDate(new Date());
                    ttMain.setTransDate(dateFrom);
                    ttMain.setVendorId(srbs.getVendorId());
                    ttMain.setVendor(srbs.getSuplier());
                    number = ttMain.getNumber();
                    try {
                        long oid = DbTandaTerimaBGMain.insertExc(ttMain);

                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) {
                                System.out.println("[exception] " + E.toString());
                            }

                            TandaTerimaBG ttDetail = new TandaTerimaBG();
                            ttDetail.setAmount(srbs.getValue());
                            ttDetail.setTandaTerimaBgMainId(oid);
                            ttDetail.setVendorId(srbs.getVendorId());
                            ttDetail.setSupplierName(srbs.getSuplier());
                            ttDetail.setTransDate(new Date());
                            ttDetail.setBankpoPaymentId(srbs.getBankpoPaymentId());
                            try {
                                DbTandaTerimaBG.insertExc(ttDetail);
                            } catch (Exception e) {
                            }
                        }
                    } catch (Exception e) {
                    }
                }

                if (first) {
                    vendorSelect = srbs.getSuplier();
                    numberSelect = number;
                }

                if (!vendorSelect.equalsIgnoreCase(srbs.getSuplier())) {


                    wb.println("      <Row ss:Height=\"18.75\">");
                    wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s20\"/>");
                    wb.println("      <Cell ss:StyleID=\"s20\"/>");
                    wb.println("      <Cell ss:StyleID=\"s20\"/>");
                    wb.println("      <Cell ss:StyleID=\"s20\"/>");
                    wb.println("      <Cell ss:StyleID=\"s20\"/>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:Height=\"21\">");
                    wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m72474684\"><Data ss:Type=\"String\">BUKTI PENGELUARAN BANK</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Dibayarkan Kepada</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");

                    wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">: " + vendorSelect.toUpperCase() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s17\"/>");
                    wb.println("      <Cell ss:StyleID=\"s17\"/>");
                    wb.println("      <Cell ss:StyleID=\"s17\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">No BPB</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + numberSelect + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Tgl Dibuat</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + JSPFormater.formatDate(new Date(), "dd-MM-yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">BG/Cek No</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Tgl JT</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Bank</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Periode Budget Tgl</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + JSPFormater.formatDate(dateFrom, "dd-MM-yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s18\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");

                    /*wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474784\"><Data ss:Type=\"String\">NO</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m72474804\"><Data");
                    wb.println("      ss:Type=\"String\">KETERANGAN</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m72474824\"><Data");
                    wb.println("      ss:Type=\"String\">NOMOR            PERKIRAAN</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474844\"><Data ss:Type=\"String\">DEBET</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474664\"><Data ss:Type=\"String\">KREDIT</Data></Cell>");
                    wb.println("      </Row>");*/

                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482100\"><Data ss:Type=\"String\">NO</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m31482120\"><Data");
                    wb.println("      ss:Type=\"String\">KETERANGAN</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m31484848\"><Data ss:Type=\"String\">NOMOR</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482160\"><Data ss:Type=\"String\">DEBET</Data></Cell>");
                    wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482180\"><Data ss:Type=\"String\">KREDIT</Data></Cell>");
                    wb.println("      </Row>");
                    
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
                    wb.println("      <Cell ss:Index=\"4\" ss:MergeAcross=\"1\" ss:StyleID=\"m31484868\"><Data");
                    wb.println("      ss:Type=\"String\">PERKIRAAN</Data></Cell>");
                    wb.println("      </Row>");

                   // wb.println("      <Row ss:Height=\"15.75\"/>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"Number\">1</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">Budget Supplier</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
                    wb.println("      <Cell ss:StyleID=\"s33ii\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s28\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s25\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + vendorSelect.toUpperCase() + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"/>");
                    wb.println("      <Cell ss:StyleID=\"s19\"/>");
                    wb.println("      <Cell ss:StyleID=\"s26\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s25\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"/>");
                    wb.println("      <Cell ss:StyleID=\"s19\"/>");
                    wb.println("      <Cell ss:StyleID=\"s26\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s29\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s61\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"/>");
                    wb.println("      <Cell ss:StyleID=\"s30\"/>");
                    wb.println("      <Cell ss:StyleID=\"s31\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:Height=\"15.75\">");
                    wb.println("      <Cell ss:StyleID=\"s32\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s63\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Total</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s38\"/>");
                    wb.println("      <Cell ss:StyleID=\"s33i\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.00\">");
                    wb.println("      <Cell ss:StyleID=\"s22\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s23\"/>");
                    wb.println("      <Cell ss:StyleID=\"s24\"/>");
                    wb.println("      </Row>");

                    wb.println("      <Row ss:Height=\"15.75\">");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header1 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header2 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header3 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header4 + "</Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"50.0625\">");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp1 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp2 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp3 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.00\">");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer1 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer2 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer3 + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer4 + "</Data></Cell>");
                    wb.println("      </Row>");

                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.4375\">");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"/>");
                    wb.println("      </Row>");
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.4375\"/>");

                    total = 0;

                }
                total = total + srbs.getValue();
                vendorSelect = srbs.getSuplier();
                numberSelect = number;
                first = false;
            }
        }

        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"/>");
        wb.println("      <Cell ss:StyleID=\"s20\"/>");
        wb.println("      <Cell ss:StyleID=\"s20\"/>");
        wb.println("      <Cell ss:StyleID=\"s20\"/>");
        wb.println("      <Cell ss:StyleID=\"s20\"/>");
        wb.println("      <Cell ss:StyleID=\"s21\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
        wb.println("      <Cell ss:StyleID=\"s22\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"21\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m72474684\"><Data ss:Type=\"String\">BUKTI PENGELUARAN BANK</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
        wb.println("      <Cell ss:StyleID=\"s22\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Dibayarkan Kepada</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");

        wb.println("      <Cell ss:StyleID=\"s17\"><Data ss:Type=\"String\">: " + vendorSelect.toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s17\"/>");
        wb.println("      <Cell ss:StyleID=\"s17\"/>");
        wb.println("      <Cell ss:StyleID=\"s17\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">No BPB</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + numberSelect + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Tgl Dibuat</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + JSPFormater.formatDate(new Date(), "dd-MM-yyyy") + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">BG/Cek No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Tgl JT</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Bank</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">Periode Budget Tgl</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"><Data ss:Type=\"String\">: " + JSPFormater.formatDate(dateFrom, "dd-MM-yyyy") + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s18\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9\">");
        wb.println("      <Cell ss:StyleID=\"s22\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");

        /*wb.println("      <Row>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474784\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m72474804\"><Data");
        wb.println("      ss:Type=\"String\">KETERANGAN</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m72474824\"><Data");
        wb.println("      ss:Type=\"String\">NOMOR            PERKIRAAN</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474844\"><Data ss:Type=\"String\">DEBET</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m72474664\"><Data ss:Type=\"String\">KREDIT</Data></Cell>");
        wb.println("      </Row>");*/
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482100\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"m31482120\"><Data");
        wb.println("      ss:Type=\"String\">KETERANGAN</Data></Cell>");

        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m31484848\"><Data ss:Type=\"String\">NOMOR</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482160\"><Data ss:Type=\"String\">DEBET</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31482180\"><Data ss:Type=\"String\">KREDIT</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:Index=\"4\" ss:MergeAcross=\"1\" ss:StyleID=\"m31484868\"><Data");
        wb.println("      ss:Type=\"String\">PERKIRAAN</Data></Cell>");
        wb.println("      </Row>");

        //wb.println("      <Row ss:Height=\"15.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">Budget Supplier</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
        wb.println("      <Cell ss:StyleID=\"s33ii\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s28\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s25\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + vendorSelect.toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s26\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s25\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s19\"/>");
        wb.println("      <Cell ss:StyleID=\"s26\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.0625\">");
        wb.println("      <Cell ss:StyleID=\"s29\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s61\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"/>");
        wb.println("      <Cell ss:StyleID=\"s30\"/>");
        wb.println("      <Cell ss:StyleID=\"s31\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s32\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s63\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s38\"/>");
        wb.println("      <Cell ss:StyleID=\"s33i\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.00\">");
        wb.println("      <Cell ss:StyleID=\"s22\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s23\"/>");
        wb.println("      <Cell ss:StyleID=\"s24\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header1 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header2 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header3 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + header4 + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"50.0625\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp1 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp2 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\">" + emp3 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34i\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.00\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer1 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer2 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer3 + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + footer4 + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.4375\">");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      <Cell ss:StyleID=\"s36\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"14.4375\"/>");

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Layout x:CenterHorizontal=\"1\"/>");
        wb.println("      <Header x:Margin=\"0.31496062992125984\"/>");
        wb.println("      <Footer x:Margin=\"0.31496062992125984\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.19685039370078741\" x:Left=\"0.19685039370078741\"");
        wb.println("      x:Right=\"0.19685039370078741\" x:Top=\"0.19685039370078741\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
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
