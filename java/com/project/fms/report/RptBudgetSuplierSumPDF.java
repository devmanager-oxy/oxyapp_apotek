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
import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.session.SessReportAnggaran;
import com.project.fms.session.SessReportBudgetSuplier;
import com.project.fms.transaction.*;
import com.project.general.Bank;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbBank;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class RptBudgetSuplierSumPDF extends HttpServlet {

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

        System.out.println("===| RptBudgetSuplier |===");
        int lang = 0;

        long vendorId = 0;
        Date dateFrom = new Date();
        Date dateTo = new Date();
        int ignore = 0;
        int pkp = 0;
        int nonpkp = 0;
        Vector list = new Vector();
        int paymentType = 0;
        
        int non = 0;
        int konsinyasi = 0;
        int komisi = 0;

        long userId = 0;
        User user = new User();

        Vector dateTrans = new Vector();
        Hashtable print = new Hashtable();
        HttpSession session = request.getSession();
        long historyPrint = JSPRequestValue.requestLong(request, "history_print");

        try {
            dateTrans = (Vector) session.getValue("DATE_TRANS_DATE");
            SessReportBudgetSuplier dt1 = (SessReportBudgetSuplier) dateTrans.get(0);
            SessReportBudgetSuplier dt2 = (SessReportBudgetSuplier) dateTrans.get(1);
            dateFrom = dt1.getTransDate();
            dateTo = dt2.getTransDate();
        } catch (Exception e) {
        }

        try {
            print = (Hashtable) session.getValue("PRINT_REPORT_BUDGET");
        } catch (Exception e) {
        }

        try {
            paymentType = JSPRequestValue.requestInt(request, "payment_type");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            vendorId = JSPRequestValue.requestLong(request, "vendorId");
        } catch (Exception e) {
            System.out.println(e.toString());
        }


        try {
            ignore = JSPRequestValue.requestInt(request, "ignore");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            pkp = JSPRequestValue.requestInt(request, "pkp");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            nonpkp = JSPRequestValue.requestInt(request, "nonpkp");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            non = JSPRequestValue.requestInt(request, "non");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            konsinyasi = JSPRequestValue.requestInt(request, "konsinyasi");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        try {
            komisi = JSPRequestValue.requestInt(request, "komisi");
        } catch (Exception e) {
            System.out.println(e.toString());
        }   

        Vector list2 = new Vector();
        try {
            list = SessReportAnggaran.getBudgetSuplierSummary(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,paymentType,non,konsinyasi,komisi);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        Hashtable vendorIdx = new Hashtable();
        try {
            if(historyPrint == 0){
                list2 = SessReportAnggaran.getBudgetSuplier(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,non,konsinyasi,komisi);
            }else{
                vendorIdx = DbReportBudget.listNumber(historyPrint);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        String vx = "";
        int numberx = 1;        
        for (int i = 0; i < list2.size(); i++) {
            SessReportBudgetSuplier srbs = (SessReportBudgetSuplier) list2.get(i);
            if (vx.equalsIgnoreCase("") || vx.compareToIgnoreCase(srbs.getSuplier()) != 0) {
                vendorIdx.put("" + srbs.getVendorId(), "" + numberx);
                numberx++;
            }
            vx = srbs.getSuplier();
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

        String title = "";
        if (!(pkp == 1 && nonpkp == 1)) {
            if (pkp == 1) {
                title = title + " ( PKP )";
            }
            if (nonpkp == 1) {
                title = title + " ( NON PKP )";
            }
        }

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user

        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Font fontHeaderTable = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font tableContent = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font fontUnderline = new Font(Font.COURIER, 9, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);

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

            Cell titleCellHeader = new Cell(new Chunk("" + cmp.getName() + " " + title, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            if (ignore == 0) {

                String date = "";
                if (dateFrom.compareTo(dateTo) == 0) {
                    date = JSPFormater.formatDate(dateFrom, "dd/MM/yyyy");
                } else {
                    date = JSPFormater.formatDate(dateFrom, "dd/MM/yyyy") + " TO " + JSPFormater.formatDate(dateTo, "dd/MM/yyyy");
                }
                titleCellHeader = new Cell(new Chunk("DATE : " + date, fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);

            }

            String bankTransfer = "";
            String msgTransfer = "";

            try {
                bankTransfer = DbSystemProperty.getValueByName("BANK_TRANSFER");
            } catch (Exception e) {
            }

            try {
                msgTransfer = DbSystemProperty.getValueByName("MSG_TRANSFER");
            } catch (Exception e) {
            }

            titleCellHeader = new Cell(new Chunk("TO : " + bankTransfer, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(msgTransfer, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(title, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            if (list != null && list.size() > 0) {

                int poHeaderTop[] = {5, 30, 12,7, 20, 19, 19, 8};

                Table prTable = new Table(8);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(1);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk("NO", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("NAME OF SUPLIER", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("BRAND OF SUPPLIER", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("REF", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("BANK", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("NO ACCOUNT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("PAYMENT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Message For", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                String v = "";
                double tot = 0;
                double totAmount = 0;
                int number = 1;

                for (int i = 0; i < list.size(); i++) {
                    SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
                    srbs = (SessReportBudgetSuplier) list.get(i);

                    long oid = 0;
                    try {
                        oid = Long.parseLong("" + print.get("" + srbs.getBankpoPaymentId()));
                    } catch (Exception e) {
                    }

                    if (oid != 0) {
                        totAmount = totAmount + srbs.getValue();
                        Bank b = new Bank();
                        try {
                            b = DbBank.fetchExc(srbs.getBankId());
                        } catch (Exception e) {
                        }

                        String noRek = "";
                        if (srbs.getNoRek() != null) {
                            noRek = srbs.getNoRek();
                        }

                        String contact = "";
                        if (srbs.getContact() != null) {
                            contact = srbs.getContact();
                        }


                        titlePrCellTop = new Cell(new Chunk("" + number, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        number = number + 1;

                        titlePrCellTop = new Cell(new Chunk(" " + contact, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + srbs.getSuplier(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        
                        int idx = 0;
                    try{
                        idx = Integer.parseInt(String.valueOf(vendorIdx.get(""+srbs.getVendorId())));
                    }catch(Exception e){}
                        
                        titlePrCellTop = new Cell(new Chunk("" + idx, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        

                        titlePrCellTop = new Cell(new Chunk("" + b.getName(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + noRek, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(srbs.getValue(), "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                    }
                }

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(5);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("TOTAL", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(totAmount, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(totAmount, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);


                document.add(prTable);

                int poHeaderTop2[] = {24, 24, 24, 24, 24};

                Table prTable2 = new Table(5);
                prTable2.setWidth(100);
                prTable2.setWidths(poHeaderTop2);
                prTable2.setBorderColor(new Color(255, 255, 255));
                prTable2.setBorderWidth(0);
                prTable2.setAlignment(1);
                prTable2.setCellpadding(0);
                prTable2.setCellspacing(1);

                String spell = "";
                try {
                    String a = JSPFormater.formatNumber(totAmount, "#,###");
                    NumberSpeller numberSpeller = new NumberSpeller();
                    String u = a.replaceAll(",", "");
                    spell = numberSpeller.spellNumberToIna(Double.parseDouble(u)) + " Rupiah";
                } catch (Exception e) {
                    spell = "";
                }

                Cell titlePrCellTop2 = new Cell(new Chunk("TERBILANG : " + spell, tableContent));
                titlePrCellTop2.setColspan(5);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("", tableContent));
                titlePrCellTop2.setColspan(5);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp.getName(), fontUnderline));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("", tableContent));
                titlePrCellTop2.setColspan(4);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("", tableContent));
                titlePrCellTop2.setColspan(5);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("", tableContent));
                titlePrCellTop2.setColspan(5);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp.getPosition(), tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("", tableContent));
                titlePrCellTop2.setColspan(4);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                document.add(prTable2);
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
