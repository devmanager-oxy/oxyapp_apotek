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
import com.project.general.Approval;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbApproval;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import java.util.Hashtable;
/**
 *
 * @author Roy
 */
public class RptBudgetSuplierDatePDF extends HttpServlet {
    
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

        long vendorId = 0;
        int typePayment = 0;
        Date dateFrom = new Date();
        Date dateTo = new Date();
        int ignore = 0;
        int pkp = 0;
        int nonpkp = 0;
        Vector list = new Vector();

        long userId = 0;
        User user = new User();

        Vector dateTrans = new Vector();
        Hashtable print = new Hashtable();
        HttpSession session = request.getSession();

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
            vendorId = JSPRequestValue.requestLong(request, "vendorId");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            typePayment = JSPRequestValue.requestInt(request, "payment_type");
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
            list = SessReportAnggaran.getBudgetSuplier(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,typePayment);
        } catch (Exception e) {
            System.out.println(e.toString());
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
        if (lang == 0) {
            title = "BUDGET PEMBAYARAN SUPLIER";
        } else {
            title = "BUDGET PEMBAYARAN SUPLIER";
        }

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

            titleCellHeader = new Cell(new Chunk(title, fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            if (ignore == 0) {

                String date = "";
                if (dateFrom.compareTo(dateTo) == 0) {
                    date = JSPFormater.formatDate(dateFrom, "dd-MM-yyyy");
                } else {
                    date = JSPFormater.formatDate(dateFrom, "dd-MM-yyyy") + " TO " + JSPFormater.formatDate(dateTo, "dd-MM-yyyy");
                }

                titleCellHeader = new Cell(new Chunk("PERIODE : " + date, fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
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

            if (list != null && list.size() > 0) {

                int poHeaderTop[] = {5, 32, 12, 25, 23, 23};

                Table prTable = new Table(6);
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

                titlePrCellTop = new Cell(new Chunk("NAMA SUPLIER", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("DIVISI", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("NO. TT", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("NILAI", fontHeaderTable));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("JUMLAH YANG DIBAYAR", fontHeaderTable));
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
                        int count = 0;
                        int counter = 0;
                        for (int t = 0; t < list.size(); t++) {
                            SessReportBudgetSuplier ck = new SessReportBudgetSuplier();
                            ck = (SessReportBudgetSuplier) list.get(t);
                            if (JSPFormater.formatDate(ck.getTransDate(),"dd/MM/yyyy").compareToIgnoreCase(JSPFormater.formatDate(srbs.getTransDate(),"dd/MM/yyyy")) == 0) {
                                count++;
                                counter = ck.getCounter();
                            }
                        }
                        if (v.compareToIgnoreCase(JSPFormater.formatDate(srbs.getTransDate(),"dd/MM/yyyy")) != 0) {
                            tot = 0;
                        }

                        tot = tot + srbs.getValue();

                        if (v.equalsIgnoreCase("") || v.compareToIgnoreCase(JSPFormater.formatDate(srbs.getTransDate(),"dd/MM/yyyy")) != 0) {
                            titlePrCellTop = new Cell(new Chunk("" + number, tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                            number = number + 1;
                        } else {
                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                        }

                        titlePrCellTop = new Cell(new Chunk(" " + srbs.getSuplier(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        
                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + srbs.getNoTT(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        if (count > 1) {
                            titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(srbs.getValue(), "#,###.##"), tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                        } else {
                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                        }

                        if (count == 1) {
                            titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(srbs.getValue(), "#,###.##"), tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                            totAmount = totAmount + srbs.getValue();
                        } else {
                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);
                        }

                        if (count > 1 && counter == srbs.getCounter()) {
                            titlePrCellTop = new Cell(new Chunk("", tableContent));
                            titlePrCellTop.setColspan(4);
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);

                            titlePrCellTop = new Cell(new Chunk("TOTAL", tableContent));
                            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titlePrCellTop.setBorderColor(blackColor);
                            prTable.addCell(titlePrCellTop);

                            if (counter == srbs.getCounter()) {
                                totAmount = totAmount + tot;
                                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(tot, "#,###.##"), tableContent));
                                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                titlePrCellTop.setBorderColor(blackColor);
                                prTable.addCell(titlePrCellTop);
                            }
                        }

                        v = JSPFormater.formatDate(srbs.getTransDate(),"dd/MM/yyyy");
                    }
                }

                titlePrCellTop = new Cell(new Chunk("", tableContent));
                titlePrCellTop.setColspan(4);
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("GRAND TOTAL", tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(totAmount, "#,###.##"), tableContent));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);

                int intDt = new Date().getDate();
                int month = new Date().getMonth();
                int year = new Date().getYear() + 1900;

                String mth = "";

                if (month == 0) {
                    mth = "Januari";
                } else if (month == 1) {
                    mth = "Februari";
                } else if (month == 2) {
                    mth = "Maret";
                } else if (month == 3) {
                    mth = "April";
                } else if (month == 4) {
                    mth = "Mei";
                } else if (month == 5) {
                    mth = "Juni";
                } else if (month == 6) {
                    mth = "Juli";
                } else if (month == 7) {
                    mth = "Agustus";
                } else if (month == 8) {
                    mth = "September";
                } else if (month == 9) {
                    mth = "Oktober";
                } else if (month == 10) {
                    mth = "November";
                } else if (month == 11) {
                    mth = "Desember";
                }

                int poHeaderTop2[] = {24, 24, 24, 24, 24};

                Table prTable2 = new Table(5);
                prTable2.setWidth(100);
                prTable2.setWidths(poHeaderTop2);
                prTable2.setBorderColor(new Color(255, 255, 255));
                prTable2.setBorderWidth(0);
                prTable2.setAlignment(1);
                prTable2.setCellpadding(0);
                prTable2.setCellspacing(1);

                Cell titlePrCellTop2 = new Cell(new Chunk("", tableContent));
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

                String header = "";

                try {
                    Approval approval = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_0);
                    header = approval.getKeterangan();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                titlePrCellTop2 = new Cell(new Chunk("" + header + ", " + intDt + " " + mth + " " + year, tableContent));
                titlePrCellTop2.setColspan(5);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                String header1 = "";

                try {
                    Approval approval1 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_1);
                    header1 = approval1.getKeterangan();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                String header2 = "";
                String emp2 = "";
                String footer2 = "";

                try {
                    Approval approval2 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_2);
                    try {
                        Employee employee2 = DbEmployee.fetchExc(approval2.getEmployeeId());
                        emp2 = employee2.getName();
                    } catch (Exception e) {
                    }
                    header2 = approval2.getKeterangan();
                    footer2 = approval2.getKeteranganFooter();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                String header3 = "";
                String emp3 = "";
                String footer3 = "";

                try {
                    Approval approval3 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_3);
                    try {
                        Employee employee3 = DbEmployee.fetchExc(approval3.getEmployeeId());
                        emp3 = employee3.getName();
                    } catch (Exception e) {
                    }
                    header3 = approval3.getKeterangan();
                    footer3 = approval3.getKeteranganFooter();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                String emp4 = "";
                String footer4 = "";

                try {
                    Approval approval4 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_4);
                    try {
                        Employee employee4 = DbEmployee.fetchExc(approval4.getEmployeeId());
                        emp4 = employee4.getName();
                    } catch (Exception e) {
                    }
                    footer4 = approval4.getKeteranganFooter();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                String header5 = "";
                String emp5 = "";
                String footer5 = "";

                try {
                    Approval approval5 = DbApproval.getListApproval(I_Project.TYPE_BUDGET_SUPLIER, DbApproval.URUTAN_5);
                    try {
                        Employee employee5 = DbEmployee.fetchExc(approval5.getEmployeeId());
                        emp5 = employee5.getName();
                    } catch (Exception e) {
                    }
                    header5 = approval5.getKeterangan();
                    footer5 = approval5.getKeteranganFooter();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }


                titlePrCellTop2 = new Cell(new Chunk("" + header1 + ",", tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + header2 + ",", tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + header3 + ",", tableContent));
                titlePrCellTop2.setColspan(2);
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + header5 + ",", tableContent));
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

                titlePrCellTop2 = new Cell(new Chunk("" + emp2, fontUnderline));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp3, fontUnderline));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp4, fontUnderline));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp5, fontUnderline));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + emp.getPosition(), tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + footer2, tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + footer3, tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + footer4, tableContent));
                titlePrCellTop2.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop2.setBorderColor(new Color(255, 255, 255));
                prTable2.addCell(titlePrCellTop2);

                titlePrCellTop2 = new Cell(new Chunk("" + footer5, tableContent));
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
