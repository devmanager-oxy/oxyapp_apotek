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
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;

import com.project.ccs.postransaction.transfer.DbFakturPajak;
import com.project.ccs.postransaction.transfer.DbFakturPajakDetail;
import com.project.ccs.postransaction.transfer.FakturPajak;
import com.project.ccs.postransaction.transfer.FakturPajakDetail;

import com.project.general.Approval;
import com.project.general.Company;
import com.project.general.DbApproval;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.system.DbSystemProperty;

/**
 *
 * @author Roy Andika
 */
public class ReportPajakXls extends HttpServlet {

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
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");

        // Company Id
        long fakturPajakId = JSPRequestValue.requestLong(request, "oid");
        int maxItem = 100000;        
        try{
            maxItem = Integer.parseInt(DbSystemProperty.getValueByName("MAX_PRINT_ITEM_TAX"));
        }catch(Exception e){}
        
        FakturPajak fakturPajak = new FakturPajak();

        try {
            fakturPajak = DbFakturPajak.fetchExc(fakturPajakId);
        } catch (Exception e) {}
        
        int countData = DbFakturPajakDetail.getCount(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID]+" = "+fakturPajak.getOID());
        
        int maxLoop = 0;
        int sisa = countData % maxItem;
        
        int pembagi = countData/maxItem;
        
        maxLoop = pembagi;
        if(sisa > 0){
            maxLoop = maxLoop + 1;
        }
        
        int loopSummary = maxLoop - 1;

        Company company = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                company = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }
        
        Location locationFrom = new Location();
        try{
            locationFrom = DbLocation.fetchExc(fakturPajak.getLocationId());
        }catch(Exception e){}
        Location locationTo = new Location();
        try{
            locationTo = DbLocation.fetchExc(fakturPajak.getLocationToId());
        }catch(Exception e){}

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
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>PNCI</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <LastPrinted>2012-10-02T07:00:58Z</LastPrinted>");
        wb.println("      <Created>2012-10-02T05:58:36Z</Created>");
        wb.println("      <LastSaved>2012-10-02T06:38:29Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_) \"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40315968\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40315988\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40316008\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40316028\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312852\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312872\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312892\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312912\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312932\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40312952\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313504\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313280\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313320\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313360\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970720\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970740\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970760\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970780\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970820\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478016\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478036\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478056\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478076\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478096\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478116\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40314176\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40314196\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40314216\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40314236\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313748\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313768\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313788\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313808\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313828\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40313848\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36972288\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478464\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478504\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36478544\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36972512\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36972532\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36972552\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36972592\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970556\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970576\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970596\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970616\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"16\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"16\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s124\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s127\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s128\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s130\" ss:Parent=\"s16\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s131\" ss:Parent=\"s16\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s132\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s133\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s134\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s136\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s137\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s138\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s139\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s140\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s143\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s144\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s146\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s147\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s152\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s158\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Underline=\"Single\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s159\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s160\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s161\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s162\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s163\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s164\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s165\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        String nama = "";
        String keterangan = "";
            try{
                Approval approval_1 = DbApproval.getListApproval(I_Project.TYPE_FAKTUR_PAJAK, DbApproval.URUTAN_1);
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama = employee.getName();
                keterangan = approval_1.getKeterangan();                
            }catch(Exception E){
                System.out.println("[exception] "+E.toString());
            }
        
         int start = 0;
            int pageStart = 1;
            double sum = 0;
            double totPotongan = 0;
            for(int ij = 0 ; ij < maxLoop; ij++){
                
                int page = ij+1;
                
                Vector vFakturPajakItem = DbFakturPajakDetail.list(start, maxItem, DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID]+" = "+fakturPajak.getOID(), DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]);                
            
        wb.println("      <Worksheet ss:Name=\"SHEET 1 PAGE "+page+"\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"17.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"12\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"83.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"10.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"34.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"37.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"26.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"16.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"147\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"18.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"2\" ss:StyleID=\"s63\"><Data ss:Type=\"String\">Lembar ke-1 :</Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\">Untuk Pembeli BKP/Penerimaan JKP</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"11\"><Data ss:Type=\"String\">Sebagai Bukti Pembayaran Pajak</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"10\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">FAKTUR PAJAK</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("          <Cell ss:StyleID=\"s66\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"8\" ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:MergeAcross=\"8\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Kode dan Nomor Seri Faktur Pajak : "+fakturPajak.getNumber()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Pengusaha Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationFrom.getAddressStreet()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationFrom.getNpwp()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s81\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Pembeli Barang Kena Pajak / Penerima Jasa Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationTo.getAddressStreet()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationTo.getNpwp()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s81\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36478016\"><Data");
        wb.println("      ss:Type=\"String\">No.</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36478036\"><Data ss:Type=\"String\">Nama Barang Kena Pajak /</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36478056\"><Data ss:Type=\"String\">Harga Jual/Penggantian</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36478076\"><Data");
        wb.println("      ss:Type=\"String\">Urut</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36478096\"><Data ss:Type=\"String\">Jasa Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36478116\"><Data ss:Type=\"String\">/Uang Muka/Termijin </Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970720\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36970740\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36970760\"><Data ss:Type=\"String\">Rp</Data></Cell>");
        wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970780\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        
        if(vFakturPajakItem != null && vFakturPajakItem.size() > 0){
            for(int i = 0 ; i < vFakturPajakItem.size() ; i++){
                FakturPajakDetail fakturPajakItem = (FakturPajakDetail)vFakturPajakItem.get(i);
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970820\"><Data");
            wb.println("      ss:Type=\"Number\">"+pageStart+"</Data></Cell>");
            pageStart++;
            wb.println("      <Cell ss:StyleID=\"s127\"/>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+fakturPajakItem.getItemName()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s128\"><Data ss:Type=\"Number\">"+fakturPajakItem.getQty()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s128\"/>");
            double total = fakturPajakItem.getQty() * fakturPajakItem.getPrice();
            sum = sum + total;
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(total, "#,###.##")+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s131\"/>");
            wb.println("      </Row>");
            }
        } 
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313320\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313360\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313504\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s133\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s136\"><ss:Data ss:Type=\"String\"");
        wb.println("      xmlns=\"http://www.w3.org/TR/REC-html40\"><Font html:Color=\"#000000\">Harga Jual</Font><S><Font");
        wb.println("      html:Color=\"#000000\">/Penggantian/Uang Muka/Termijin</Font></S><Font");
        wb.println("      html:Color=\"#000000\"> **)</Font></ss:Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s137\"/>");
        
        if(ij == loopSummary){        
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(sum, "#,###.##")+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"String\"></Data></Cell>");
        }
        
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s140\"><Data ss:Type=\"String\">Dikurangi Potongan Harga'</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
        wb.println("      <Cell ss:StyleID=\"s143\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s144\"><Data ss:Type=\"String\">Dikurangi Uang Muka yang telah diterima</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s144\"/>");
        wb.println("      <Cell ss:StyleID=\"s143\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        double x = 100;
        double y = 110;
        double z = 10;
        double pengenaanPajak = (x/y) * sum;
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s144\"><Data ss:Type=\"String\">Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s144\"/>");
        if(ij == loopSummary){
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pengenaanPajak, "#,###.##")+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"String\"></Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        double ppn = (z/x)*pengenaanPajak;
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s140\"><Data ss:Type=\"String\">PPN = 10% x Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
         if(ij == loopSummary){
            wb.println("      <Cell ss:StyleID=\"s146\"><Data ss:Type=\"Number\">"+ppn+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s146\"><Data ss:Type=\"String\"></Data></Cell>");
        }        
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        
        String month = "";
        
        int intDate = new Date().getDate();
        int intMonth = new Date().getMonth();
        int intYear = new Date().getYear()+1900;
        
        if(intMonth == 0){
            month = "Januari";
        }else if(intMonth == 1){
            month = "Februari";
        }else if(intMonth == 2){
            month = "Maret";
        }else if(intMonth == 3){
            month = "April";
        }else if(intMonth == 4){
            month = "Mei";
        }else if(intMonth == 5){
            month = "Juni";
        }else if(intMonth == 6){
            month = "Juli";
        }else if(intMonth == 7){
            month = "Agustus";
        }else if(intMonth == 8){
            month = "September";
        }else if(intMonth == 9){
            month = "Oktober";
        }else if(intMonth == 10){
            month = "November";
        }else if(intMonth == 11){
            month = "Desember";
        }
        
        String tanggal = ""+intDate+" "+month+" "+intYear;
                
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
         if(ij == loopSummary){
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Pajak Penjualan Atas Barang Mewah</Data></Cell>");
        }else{
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");    
        }
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"><Data ss:Type=\"String\">Denpasar, "+tanggal+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        if(ij == loopSummary){
            
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s147\"><Data ss:Type=\"String\">Tarif</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312852\"><Data ss:Type=\"String\">DPP</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312872\"><Data ss:Type=\"String\">PPn BM</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312892\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312912\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312932\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312952\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        }else{
            
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");  
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");   
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");        
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>"); 
        }
        
        
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        if(ij == loopSummary){
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40315968\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40315988\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        }else{
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");  
        }
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s158\"><Data ss:Type=\"String\">"+nama.toUpperCase()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        if(ij == loopSummary){
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40316008\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40316028\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        }else{
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");    
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");    
        wb.println("      <Cell ss:StyleID=\"s73\"/>");  
        }
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"><Data ss:Type=\"String\">"+keterangan.toUpperCase()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s159\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s161\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\"><Data ss:Type=\"String\">**) Coret yang tidak perlu</Data></Cell>");
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
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <TopRowVisible>1</TopRowVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>21</ActiveRow>");
        wb.println("      <ActiveCol>18</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");  
        start = start + maxItem;
      }
        
            start = 0;
            pageStart = 1;
            sum = 0;
            totPotongan = 0;
            for(int ij = 0 ; ij < maxLoop; ij++){
                
                int page = ij+1;
                
                Vector vFakturPajakItem = DbFakturPajakDetail.list(start, maxItem, DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID]+" = "+fakturPajak.getOID(), DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]);                
            
        wb.println("      <Worksheet ss:Name=\"SHEET 2 PAGE "+page+"\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"17.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"12\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"83.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"10.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"34.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"37.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"26.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"16.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"147\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"18.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"8\" ss:MergeAcross=\"2\" ss:StyleID=\"s63\"><Data ss:Type=\"String\">Lembar ke-2 :</Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\">Untuk Pembeli BKP/Penerimaan JKP</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"11\"><Data ss:Type=\"String\">Sebagai Bukti Pembayaran Pajak</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"10\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">FAKTUR PAJAK</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("      <Cell ss:StyleID=\"s66\"/>");
        wb.println("          <Cell ss:StyleID=\"s66\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"8\" ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      <Cell ss:StyleID=\"s64\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:MergeAcross=\"8\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Kode dan Nomor Seri Faktur Pajak : "+fakturPajak.getNumber()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Pengusaha Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationFrom.getAddressStreet()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationFrom.getNpwp()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s81\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s70\"><Data ss:Type=\"String\">Pembeli Barang Kena Pajak / Penerima Jasa Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Nama</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+company.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">Alamat</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationTo.getAddressStreet()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s75\"/>");
        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+locationTo.getNpwp()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s81\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36478016\"><Data");
        wb.println("      ss:Type=\"String\">No.</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36478036\"><Data ss:Type=\"String\">Nama Barang Kena Pajak /</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36478056\"><Data ss:Type=\"String\">Harga Jual/Penggantian</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36478076\"><Data");
        wb.println("      ss:Type=\"String\">Urut</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36478096\"><Data ss:Type=\"String\">Jasa Kena Pajak</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36478116\"><Data ss:Type=\"String\">/Uang Muka/Termijin </Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970720\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m36970740\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36970760\"><Data ss:Type=\"String\">Rp</Data></Cell>");
        wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970780\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        if(vFakturPajakItem != null && vFakturPajakItem.size() > 0){
            for(int i = 0 ; i < vFakturPajakItem.size() ; i++){
                FakturPajakDetail fakturPajakItem = (FakturPajakDetail)vFakturPajakItem.get(i);
                
            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m36970820\"><Data");
            wb.println("      ss:Type=\"Number\">"+pageStart+"</Data></Cell>");
            pageStart++;
            wb.println("      <Cell ss:StyleID=\"s127\"/>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+fakturPajakItem.getItemName()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s128\"><Data ss:Type=\"Number\">"+fakturPajakItem.getQty()+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s128\"/>");
            double total = fakturPajakItem.getQty() * fakturPajakItem.getPrice();
            sum = sum + total;
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(total, "#,###.##")+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s131\"/>");
            wb.println("      </Row>");
            }
        }        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313320\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313360\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"m40313504\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s133\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s136\"><ss:Data ss:Type=\"String\"");
        wb.println("      xmlns=\"http://www.w3.org/TR/REC-html40\"><Font html:Color=\"#000000\">Harga Jual</Font><S><Font");
        wb.println("      html:Color=\"#000000\">/Penggantian/Uang Muka/Termijin</Font></S><Font");
        wb.println("      html:Color=\"#000000\"> **)</Font></ss:Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s137\"/>");
        if(ij == loopSummary){        
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(sum, "#,###.##")+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"String\"></Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s140\"><Data ss:Type=\"String\">Dikurangi Potongan Harga'</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
        wb.println("      <Cell ss:StyleID=\"s143\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s144\"><Data ss:Type=\"String\">Dikuranfi Uang Muka yang telah diterima</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s144\"/>");
        wb.println("      <Cell ss:StyleID=\"s143\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        double x = 100;
        double y = 110;
        double z = 10;
        double pengenaanPajak = (x/y) * sum;
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s144\"><Data ss:Type=\"String\">Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s144\"/>");
        if(ij == loopSummary){
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pengenaanPajak, "#,###.##")+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s138\"><Data ss:Type=\"String\"></Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s140\"><Data ss:Type=\"String\">PPN = 10% x Dasar Pengenaan Pajak</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s140\"/>");
        double ppn = (z/x)*pengenaanPajak;
         if(ij == loopSummary){
            wb.println("      <Cell ss:StyleID=\"s146\"><Data ss:Type=\"Number\">"+ppn+"</Data></Cell>");
        }else{
            wb.println("      <Cell ss:StyleID=\"s146\"><Data ss:Type=\"String\"></Data></Cell>");
        }        
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s134\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s139\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Pajak Penjualan Atas Barang Mewah</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        String month = "";
        
        int intDate = new Date().getDate();
        int intMonth = new Date().getMonth();
        int intYear = new Date().getYear()+1900;
        
        if(intMonth == 0){
            month = "Januari";
        }else if(intMonth == 1){
            month = "Februari";
        }else if(intMonth == 2){
            month = "Maret";
        }else if(intMonth == 3){
            month = "April";
        }else if(intMonth == 4){
            month = "Mei";
        }else if(intMonth == 5){
            month = "Juni";
        }else if(intMonth == 6){
            month = "Juli";
        }else if(intMonth == 7){
            month = "Agustus";
        }else if(intMonth == 8){
            month = "September";
        }else if(intMonth == 9){
            month = "Oktober";
        }else if(intMonth == 10){
            month = "November";
        }else if(intMonth == 11){
            month = "Desember";
        }
        
        String tanggal = ""+intDate+" "+month+" "+intYear;
        wb.println("      <Cell ss:StyleID=\"s127\"><Data ss:Type=\"String\">Denpasar, "+tanggal+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        
        if(ij == loopSummary){
            
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s147\"><Data ss:Type=\"String\">Tarif</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312852\"><Data ss:Type=\"String\">DPP</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312872\"><Data ss:Type=\"String\">PPn BM</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312892\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312912\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40312932\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40312952\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        }else{
            
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");  
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");   
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>"); 
        }
        
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        if(ij == loopSummary){
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40315968\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40315988\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        }else{
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");  
        }
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s158\"><Data ss:Type=\"String\">"+nama.toUpperCase()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        if(ij == loopSummary){
        wb.println("      <Cell ss:StyleID=\"s152\"><Data ss:Type=\"String\">.............%</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m40316008\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m40316028\"><Data ss:Type=\"String\">Rp...........</Data></Cell>");
        }else{
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");    
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");    
        wb.println("      <Cell ss:StyleID=\"s73\"/>");  
        }
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"><Data ss:Type=\"String\">"+keterangan.toUpperCase()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s72\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s73\"/>");
        wb.println("      <Cell ss:StyleID=\"s74\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s159\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s160\"/>");
        wb.println("      <Cell ss:StyleID=\"s161\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:Index=\"3\"><Data ss:Type=\"String\">**) Coret yang tidak perlu</Data></Cell>");
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
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <TopRowVisible>1</TopRowVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>21</ActiveRow>");
        wb.println("      <ActiveCol>18</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
         start = start + maxItem;
            }
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
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
