/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.lowagie.text.*;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.FontFactory;
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
import java.net.MalformedURLException;
import java.net.URL;

import com.lowagie.text.Font;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.session.ReportConsigCost;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessLastPriceKonsinyasi;
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
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import java.util.Hashtable;

/**
 *
 * @author Roy Andika
 */
public class RptKonsinyasiPricePDF extends HttpServlet {

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

        try {
            rp = (ReportParameter) session.getValue("REPORT_KONSINYASI_PRICE");
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
            result = (Vector) session.getValue("REPORT_KONSINYASI_RESULT");
        } catch (Exception e) {
        }

        try {
            sBegin = (Hashtable) session.getValue("REPORT_KONSINYASI_BEGIN");
        } catch (Exception e) {
        }

        try {
            sReceive = (Hashtable) session.getValue("REPORT_KONSINYASI_RECEIVE");
        } catch (Exception e) {
        }

        try {
            sSold = (Hashtable) session.getValue("REPORT_KONSINYASI_SOLD");
        } catch (Exception e) {
        }

        try {
            sRetur = (Hashtable) session.getValue("REPORT_KONSINYASI_RETUR");
        } catch (Exception e) {
        }

        try {
            sTransIn = (Hashtable) session.getValue("REPORT_KONSINYASI_TRANS_IN");
        } catch (Exception e) {
        }

        try {
            sTransOut = (Hashtable) session.getValue("REPORT_KONSINYASI_TRANS_OUT");
        } catch (Exception e) {
        }

        try {
            sAdjustment = (Hashtable) session.getValue("REPORT_KONSINYASI_ADJ");
        } catch (Exception e) {
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_KOSNINYASI_HARGA_JUAL");
        } catch (Exception e) {
        }

        String addrReport = DbSystemProperty.getValueByName("ADDRESS_REPORT");
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
        Font tableUnderline = new Font(Font.COURIER, 9, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Color white = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4.rotate(), 20, 20, 20, 20);
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
            
