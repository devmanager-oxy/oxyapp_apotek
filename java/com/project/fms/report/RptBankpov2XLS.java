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
import com.project.admin.DbUser;
import com.project.admin.User;

import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.general.Vendor;
import com.project.payroll.Employee;
import com.project.payroll.DbEmployee;
import com.project.util.NumberSpeller;

/**
 *
 * @author Roy
 */
public class RptBankpov2XLS extends HttpServlet {

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
        long bankpoPaymentId = 0;
        BankpoPayment bankpoPayment = new BankpoPayment();
        long userId = 0;
        User user = new User();
        Vector vVendor = new Vector();
        try {
            bankpoPaymentId = JSPRequestValue.requestLong(request, "bankpopayment_id");
            vVendor = DbBankpoPaymentDetail.getGroupVendor(bankpoPaymentId);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            bankpoPayment = DbBankpoPayment.fetchExc(bankpoPaymentId);
        } catch (Exception e) {
        }

        try {
            lang = JSPRequestValue.requestInt(request, "lang");
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        User ux = new User();
        try {
            ux = DbUser.fetch(bankpoPayment.getOperatorId());
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
        wb.println("      <LastPrinted>2015-02-10T19:07:00Z</LastPrinted>");
        wb.println("      <Created>2015-02-10T17:52:22Z</Created>");
        wb.println("      <LastSaved>2015-02-10T19:12:46Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        
        wb.println("      <WindowHeight>8445</WindowHeight>");
        //wb.println("      <WindowWidth>19440</WindowWidth>");
        wb.println("      <WindowWidth>15600</WindowWidth>");
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
        wb.println("      <Style ss:ID=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s65\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"11\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s110\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s111\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s120\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s122\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s123\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s129\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s133\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s134\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s142\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s143\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s144\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s148\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s154\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Courier New\" x:Family=\"Modern\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table ss:ExpandedColumnCount=\"11\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"86.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"13.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"24\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"42.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"12.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"113.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"138.75\"/>");
        //Baris 1
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(new Date(), "dd MM yyyy") + " at " + JSPFormater.formatDate(new Date(), "hh:mm:ss") + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s62\"/>");
        wb.println("      <Cell ss:Index=\"9\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">Page 1 of 1</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s65\"/>");
        wb.println("      </Row>");

        //Baris 2
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
        wb.println("      </Row>");

        //Baris 3
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"8\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s69\"/>");
        wb.println("      </Row>");

        //Baris 4
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"8\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">POST DATED INVOICE &amp; FAKTUR PAJAK</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s69\"/>");
        wb.println("      </Row>");

        //Baris 5
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");

        int baris = 5;

