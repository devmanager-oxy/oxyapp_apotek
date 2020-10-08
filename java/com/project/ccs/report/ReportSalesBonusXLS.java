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
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.session.ReportParameter;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class ReportSalesBonusXLS extends HttpServlet {

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
        double persen = 0;
        try {
            persen = Double.parseDouble(DbSystemProperty.getValueByName("PERSENTASE_BONUS_SALES"));
        } catch (Exception e) {
        }
        ReportParameter rp = new ReportParameter();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameter) session.getValue("REPORT_SALES_BONUS");
        } catch (Exception e) {
        }

        User u = new User();
        try {
            u = DbUser.fetch(userxId);
        } catch (Exception e) {
        }

        Vector listUser = DbUser.listPartObj(0, 0, "", null);
        Hashtable hash = new Hashtable();
        if (listUser != null && listUser.size() > 0) {
            for (int i = 0; i < listUser.size(); i++) {
                User ux = (User) listUser.get(i);
                hash.put(String.valueOf(ux.getOID()), String.valueOf(ux.getFullName()));
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
        wb.println("      <LastPrinted>2015-08-25T18:44:41Z</LastPrinted>");
        wb.println("      <Created>2015-08-25T18:32:51Z</Created>");
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
        wb.println("      <Style ss:ID=\"m42941972\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m42941992\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m42942012\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
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
        wb.println("      <Style ss:ID=\"m42942052\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
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
        wb.println("      <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s90\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s93\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\">");
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
        wb.println("      <Style ss:ID=\"s101\">");
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
        wb.println("      <Style ss:ID=\"s104\">");
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
        wb.println("      <Style ss:ID=\"s106\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <NumberFormat ss:Format=\"0%\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"42\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"119.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"94.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"9.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96.75\"/>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Printed by : " + u.getFullName() + "," + JSPFormater.formatDate(new Date(), "dd MMM yyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"4\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s90\"><Data ss:Type=\"String\">SALES BONUS REPORT</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s90\"><Data ss:Type=\"String\">PERIOD :" + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " to " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");

        String where = "";
        if (rp.getLocationId() != 0) {
            where = DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + rp.getLocationId();
        }

        Vector locations = DbLocation.list(0, 0, where, DbLocation.colNames[DbLocation.COL_NAME]);

        double grandSales = 0;
        double grandBonus = 0;

        if (locations != null && locations.size() > 0) {
            for (int i = 0; i < locations.size(); i++) {
                Location l = (Location) locations.get(i);
                try {
                    CONResultSet crs = null;
                    where = " and ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + l.getOID();
                    String sql = "select locationid, user_id,name,sum(omset) as xomset,sum(hpp) as xhpp from ( " +
                            " select ps.type,l.location_id as locationid, l.name as name, ps.marketing_id as user_id,sum((psd.qty * psd.selling_price)- psd.discount_amount) as omset ,sum( psd.qty * psd.cogs) as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                            " where ps.type in (0,1) " + where + " and ps.date >= '" + JSPFormater.formatDate(rp.getDateFrom(), "yyyy-MM-dd") + " 00:00:00'  and ps.date <= '" + JSPFormater.formatDate(rp.getDateTo(), "yyyy-MM-dd") + " 23:59;59' group by ps.user_id union " +
                            " select ps.type,l.location_id as locationid, l.name as name, ps.marketing_id as user_id,sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as omset ,sum( psd.qty * psd.cogs)*-1 as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                            " where ps.type in (2,3) " + where + " and ps.date >= '" + JSPFormater.formatDate(rp.getDateFrom(), "yyyy-MM-dd") + " 00:00:00'  and ps.date <= '" + JSPFormater.formatDate(rp.getDateTo(), "yyyy-MM-dd") + " 23:59;59' group by ps.user_id ) as x group by user_id ";
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    Vector datas = new Vector();
                    double total = 0;
                    while (rs.next()) {
                        double amount = rs.getDouble("xomset");
                        long userId = rs.getLong("user_id");
                        total = total + amount;

                        Vector tmp = new Vector();
                        tmp.add(String.valueOf(userId));
                        tmp.add(String.valueOf(amount));
                        datas.add(tmp);
                    }

                    double totalBonus = 0;
                    if (l.getAmountTarget() < total) {
                        totalBonus = (persen * total) / 100;
                    }

                    if (datas != null && datas.size() > 0) {
                        wb.println("      <Row>");
                        wb.println("      <Cell><Data ss:Type=\"String\">Location</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">:</Data></Cell>");
                        wb.println("      <Cell><Data ss:Type=\"String\">" + l.getName() + "</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"6\"><Data ss:Type=\"String\">Persentase Bonus</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">:</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + persen + "%</Data></Cell>");
                        wb.println("      </Row>");
                        wb.println("      <Row>");
                        wb.println("      <Cell><Data ss:Type=\"String\">Target Omset</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s71\"><Data ss:Type=\"String\">:</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"Number\">" + l.getAmountTarget() + "</Data></Cell>");
                        wb.println("      <Cell ss:Index=\"6\"><Data ss:Type=\"String\">Total Bonus</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">:</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"Number\">" + totalBonus + "</Data></Cell>");
                        wb.println("      </Row>");

                        wb.println("      <Row>");
                        wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"String\">No</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">Cashier</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"String\">Total Sales</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"String\">Bonus (%)</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">Bonus (Value)</Data></Cell>");
                        wb.println("      </Row>");
                    }
                    int no = 1;
                    double subTotal = 0;
                    double subPersen = 0;
                    double subBonus = 0;
                    for (int ix = 0; ix < datas.size(); ix++) {

                        Vector tx = (Vector) datas.get(ix);
                        double amount = Double.parseDouble(String.valueOf(tx.get(1)));
                        String fullName = "";
                        long userId = Long.parseLong(String.valueOf(tx.get(0)));
                        try {
                            fullName = String.valueOf(hash.get(String.valueOf(userId)));
                        } catch (Exception e) {
                        }

                        double bonusPersonal = 0;
                        double persenPersonal = 0;
                        if (l.getAmountTarget() < total) {
                            persenPersonal = (amount * 100) / total;
                            bonusPersonal = (persenPersonal * totalBonus) / 100;
                            subPersen = subPersen + persenPersonal;
                            subBonus = subBonus + bonusPersonal;
                            grandBonus = grandBonus + bonusPersonal;
                        }
                        subTotal = subTotal + amount;
                        grandSales = grandSales + amount;

                        wb.println("      <Row>");
                        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"Number\">" + no + "</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">" + fullName + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"Number\">" + amount + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"Number\">" + persenPersonal + "</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m42941972\"><Data ss:Type=\"Number\">" + bonusPersonal + "</Data></Cell>");
                        wb.println("      </Row>");
                        no++;
                    }
                    if (no > 1) {

                        wb.println("      <Row>");
                        wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">T O T A L</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subPersen + "</Data></Cell>");
                        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m42942012\"><Data ss:Type=\"Number\">" + subBonus + "</Data></Cell>");
                        wb.println("      </Row>");
                        wb.println("      <Row >");
                        wb.println("      <Cell ss:MergeAcross=\"3\" ><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("      </Row>");
                    }

                } catch (Exception e) {
                }


            }
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"3\" ><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">G R A N D   T O T A L</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + grandSales + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m42942052\"><Data ss:Type=\"Number\">" + grandBonus + "</Data></Cell>");
            wb.println("      </Row>");
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
        wb.println("      <ActiveRow>21</ActiveRow>");
        wb.println("      <ActiveCol>15</ActiveCol>");
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