            Cell titleCellHeader = new Cell(new Chunk("Printed By : " + user.getFullName() + ",Date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);            

            titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("" + cmp.getAddress().toUpperCase(), fontHeader));
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

            if (vnd.getOID() != 0) {
                titleCellHeader = new Cell(new Chunk("SUPLIER   : " + vnd.getName(), fontHeader));
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
                titleCellHeader = new Cell(new Chunk("LOCATION    : " + loc.getName().toUpperCase(), fontHeader));
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
            
            String strVz = "";
            if (result != null && result.size() > 0) {

                int poHeaderTop[] = {8, 10, 7, 8, 8, 5, 5, 7, 7, 7, 6, 8, 5, 11, 12, 7};

                Table prTable = new Table(16);
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

                titlePrCellTop = new Cell(new Chunk("PRICE", fontHeaderTable));
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

                titlePrCellTop = new Cell(new Chunk("RECEIVING", fontHeaderTable));
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

                titlePrCellTop = new Cell(new Chunk("MRG " + vnd.getPercentMargin(), fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("MARGIN", fontHeaderTable));
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

                titlePrCellTop = new Cell(new Chunk("PPN", fontHeaderTable));
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
                double tot11 = 0;

                double tot12 = 0;
                double tot13 = 0;

                for (int i = 0; i < result.size(); i++) {

                    ReportConsigCost rsm = (ReportConsigCost) result.get(i);

                    double price = 0;

                    ItemMaster im = new ItemMaster();
                    double discount = 0;
                    try {
                        im = DbItemMaster.fetchExc(rsm.getItemMasterId());
                        Vendor vndx = new Vendor();
                        vndx = DbVendor.fetchExc(im.getDefaultVendorId());
                        discount = vndx.getPercentMargin();
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

                    double lastPrice = 0;
                    try {
                        //lastPrice = DbSales.getLastPrice(rp.getLocationId(), rsm.getItemMasterId(), rp.getDateTo());
                        lastPrice = SessLastPriceKonsinyasi.getLastPrice(rp.getLocationId(), rsm.getItemMasterId(), rp.getDateTo());
                    } catch (Exception e) {
                    }
                    price = lastPrice;
                    if (price == 0) {
                        double tmpPrice = 0;
                        try {
                            tmpPrice = SessReportSales.reportConsignedBySellingPrice(rp.getLocationId(), rsm.getItemMasterId());                        
                        } catch (Exception e) {
                        }
                        price = tmpPrice;
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
                        sellingV = sold.getQty() * -1 * price;
                    } else {
                        sellingV = sold.getQty() * price;
                    }

                    String strSellingV = "";
                    if (sellingV < 0) {
                        strSellingV = "(" + JSPFormater.formatNumber(sellingV, "#,###.##") + ")";
                    } else {
                        strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                    }

                    double vEnding = 0;
                    double vEnding2 = 0;
                    vEnding = stock * price;
                    vEnding2 = stock * price;

                    String strV = "";
                    if (vEnding < 0) {
                        vEnding = vEnding * -1;
                        strV = "(" + JSPFormater.formatNumber(vEnding, "#,###.##") + ")";
                    } else {
                        strV = JSPFormater.formatNumber(vEnding, "#,###.##");
                    }

                    double tmpAmountDisc = (sellingV * discount) / 100;
                    String strAmountDisc = JSPFormater.formatNumber(tmpAmountDisc, "#,###.##");

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
                    tot11 = tot11 + tmpAmountDisc;

                    double marg = vnd.getPercentMargin() * sellingV / 100;
                    tot12 = tot12 + marg;

                    double ppn = 0;
                    if (vnd.getIsPKP() == 1) {
                        ppn = sellingV - ((100*sellingV)/110);
                    }
                    tot13 = tot13 + ppn;

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

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(price, "#,###.##"), tableContent));
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

                    titlePrCellTop = new Cell(new Chunk("" + vnd.getPercentMargin(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + marg, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + strV, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + ppn, tableContent));
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

                if (tot9 < 0) {
                    tot9 = tot9 * -1;
                    strVz = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                } else {
                    strVz = JSPFormater.formatNumber(tot9, "#,###.##");
                }

                titlePrCellTop = new Cell(new Chunk("" + strVz, tableContent));
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

                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(vnd.getPercentMargin(), "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(tot12, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + strVx, tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(tot13, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);

                int poHeaderTopF[] = {15, 5, 15, 5, 15, 35};

                Table prTableF = new Table(6);
                prTableF.setWidth(100);
                prTableF.setWidths(poHeaderTopF);
                prTableF.setBorderColor(white);
                prTableF.setBorderWidth(0);
                prTableF.setAlignment(1);
                prTableF.setCellpadding(0);
                prTableF.setCellspacing(1);

                Cell titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setColspan(6);
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setColspan(6);
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);


                titlePrCellTopF = new Cell(new Chunk("Total Selling Price", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("=", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(strVz, tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(addrReport + " ," + new Date().getDate() + " " + month + " " + new Date().getYear() + 1900, tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);


                titlePrCellTopF = new Cell(new Chunk("VAT Out ", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("=", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(tot13, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Created By", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);



                titlePrCellTopF = new Cell(new Chunk("Margin " + JSPFormater.formatNumber(vnd.getPercentMargin(), "#,###") + "%", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("=", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double margin = vnd.getPercentMargin() * (tot9-tot13)/100;

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(margin, "#,###.##"), tableUnderline));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double tot = tot9 - tot13 - margin;

                titlePrCellTopF = new Cell(new Chunk("Subtotal 1", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(tot, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setColspan(6);
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double vatin = 0;
                if (vnd.getIsPKP() == 1) {
                    vatin = (10*tot)/100;
                }
                double subtotal2 = tot + vatin;

                titlePrCellTopF = new Cell(new Chunk("VAT In", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(vatin, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(""+ user.getFullName(), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Subtotal 2", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(subtotal2, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setColspan(6);
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Potongan", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Promosi " + vnd.getPercentPromosi() + "%", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double promot = (tot9 / 100) * vnd.getPercentPromosi();

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(promot, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double barcode = vnd.getPercentBarcode() * (tot2 + tot5);

                titlePrCellTopF = new Cell(new Chunk("Barcode @ Rp. " + vnd.getPercentBarcode() + ",-", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(JSPFormater.formatNumber(barcode, "#,###.##"), tableUnderline));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableUnderline));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("" , tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double totPotongan = promot + barcode;

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("=", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("" + JSPFormater.formatNumber(totPotongan, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk(emp.getPosition(), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                double grandTotal = subtotal2 - totPotongan;

                titlePrCellTopF = new Cell(new Chunk("Total Bayar", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("=", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("Rp.", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("" + JSPFormater.formatNumber(grandTotal, "#,###.##"), tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                titlePrCellTopF = new Cell(new Chunk("", tableContent));
                titlePrCellTopF.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTopF.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTopF.setBorderColor(white);
                prTableF.addCell(titlePrCellTopF);

                document.add(prTableF);

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
