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
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.ReportSalesMember;
import com.project.ccs.session.SessReportSales;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.session.SessReportBudgetSuplier;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;
import com.project.general.DbCustomer;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
//import com.project.simprop.property.DbSalesData;
//import com.project.simprop.session.RptAging;
//import com.project.simprop.session.RptCustomer;
//import com.project.simprop.session.RptPayment;

/**
 *
 * @author Roy Andika
 */
public class RptSalesMemberPDF extends HttpServlet {

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

        System.out.println("===| Rpt Sales Member |===");
        int lang = 0;

        Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameter) session.getValue("REPORT_MEMBER");
        } catch (Exception e) {
        }

        try {
            result = SessReportSales.ReportSalesByMember(rp.getDateFrom(), rp.getDateTo(), rp.getIgnore(), rp.getMember(), rp.getLocationId(),rp.getCustomerId());
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_SALES_BY_MEMBER");
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
        Font fontHeaderBig = new Font(Font.HELVETICA, 11, Font.BOLD, border);
        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font fontHeaderTable = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font fontContent = new Font(Font.HELVETICA, 11, Font.BOLD, border);
        Font fontTitle = new Font(Font.COURIER, 11, Font.BOLD, border);
        Font tableContent = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font tableContentUnderline = new Font(Font.COURIER, 11, Font.UNDERLINE, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 11, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.COURIER, 9, Font.UNDERLINE, border);
        Font fontCourier = new Font(Font.COURIER, 8, Font.NORMAL, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4LANDSCAPE, 30, 30, 30, 30);
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

                int poHeaderTop[] = {20, 20, 15, 14, 12, 9, 9, 9, 12};

                Table prTable = new Table(9);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(1);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk("MEMBER", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("STORE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("INVOICE DATE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("INVOICE NUMBER", fontHeaderTable));
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

                titlePrCellTop = new Cell(new Chunk("CASH", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("DEBIT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("CREDIT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("RECEIVEABLE", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                long memberId = 0;
                long locId = 0;
                Date invDt = null;

                double totAmountMember = 0;
                double totAmount = 0;
                int totMember = 0;
                int grandTotMember = 0;

                for (int i = 0; i < result.size(); i++) {

                    ReportSalesMember rsm = (ReportSalesMember) result.get(i);

                    if (memberId != rsm.getCustomerId() && memberId != 0){

                        titlePrCellTop = new Cell(new Chunk("Total by Member : " + totMember + " Invoice", tableContent));
                        titlePrCellTop.setColspan(4);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(totAmountMember, "#,###")+" ", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(totAmountMember, "#,###")+" ", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                    }

                    if (memberId != rsm.getCustomerId()) {
                        locId = 0;
                        invDt = null;
                        totAmountMember = 0;
                        totMember = 0;
                    }

                    double amount = 0;
                    if (rsm.getType() == DbSales.TYPE_CASH || rsm.getType() == DbSales.TYPE_CREDIT) {
                        amount = rsm.getAmount();
                    } else {
                        amount = rsm.getAmount() * -1;
                    }

                    totAmount = totAmount + amount;
                    totAmountMember = totAmountMember + amount;

                    String nameCst = "";
                    if (memberId != rsm.getCustomerId()) {
                        nameCst = rsm.getNameCustomer();
                    }

                    titlePrCellTop = new Cell(new Chunk(""+nameCst, tableContent));                    
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    String locName = "";
                    if (locId != rsm.getLocationId()) {
                        locName = rsm.getLocationName();
                    }

                    titlePrCellTop = new Cell(new Chunk(" " + locName, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    String dtTransaction = "";
                    if (invDt == null || invDt.compareTo(rsm.getDateTransaction()) != 0) {
                        dtTransaction = JSPFormater.formatDate(rsm.getDateTransaction(), "yyyy-MM-dd");
                    }

                    titlePrCellTop = new Cell(new Chunk("" + dtTransaction, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + rsm.getNumber(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(amount, "#,###")+" ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(0, "#,###")+" ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(amount, "#,###")+" ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    totMember = totMember + 1;
                    grandTotMember = grandTotMember + 1;
                    memberId = rsm.getCustomerId();
                    invDt = rsm.getDateTransaction();
                    locId = rsm.getLocationId();
                }
                
                titlePrCellTop = new Cell(new Chunk("Total by Member : "+totMember+" Invoice", tableContent));
                titlePrCellTop.setColspan(4);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totAmountMember, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);                
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totAmountMember, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);   
                
                titlePrCellTop = new Cell(new Chunk("Grand Total : "+grandTotMember+" Invoice", tableContent));
                titlePrCellTop.setColspan(4);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totAmount, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);                
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(0, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totAmount, "#,###") +" ", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);    
                
                document.add(prTable);

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
