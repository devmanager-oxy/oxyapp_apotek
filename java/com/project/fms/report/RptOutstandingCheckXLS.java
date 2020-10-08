/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import com.project.admin.DbUser;
import com.project.admin.User;
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
import com.project.fms.session.SysUser;
import java.sql.ResultSet;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;

import com.project.general.BankPayment;
import com.project.general.DbBankPayment;
import com.project.general.DbVendor;
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import com.project.util.NumberSpeller;

/**
 *
 * @author Roy
 */
public class RptOutstandingCheckXLS extends HttpServlet {

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
        User user = new User();
        try{
            user = DbUser.fetch(userId);
        }catch(Exception e){}

        Vector parameter = new Vector();
        Vector listBankPayment = new Vector();

        try {
            HttpSession session = request.getSession();
            parameter = (Vector) session.getValue("PARAMETER_REPORT_OUTSTANDING_BG_CHEQUE");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            HttpSession session = request.getSession();
            listBankPayment = (Vector) session.getValue("REPORT_OUTSTANDING_BG_CHEQUE");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        int ignoreInputDate = 0;
        Date startDate = new Date();
        Date endDate = new Date();
        long vendorId = 0;
        int type = 0;
        int status = 0;

        try {
            ignoreInputDate = Integer.parseInt(String.valueOf("" + parameter.get(0)));
        } catch (Exception e) {
        }

        try {
            startDate = JSPFormater.formatDate(String.valueOf("" + parameter.get(1)), "dd/MM/yyyy");
        } catch (Exception e) {
        }

        try {
            endDate = JSPFormater.formatDate(String.valueOf("" + parameter.get(2)), "dd/MM/yyyy");
        } catch (Exception e) {
        }

        try {
            vendorId = Long.parseLong(String.valueOf("" + parameter.get(3)));
        } catch (Exception e) {
        }

        try {
            type = Integer.parseInt(String.valueOf("" + parameter.get(4)));
        } catch (Exception e) {
        }

        try {
            status = Integer.parseInt(String.valueOf("" + parameter.get(5)));
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
        wb.println("      <Author>SOMgr</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <LastPrinted>2016-02-20T01:07:42Z</LastPrinted>");
        wb.println("      <Created>2016-02-18T03:56:08Z</Created>");
        wb.println("      <LastSaved>2016-02-20T00:59:30Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>5130</WindowHeight>");
        wb.println("      <WindowWidth>14295</WindowWidth>");
        wb.println("      <WindowTopX>480</WindowTopX>");
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
        wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
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

        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s64n\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s64l\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s65\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s65n\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s65l\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s90\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s90n\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s90l\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s92n\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s92l\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"");
        wb.println("      ss:Color=\"#BFBFBF\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s117\" ss:Parent=\"s16\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"30\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"86.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">Daftar Outstanding Cheque</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s86\"/>");
        wb.println("      <Cell ss:StyleID=\"s86\"/>");
        wb.println("      </Row>");
        String str = "";
        if (ignoreInputDate == 0) {
            String strDate1 = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
            String strDate2 = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            if (strDate1.equals(strDate2)) {
                str = "Per-Tanggal " + strDate1;
            } else {
                str = "Periode Tanggal " + strDate1 + " sampai " + strDate2;
            }
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">" + str + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (vendorId != 0) {
            try {
                Vendor v = DbVendor.fetchExc(vendorId);
                if (v.getOID() != 0) {
                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">Vendor " + v.getName() + "</Data></Cell>");
                    wb.println("      </Row>");
                }
            } catch (Exception e) {
            }
        }

        if (status == -1) {
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">Status : Belum Cair & Sudah Cair</Data></Cell>");
            wb.println("      </Row>");
        } else {
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            if(status== DbBankPayment.STATUS_NOT_PAID ){
                wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">Status : Belum Cair</Data></Cell>");
            }else{
                wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\">Status : Sudah Cair</Data></Cell>");
            }
            wb.println("      </Row>");
        }

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");            
                
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"27.75\">");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Tanggal Transaksi</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Kode Transaksi</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">No Cheque</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Nama Bank</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Vendor</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Jumlah</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\"/>");
        if (listBankPayment != null && listBankPayment.size() > 0) {
            double total = 0;
            for (int i = 0; i < listBankPayment.size(); i++) {

                BankPayment pp = (BankPayment) listBankPayment.get(i);
                total = total + pp.getAmount();


                String vendorName = "";
                String coaName = "";
                if (pp.getVendorId() != 0) {
                    try {
                        Vendor vendor = DbVendor.fetchExc(pp.getVendorId());
                        vendorName = vendor.getName();
                    } catch (Exception e) {
                    }

                }

                if (pp.getCoaPaymentId() != 0 && pp.getStatus() == 1) {
                    try {
                        Coa c = DbCoa.fetchExc(pp.getCoaPaymentId());
                        coaName = c.getName();
                    } catch (Exception e) {
                    }
                }

                if (i == 0) {
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(pp.getTransactionDate(), "dd/MM/yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">" + pp.getJournalNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">" + pp.getNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">" + coaName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">" + vendorName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"Number\">" + pp.getAmount() + "</Data></Cell>");
                    wb.println("      </Row>");
                } else if (i != (listBankPayment.size() - 1)) {

                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s64n\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s92n\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(pp.getTransactionDate(), "dd/MM/yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65n\"><Data ss:Type=\"String\">" + pp.getJournalNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65n\"><Data ss:Type=\"String\">" + pp.getNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65n\"><Data ss:Type=\"String\">" + coaName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65n\"><Data ss:Type=\"String\">" + vendorName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s90n\"><Data ss:Type=\"Number\">" + pp.getAmount() + "</Data></Cell>");
                    wb.println("      </Row>");
                } else {
                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
                    wb.println("      <Cell ss:StyleID=\"s64l\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s92l\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(pp.getTransactionDate(), "dd/MM/yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65l\"><Data ss:Type=\"String\">" + pp.getJournalNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65l\"><Data ss:Type=\"String\">" + pp.getNumber() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65l\"><Data ss:Type=\"String\">" + coaName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s65l\"><Data ss:Type=\"String\">" + vendorName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s90l\"><Data ss:Type=\"Number\">" + pp.getAmount() + "</Data></Cell>");
                    wb.println("      </Row>");
                }
            }
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\">");
            wb.println("      <Cell ss:StyleID=\"s73\"/>");
            wb.println("      <Cell ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s74\"/>");
            wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Jumlah               Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
            wb.println("      </Row>");
        }


        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s77\"/>");
        wb.println("      <Cell ss:StyleID=\"s78\"/>");
        wb.println("      <Cell ss:StyleID=\"s78\"/>");
        wb.println("      <Cell ss:StyleID=\"s78\"/>");
        wb.println("      <Cell ss:StyleID=\"s78\"/>");
        wb.println("      <Cell ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>"); 
        
        String addrReport = "";
        try{
            addrReport = DbSystemProperty.getValueByName("ADDRESS_REPORT");
        }catch(Exception e){}
        
        String month = "";
        if (new Date().getMonth() == 0) {
            month = "Januari";
        } else if (new Date().getMonth() == 1) {
            month = "Februari";
        } else if (new Date().getMonth() == 2) {
            month = "Maret";
        } else if (new Date().getMonth() == 3) {
            month = "April";
        } else if (new Date().getMonth() == 4) {
            month = "Mei";
        } else if (new Date().getMonth() == 5) {
            month = "Juni";
        } else if (new Date().getMonth() == 6) {
            month = "Juli";
        } else if (new Date().getMonth() == 7) {
            month = "Agustus";
        } else if (new Date().getMonth() == 8) {
            month = "September";
        } else if (new Date().getMonth() == 9) {
            month = "Oktober";
        } else if (new Date().getMonth() == 10) {
            month = "November";
        } else if (new Date().getMonth() == 11) {
            month = "Desember";
        }
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell><Data ss:Type=\"String\">"+addrReport+", " + new Date().getDate() + " " + month + " " + (new Date().getYear() + 1900) +"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell><Data ss:Type=\"String\">Dilaporkan Oleh </Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>"); 
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>"); 
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>"); 
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell><Data ss:Type=\"String\">"+user.getFullName()+"</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>"); 
        
        wb.println("      <Row  ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell><Data ss:Type=\"String\">Note :</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Yang dilaporkan hanya yang belum terbayar</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.45\" x:Right=\"0.45\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>600</HorizontalResolution>");
        wb.println("      <VerticalResolution>600</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>17</ActiveRow>");
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
