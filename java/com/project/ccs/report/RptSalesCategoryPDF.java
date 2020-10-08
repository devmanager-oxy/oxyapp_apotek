/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.lowagie.text.*;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.Document;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import java.util.Date;
import com.lowagie.text.Font;
import com.project.admin.DbUser;
import com.project.admin.User;

import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.RptSalesCategory;
import com.project.ccs.session.SessReportSales;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.Location;
import java.util.Hashtable;
import com.project.ccs.posmaster.*;

/**
 *
 * @author Roy Andika
 */
public class RptSalesCategoryPDF extends HttpServlet {

    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameter) session.getValue("REPORT_SALES_CATEGORY");
        } catch (Exception e) {
        }
        int type = JSPRequestValue.requestInt(request, "type_sub");

        try {
            result = SessReportSales.listSalesReportBySubCategory(rp.getDateFrom(), rp.getDateTo(), rp.getLocationId(), rp.getCategoryId(), rp.getVendorId());
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_SALES_BY_CATEGORY");
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Employee emp = new Employee();
        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
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

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user

        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font fontHeaderTable = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font fontContent = new Font(Font.COURIER, 11, Font.BOLD, border);
        Font tableContent = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font tableContentUnderline = new Font(Font.COURIER, 11, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Color white = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");
            document.open();

            //for header =========================================================== 
            int titleHeader[] = {90};

            Table titleTable = new Table(1);
            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setPadding(2);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk("User Id : " + user.getFullName(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Printed : " + JSPFormater.formatDate(new Date(), "dd MMM yyyy hh:mm:ss"), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + cmp.getAddress(), fontHeader));
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(titleRpt, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");

            titleCellHeader = new Cell(new Chunk(period, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(rp.getLocationId());
            } catch (Exception e) {
            }

            titleCellHeader = new Cell(new Chunk("STORE   : " + loc.getName().toUpperCase(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            if (result != null && result.size() > 0) {

                int poHeaderTop[] = {10, 9, 18, 10, 5, 7, 6, 10, 15};
                int poHeaderTop2[] = {10, 9, 9, 9, 10, 5, 7, 6, 10, 15};
                
                int l = 9;
                if (type == 1) {
                    l = 10;
                }

                Table prTable = new Table(l);

                prTable.setWidth(100);
                if (type == 1) {
                    prTable.setWidths(poHeaderTop2);
                }else{
                    prTable.setWidths(poHeaderTop);
                }
                
                prTable.setBorderColor(white);
                prTable.setBorderWidth(0);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk("CATEGORY", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                if (type == 1) {
                    titlePrCellTop = new Cell(new Chunk("SUB CATEGORY", fontHeaderTable));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                }

                titlePrCellTop = new Cell(new Chunk("SKU", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("ITEM NAME", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("VENDOR", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("QTY", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("PRICE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("DISKON", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TOTAL", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TOTAL", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                long itemCategoryId = 0;
                double jum = 0;
                double prc = 0;

                double gJum = 0;
                double gPrc = 0;

                Vector subcategorys = DbItemCategory.list(0, 0, "", DbItemCategory.colNames[DbItemCategory.COL_NAME]);
                Hashtable hascategorys = new Hashtable();
                if (subcategorys != null && subcategorys.size() > 0) {
                    for (int x = 0; x < subcategorys.size(); x++) {
                        ItemCategory ic = (ItemCategory) subcategorys.get(x);
                        hascategorys.put("" + ic.getOID(), "" + ic.getName());
                    }
                }

                for (int i = 0; i < result.size(); i++) {

                    RptSalesCategory rsc = (RptSalesCategory) result.get(i);

                    double jumlah = rsc.getJumlah();

                    double total = (jumlah * rsc.getSelling()) - rsc.getDiskon();

                    if (itemCategoryId != rsc.getCategoriId() && itemCategoryId != 0) {

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setColspan(4);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        if (type == 1) {
                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                        }

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(jum, "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setColspan(3);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Rp." + JSPFormater.formatNumber(prc, "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        jum = 0;
                        prc = 0;

                    }

                    jum = jum + jumlah;
                    prc = prc + total;
                    gJum = gJum + jumlah;
                    gPrc = gPrc + total;

                    String strCategory = "";
                    if (itemCategoryId != rsc.getCategoriId()) {
                        strCategory = rsc.getCategory();
                    }

                    titlePrCellTop = new Cell(new Chunk("" + strCategory, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    if (type == 1) {
                        String sub = "";
                        try {
                            sub = String.valueOf(hascategorys.get("" + rsc.getSubCategoryId()));
                        } catch (Exception e) {
                        }
                        titlePrCellTop = new Cell(new Chunk("" + sub, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                    }

                    titlePrCellTop = new Cell(new Chunk("" + rsc.getSku(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + rsc.getName(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    String vendor = "-";
                    if (rsc.getVendor() != null && rsc.getVendor().length() > 0) {
                        vendor = rsc.getVendor();
                    }

                    titlePrCellTop = new Cell(new Chunk("" + vendor, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(jumlah, "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsc.getSelling(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsc.getDiskon(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(total, "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    itemCategoryId = rsc.getCategoriId();
                }

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(4);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                if (type == 1) {
                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                }

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(jum, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(3);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Rp. " + JSPFormater.formatNumber(prc, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(9);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                if (type == 1) {
                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                }

                titlePrCellTop = new Cell(new Chunk("GRAND TOTAL", tableContent));
                titlePrCellTop.setColspan(4);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                if (type == 1) {
                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                }

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(gJum, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(3);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Rp. " + JSPFormater.formatNumber(gPrc, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);

                int poHeaderTopFot[] = {15, 9, 28, 6, 7, 10, 15};

                Table prTableFot = new Table(7);
                prTableFot.setWidth(100);
                prTableFot.setWidths(poHeaderTopFot);
                prTableFot.setBorderColor(white);
                prTableFot.setBorderWidth(0);
                prTableFot.setAlignment(1);
                prTableFot.setCellpadding(0);
                prTableFot.setCellspacing(1);

                Cell titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(7);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(7);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("OMSET, Rp. " + JSPFormater.formatNumber(gPrc, "#,###.##"), fontContent));
                titlePrCellTopFot.setColspan(7);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("Create By,", tableContent));
                titlePrCellTopFot.setColspan(2);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(5);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(7);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(7);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("" + emp.getName(), tableContentUnderline));
                titlePrCellTopFot.setColspan(2);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(5);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("" + emp.getPosition(), tableContent));
                titlePrCellTopFot.setColspan(2);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                titlePrCellTopFot = new Cell(new Chunk("", tableContent));
                titlePrCellTopFot.setColspan(5);
                titlePrCellTopFot.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopFot.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopFot.setBorderColor(white);
                prTableFot.addCell(titlePrCellTopFot);

                document.add(prTableFot);

            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        document.close();

        System.out.println("print==============");
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();

        baos.writeTo(out);
        out.flush();
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
}