        if (vVendor != null && vVendor.size() > 0) {

            for (int v = 0; v < vVendor.size(); v++) {

                long vendorId = Long.parseLong("" + vVendor.get(v));

                String where = DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = " + bankpoPaymentId + " and " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + vendorId;
                Vector vBpd = DbBankpoPaymentDetail.list(0, 0, where, null);

                Vendor vend = new Vendor();
                try {
                    vend = DbVendor.fetchExc(vendorId);
                } catch (Exception e) {
                }

                //Baris 6
                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Post Dated No</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + bankpoPayment.getJournalNumber() + "</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">To</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + vend.getName() + "</Data></Cell>");
                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                wb.println("      </Row>");
                baris++;

                //Baris 7
                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Date</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(bankpoPayment.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Phone</Data></Cell>");
                //wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Atas Nama</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + vend.getPhone() + "</Data></Cell>");
                //wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + vend.getContact() + "</Data></Cell>");
                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                wb.println("      </Row>");
                baris++;

                
                /*wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Clearing Date</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">No BG.</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                    wb.println("      </Row>");
                    baris++;*/
                
                if (vend.getAddress() == null || vend.getAddress().length() <= 0) {
                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Clearing Date</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy") + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Address</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                    wb.println("      </Row>");
                    baris++;
                } else {
                    String[] address = new String[10];
                    address = vend.getAddress().split(" ");
                    int maxAddr = 0;
                    String kalimatAddress = vend.getAddress();
                    boolean availableAddress = true;

                    if (vend.getAddress().length() > 0) {
                        kalimatAddress = "";
                        for (int iAddr = 0; iAddr < address.length; iAddr++) {
                            String tmpKalimat1 = address[iAddr];
                            maxAddr = maxAddr + tmpKalimat1.length();

                            if (maxAddr > 25) {

                                if (availableAddress) {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Clearing Date</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy") + "</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Address</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + kalimatAddress + "</Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                    availableAddress = false;
                                } else {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + kalimatAddress + "</Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                }

                                maxAddr = tmpKalimat1.length();
                                kalimatAddress = tmpKalimat1;
                                baris++;
                            } else {

                                if (kalimatAddress != null && kalimatAddress.length() > 0) {
                                    kalimatAddress = kalimatAddress + " ";
                                }
                                kalimatAddress = kalimatAddress + tmpKalimat1;
                            }
                        }

                    }
                    if ((kalimatAddress != null && kalimatAddress.length() > 0) || availableAddress) {

                        if (availableAddress) {
                            wb.println("      <Row ss:AutoFitHeight=\"0\">");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Clearing Date</Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy") + "</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Address</Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + kalimatAddress + "</Data></Cell>");
                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                            wb.println("      </Row>");
                        } else {
                            wb.println("      <Row ss:AutoFitHeight=\"0\">");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + kalimatAddress + "</Data></Cell>");
                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                            wb.println("      </Row>");
                        }
                        baris++;
                    }
                }

                
                String[] memo = new String[10];
                memo = bankpoPayment.getMemo().split(" ");
                int maxMemo = 0;
                String kalimatMemo = bankpoPayment.getMemo();
                boolean availableMemo = true;

                if (vend.getAddress().length() > 0) {
                    kalimatMemo = "";
                    for (int iAddr = 0; iAddr < memo.length; iAddr++) {
                        String tmpKalimat1 = memo[iAddr];
                        maxMemo = maxMemo + tmpKalimat1.length();

                        if (maxMemo > 75) {

                            if (availableMemo) {
                                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Remark</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                                wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">" + kalimatMemo + "</Data></Cell>");
                                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                wb.println("      </Row>");
                                availableMemo = false;
                            } else {
                                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                                wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">" + kalimatMemo + "</Data></Cell>");
                                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                wb.println("      </Row>");
                            }

                            maxMemo = tmpKalimat1.length();
                            kalimatMemo = tmpKalimat1;
                            baris++;
                        } else {
                            if (kalimatMemo != null && kalimatMemo.length() > 0) {
                                kalimatMemo = kalimatMemo + " ";
                            }
                            kalimatMemo = kalimatMemo + tmpKalimat1;

                        }
                    }
                }
                
                if ((kalimatMemo != null && kalimatMemo.length() > 0) || availableMemo) {
                    if (availableMemo) {
                        wb.println("      <Row ss:AutoFitHeight=\"0\">");
                        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Remark</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">:</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">" + kalimatMemo + "</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                        wb.println("      </Row>");
                    } else {
                        wb.println("      <Row ss:AutoFitHeight=\"0\">");
                        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s105\"><Data ss:Type=\"String\">" + kalimatMemo + "</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                        wb.println("      </Row>");
                    }
                    baris++;
                }

                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:StyleID=\"s70\"/>");
                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                wb.println("      </Row>");
                baris++;

                if (vBpd != null && vBpd.size() > 0) {

                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:StyleID=\"s120\"><Data ss:Type=\"String\">Invoice No</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s120\"><Data ss:Type=\"String\">Description</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s120\"><Data ss:Type=\"String\">Date</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s122\"><Data ss:Type=\"String\">Purchase</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s123\"><Data ss:Type=\"String\">Deduction</Data></Cell>");
                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s83\"/>");
                    wb.println("      </Row>");
                    baris++;

                    double tPurchase = 0;
                    double tDeduction = 0;

                    for (int i = 0; i < vBpd.size(); i++) {

                        BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBpd.get(i);

                        Receive receive = new Receive();
                        try {
                            receive = DbReceive.fetchExc(bpd.getInvoiceId());
                        } catch (Exception e) {
                        }

                        double purchase = 0;
                        double deduction = 0;

                        if (bpd.getPaymentAmount() > 0) {
                            purchase = bpd.getPaymentAmount();
                        } else {
                            deduction = bpd.getPaymentAmount() * -1;
                        }

                        if (bpd.getMemo() == null && bpd.getMemo().length() <= 0) {
                            wb.println("      <Row ss:AutoFitHeight=\"0\">");
                            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + receive.getNumber() + "</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(purchase, "#,###.##") + "</Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(deduction, "#,###.##") + "</Data></Cell>");
                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                            wb.println("      </Row>");
                            baris++;

                        } else {

                            String[] desc = new String[10];
                            desc = bpd.getMemo().split(" ");
                            int max = 0;
                            String kalimat = bpd.getMemo();
                            boolean available = true;

                            if (desc.length > 0) {
                                kalimat = "";
                                for (int iKalimat = 0; iKalimat < desc.length; iKalimat++) {
                                    String tmpKalimat = desc[iKalimat];
                                    max = max + tmpKalimat.length();
                                    if (max > 25) {

                                        if (available) {
                                            wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + receive.getNumber() + "</Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(purchase, "#,###.##") + "</Data></Cell>");
                                            wb.println("      <Cell ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(deduction, "#,###.##") + "</Data></Cell>");
                                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                            wb.println("      </Row>");
                                            available = false;
                                        } else {
                                            wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                            wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s134\"><Data ss:Type=\"String\"></Data></Cell>");
                                            wb.println("      <Cell ss:StyleID=\"s134\"><Data ss:Type=\"String\"></Data></Cell>");
                                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                            wb.println("      </Row>");

                                        }

                                        baris++;
                                        max = tmpKalimat.length();
                                        kalimat = tmpKalimat;
                                    } else {
                                        if (kalimat != null && kalimat.length() > 0) {
                                            kalimat = kalimat + " ";
                                        }
                                        kalimat = kalimat + tmpKalimat;
                                    }
                                }
                            }

                            if ((kalimat != null && kalimat.length() > 0) || available) {

                                if (available) {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                    wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + receive.getNumber() + "</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy") + "</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(purchase, "#,###.##") + "</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(deduction, "#,###.##") + "</Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                } else {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                                    wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s134\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s134\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                }
                                baris++;
                            }
                        }

                        tPurchase = tPurchase + purchase;
                        tDeduction = tDeduction + deduction;
                    }

                    double amount = tPurchase - tDeduction;

                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:StyleID=\"s143\"><Data ss:Type=\"String\">Amount</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s143\"><Data ss:Type=\"String\">:</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s144\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(amount, "#,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s143\"/>");
                    wb.println("      <Cell ss:StyleID=\"s143\"/>");
                    wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s143\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(tPurchase, "#,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s143\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(tDeduction, "#,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                    wb.println("      </Row>");
                    baris++;

                    String a = JSPFormater.formatNumber(amount, "#,###");
                    NumberSpeller numberSpeller = new NumberSpeller();
                    String u = a.replaceAll(",", "");
                    String spell = numberSpeller.spellNumberToIna(Double.parseDouble(u)) + " Rupiah";

                    String[] descSpell = new String[10];
                    descSpell = spell.split(" ");
                    int maxx = 0;
                    String kalimat = spell;
                    boolean available = true;

                    if (descSpell.length > 0) {
                        kalimat = "";
                        for (int iKalimat = 0; iKalimat < descSpell.length; iKalimat++) {
                            String tmpKalimat = descSpell[iKalimat];
                            maxx = maxx + tmpKalimat.length();
                            if (maxx > 75) {

                                if (available) {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">In Words</Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">:</Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s142\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                    available = false;
                                } else {
                                    wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                                    wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s142\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                                    wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                                    wb.println("      </Row>");
                                }

                                baris++;
                                maxx = tmpKalimat.length();
                                kalimat = tmpKalimat;
                            } else {
                                if (kalimat != null && kalimat.length() > 0) {
                                    kalimat = kalimat + " ";
                                }
                                kalimat = kalimat + tmpKalimat;
                            }
                        }
                    }

                    if ((kalimat != null && kalimat.length() > 0) || available) {

                        if (available) {
                            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">In Words</Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">:</Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s142\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                            wb.println("      </Row>");
                        } else {
                            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s142\"><Data ss:Type=\"String\">" + kalimat + "</Data></Cell>");
                            wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                            wb.println("      </Row>");
                        }
                        baris++;
                    }
                }
            }
        }
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        baris++;

        Employee create = new Employee();

        try {
            create = DbEmployee.fetchExc(ux.getEmployeeId());
        } catch (Exception e) {
        }
        String crName = "";
        if (create.getName().length() > 0) {
            crName = create.getName();
        }

        int loop = 0;
        if (baris == 21 || baris == 45 || baris == 69 || baris == 93) {
            loop = 4;
        }

        if (baris == 22 || baris == 46 || baris == 67 || baris == 94) {
            loop = 3;
        }

        if (baris == 23 || baris == 47 || baris == 68 || baris == 95) {
            loop = 2;
        }

        if (baris == 24 || baris == 48 || baris == 69 || baris == 96) {
            loop = 1;
        }

        if (loop != 0) {
            for (int ix = 0; ix < loop; ix++) {
                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s111\"/>");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:StyleID=\"s72\"/>");
                wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
                wb.println("      </Row>");
            }

        }

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Submited by,</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Create By</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Checked By</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        baris++;

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s111\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        baris++;

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s111\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        baris++;

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s148\"><Data ss:Type=\"String\">(                    )</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s154\"><Data ss:Type=\"String\">(  " + crName + "  )</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s110\"><Data ss:Type=\"String\">(                   )</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Suplier</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Acct.</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">Spv Acct.</Data></Cell>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s102\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"11\" ss:StyleID=\"s102\"/>");
        wb.println("      </Row>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        //wb.println("      <Header x:Margin=\"0.31496062992125984\"/>");
        //wb.println("      <Footer x:Margin=\"0.31496062992125984\"/>");
        //wb.println("      <PageMargins x:Bottom=\"0.19685039370078741\" x:Left=\"0.19685039370078741\"");
        //wb.println("      x:Right=\"0.11811023622047245\" x:Top=\"0.19685039370078741\"/>");



        wb.println("      <Header x:Margin=\"0.31496062992125984\"/>");
        wb.println("      <Footer x:Margin=\"0.31496062992125984\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.19685039370078741\" x:Left=\"0.19685039370078741\" x:Right=\"0.11811023622047245\" x:Top=\"0.19685039370078741\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>152</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");

        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <TopRowVisible>3</TopRowVisible>");

        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>11</ActiveRow>");
        wb.println("      <ActiveCol>10</ActiveCol>");
        wb.println("      <RangeSelection>R122C4:R122C7</RangeSelection>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
        wb.println("      <Table x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
