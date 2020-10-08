/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;

import com.project.I_Project;
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
import com.project.general.Approval;
import com.project.general.DbApproval;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.payroll.Employee;
import com.project.payroll.DbEmployee;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class ReportAdjGaXLS extends HttpServlet{
    
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

        Vector result = new Vector();
        Vector resultParameter = new Vector();

        long userId = 0;
        User user = new User();
        Employee emp = new Employee();            
        Location location = new Location();
        HttpSession session = request.getSession();
        try {
            result = (Vector) session.getValue("REPORT_ADJ_GA");
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
            emp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }
        
        Date startDate = new Date();
        Date endDate = new Date();
        long locationId = 0;
        
        String kepada = "";
        try {
            resultParameter = (Vector) session.getValue("REPORT_ADJ_GA_PARAMETER");
            locationId = Long.parseLong(String.valueOf("" + resultParameter.get(0)));
            startDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(1)), "dd/MM/yyyy");
            endDate = JSPFormater.formatDate(String.valueOf("" + resultParameter.get(2)), "dd/MM/yyyy");            
        } catch (Exception e) {
        }

        if (locationId != 0) {
            try {
                location = DbLocation.fetchExc(locationId);
                kepada = location.getName();
            } catch (Exception e) {
            }
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
        wb.println("      <LastPrinted>2015-02-25T23:31:07Z</LastPrinted>");
        wb.println("      <Created>2015-02-25T22:25:13Z</Created>");
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
        wb.println("      <Style ss:ID=\"m83537408\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537428\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537448\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537468\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537548\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537568\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537184\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537204\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537224\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537244\">");
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
        wb.println("      <Style ss:ID=\"m83537264\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537284\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83537304\">");
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
        wb.println("      <Style ss:ID=\"m83537324\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83536776\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83536796\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83536816\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83536836\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m83536856\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s93\">");
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
        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s107\">");
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
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s109\">");
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
        wb.println("      <Style ss:ID=\"s111\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s112\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s120\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s121\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s122\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s131\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s140\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s142\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s144\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s152\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s154\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s156\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"18\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s158\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s159\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"50.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"18\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"70.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"54\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"82.5\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"27\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"6\" ss:StyleID=\"s156\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s131\"/>");
        wb.println("      <Cell ss:StyleID=\"s131\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("      <Cell ss:Index=\"3\" ss:MergeAcross=\"6\" ss:StyleID=\"s158\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"21.75\">");
        wb.println("      <Cell ss:StyleID=\"s142\"/>");
        wb.println("      <Cell ss:StyleID=\"s142\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s159\"><Data ss:Type=\"String\">" + cmp.getPhone().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83536776\"><Data ss:Type=\"String\">No. Invoice</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s120\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m83536796\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m83536816\"><Data ss:Type=\"String\">Jimbaran, " + JSPFormater.formatDate(new Date(), "dd MMMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83536836\"><Data ss:Type=\"String\">Jenis Tagihan</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Penggunaan Perlengkapan Operational</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m83536856\"><Data ss:Type=\"String\">Kepada</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83537184\"><Data ss:Type=\"String\">Masa Tagihan</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s122\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m83537204\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(endDate, "MMMM yyyy") + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m83537224\"><Data ss:Type=\"String\">" + kepada + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"9\" ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83537304\"><Data ss:Type=\"String\">SKU</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83537244\"><Data ss:Type=\"String\">NAMA BARANG</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">SATUAN</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">QTY</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">HARGA</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">JUMLAH</Data></Cell>");
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {

            int nomor = 1;
            long tmpGid = 0;
            String grpName = "";

            double subTotal = 0;
            double grandTotal = 0;

            for (int i = 0; i < result.size(); i++) {

                Vector tmp = (Vector) result.get(i);

                long gId = 0;
                String groupCode = "";
                String itemCode = "";
                String gname = "";
                String name = "";
                String unit = "";
                double qty = 0;
                double price = 0;
                double amount = 0;
                try {
                    gId = Long.parseLong("" + tmp.get(0));
                } catch (Exception e) {
                }

                try {
                    groupCode = String.valueOf(tmp.get(1));
                } catch (Exception e) {
                }

                try {
                    itemCode = String.valueOf(tmp.get(2));
                } catch (Exception e) {
                }

                try {
                    name = String.valueOf(tmp.get(3));
                } catch (Exception e) {
                }

                try {
                    unit = String.valueOf(tmp.get(4));
                } catch (Exception e) {
                }

                try {
                    qty = Double.parseDouble("" + tmp.get(5));
                } catch (Exception e) {
                }

                try {
                    price = Double.parseDouble("" + tmp.get(6));
                } catch (Exception e) {
                }

                try {
                    amount = Double.parseDouble("" + tmp.get(7));
                } catch (Exception e) {
                }

                try {
                    gname = String.valueOf(tmp.get(8));
                } catch (Exception e) {
                }

                if (tmpGid != 0 && tmpGid != gId) {
                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"m83537448\"><Data ss:Type=\"String\">TOTAL PEMAKAINAN " + grpName + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s108\"/>");
                    wb.println("      <Cell ss:StyleID=\"s108\"/>");
                    wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
                    wb.println("      </Row>");
                    subTotal = 0;

                }

                if (tmpGid != gId) {
                    grpName = gname;
                    wb.println("      <Row ss:AutoFitHeight=\"0\">");
                    wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">" + groupCode + "</Data></Cell>");
                    wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"m83537264\"><Data ss:Type=\"String\">" + gname + "</Data></Cell>");
                    wb.println("      </Row>");
                    nomor = 1;
                }
                tmpGid = gId;

                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + nomor + "</Data></Cell>");
                nomor++;
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83537324\"><Data ss:Type=\"Number\">" + itemCode + "</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m83537284\"><Data ss:Type=\"String\">" + name + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\">" + unit + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"Number\">" + price + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s107\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
                wb.println("      </Row>");
                subTotal = subTotal + amount;
                grandTotal = grandTotal + amount;
            }
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"m83537448\"><Data ss:Type=\"String\">TOTAL PEMAKAINAN " + grpName + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s108\"/>");
            wb.println("      <Cell ss:StyleID=\"s108\"/>");
            wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"m83537468\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s109\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s144\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s144\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        
        String header1 = "";
        String emp1 = "";
        String footer1 = "";
        
        try {
            Approval approval = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_ADJUSMENT_GA, DbApproval.URUTAN_0);             
            try {
                Employee employee1 = DbEmployee.fetchExc(approval.getEmployeeId());
                emp1 = employee1.getName();
            } catch (Exception e) {
            }
            header1 = approval.getKeterangan();
            footer1 = approval.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }
        
        String header2 = "";        
        String footer2 = "";
        
        try {
            Approval approval2 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_ADJUSMENT_GA, DbApproval.URUTAN_1);                         
            header2 = approval2.getKeterangan();
            footer2 = approval2.getKeteranganFooter();
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }
        
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s144\"><Data ss:Type=\"String\">Prepared By</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">"+header1+"</Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">"+header2+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s144\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s144\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s154\"><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s112\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s114\"><Data ss:Type=\"String\">"+emp1+"</Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">(___________________)</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s152\"><Data ss:Type=\"String\">"+emp.getPosition()+"</Data></Cell>");
        wb.println("      <Cell ss:Index=\"5\" ss:MergeAcross=\"1\" ss:StyleID=\"s117\"><Data ss:Type=\"String\">"+footer1+"</Data></Cell>");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"s111\"><Data ss:Type=\"String\">"+footer2+"</Data></Cell>");
        wb.println("      </Row>");
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
        wb.println("      <HorizontalResolution>120</HorizontalResolution>");
        wb.println("      <VerticalResolution>72</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>7</ActiveRow>");
        wb.println("      <ActiveCol>14</ActiveCol>");
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
