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
import com.project.ccs.session.RptKonsinyasiBeli;
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
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;

/**
 *
 * @author Roy Andika
 */
public class RptKonsinyasiCostPDF extends HttpServlet {

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

        ReportParameter rp = new ReportParameter();
        long userId = 0;
        User user = new User();
        HttpSession session = request.getSession();

        Vector result = new Vector();
        try {
            result = (Vector) session.getValue("REPORT_KONSINYASI BELI");
        } catch (Exception e) {
        }

        try {
            rp = (ReportParameter) session.getValue("REPORT_KONSINYASI_COST");
        } catch (Exception e) {
        }

        Vendor vendor = new Vendor();
        try {
            vendor = DbVendor.fetchExc(rp.getVendorId());
        } catch (Exception e) {
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(rp.getLocationId());
        } catch (Exception e) {
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_KOSNINYASI_HARGA_BELI");
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
        Font fontHeader = new Font(Font.COURIER, 10, Font.NORMAL, border);
        Font fontPrinted = new Font(Font.COURIER, 7, Font.NORMAL, border);
        Font fontHeaderTable = new Font(Font.COURIER, 8, Font.NORMAL, border);
        Font tableContent = new Font(Font.COURIER, 8, Font.NORMAL, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Color white = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4.rotate(), 30, 30, 30, 30);
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

            Cell titleCellHeader = new Cell(new Chunk("Printed By :" + user.getFullName() + ", Date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss"), fontPrinted));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + cmp.getAddress(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(titleRpt, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            if (vendor.getOID() != 0) {
                titleCellHeader = new Cell(new Chunk("SUPLIER   :" + vendor.getName().toUpperCase(), fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);
            }

            String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");

            titleCellHeader = new Cell(new Chunk("PERIOD : " + period.toUpperCase(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            if (loc.getOID() != 0) {
                titleCellHeader = new Cell(new Chunk("LOCATION   : " + loc.getName().toUpperCase(), fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);
            }

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            double tot1 = 0;
            double tot2 = 0;
            double tot3 = 0;
            double tot4 = 0;
            double tot5 = 0;
            double tot6 = 0;
            double tot7 = 0;
            double tot8 = 0;
            double tot9 = 0;
            double tot10 = 0;

            if (result != null && result.size() > 0) {

                int poHeaderTop[] = {8, 23, 10, 7, 7, 7, 7, 7, 7, 8, 7, 10, 12};

                Table prTable = new Table(13);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(0);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk("SKU", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);                
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("DESCRIPTION", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("COST", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("BEGINING", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor); 
                titlePrCellTop.setBackgroundColor(bgColor); 
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("RECEIVE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("SOLD", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("RETUR", fontHeaderTable));
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TRANSFER", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setColspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("ADJUSTMENT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("ENDING", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("SELLING VALUE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("STOCK VALUE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setRowspan(2);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);                
                
                titlePrCellTop = new Cell(new Chunk("IN", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("OUT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                for (int i = 0; i < result.size(); i++) {

                    RptKonsinyasiBeli rsm = (RptKonsinyasiBeli) result.get(i);

                    double stock = rsm.getBegining() + rsm.getReceiving() - rsm.getSold() - rsm.getRetur() + rsm.getTransferIn() - rsm.getTransferOut() + rsm.getAdjustment();

                    double sellingV = rsm.getSold() * rsm.getCost();
                    String strSellingV = "";

                    if (sellingV < 0) {
                        strSellingV = "(" + JSPFormater.formatNumber(sellingV*-1, "#,###.##") + ")";
                    } else {
                        strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                    }
                    double vEnding = stock * rsm.getCost();

                    String strV = "";
                    if (vEnding < 0) {                        
                        strV = "(" + JSPFormater.formatNumber(vEnding*-1, "#,###.##") + ")";
                    } else {
                        strV = JSPFormater.formatNumber(vEnding, "#,###.##");
                    }

                    tot1 = tot1 + rsm.getBegining();
                    tot2 = tot2 + rsm.getReceiving();
                    tot3 = tot3 + rsm.getSold();
                    tot4 = tot4 + rsm.getRetur();
                    tot5 = tot5 + rsm.getTransferIn();
                    tot6 = tot6 + rsm.getTransferOut();
                    tot7 = tot7 + rsm.getAdjustment();
                    tot8 = tot8 + stock;
                    tot9 = tot9 + sellingV;
                    tot10 = tot10 + vEnding;

                    titlePrCellTop = new Cell(new Chunk("" + rsm.getSku(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + rsm.getItemName(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getCost(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getBegining(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getReceiving(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getSold(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getRetur(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getTransferIn(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);


                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getTransferOut(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(rsm.getAdjustment(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(stock, "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + strSellingV, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + strV, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                }

                titlePrCellTop = new Cell(new Chunk("GRAND TOTAL     ", tableContent));
                titlePrCellTop.setColspan(3);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot1, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot2, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot3, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot4, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot5, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot6, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot7, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot8, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                String strV = "";                
                if (tot9 < 0) {
                    tot9 = tot9 * -1;
                    strV = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                } else {
                    strV = JSPFormater.formatNumber(tot9, "#,###.##");
                }

                titlePrCellTop = new Cell(new Chunk("" + strV, tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                String strVx = "";
                if (tot10 < 0) {
                    tot10 = tot10 * -1;
                    strVx = "(" + JSPFormater.formatNumber(tot10, "#,###.##") + ")";
                } else {
                    strVx = JSPFormater.formatNumber(tot10, "#,###.##");
                }

                titlePrCellTop = new Cell(new Chunk("" + strVx, tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);

            }

            int po1HeaderTop[] = {15, 5, 10, 25, 25};

            Table pr1Table = new Table(5);
            pr1Table.setWidth(100);
            pr1Table.setWidths(po1HeaderTop);
            pr1Table.setBorderColor(white);
            pr1Table.setBorderWidth(0);
            pr1Table.setAlignment(1);
            pr1Table.setCellpadding(0);
            pr1Table.setCellspacing(1);

            Cell titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setColspan(5);
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("Subtotal", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("" + JSPFormater.formatNumber(tot9, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            String addrReport = DbSystemProperty.getValueByName("ADDRESS_REPORT");
            String month = "";
            if (new Date().getMonth() == 0) {
                month = "Januari";
            } else if (new Date().getMonth() == 1) {
                month = "Februari";
            } else if (new Date().getMonth() == 2) {
                month = "Maret";
            } else if (new Date().getMonth() == 3) {
                month = "April";
            } else if (new Date().getMonth() == 4) {
                month = "Mei";
            } else if (new Date().getMonth() == 5) {
                month = "Juni";
            } else if (new Date().getMonth() == 6) {
                month = "Juli";
            } else if (new Date().getMonth() == 7) {
                month = "Agustus";
            } else if (new Date().getMonth() == 8) {
                month = "September";
            } else if (new Date().getMonth() == 9) {
                month = "Oktober";
            } else if (new Date().getMonth() == 10) {
                month = "November";
            } else if (new Date().getMonth() == 11) {
                month = "Desember";
            }

            titlePrCellTop1 = new Cell(new Chunk(addrReport+", " +new Date().getDate() + " " + month + " " + (new Date().getYear() + 1900) , tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            //new Line

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setColspan(4);
            titlePrCellTop1.setBorderColor(white); 
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk("Created By", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setColspan(1);
            titlePrCellTop1.setBorderColor(white); 
            pr1Table.addCell(titlePrCellTop1);
            
            //new Line
            
            double ppn = 0;
            if (vendor.getIsPKP() == 1) {
                ppn = (tot9 * 10) / 100;
            }

            titlePrCellTop1 = new Cell(new Chunk("Tax", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("" + JSPFormater.formatNumber(ppn, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);            
                        
            double totalBill = tot9 + ppn;
            
            titlePrCellTop1 = new Cell(new Chunk("Total Bill", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("" + JSPFormater.formatNumber(totalBill, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            //new Line

            double promot = (totalBill / 100) * vendor.getPercentPromosi();

            titlePrCellTop1 = new Cell(new Chunk("Promosi " + JSPFormater.formatNumber(vendor.getPercentPromosi(), "#,###") + " %", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("" + JSPFormater.formatNumber(promot, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk(emp.getName(), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            //new Line
            
            double barcode = vendor.getPercentBarcode() * (tot2 + tot5);

            titlePrCellTop1 = new Cell(new Chunk("Barcode @Rp. " + JSPFormater.formatNumber(vendor.getPercentBarcode(), "#,###"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk(JSPFormater.formatNumber(barcode, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            double grandTotal = totalBill - promot - barcode;

            titlePrCellTop1 = new Cell(new Chunk("Total Bayar", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk(": Rp.", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);
            
            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            
            titlePrCellTop1 = new Cell(new Chunk(JSPFormater.formatNumber(grandTotal, "#,###.##"), tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            titlePrCellTop1 = new Cell(new Chunk("", tableContent));
            titlePrCellTop1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop1.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop1.setBorderColor(white);
            pr1Table.addCell(titlePrCellTop1);

            document.add(pr1Table);

            int poHeaderTop[] = {45, 45};

            Table prTable = new Table(2);
            prTable.setWidth(100);
            prTable.setWidths(poHeaderTop);
            prTable.setBorderColor(white);
            prTable.setBorderWidth(0);
            prTable.setAlignment(1);
            prTable.setCellpadding(0);
            prTable.setCellspacing(1);

            Cell titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setColspan(2);
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setColspan(2);
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            document.add(prTable);

        } catch (Exception e) {
            System.out.println(e.toString());
        }

        document.close();
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
