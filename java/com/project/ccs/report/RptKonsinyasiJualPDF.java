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
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.VendorItem;
import com.project.ccs.session.ReportConsigCost;
import com.project.ccs.session.ReportParameter;
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
import java.util.Hashtable;

/**
 *
 * @author Roy Andika
 */
public class RptKonsinyasiJualPDF extends HttpServlet {

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

        System.out.println("===| Rpt Konsinyasi Harga Beli |===");

        ReportParameter rp = new ReportParameter();

        long userId = 0;
        User user = new User();

        HttpSession session = request.getSession();
        try {            
            rp = (ReportParameter) session.getValue("REPORT_KONSINYASI_COST");
        } catch (Exception e) {
        }

        Vector result = new Vector();
        Hashtable sBegin = new Hashtable();
        Hashtable sReceive = new Hashtable();
        Hashtable sSold = new Hashtable();
        Hashtable sRetur = new Hashtable();
        Hashtable sTransIn = new Hashtable();
        Hashtable sTransOut = new Hashtable();
        Hashtable sAdjustment = new Hashtable();

        long vendorId = rp.getVendorId();

        Vendor vnd = new Vendor();
        try {
            vnd = DbVendor.fetchExc(vendorId);
        } catch (Exception e) {
        }
        
        try {
            result = (Vector) session.getValue("REPORT_KONSINYASI_COST_RESULT");
        } catch (Exception e) {
        }

        try {
            sBegin = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_BEGIN");
        } catch (Exception e) {
        }

        try {
            sReceive = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_RECEIVE");
        } catch (Exception e) {
        }

        try {
            sSold = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_SOLD");
        } catch (Exception e) {
        }

        try {
            sRetur = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_RETUR");
        } catch (Exception e) {
        }

        try {
            sTransIn = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_TI");
        } catch (Exception e) {
        }

        try {
            sTransOut = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_TO");
        } catch (Exception e) {
        }

