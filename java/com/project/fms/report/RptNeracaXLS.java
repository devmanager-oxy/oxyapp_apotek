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
import java.util.Vector;
import java.net.URLEncoder;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.fms.session.SessNeraca;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.system.DbSystemProperty;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptNeracaXLS extends HttpServlet {

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
        long periodId = JSPRequestValue.requestLong(request, "period_id");
        long segment1Id = JSPRequestValue.requestLong(request, "segment1_id");
        int lang = JSPRequestValue.requestInt(request, "lang");
        
        String title = "";
        String[] langMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

        try {
            title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA_EN");
        } catch (Exception e) {
        }

        if (lang == 2) {

            String[] langMonthID = {"Januari", "Februari", "Maret", "April", "Mei", "June", "Juli", "Agustus", "September", "Oktober", "November", "Desember"};
            langMonth = langMonthID;

            try {
                title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA");
            } catch (Exception e) {
            }

        }


        String strSeg1 = "";
        try {
            if (segment1Id != 0) {
                SegmentDetail sd = DbSegmentDetail.fetchExc(segment1Id);
                strSeg1 = sd.getName();
            }
        } catch (Exception e) {
        }

        Vector resultAktiva = new Vector();
        Vector resultPasiva = new Vector();

        HttpSession session = request.getSession();
        if (session.getValue("NERACA_REPORT_AKTIVA") != null) {
            resultAktiva = (Vector) session.getValue("NERACA_REPORT_AKTIVA");
        }

        if (session.getValue("NERACA_REPORT_PASIVA") != null) {
            resultPasiva = (Vector) session.getValue("NERACA_REPORT_PASIVA");
        }

        Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
        Company company = DbCompany.getCompany();

        Periode period = new Periode();
        if (periodId != 0) {
            try {
                period = DbPeriode.fetchExc(periodId);
            } catch (Exception e) {
            }
        } else {
            period = (Periode) periods.get(0);
        }

        Date reportDate = new Date();
        Date endPeriod = period.getEndDate();
        if (reportDate.after(endPeriod)) {
            reportDate = endPeriod;
        }

        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            reportDate = period.getStartDate();
        }

        Date dtx = (Date) reportDate.clone();
        dtx.setYear(dtx.getYear() - 1);

        String monthPrev = dtx.getDate() + " " + langMonth[dtx.getMonth()].toUpperCase() + " " + (dtx.getYear() + 1900);
        String month = reportDate.getDate() + " " + langMonth[reportDate.getMonth()].toUpperCase() + " " + (reportDate.getYear() + 1900);
        String currentMonth = new Date().getDate() + " " + langMonth[new Date().getMonth()] + " " + (new Date().getYear() + 1900);

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
        wb.println("      <LastPrinted>2014-10-14T18:02:48Z</LastPrinted>");
        wb.println("      <Created>2014-10-14T17:40:29Z</Created>");
        wb.println("      <LastSaved>2014-10-14T17:50:55Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m34111488\">");
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
        wb.println("      <Style ss:ID=\"m34111508\">");
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
        wb.println("      <Style ss:ID=\"s87\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s90\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s91\" ss:Parent=\"s16\">");
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
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s96\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s97\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s99\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");        
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"231\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"111\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"114.75\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s102\"><Data ss:Type=\"String\">" + company.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + title + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + strSeg1.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s101\"><Data ss:Type=\"String\">( " + monthPrev.toUpperCase() + " dan " + month.toUpperCase() + " )</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"7\">");
        wb.println("      <Cell ss:MergeDown=\"2\" ss:StyleID=\"m34111508\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"2\" ss:StyleID=\"m34111488\"><Data ss:Type=\"String\">URAIAN</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">REALISASI</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"String\">REALISASI</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s96\"><Data ss:Type=\"String\">PER</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">PER</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s99\"><Data ss:Type=\"String\">" + monthPrev.toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"String\">" + month.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if (resultAktiva != null && resultAktiva.size() > 0) {
            double totalPrev = 0;
            double total = 0;
            for (int i = 0; i < resultAktiva.size(); i++) {
                SessNeraca neraca = (SessNeraca) resultAktiva.get(i);
                String level = "";
                if (neraca.getLevel() == 1) {
                } else if (neraca.getLevel() == 2) {
                    level = "   ";
                } else if (neraca.getLevel() == 3) {
                    level = "       ";
                } else if (neraca.getLevel() == 4) {
                    level = "           ";
                } else if (neraca.getLevel() == 5) {
                    level = "               ";
                }

                wb.println("      <Row>");
                if (neraca.getStatus().equalsIgnoreCase("HEADER")) {
                    wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">" + level + "" + neraca.getCoa() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
                } else {
                    wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"String\">" + level + "" + neraca.getCoa() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + neraca.getBalancePrevious() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + neraca.getBalance() + "</Data></Cell>");
                    totalPrev = totalPrev + neraca.getBalancePrevious();
                    total = total + neraca.getBalance();
                }
                wb.println("      </Row>");

            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s88\"/>");
            wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">TOTA AKTIVA</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">" + totalPrev + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s88\"/>");
        wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        if (resultPasiva != null && resultPasiva.size() > 0) {
            double totalPrev = 0;
            double total = 0;
            for (int i = 0; i < resultPasiva.size(); i++) {
                SessNeraca neraca = (SessNeraca) resultPasiva.get(i);
                String level = "";
                if (neraca.getLevel() == 1) {
                } else if (neraca.getLevel() == 2) {
                    level = "   ";
                } else if (neraca.getLevel() == 3) {
                    level = "       ";
                } else if (neraca.getLevel() == 4) {
                    level = "           ";
                } else if (neraca.getLevel() == 5) {
                    level = "               ";
                }

                wb.println("      <Row>");
                if (neraca.getStatus().equalsIgnoreCase("HEADER")) {
                    wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">" + level + "" + neraca.getCoa() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\"></Data></Cell>");
                } else {
                    wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"String\">" + level + "" + neraca.getCoa() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + neraca.getBalancePrevious() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">" + neraca.getBalance() + "</Data></Cell>");
                    totalPrev = totalPrev + neraca.getBalancePrevious();
                    total = total + neraca.getBalance();
                }
                wb.println("      </Row>");

            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s88\"/>");
            wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">TOTA PASIVA</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">" + totalPrev + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row>");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:Index=\"2\" ><Data ss:Type=\"String\">Date : " + currentMonth + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">Created By</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s103\"/>");
        wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"String\">Approved By</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      <Cell />");
        wb.println("      </Row>");        
        wb.println("      <Row >");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s103\"><Data ss:Type=\"String\">(                                              )</Data></Cell>");
        wb.println("      <Cell ss:Index=\"4\" ><Data ss:Type=\"String\">(                                              )</Data></Cell>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>11</ActiveRow>");
        wb.println("      <ActiveCol>8</ActiveCol>");
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
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
