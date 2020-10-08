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
import com.project.general.Bank;
import com.project.general.Bank;
import com.project.general.Company;
import com.project.general.DbBank;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class ReportVendorXLS extends HttpServlet {

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

        int group = 0;
        String code = "";
        String name = "";
        int tax = 0;
        int inpKomisi = 0;
        int inpKonsinyasi = 0;
        int inpBeliputus = 0;

        long userId = 0;
        User user = new User();
        Vector rp = new Vector();
        HttpSession session = request.getSession();

        try {
            rp = (Vector) session.getValue("REPORT_VENDOR_LIST");
        } catch (Exception e) {
        }

        // index 0 = group
        try {
            group = Integer.parseInt(String.valueOf(rp.get(0)));
        } catch (Exception e) {
        }

        try {
            code = String.valueOf(rp.get(1));
        } catch (Exception e) {
        }

        try {
            name = String.valueOf(rp.get(2));
        } catch (Exception e) {
        }

        try {
            tax = Integer.parseInt(String.valueOf(rp.get(3)));
        } catch (Exception e) {
        }

        try {
            inpKomisi = Integer.parseInt(String.valueOf(rp.get(4)));
        } catch (Exception e) {
        }

        try {
            inpKonsinyasi = Integer.parseInt(String.valueOf(rp.get(5)));
        } catch (Exception e) {
        }
        
        try {
            inpBeliputus = Integer.parseInt(String.valueOf(rp.get(6)));
        } catch (Exception e) {
        }


        String whereClause = "";

        if (group != -1) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + group;
        }


        if (tax != -1) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + tax;
        }

        if (code != null && code.length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbVendor.colNames[DbVendor.COL_CODE] + " like '%" + code + "%'";
        }

        if (name != null && name.length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbVendor.colNames[DbVendor.COL_NAME] + " like '%" + name + "%'";
        }

        String wOR = "";
        if (inpKonsinyasi == 1) {
            wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 1 ";
        }else{
            wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 ";
        }

        if (inpKomisi == 1) {
            if (wOR.length() > 0) {
                wOR = wOR + " or ";
            }
            wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 1 ";
        }else{
            if (wOR.length() > 0) {
                wOR = wOR + " or ";
            }
            wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = -1 ";
        }
        
        if(inpBeliputus==1){
            if (wOR.length() > 0) {
                wOR = wOR + " or ";
            }
            wOR = wOR + " ( "+DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 0 and "+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" = 0 )";
                
        }else{
            if (wOR.length() > 0) {
                wOR = wOR + " or ";
            }
            wOR = wOR + " ( "+DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = -1 and "+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" = -1 )";
        }

        if (wOR.length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " ( " + wOR + " )";
        }

        String strType = "";        
        
        if(inpBeliputus ==1){
            strType = "BELI PUTUS";
        }
        
        if(inpKonsinyasi == 1){
            if(strType != null && strType.length() > 0){
                strType = strType +", ";
            }
            strType = strType + "CONSIGMENT";
        }
        
        if(inpKomisi == 1){
            if(strType != null && strType.length() > 0){
                strType = strType +", ";
            }
            strType = strType + "KOMISI";            
        }

        String strTax = "PKP & NON PKP";
        if(tax != -1){
            if (tax == 1) {
                strTax = "PKP";
            } else {
                strTax = "NON PKP";
            }
        }

        String orderClause = "name";

        Vector listVendor = DbVendor.list(0, 0, whereClause, orderClause);

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
        wb.println("      <Created>2015-08-11T16:44:23Z</Created>");
        wb.println("      <LastSaved>2015-08-11T17:06:06Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m42914240\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m31942784\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s95\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s96\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s98\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s113\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s122\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s125\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s130\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s133\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"30\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"104.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"129.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"54\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"85.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"76.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"97.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"74.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"97.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"110.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84\"/>");
        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"15\" ss:StyleID=\"s133\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s130\"><Data ss:Type=\"String\">Printed by : " + user.getFullName() + "," + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s122\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s125\"><Data ss:Type=\"String\">VENDOR LIST</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\">");
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s125\"><Data ss:Type=\"String\">GROUP : " + DbVendor.vendorType[group] + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"6\">");
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s125\"><Data ss:Type=\"String\">TYPE : " + strType + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"7\">");
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s125\"><Data ss:Type=\"String\">TAX : " + strTax + "</Data></Cell>");
        wb.println("      </Row>");


        wb.println("      <Row ss:Index=\"8\">");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">CODE</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">CONSIGMENT /</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">NAME</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">ADDRESS</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">PKP</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m42914240\"><Data ss:Type=\"String\">EMAIL</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">NPWP</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">REK. NUMBER</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">PIC</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s74\"><Data ss:Type=\"String\">BANK</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">TYPE LOCATION</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m31942784\"><Data ss:Type=\"String\">PAYMENT TYPE</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s76\"><Data ss:Type=\"String\">CONSIGMENT</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s76\"><Data ss:Type=\"String\">KOMISI</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">KOMISI</Data></Cell>");
        wb.println("      <Cell ss:Index=\"12\" ss:StyleID=\"s96\"><Data ss:Type=\"String\">INCOMING</Data></Cell>");
        wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Margin (%)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Promotion (%)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Margin (%)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Promotion (%)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("      </Row>");
        if (listVendor != null && listVendor.size() > 0) {
            for (int i = 0; i < listVendor.size(); i++) {
                Vendor vendor = (Vendor) listVendor.get(i);

                String type = "BELI PUTUS";
                if (vendor.getIsKonsinyasi() == 0 && vendor.getIsKomisi() == 0) {
                    type = "BELI PUTUS";
                } else {
                    type = "";
                    if (vendor.getIsKonsinyasi() == 1) {
                        type = "Consigment";
                    }

                    if (vendor.getIsKomisi() == 1) {
                        if (type.length() > 0) {
                            type = type + " & ";
                        }
                        type = type + "Komisi";
                    }
                }
                
                String typePkp = "";
                if(vendor.getIsPKP()==1){
                    typePkp = "PKP";
                }else{
                    typePkp = "NON PKP";
                }

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"String\">" + vendor.getCode() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s113\"><Data ss:Type=\"String\">" + type.toUpperCase()  + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">" + vendor.getName() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+vendor.getAddress()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+typePkp+"</Data></Cell>");
                String strEmail = "";
                if(vendor.getEmail() != null && vendor.getEmail().length() > 0 && vendor.getEmail().compareToIgnoreCase("null") != 0){
                    strEmail = vendor.getEmail();
                }
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+strEmail+"</Data></Cell>");
                String strNpwp = "";
                if(vendor.getNpwp() != null && vendor.getNpwp().length() > 0 && vendor.getNpwp().compareToIgnoreCase("null") != 0){
                    strNpwp = vendor.getNpwp();
                }
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+strNpwp+"</Data></Cell>");
                String strNoRek = "";
                if(vendor.getNoRek() != null && vendor.getNoRek().length() > 0 && vendor.getNoRek().compareToIgnoreCase("null") != 0){
                    strNoRek = vendor.getNoRek();
                }
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+strNoRek+"</Data></Cell>");
                String strContact = "";
                if(vendor.getContact() != null && vendor.getContact().length() > 0 && vendor.getContact().compareToIgnoreCase("null") != 0){
                    strContact = vendor.getContact();
                }
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+strContact+"</Data></Cell>");
                String bankName = "";
                try{
                    if(vendor.getBankId() != 0){
                        Bank bank = DbBank.fetchExc(vendor.getBankId());
                        bankName = bank.getName();
                    }
                }catch(Exception e){}
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+bankName+"</Data></Cell>");
                String locationName = "";
                try{
                    if(vendor.getTypeLocIncoming() != null && vendor.getTypeLocIncoming().length() > 0 && vendor.getTypeLocIncoming().compareToIgnoreCase("null") != 0){                        
                        locationName = vendor.getTypeLocIncoming();
                    }
                }catch(Exception e){}
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+locationName+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s98\"><Data ss:Type=\"String\">"+DbVendor.keyPayment[vendor.getPaymentType()]+"</Data></Cell>");
                
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getPercentMargin()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getPercentPromosi()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getPercentBarcode()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getKomisiMargin()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getKomisiPromosi()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">"+vendor.getKomisiBarcode()+"</Data></Cell>");
                wb.println("      </Row>");
            }
        }
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
        wb.println("      <ActiveRow>14</ActiveRow>");
        wb.println("      <ActiveCol>5</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
        wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