        try {
            sAdjustment = (Hashtable) session.getValue("REPORT_KONSINYASI_COST_ADJ");
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
        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font fontHeaderTable = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font tableContent = new Font(Font.COURIER, 9, Font.NORMAL, border);

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

            Cell titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontHeader));
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

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            if (vnd.getOID() != 0) {
                titleCellHeader = new Cell(new Chunk("VENDOR   :" + vnd.getName(), fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);
            }

            String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");

            titleCellHeader = new Cell(new Chunk("PERIOD   : " + period.toUpperCase(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(rp.getLocationId());
            } catch (Exception e) {
            }

            if (loc.getOID() != 0) {
                titleCellHeader = new Cell(new Chunk("STORE    : " + loc.getName().toUpperCase(), fontHeader));
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

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            double totalBill = 0;
            if (result != null && result.size() > 0) {

                int poHeaderTop[] = {8, 31, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 10};

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
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("DESCRIPTION", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("COST", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("BEGINING", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("RECEIVE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("SOLD", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("RETUR", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TRANSFER IN", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TRANSFER OUT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("ADJUST.", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("ENDING", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("SELLING VALUE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("STOCK VALUE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

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

                for (int i = 0; i < result.size(); i++) {

                    ReportConsigCost rsm = (ReportConsigCost) result.get(i);

                    String wherex = DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + "=" + rsm.getItemMasterId();
                    String orderx = DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE] + " desc ";

                    Vector listVItem = DbVendorItem.list(0, 1, wherex, orderx);

                    VendorItem vI = new VendorItem();
                    try {
                        if (listVItem != null && listVItem.size() > 0) {
                            vI = (VendorItem) listVItem.get(0);
                        }
                    } catch (Exception e) {
                    }

                    ReportConsigCost begin = new ReportConsigCost();
                    try {
                        begin = (ReportConsigCost) sBegin.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        begin = new ReportConsigCost();
                    }
                    ReportConsigCost receive = new ReportConsigCost();
                    try {
                        receive = (ReportConsigCost) sReceive.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (receive == null) {
                        receive = new ReportConsigCost();
                    }
                    if (begin == null) {
                        begin = new ReportConsigCost();
                    }
                    ReportConsigCost sold = new ReportConsigCost();
                    try {
                        sold = (ReportConsigCost) sSold.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (sold == null) {
                        sold = new ReportConsigCost();
                    }

                    ReportConsigCost retur = new ReportConsigCost();
                    try {
                        retur = (ReportConsigCost) sRetur.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (retur == null) {
                        retur = new ReportConsigCost();
                    }
                    ReportConsigCost transIn = new ReportConsigCost();
                    try {
                        transIn = (ReportConsigCost) sTransIn.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (transIn == null) {
                        transIn = new ReportConsigCost();
                    }

                    ReportConsigCost transOut = new ReportConsigCost();
                    try {
                        transOut = (ReportConsigCost) sTransOut.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (transOut == null) {
                        transOut = new ReportConsigCost();
                    }

                    ReportConsigCost adjustment = new ReportConsigCost();
                    try {
                        adjustment = (ReportConsigCost) sAdjustment.get("" + rsm.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println("exception " + e.toString());
                    }
                    if (adjustment == null) {
                        adjustment = new ReportConsigCost();
                    }

                    double stock = begin.getQty() + receive.getQty() + sold.getQty() + retur.getQty() + transIn.getQty() + transOut.getQty() + adjustment.getQty();
                    double sellingV = 0;
                    if (sold.getQty() != 0) {
                        sellingV = sold.getQty() * -1 * vI.getLastPrice();
                    } else {
                        sellingV = sold.getQty() * vI.getLastPrice();
                    }

                    String strSellingV = "";
                    if (sellingV < 0) {
                        strSellingV = "(" + JSPFormater.formatNumber(sellingV, "#,###") + ")";
                    } else {
                        strSellingV = JSPFormater.formatNumber(sellingV, "#,###");
                    }

                    double vEnding = 0;
                    double vEnding2 = 0;
                    vEnding = stock * vI.getLastPrice();
                    vEnding2 = stock * vI.getLastPrice();

                    String strV = "";
                    if (vEnding < 0) {
                        vEnding = vEnding * -1;
                        strV = "(" + JSPFormater.formatNumber(vEnding, "#,###") + ")";
                    } else {
                        strV = JSPFormater.formatNumber(vEnding, "#,###");
                    }

                    tot1 = tot1 + begin.getQty();
                    tot2 = tot2 + receive.getQty();
                    double tot3x = sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty();
                    tot3 = tot3 + tot3x;
                    double tot4x = retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty();
                    tot4 = tot4 + tot4x;
                    tot5 = tot5 + transIn.getQty();
                    double tot6x = transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty();
                    tot6 = tot6 + tot6x;
                    tot7 = tot7 + adjustment.getQty();
                    tot8 = tot8 + stock;
                    tot9 = tot9 + sellingV;
                    tot10 = tot10 + vEnding2;

                    titlePrCellTop = new Cell(new Chunk("" + rsm.getSku(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + rsm.getDescription(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(vI.getLastPrice(), "#,###"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + begin.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + receive.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    double qtx = sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty();
                    titlePrCellTop = new Cell(new Chunk("" + qtx, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    double qty = retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty();
                    titlePrCellTop = new Cell(new Chunk("" + qty, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + transIn.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    double qtz = transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty();
                    titlePrCellTop = new Cell(new Chunk("" + qtz, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + adjustment.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + stock, tableContent));
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
                totalBill = tot9;
                if (tot9 < 0) {
                    tot9 = tot9 * -1;
                    strV = "(" + JSPFormater.formatNumber(tot9, "#,###") + ")";
                } else {
                    strV = JSPFormater.formatNumber(tot9, "#,###");
                }

                titlePrCellTop = new Cell(new Chunk("" + strV, tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                String strVx = "";
                if (tot10 < 0) {
                    tot10 = tot10 * -1;
                    strVx = "(" + JSPFormater.formatNumber(tot10, "#,###") + ")";
                } else {
                    strVx = JSPFormater.formatNumber(tot10, "#,###");
                }

                titlePrCellTop = new Cell(new Chunk("" + strVx, tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);

            }

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

            titlePrCellTop = new Cell(new Chunk("........," + JSPFormater.formatDate(new Date(), "dd MM yyyy"), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("Created by", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("                   ======================", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("TOTAL BILL       :  Rp. " + JSPFormater.formatNumber(totalBill, "#,###.##"), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);


            titlePrCellTop = new Cell(new Chunk("                   ======================", tableContent));
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

            titlePrCellTop = new Cell(new Chunk("" + emp.getName(), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(white);
            prTable.addCell(titlePrCellTop);

            document.add(prTable);

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
