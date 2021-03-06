/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

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
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.general.Vendor;

/**
 *
 * @author Roy Andika
 */
public class RptApMemoPDF extends HttpServlet {

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

        int lang = 0;
        long bankpoPaymentId = 0;
        BankpoPayment bankpoPayment = new BankpoPayment();
        long userId = 0;
        User user = new User();
        Vector vVendor = new Vector();
        try {
            bankpoPaymentId = JSPRequestValue.requestLong(request, "bankpopayment_id");
            vVendor = DbBankpoPaymentDetail.getGroupVendor(bankpoPaymentId);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        int maxKarakter = 7;
        int maxDatas = 10;

        try {
            bankpoPayment = DbBankpoPayment.fetchExc(bankpoPaymentId);
        } catch (Exception e) {
        }

        try {
            lang = JSPRequestValue.requestInt(request, "lang");
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

        Employee create = new Employee();

        User ux = new User();
        try {
            ux = DbUser.fetch(bankpoPayment.getOperatorId());
        } catch (Exception e) {
        }

        try {
            create = DbEmployee.fetchExc(ux.getEmployeeId());
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

        String title = "";
        if (lang == 0) {
            title = "POST DATED INVOICE & FAKTUR PAJAK";
        } else {
            title = "POST DATED INVOICE & FAKTUR PAJAK";
        }

        Color border = new Color(0x00, 0x00, 0x00);


        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font fontHeaderv = new Font(Font.COURIER, 11, Font.BOLD, border);
        Font fontH = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font fontTitle = new Font(Font.COURIER, 11, Font.BOLD, border);
        Font tableContent = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font tableContentUnderline = new Font(Font.COURIER, 11, Font.UNDERLINE, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);

        Color blackColor = new Color(0, 0, 0);
        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4_CUSTOM, 25, 20, 15, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            //for header =========================================================== 
            int titleHeader[] = {12, 1, 20, 7, 1, 26};

            int page = vVendor.size();

            if (vVendor != null && vVendor.size() > 0) {

                for (int v = 0; v < vVendor.size(); v++) {

                    Table titleTable = new Table(6);
                    int pageCurrent = v + 1;

                    titleTable.setWidth(100);
                    titleTable.setWidths(titleHeader);
                    titleTable.setBorderColor(new Color(255, 255, 255));
                    titleTable.setBorderWidth(0);
                    titleTable.setAlignment(1);
                    titleTable.setCellpadding(0);
                    titleTable.setCellspacing(1);

                    long vendorId = Long.parseLong("" + vVendor.get(v));

                    String where = DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = " + bankpoPaymentId + " and " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + vendorId;
                    Vector vBpd = DbBankpoPaymentDetail.list(0, 0, where, null);

                    int totalDatas = 0;

                    if (vBpd != null && vBpd.size() > 0) {
                        for (int i = 0; i < vBpd.size(); i++) {
                            BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBpd.get(i);

                            int length = bpd.getMemo().length();
                            int looping = length / 5;
                            int mod = length % 5;

                            int start = 0;
                            int end = maxKarakter;

                            if (length > 0) {
                                for (int t = 0; t < looping; t++) {
                                    String desc = bpd.getMemo().substring(start, end);
                                    System.out.println("desc " + desc);

                                    start = end;
                                    end = start + maxKarakter;
                                    totalDatas = totalDatas + 1;
                                }

                                if (mod != 0) {
                                    String desc = bpd.getMemo().substring(start);
                                    System.out.println("desc " + desc);
                                    totalDatas = totalDatas + 1;
                                }
                            } else {
                                totalDatas = totalDatas + 1;
                            }
                        }
                    }

                    int totalPages = totalDatas / maxDatas;
                    int sisa = totalDatas % maxDatas;
                    if (sisa != 0) {
                        totalPages = totalPages + 1;
                    }

                    Vendor vend = new Vendor();
                    try {
                        vend = DbVendor.fetchExc(vendorId);
                    } catch (Exception e) {
                    }

                    //===========================================================================



                    Cell titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatDate(new Date(), "dd MM yyyy") + " at " + JSPFormater.formatDate(new Date(), "HH:mm:ss"), fontH));
                    titleCellHeader.setColspan(3);
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Page " + pageCurrent + " of " + totalPages, fontH));
                    titleCellHeader.setColspan(3);
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + emp.getName(), fontH));
                    titleCellHeader.setColspan(6);
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + cmp.getName().toUpperCase() + "", fontTitle));
                    titleCellHeader.setColspan(6);
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(title, fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setColspan(6);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setColspan(6);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Post Dated No", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + bankpoPayment.getJournalNumber(), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("To", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + vend.getName(), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Date", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(JSPFormater.formatDate(bankpoPayment.getDate(), "dd/MM/yyyy"), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Phone", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + vend.getPhone(), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Clearing Date", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy"), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Address", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + vend.getAddress(), fontHeaderv));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("Remark", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(":", fontHeader));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk(bankpoPayment.getMemo(), fontHeaderv));
                    titleCellHeader.setColspan(4);
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorderColor(new Color(255, 255, 255));
                    titleTable.addCell(titleCellHeader);

                    document.add(titleTable);

                    if (vBpd != null && vBpd.size() > 0) {

                        //membuat table 
                        int poHeaderTop[] = {22, 33, 19, 23, 23};

                        Table prTable = new Table(5);
                        prTable.setWidth(100);
                        prTable.setWidths(poHeaderTop);
                        prTable.setBorderColor(new Color(255, 255, 255));
                        prTable.setBorderWidth(0);
                        prTable.setAlignment(1);
                        prTable.setCellpadding(0);
                        prTable.setCellspacing(1);

                        //space antar table                        
                        Cell titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setColspan(5);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Invoice No", fontHeader));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Description", fontHeader));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Date", fontHeader));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Purchase", fontHeader));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("Deduction", fontHeader));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorder(Rectangle.BOTTOM);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        
                        

                        //value-valuenya
                        double tPurchase = 0;
                        double tDeduction = 0;
                        
                        int idx = 1;

                        for (int i = 0; i < vBpd.size(); i++) {

                            BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBpd.get(i);
                            
                            Receive receive = new Receive();
                            try {
                                receive = DbReceive.fetchExc(bpd.getInvoiceId());
                            } catch (Exception e) {
                            }
                            
                            //===================

                            int length = bpd.getMemo().length();
                            int looping = length / 5;
                            int mod = length % 5;

                            int start = 0;
                            int end = maxKarakter;

                            if (length > 0) {
                                for (int t = 0; t < looping; t++) {
                                    String desc = bpd.getMemo().substring(start, end);
                                    System.out.println("desc " + desc);

                                    if(idx == maxDatas){
                                        
                                        document.newPage();
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    start = end;
                                    end = start + maxKarakter;
                                    totalDatas = totalDatas + 1;
                                }

                                if (mod != 0) {
                                    String desc = bpd.getMemo().substring(start);
                                    System.out.println("desc " + desc);
                                    totalDatas = totalDatas + 1;
                                }
                            } else {
                                totalDatas = totalDatas + 1;
                            }





                            //==================






                           



                            String[] desc = new String[20];
                            desc = bpd.getMemo().split(" ");
                            String des = "";
                            boolean available = true;
                            if (desc.length > 0) {
                                int max = 0;
                                for (int iKalimat = 0; iKalimat < desc.length; iKalimat++) {
                                    String tmpKalimat = desc[iKalimat];
                                    max = max + tmpKalimat.length() + 1;
                                    if (max > maxKarakter) {

                                        //=================================
                                        if (available) {
                                            titlePrCellTop = new Cell(new Chunk(receive.getNumber(), tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);
                                        } else {
                                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);
                                        }

                                        titlePrCellTop = new Cell(new Chunk(des, tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        if (available) {
                                            titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy"), tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                            double purchase = 0;
                                            double deduction = 0;

                                            if (bpd.getPaymentAmount() > 0) {
                                                purchase = bpd.getPaymentAmount();
                                            } else {
                                                deduction = bpd.getPaymentAmount() * -1;
                                            }

                                            titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(purchase, "#,###.##"), tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                            titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(deduction, "#,###.##"), tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                            tPurchase = tPurchase + purchase;
                                            tDeduction = tDeduction + deduction;

                                        } else {
                                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                            titlePrCellTop.setBorderWidth(0);
                                            prTable.addCell(titlePrCellTop);

                                        }

                                        available = false;
                                        //====================================  
                                        des = tmpKalimat;
                                        if (tmpKalimat.compareTo(" ") != 0) {
                                            max = tmpKalimat.length() + 1;
                                        } else {
                                            max = 0;
                                        }
                                    } else {
                                        if (des != null && des.length() > 0) {
                                            des = des + " ";
                                        }
                                        des = des + tmpKalimat;
                                    }
                                }
                                if (max > 0) {
                                    if (available) {
                                        titlePrCellTop = new Cell(new Chunk(receive.getNumber(), tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);
                                    } else {
                                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);
                                    }

                                    titlePrCellTop = new Cell(new Chunk(des, tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    if (available) {
                                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy"), tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        double purchase = 0;
                                        double deduction = 0;

                                        if (bpd.getPaymentAmount() > 0) {
                                            purchase = bpd.getPaymentAmount();
                                        } else {
                                            deduction = bpd.getPaymentAmount() * -1;
                                        }

                                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(purchase, "#,###.##"), tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(deduction, "#,###.##"), tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        tPurchase = tPurchase + purchase;
                                        tDeduction = tDeduction + deduction;

                                    } else {
                                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                        titlePrCellTop.setBorderWidth(0);
                                        prTable.addCell(titlePrCellTop);

                                    }
                                }

                            } else {
                                //=================================
                                if (available) {
                                    titlePrCellTop = new Cell(new Chunk(receive.getNumber(), tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);
                                } else {
                                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);
                                }

                                titlePrCellTop = new Cell(new Chunk(des, tableContent));
                                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                titlePrCellTop.setBorderWidth(0);
                                prTable.addCell(titlePrCellTop);

                                if (available) {
                                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy"), tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    double purchase = 0;
                                    double deduction = 0;

                                    if (bpd.getPaymentAmount() > 0) {
                                        purchase = bpd.getPaymentAmount();
                                    } else {
                                        deduction = bpd.getPaymentAmount() * -1;
                                    }

                                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(purchase, "#,###.##"), tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(deduction, "#,###.##"), tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    tPurchase = tPurchase + purchase;
                                    tDeduction = tDeduction + deduction;

                                } else {
                                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    titlePrCellTop.setBorderColor(new Color(255, 255, 255));
                                    titlePrCellTop.setBorderWidth(0);
                                    prTable.addCell(titlePrCellTop);

                                }


                            }





                        }

                        double amount = tPurchase - tDeduction;
                        
                        titlePrCellTop = new Cell(new Chunk("Amount", tableContent));
                        titlePrCellTop.setBorder(Rectangle.TOP);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(": " + JSPFormater.formatNumber(amount, "#,###.##"), tableContent));
                        titlePrCellTop.setColspan(2);
                        titlePrCellTop.setBorder(Rectangle.TOP);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(tPurchase, "#,###.##"), tableContent));
                        titlePrCellTop.setBorder(Rectangle.TOP);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(tDeduction, "#,###.##"), tableContent));
                        titlePrCellTop.setBorder(Rectangle.TOP);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("In Words", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(putih);
                        prTable.addCell(titlePrCellTop);

                        String a = JSPFormater.formatNumber(amount, "#,###");
                        NumberSpeller numberSpeller = new NumberSpeller();
                        String u = a.replaceAll(",", "");

                        titlePrCellTop = new Cell(new Chunk(": " + numberSpeller.spellNumberToIna(Double.parseDouble(u)) + " Rupiah", fontSpellCharge));
                        titlePrCellTop.setColspan(4);
                        titlePrCellTop.setBorder(0);
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(putih);
                        prTable.addCell(titlePrCellTop);

                        document.add(prTable);
                    }

                    int poFooter[] = {40, 40, 40};

                    Table prTableF = new Table(3);
                    prTableF.setWidth(100);
                    prTableF.setWidths(poFooter);
                    prTableF.setBorderColor(new Color(255, 255, 255));
                    prTableF.setBorderWidth(0);
                    prTableF.setAlignment(1);
                    prTableF.setCellpadding(0);
                    prTableF.setCellspacing(1);

                    Cell titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setColspan(3);
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Submited by,", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Created by,", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Checked by,", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setColspan(3);
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("", tableContent));
                    titlePrCellTop.setColspan(3);
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("(                 )", tableContentUnderline));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTableF.addCell(titlePrCellTop);

                    String crName = "";
                    if (create.getName().length() > 0) {
                        crName = "( " + create.getName() + " )";
                    } else {
                        crName = "(                 )";
                    }

                    titlePrCellTop = new Cell(new Chunk(crName, tableContentUnderline));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("(                 )", tableContentUnderline));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Suplier", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Acct.", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Spv Acct.", tableContent));
                    titlePrCellTop.setBorder(0);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(putih);
                    prTableF.addCell(titlePrCellTop);

                    document.add(prTableF);

                    document.newPage();
                }
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
