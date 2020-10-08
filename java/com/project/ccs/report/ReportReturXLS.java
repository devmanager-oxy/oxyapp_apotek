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
import com.project.ccs.session.ReportParameterLocation;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class ReportReturXLS extends HttpServlet {

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
        long userxId = JSPRequestValue.requestLong(request, "user_id");
        ReportParameterLocation rp = new ReportParameterLocation();
        Vector vLocSelected = new Vector();
        HttpSession session = request.getSession();
        try {
            rp = (ReportParameterLocation) session.getValue("REPORT_SALES_VOID");
        } catch (Exception e) {
        }

        try {
            vLocSelected = (Vector) session.getValue("VECTOR_VOIDLOCATION");
        } catch (Exception e) {
        }

        User u = new User();
        try {
            u = DbUser.fetch(userxId);
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
        wb.println("      <LastPrinted>2015-08-15T22:04:23Z</LastPrinted>");
        wb.println("      <Created>2015-08-15T21:26:00Z</Created>");
        wb.println("      <LastSaved>2015-08-15T22:31:14Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Medium Date\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
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
        wb.println("      <Style ss:ID=\"s99\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        //wb.println("      <NumberFormat ss:Format=\"0.000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s110\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        //wb.println("      <NumberFormat ss:Format=\"0.000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s111\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s112\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s118\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s126\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"");
        wb.println("      ss:Underline=\"Single\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s127\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s129\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s130\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s132\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:Width=\"47.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"124.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:Width=\"31.5\"/>");
        wb.println("      <Column ss:Width=\"62.25\"/>");
        wb.println("      <Column ss:Width=\"45.75\"/>");
        wb.println("      <Column ss:Width=\"51.75\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + u.getFullName() + ", " + JSPFormater.formatDate(new Date(), "dd MMM yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s127\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"/>");
        wb.println("      <Cell ss:StyleID=\"s127\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s126\"><Data ss:Type=\"String\">RETUR SALES REPORT</Data></Cell>");
        wb.println("      </Row>");

        Location location = new Location();
        if (rp.getLocationId() == 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s129\"><Data ss:Type=\"String\">LOCATION : ALL LOCATION</Data></Cell>");
            wb.println("      </Row>");
        } else {
            try {
                location = DbLocation.fetchExc(rp.getLocationId());
                if (location.getOID() != 0) {
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s129\"><Data ss:Type=\"String\">LOCATION : " + location.getName() + "</Data></Cell>");
                    wb.println("      </Row>");
                }
            } catch (Exception e) {
            }
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s130\"><Data ss:Type=\"String\">PERIOD : " + JSPFormater.formatDate(rp.getStartDate(), "dd MMM yyyy") + " to " + JSPFormater.formatDate(rp.getEndDate(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");

        String strType = "";
        if (rp.getSalesType() == 0) {
            strType = "TYPE : ALL TYPE";
        } else if (rp.getSalesType() == 1) {
            strType = "TYPE : NON RETUR";
        } else {
            strType = "TYPE : RETUR";
        }

        double gQty = 0;
        double gPrice = 0;
        double gDiscount = 0;
        double gAmount = 0;

        if (vLocSelected != null && vLocSelected.size() > 0) {

            Vector users = DbUser.listFullObj(0, 0, "", "", "");
            Hashtable hashUser = new Hashtable();
            if (users != null && users.size() > 0) {
                for (int i = 0; i < users.size(); i++) {
                    User ux = (User) users.get(i);
                    hashUser.put(String.valueOf(ux.getOID()), ux.getFullName());
                }
            }

            for (int a = 0; a < vLocSelected.size(); a++) {

                Location loc = new Location();
                loc = (Location) vLocSelected.get(a);

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s105\"/>");
                wb.println("      <Cell ss:StyleID=\"s110\"/>");
                wb.println("      <Cell ss:StyleID=\"s111\"/>");
                wb.println("      <Cell ss:StyleID=\"s111\"/>");
                wb.println("      <Cell ss:StyleID=\"s111\"/>");
                wb.println("      </Row>");
                wb.println("      <Row>");
                wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s132\"><Data ss:Type=\"String\">" + loc.getName() + " - " + strType + "</Data></Cell>");
                wb.println("      </Row>");

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Date</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Number</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">User</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">SKU</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Approved By</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Qty</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Selling Price</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Discount</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">Amount</Data></Cell>");
                wb.println("      </Row>");

                try {
                    CONResultSet crs = null;

                    String where = "";

                    where = where + " and s.location_id = " + loc.getOID();


                    if (rp.getNumber() != null && rp.getNumber().length() > 0) {
                        where = where + " and s.number like '%" + rp.getNumber() + "%' ";
                    }

                    String sqlVoid = "select s.type as type,s.date as date,s.number as number,s.user_id as user_id,sd.sales_detail_id as sales_detail_id,m.code as code,m.name as name,sd.qty as qty,sd.selling_price as selling_price,sd.discount_amount as discount,sd.cancelled_by as cancelled_by from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in (0,1) and (s.date between '" + JSPFormater.formatDate(rp.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(rp.getEndDate(), "yyyy-MM-dd") + " 23:59:59') and sd.qty < 0 " + where;
                    String sqlRetur = "select s.type as type,s.date as date,s.number as number,s.user_id as user_id,sd.sales_detail_id as sales_detail_id,m.code as code,m.name as name,sd.qty*-1 as qty,sd.selling_price as selling_price,sd.discount_amount*-1 as discount,sd.cancelled_by as cancelled_by from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in (2,3) and (s.date between '" + JSPFormater.formatDate(rp.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(rp.getEndDate(), "yyyy-MM-dd") + " 23:59:59') and sd.qty > 0 " + where;

                    String sqlUnion = "";

                    if (rp.getSalesType() == 0) {
                        sqlUnion = sqlVoid + " union " + sqlRetur;
                    } else if (rp.getSalesType() == 1) {
                        sqlUnion = sqlVoid;
                    } else if (rp.getSalesType() == 2) {
                        sqlUnion = sqlRetur;
                    }

                    String sql = "select type,date,number,user_id,sales_detail_id,code,name,qty,selling_price,discount,cancelled_by from ( " + sqlUnion + ") as x order by date";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    int no = 0;
                    String tmpDate = "";

                    double subQty = 0;
                    double subPrice = 0;
                    double subDiscount = 0;
                    double subAmount = 0;

                    double grandQty = 0;
                    double grandPrice = 0;
                    double grandDiscount = 0;
                    double grandAmount = 0;

                    while (rs.next()) {

                        Date date = rs.getDate("date");
                        String number = rs.getString("number");

                        String sku = rs.getString("code");
                        String name = rs.getString("name");

                        double qty = rs.getDouble("qty");
                        double sellingPrice = rs.getDouble("selling_price");
                        double discount = rs.getDouble("discount");
                        if (qty == -0) {
                            qty = 0;
                        }
                        if (sellingPrice == -0) {
                            sellingPrice = 0;
                        }
                        if (discount == -0) {
                            discount = 0;
                        }
                        double amount = (qty * sellingPrice) - discount;

                        long userId = 0;
                        long appId = 0;

                        try {
                            userId = rs.getLong("user_id");
                        } catch (Exception e) {
                        }

                        try {
                            appId = rs.getLong("cancelled_by");
                        } catch (Exception e) {
                        }

                        String strUser = "";
                        String strApp = "";

                        if (userId != 0) {
                            try {
                                strUser = String.valueOf(hashUser.get(String.valueOf(userId)));
                            } catch (Exception e) {
                                strUser = "";
                            }
                        }

                        if (appId != 0) {
                            try {
                                strApp = String.valueOf(hashUser.get(String.valueOf(appId)));
                            } catch (Exception e) {
                                strUser = "";
                            }
                        }

                        String strDate = "";
                        if (tmpDate == null || tmpDate.length() <= 0) {
                            strDate = JSPFormater.formatDate(date, "dd MMM yyyy");
                        } else {
                            if (tmpDate.compareTo(JSPFormater.formatDate(date, "dd MMM yyyy")) != 0) {
                                no = 0;
                                strDate = JSPFormater.formatDate(date, "dd MMM yyyy");

                                wb.println("      <Row>");
                                wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s112\"><Data ss:Type=\"String\">Total By Date</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subQty, "###,###.##") + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subPrice, "###,###.##") + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subDiscount, "###,###.##") + "</Data></Cell>");
                                wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subAmount, "###,###.##") + "</Data></Cell>");
                                wb.println("      </Row>");

                                subQty = 0;
                                subPrice = 0;
                                subDiscount = 0;
                                subAmount = 0;
                            }
                        }

                        wb.println("      <Row>");
                        wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + strDate + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + number + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + strUser + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"Number\">" + sku + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + name + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + strApp + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(qty, "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(sellingPrice, "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(discount, "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(amount, "###,###.##") + "</Data></Cell>");
                        wb.println("      </Row>");

                        subQty = subQty + qty;
                        subPrice = subPrice + sellingPrice;
                        subDiscount = subDiscount + discount;
                        subAmount = subAmount + amount;

                        grandQty = grandQty + qty;
                        grandPrice = grandPrice + sellingPrice;
                        grandDiscount = grandDiscount + discount;
                        grandAmount = grandAmount + amount;
                        no++;
                        tmpDate = JSPFormater.formatDate(date, "dd MMM yyyy");

                    }


                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s112\"><Data ss:Type=\"String\">Total By Date</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subQty, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subPrice, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subDiscount, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(subAmount, "###,###.##") + "</Data></Cell>");
                    wb.println("      </Row>");

                    gQty = gQty + grandQty;
                    gPrice = gPrice + grandPrice;
                    gDiscount = gDiscount + grandDiscount;
                    gAmount = gDiscount + grandAmount;
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s112\"><Data ss:Type=\"String\">Sub Total</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(grandQty, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(grandPrice, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(grandDiscount, "###,###.##") + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(grandAmount, "###,###.##") + "</Data></Cell>");
                    wb.println("      </Row>");

                } catch (Exception e) {
                }

            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s105\"/>");
            wb.println("      <Cell ss:StyleID=\"s110\"/>");
            wb.println("      <Cell ss:StyleID=\"s111\"/>");
            wb.println("      <Cell ss:StyleID=\"s111\"/>");
            wb.println("      <Cell ss:StyleID=\"s111\"/>");
            wb.println("      </Row>");

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s112\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s99\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(gQty, "###,###.##") + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(gPrice, "###,###.##") + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(gDiscount, "###,###.##") + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s100\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(gAmount, "###,###.##") + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Layout x:Orientation=\"Landscape\"/>");
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
        wb.println("      <ActiveRow>15</ActiveRow>");
        wb.println("      <ActiveCol>13</ActiveCol>");
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
            String str = "";
            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
