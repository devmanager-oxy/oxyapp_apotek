/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.InvReport;
import com.project.ccs.session.ReportParameter;
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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;
import com.project.util.JSPFormater;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class ReportInventoryXLS extends HttpServlet {

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
        Vector resultXLS = new Vector();
        Location location = new Location();

        long userId = JSPRequestValue.requestLong(request, "user_id");
        int type = JSPRequestValue.requestInt(request, "type");
        int invType = JSPRequestValue.requestInt(request, "inv_type");

        User u = new User();
        try {
            u = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Vector result = new Vector();
        ReportParameter rp = new ReportParameter();
        try {
            HttpSession session = request.getSession();
            resultXLS = (Vector) session.getValue("REPORT_INVENTORY_STOCK_SUMMARY");
            result = (Vector) resultXLS.get(0);
            rp = (ReportParameter) resultXLS.get(1);
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

        if (rp.getLocationId() != 0) {
            try {
                location = DbLocation.fetchExc(rp.getLocationId());
            } catch (Exception e) {
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

        String title = "";
        if (invType == 0) {
            title = "INVENTORY REPORT (VALUE)";
        } else {
            title = "INVENTORY REPORT (QUANTITY)";
        }

        wb.println("      <?xml version=\"1.0\"?>");
        wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Acer</LastAuthor>");
        wb.println("      <Created>2015-01-25T05:27:31Z</Created>");
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
        wb.println("      <Style ss:ID=\"m34628256\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34628276\">");
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
        wb.println("      <Style ss:ID=\"m34628296\">");
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
        wb.println("      <Style ss:ID=\"m34628032\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34628052\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34628072\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34628092\">");
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
        wb.println("      <Style ss:ID=\"m34628112\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34628132\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34627808\">");
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
        wb.println("      <Style ss:ID=\"m34627828\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34627848\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m34627908\">");
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
        wb.println("      <Style ss:ID=\"m34627584\">");
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
        wb.println("      <Style ss:ID=\"m34627604\">");
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
        wb.println("      <Style ss:ID=\"m34627624\">");
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
        wb.println("      <Style ss:ID=\"m34627644\">");
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
        wb.println("      <Style ss:ID=\"m34627664\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s62\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
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
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s93\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s95\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s96\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s97\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s98\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s99\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\" ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s108\">");
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
        wb.println("      <Style ss:ID=\"s109\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s113\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s115\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");

        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"39.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"92.25\"/>");
        if (type == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80.25\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123\"/>");
        }
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"61.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\" ss:Span=\"2\"/>");
        wb.println("      <Column ss:Index=\"28\" ss:AutoFitWidth=\"0\" ss:Width=\"66\"/>");
        wb.println("      <Column ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        if (type == 1) {
            wb.println("      <Cell ss:MergeAcross=\"27\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        } else {
            wb.println("      <Cell ss:MergeAcross=\"24\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        }
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s115\"><Data ss:Type=\"String\">Print date : " + JSPFormater.formatDate(new Date(), "dd-MM-yyyy HH:mm:ss") + ", by " + u.getFullName() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">INVENTORY REPORT</Data></Cell>");
        wb.println("      </Row>");
        if (rp.getLocationId() != 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Location : " + location.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        } else {
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Location : All Location</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Period : " + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34627584\"><Data ss:Type=\"String\">Code </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34627604\"><Data ss:Type=\"String\">Category</Data></Cell>");
        if (type == 1) {
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34627624\"><Data ss:Type=\"String\">Sub Category</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34627644\"><Data ss:Type=\"String\">Sku </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34627664\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        }
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Begining </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34627808\"><Data ss:Type=\"String\">Incoming </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34627828\"><Data ss:Type=\"String\">Incoming Ajustment</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34627848\"><Data ss:Type=\"String\">RTV </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TRF In</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">TRF Out</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34627908\"><Data ss:Type=\"String\">Costing</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628032\"><Data ss:Type=\"String\">RPC Out</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628052\"><Data ss:Type=\"String\">RPC In</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628072\"><Data ss:Type=\"String\">Shringkage </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34628092\"><Data ss:Type=\"String\">ADJ. Val </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34628112\"><Data ss:Type=\"String\">COGS </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628132\"><Data ss:Type=\"String\">Net Sales </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628256\"><Data ss:Type=\"String\">Ending </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m34628276\"><Data ss:Type=\"String\">ITO</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        if (type == 1) {
            wb.println("      <Cell ss:Index=\"6\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        } else {
            wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"String\">Value</Data></Cell>");
        if (type == 1) {
            wb.println("      <Cell ss:Index=\"28\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        } else {
            wb.println("      <Cell ss:Index=\"25\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">Value</Data></Cell>");
        wb.println("      </Row>");
        if (result != null && result.size() > 0) {

            double totBegining = 0;
            double totBeginingQty = 0;
            double totReceiving = 0;
            double totReceivingQty = 0;
            double totRecAdj = 0;
            double totRecAdjQty = 0;
            double totRtv = 0;
            double totRtvQty = 0;
            double totTrafIn = 0;
            double totTrafInQty = 0;
            double totTrafOut = 0;
            double totTrafOutQty = 0;
            double totCosting = 0;
            double totCostingQty = 0;
            double totMutation = 0;
            double totMutationQty = 0;
            double totRepackOut = 0;
            double totRepackOutQty = 0;
            double totAdjustment = 0;
            double totAdjustmentQty = 0;            
            double totCogs = 0;
            double totNetSales = 0;
            double totNetSalesQty = 0;
            double totEnding = 0;
            double totEndingQty = 0;
            double totTurnOver = 0;
            double totAdjVal = 0; 

            for (int i = 0; i < result.size(); i++) {

                InvReport iReport = (InvReport) result.get(i);
                wb.println("      <Row ss:AutoFitHeight=\"0\">"); 
                wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"String\">" + iReport.getCode() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + iReport.getSectionName() + "</Data></Cell>");
                if (type == 1) {
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + iReport.getCodeClass() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + iReport.getSku() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + iReport.getDesription() + "</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getBeginingQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getBegining() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + iReport.getReceivingQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + iReport.getReceiving() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getReceivingAdjustmentQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getReceivingAdjustment() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getRtvQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getRtv() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getTransferInQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getTransferIn() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getTransferOutQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getTransferOut() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getCostingQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getCosting() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getMutationQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getMutation() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getRepackOutQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getRepackOut() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getStockAdjustmentQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getStockAdjustment() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + iReport.getAdjVal() + "</Data></Cell>");

                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + iReport.getCogs() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getNetSalesQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getNetSales() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getEndingQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + iReport.getEnding() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + iReport.getTurnOvr() + "</Data></Cell>");
                wb.println("      </Row>");
                
                totBegining = totBegining + iReport.getBegining();
                totBeginingQty = totBeginingQty + iReport.getBeginingQty();
                
                totReceiving = totReceiving + iReport.getReceiving();
                totReceivingQty = totReceivingQty + iReport.getReceivingQty();
                
                totRecAdj = totRecAdj + iReport.getReceivingAdjustment();
                totRecAdjQty = totRecAdjQty + iReport.getReceivingAdjustmentQty();
                
                totRtv = totRtv + iReport.getRtv();
                totRtvQty = totRtvQty + iReport.getRtvQty();
                
                totTrafIn = totTrafIn + iReport.getTransferIn();
                totTrafInQty = totTrafInQty + iReport.getTransferInQty();
                
                totTrafOut = totTrafOut + iReport.getTransferOut();
                totTrafOutQty = totTrafOutQty + iReport.getTransferOutQty();
                
                totCosting = totCosting + iReport.getCosting();
                totCostingQty = totCostingQty + iReport.getCostingQty();
                
                totMutation = totMutation + iReport.getMutation();
                totMutationQty = totMutationQty + iReport.getMutationQty();
                
                totRepackOut = totRepackOut + iReport.getRepackOut();
                totRepackOutQty = totRepackOutQty + iReport.getRepackOutQty();
                
                totAdjustment = totAdjustment + iReport.getStockAdjustment();
                totAdjustmentQty = totAdjustmentQty + iReport.getStockAdjustmentQty();
                
                totCogs = totCogs + iReport.getCogs();
                totNetSales = totNetSales + iReport.getNetSales();
                totNetSalesQty = totNetSalesQty + iReport.getNetSalesQty();
                
                totEnding = totEnding + iReport.getEnding();
                totEndingQty = totEndingQty + iReport.getEndingQty();
                totTurnOver = totTurnOver + iReport.getTurnOvr();
                totAdjVal = totAdjVal + iReport.getAdjVal() ;
                
            }

            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m34628296\"><Data ss:Type=\"String\">Total</Data></Cell>");
            if (type == 1) {
                wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">"+totBeginingQty+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">"+totBegining+"</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totReceivingQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totReceiving + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRecAdjQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRecAdj + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRtvQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRtv + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totTrafInQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totTrafIn + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totTrafOutQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totTrafOut + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totCostingQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totCosting + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totMutationQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totMutation + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRepackOutQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totRepackOut + "</Data></Cell>");
            
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totAdjustmentQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totAdjustment + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totAdjVal + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totCogs + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totNetSalesQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totNetSales + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totEndingQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"Number\">" + totEnding + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"><Data ss:Type=\"String\"></Data></Cell>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <LeftColumnVisible>20</LeftColumnVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveCol>28</ActiveCol>");
        wb.println("      <RangeSelection>R1C29:R1C32</RangeSelection>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
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
        wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
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
