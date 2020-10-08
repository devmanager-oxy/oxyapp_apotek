/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */
package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.ItemGroup;
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
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import java.util.Date;

public class RptSalesByItemXLS extends HttpServlet {

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

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        Vector vpar = new Vector();
        Vector vvDetail = new Vector();
        Vector vloc = new Vector();
        HttpSession session = request.getSession();
        try {
            vpar = (Vector) session.getValue("REPORT_SALES_ITEM_PARAMETER");
            vloc = (Vector) session.getValue("LOCATION");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        try {
            vvDetail = (Vector) session.getValue("REPORT_SALES_ITEM");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        //long locationId = Long.parseLong("" + vpar.get(0));
        Date startDate = JSPFormater.formatDate("" + vpar.get(1), "dd/MM/yyyy");
        Date endDate = JSPFormater.formatDate("" + vpar.get(2), "dd/MM/yyyy");
        long groupId = Long.parseLong("" + vpar.get(3));
        String srcCode = "" + vpar.get(4);
        String srcName = "" + vpar.get(5);
        String user = "" + vpar.get(6);

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));
        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-07-21T06:26:34Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-07-21T06:27:07Z</LastSaved>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9300</WindowHeight>");
        wb.println("<WindowWidth>15135</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>120</WindowTopY>");
        wb.println("<AcceptLabelsInFormulas/>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175768\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s23\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s87\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s40\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s41\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s50\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s88\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");

        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        wb.println("<Table>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"20\"/>");//no
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//code
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");//barcode
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"150\"/>");//name
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//kategory
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"130\"/>");// supplier
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");// qty
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");// sell price
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");// discount
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");// total

        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"9\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">REPORT SALES BY ITEM</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"9\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"9\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");

        wb.println("<Row >");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Printed By </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: " + user + ", date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy") + "</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Periode</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\" ss:MergeAcross=\"1\"><Data ss:Type=\"String\">: " + JSPFormater.formatDate(startDate, "dd/MM/yyyy") + " - " + JSPFormater.formatDate(endDate, "dd/MM/yyyy") + "</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        for(int j=0;j<vvDetail.size();j++){
            
        //Location loc = new Location();
        //loc = (Location) vloc.get(j);
       // try {
         //   loc = DbLocation.fetchExc(loc.getOID());
       // } catch (Exception ex) {
       // }
         Vector vDetail = new Vector();   
         vDetail = (Vector)vvDetail.get(j);
        //if (loc.getOID() != 0) {
            wb.println("<Row >");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Location</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: " + vDetail.get(0).toString() + "</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("</Row>");
       // }

        if (groupId != 0) {
            try {
                ItemGroup g = DbItemGroup.fetchExc(groupId);
                wb.println("<Row >");
                wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Category</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: " + g.getName() + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s25\"/>");
                wb.println("<Cell ss:StyleID=\"s25\"/>");
                wb.println("<Cell ss:StyleID=\"s25\"/>");
                wb.println("</Row>");
            } catch (Exception e) {
            }
        }

        if (srcCode != null && srcCode.length() > 0) {
            wb.println("<Row >");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Barcode/SKU</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: " + srcCode + "</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("</Row>");
        }

        if (srcName != null && srcName.length() > 0) {
            wb.println("<Row >");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: " + srcName + "</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("<Cell ss:StyleID=\"s25\"/>");
            wb.println("</Row>");
        }

        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row >");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">SKU</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Name</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Category</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Supplier</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Selling Price</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Discount</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("</Row>");

        if (vDetail != null && vDetail.size() > 0) {
            double totQty = 0;
            double tot = 0;
            for (int i = 1; i < vDetail.size(); i++) {

                Vector vdt = new Vector();
                vdt = (Vector) vDetail.get(i);

                double harga = 0;
                double discount = 0;
                double qty = 0;
                
                try{
                    harga = Double.parseDouble(vdt.get(6).toString());
                }catch(Exception e){}
                try{
                    discount = Double.parseDouble(vdt.get(7).toString());
                }catch(Exception e){}
                try{
                    qty = Double.parseDouble(vdt.get(4).toString());
                }catch(Exception e){}
                
                double grandTotal = (harga * qty) - discount;

                totQty = totQty + qty;
                tot = tot + grandTotal;
                
                String sku = "";
                String barcode = "";
                String item = "";
                String category = "";
                String suplier = "";
                
                try{
                    sku =  vdt.get(1).toString();
                }catch(Exception e){}
                
                try{
                    barcode = vdt.get(2).toString();
                }catch(Exception e){}
                
                try{
                    item = vdt.get(3).toString();
                }catch(Exception e){}
                
                try{
                    category = vdt.get(0).toString();
                }catch(Exception e){}
                
                try{
                    suplier = vdt.get(5).toString();
                }catch(Exception e){}

                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"Number\">" + ( i) + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + sku + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + barcode + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + item + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + category + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + suplier + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + qty + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + harga + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + discount + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
                wb.println("</Row>");

            }

            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s50\"><Data ss:Type=\"String\">T O T A L</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + totQty + "</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + tot + "</Data></Cell>");
            wb.println("</Row>");
        }
        }

        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");



        //=======penambahan batas
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        //=======end batas

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");


        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");

        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>12</ActiveRow>");
        wb.println("<ActiveCol>6</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("</Workbook>");

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
