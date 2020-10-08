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
import com.project.ccs.session.SessReportClosing;
import com.project.general.Bank;
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbBank;
import com.project.general.DbCompany;

import com.project.general.DbCustomer;
import com.project.general.DbIndukCustomer;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.general.IndukCustomer;
import com.project.general.Location;
import com.project.general.Merchant;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class ReportCardXLS extends HttpServlet {

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
        Vector result = new Vector();
        Vector resultParameter = new Vector();
        Location location = new Location();
        HttpSession session = request.getSession();
        try {
            result = (Vector) session.getValue("REPORT_CARD");
        } catch (Exception e) {
        }

        Date startDate = new Date();
        Date endDate = new Date();
        long locationId = 0;
        long bankId = 0;
        try {
            resultParameter = (Vector) session.getValue("REPORT_CARD_PARAMETER");
            locationId = Long.parseLong(String.valueOf("" + resultParameter.get(0)));
            startDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(1)), "dd/MM/yyyy");
            endDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(2)), "dd/MM/yyyy");
            bankId = Long.parseLong(String.valueOf("" + resultParameter.get(4)));
        } catch (Exception e) {
        }

        try {
            location = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
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
        wb.println("      <Created>2015-03-02T08:45:26Z</Created>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>3345</WindowHeight>");
        wb.println("      <WindowWidth>14295</WindowWidth>");
        wb.println("      <WindowTopX>480</WindowTopX>");
        wb.println("      <WindowTopY>90</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Percent\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
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
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
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
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51.75\"/>");
        wb.println("      <Column ss:Width=\"61.5\" ss:Span=\"3\"/>");
        wb.println("      <Column ss:Index=\"7\" ss:Width=\"61.5\" ss:Span=\"4\"/>");
        wb.println("      <Column ss:Index=\"13\" ss:Width=\"61.5\"/>");
        wb.println("      <Column ss:Width=\"60\"/>");

        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if (location.getOID() != 0) {
            wb.println("      <Row>");
            wb.println("      <Cell><Data ss:Type=\"String\">Location : " + location.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\">Periode " + JSPFormater.formatDate(startDate, "dd MMM") + " - " + JSPFormater.formatDate(endDate, "dd MMM") + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\">Pencairan ke Rek :" + cmp.getName() + "</Data></Cell>");
        wb.println("      </Row>");

        if (bankId != 0) {
            try {
                Bank bank = DbBank.fetchExc(bankId);
                wb.println("      <Row>");
                wb.println("      <Cell><Data ss:Type=\"String\">Bank :" + bank.getName() + "</Data></Cell>");
                wb.println("      </Row>");
            } catch (Exception e) {
            }
        }

        Vector credits = SessReportClosing.getListCard(locationId, bankId, DbMerchant.TYPE_CREDIT_CARD);
        Vector debits = SessReportClosing.getListCard(locationId, bankId, DbMerchant.TYPE_DEBIT_CARD);

        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Tanggal</Data></Cell>");
        if (credits != null && credits.size() > 0) {
            for (int i = 0; i < credits.size(); i++) {
                Merchant m = (Merchant) credits.get(i);
                wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">" + m.getDescription() + "</Data></Cell>");
            }
        }
        if (debits != null && debits.size() > 0) {
            for (int i = 0; i < debits.size(); i++) {
                Merchant m = (Merchant) debits.get(i);
                wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">" + m.getDescription() + "</Data></Cell>");
            }
        }

        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">TOTAL NETT</Data></Cell>");
        wb.println("      </Row>");
        boolean exist = false;
        wb.println("      <Row>");
        if (credits != null && credits.size() > 0) {
            for (int i = 0; i < credits.size(); i++) {
                Merchant m = (Merchant) credits.get(i);
                if (i == 0) {
                    wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nilai</Data></Cell>");
                    exist = true;
                } else {
                    wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nilai</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(m.getPersenExpense(), "###.##") + " %</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nett</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Trf Bank</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Tgl Cair</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Selisih</Data></Cell>");
            }
        }

        if (debits != null && debits.size() > 0) {
            for (int i = 0; i < debits.size(); i++) {
                Merchant m = (Merchant) debits.get(i);
                if (i == 0 && exist == false) {
                    wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nilai</Data></Cell>");
                } else {
                    wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nilai</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(m.getPersenExpense(), "###.##") + " %</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Nett</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Trf Bank</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Tgl Cair</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">Selisih</Data></Cell>");

            }
        }
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {
            double totalNett = 0;
            double nilaic[] = new double[20];
            double biayac[] = new double[20];
            double nettc[] = new double[20];

            double nilaid[] = new double[20];
            double biayad[] = new double[20];
            double nettd[] = new double[20];

            for (int x = 0; x < result.size(); x++) {
                Vector tmpReport = (Vector) result.get(x);
                double subNett = 0;
                Date tgl = JSPFormater.formatDate(String.valueOf("" + tmpReport.get(0)), "dd/MM/yyyy");
                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(tgl, "dd-MMM") + "</Data></Cell>");

                if (credits != null && credits.size() > 0) {
                    for (int i = 0; i < credits.size(); i++) {
                        Merchant m = (Merchant) credits.get(i);
                        double amount = SessReportClosing.getAmountCard(locationId, tgl, m.getOID());
                        Date payDt = SessReportClosing.getDatePayment(locationId, tgl, m.getOID());
                        double exp = (m.getPersenExpense() * amount / 100);
                        double net = amount - exp;
                        subNett = subNett + net;
                        totalNett = totalNett + net;

                        nilaic[i] = nilaic[i] + amount;
                        biayac[i] = biayac[i] + exp;
                        nettc[i] = nettc[i] + net;

                        String strPayDt = "";
                        if (payDt != null) {
                            strPayDt = JSPFormater.formatDate(payDt, "dd-MM-yyyy");
                        }

                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + exp + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + net + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+strPayDt+"</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                    }
                }

                if (debits != null && debits.size() > 0) {
                    for (int i = 0; i < debits.size(); i++) {
                        Merchant m = (Merchant) debits.get(i);
                        double amount = SessReportClosing.getAmountCard(locationId, tgl, m.getOID());
                        Date payDt = SessReportClosing.getDatePayment(locationId, tgl, m.getOID());
                        double exp = (m.getPersenExpense() * amount / 100);
                        double net = amount - exp;
                        subNett = subNett + net;
                        totalNett = totalNett + net;

                        nilaid[i] = nilaid[i] + amount;
                        biayad[i] = biayad[i] + exp;
                        nettd[i] = nettd[i] + net;
                        
                        String strPayDt = "";
                        if (payDt != null) {
                            strPayDt = JSPFormater.formatDate(payDt, "dd-MM-yyyy");
                        }

                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + exp + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + net + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">"+strPayDt+"</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                    }
                }

                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + subNett + "</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Total</Data></Cell>");
            if (credits != null && credits.size() > 0) {
                for (int i = 0; i < credits.size(); i++) {
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + nilaic[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + biayac[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + nettc[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s85\"/>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                }
            }
            if (debits != null && debits.size() > 0) {
                for (int i = 0; i < debits.size(); i++) {
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + nilaid[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + biayad[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + nettd[i] + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">0.00</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s85\"/>");
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">0.00</Data></Cell>");

                }
            }
            wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + totalNett + "</Data></Cell>");
            wb.println("      </Row>");

        }

        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">Dibuat Oleh</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
        wb.println("      </Row>");
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
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>15</ActiveRow>");
        wb.println("      <ActiveCol>3</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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
