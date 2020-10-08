/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

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

import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;

import com.lowagie.text.Font;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.crm.master.Approval;
import com.project.crm.master.DbApproval;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;
import com.project.general.Company;
import com.project.general.DbCompany;

/**
 *
 * @author Roy
 */
public class RptRequestBudgetPDF extends HttpServlet {

    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color blackColor = new Color(0, 0, 0);
    public static Color putih = new Color(250, 250, 250);
    public static Font fontHeader = new Font(Font.HELVETICA, 10, Font.BOLD, border);
    public static Font fontHeaderUnderline = new Font(Font.HELVETICA, 13, Font.UNDERLINE, border);
    public static Font fontHeaderv = new Font(Font.HELVETICA, 12, Font.BOLD, border);
    public static Font fontH = new Font(Font.HELVETICA, 12, Font.NORMAL, border);
    public static Font fontTitle = new Font(Font.HELVETICA, 13, Font.BOLD, border);
    public static Font tableContent = new Font(Font.HELVETICA, 10, Font.NORMAL, border);
    public static Font tableContentUnderline = new Font(Font.HELVETICA, 11, Font.UNDERLINE, border);
    public static Font fontSpellCharge = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);

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

        long budgetRequestId = JSPRequestValue.requestLong(request, "reqBudId");

        BudgetRequest br = new BudgetRequest();
        SegmentDetail seg = new SegmentDetail();
        Department dep = new Department();

        //===== Gtot
        double GbudgetYTD = 0;
        double GbudgetUsed = 0;
        double Grequest = 0;
        double Gselisih = 0;
        double GPercentselisih = 0;
        double GPercentrequest = 0;
        double GPercentbudgetUsed = 0;
        double GPercentbudgetYTD = 0;

        try {
            if (budgetRequestId != 0) {
                br = DbBudgetRequest.fetchExc(budgetRequestId);
                seg = DbSegmentDetail.fetchExc(br.getSegment1Id());
                dep = DbDepartment.fetchExc(br.getDepartmentId());
            }
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


        Document document = new Document(PageSize.A4LANDSCAPE, 25, 20, 15, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, baos);
            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            int titleHeader[] = {12};
            Table titleTable = new Table(1);

            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("PERMOHONAN PEMAKAIAN BUDGET", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            int spaceTitle[] = {100};
            Table spaceTitle1 = new Table(1);

            spaceTitle1.setWidth(25);
            spaceTitle1.setWidths(spaceTitle);
            spaceTitle1.setBorderColor(new Color(255, 255, 255));
            spaceTitle1.setBorderWidth(0);
            spaceTitle1.setAlignment(0);
            spaceTitle1.setCellpadding(0);
            spaceTitle1.setCellspacing(1);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            spaceTitle1.addCell(titleCellHeader);

            document.add(spaceTitle1);

            // ==========================================
            int titleKetHeader[] = {10, 1, 20};
            Table titleTable1 = new Table(3);

            titleTable1.setWidth(25);
            titleTable1.setWidths(titleKetHeader);
            titleTable1.setBorderColor(new Color(255, 255, 255));
            titleTable1.setBorderWidth(0);
            titleTable1.setAlignment(0);
            titleTable1.setCellpadding(0);
            titleTable1.setCellspacing(1);

            titleCellHeader = new Cell(new Chunk("No", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + br.getJournalNumber(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);


            titleTable1.setWidth(35);
            titleTable1.setWidths(titleKetHeader);
            titleTable1.setBorderColor(new Color(255, 255, 255));
            titleTable1.setBorderWidth(0);
            titleTable1.setAlignment(0);
            titleTable1.setCellpadding(0);
            titleTable1.setCellspacing(1);

            titleCellHeader = new Cell(new Chunk("Tanggal", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatDate(br.getTransDate(), "dd-MM-yyyy"), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Nama Outlet", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + seg.getName(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Departemen", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + dep.getName(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("    ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("    ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("    ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            titleTable1.addCell(titleCellHeader);


            document.add(titleTable1);

            //=======================================

            int titleTblHeader[] = {5, 20, 20, 17, 7, 15, 7, 15, 7, 15, 7};
            Table tblContent = new Table(11);

            tblContent.setWidth(100);
            tblContent.setWidths(titleTblHeader);
            tblContent.setBorderColor(new Color(255, 255, 255));
            tblContent.setBorderWidth(0);
            tblContent.setAlignment(0);
            tblContent.setCellpadding(0);
            tblContent.setCellspacing(1);

            titleCellHeader = new Cell(new Chunk("No", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Nama Akun", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Keterangan", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Diajukan Sekarang", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("%", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Sudah Terpakai", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("%", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Budget YTD", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("%", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Selisih", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("%", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            tblContent.addCell(titleCellHeader);

            document.add(tblContent);

            //=============DETAIL==========================

            Vector bDetail = new Vector();
            String where = DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + "=" + budgetRequestId;
            bDetail = DbBudgetRequestDetail.list(0, 0, where, "");

            int titleTblContent[] = {5, 20, 20, 15, 5, 15, 5, 15, 5, 15, 5};
            Table tblContentDetail = new Table(11);

            tblContentDetail.setWidth(100);
            tblContentDetail.setWidths(titleTblHeader);
            tblContentDetail.setBorderColor(new Color(255, 255, 255));
            tblContentDetail.setBorderWidth(0);
            tblContentDetail.setAlignment(0);
            tblContentDetail.setCellpadding(0);
            tblContentDetail.setCellspacing(1);

            if (bDetail.size() > 0 || bDetail != null) {
                int num = 0;

                for (int i = 0; i < bDetail.size(); i++) {
                    num = num + 1;
                    BudgetRequestDetail bdet = (BudgetRequestDetail) bDetail.get(i);

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(bdet.getCoaId());
                    } catch (Exception e) {
                    }

                    double budgetYTD = 0;
                    double budgetUsed = 0;
                    double persenBudgetUsed = 0;

                    try {
                        //budgetUsed = DbBudgetRequestDetail.getBudgetUsed(bdet.getOID(), br.getTransDate(), br.getSegment1Id(), bdet.getCoaId());
                        budgetUsed = DbBudgetRequestDetail.getTerpakai(bdet.getCoaId(), br.getPeriodeId(), br.getSegment1Id(), br.getOID(), bdet.getDate());
                    } catch (Exception e) {
                    }

                    try {
                        budgetYTD = DbCoaBudget.getBudgetYTD(br.getTransDate().getYear() + 1900, bdet.getCoaId(), br.getSegment1Id());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    double selisih = budgetYTD - bdet.getRequest() - budgetUsed;
                    double persenSelisih = 0;
                    if (budgetYTD != 0) {
                        persenSelisih = selisih / budgetYTD * 100;
                    }

                    double persenRequest = 0;
                    if (budgetYTD != 0) {
                        persenRequest = bdet.getRequest() / budgetYTD * 100;
                    }

                    if (budgetYTD != 0) {
                        persenBudgetUsed = budgetUsed / budgetYTD * 100;
                    }
                    double available = budgetYTD - budgetUsed;

                    GbudgetYTD = GbudgetYTD + budgetYTD;
                    GbudgetUsed = GbudgetUsed + budgetUsed;
                    Grequest = Grequest + bdet.getRequest();
                    Gselisih = Gselisih + selisih;


                    titleCellHeader = new Cell(new Chunk("" + num, tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + c.getCode() + " - " + c.getName(), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + bdet.getMemo(), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(bdet.getRequest(), "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(persenRequest, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(budgetUsed, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(persenBudgetUsed, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(budgetYTD, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(100.00, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(selisih, "###,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);

                    titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(persenSelisih, "#,###.##"), tableContent));
                    titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellHeader.setBorder(Rectangle.TOP);
                    titleCellHeader.setBorderColor(blackColor);
                    tblContentDetail.addCell(titleCellHeader);
                }
            }


            // paling bawah ===============================================================

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);


            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentDetail.addCell(titleCellHeader);

            document.add(tblContentDetail);

            // TOTAL =====================================================================================
            int titleTblTotal[] = {5, 20, 20, 15, 5, 15, 5, 15, 5, 15, 5};
            Table tblContentTotal = new Table(11);

            tblContentTotal.setWidth(100);
            tblContentTotal.setWidths(titleTblHeader);
            tblContentTotal.setBorderColor(new Color(255, 255, 255));
            tblContentTotal.setBorderWidth(0);
            tblContentTotal.setAlignment(0);
            tblContentTotal.setCellpadding(0);
            tblContentTotal.setCellspacing(1);

            GPercentselisih = Gselisih / GbudgetYTD * 100;
            GPercentrequest = Grequest / GbudgetYTD * 100;
            GPercentbudgetUsed = GbudgetUsed / GbudgetYTD * 100;
            GPercentbudgetYTD = 100;

            titleCellHeader = new Cell(new Chunk(" TOTAL ", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(3);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(Grequest, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(GPercentrequest, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(GbudgetUsed, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(GPercentbudgetUsed, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(GbudgetYTD, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(100.00, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(Gselisih, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + JSPFormater.formatNumber(GPercentselisih, "###,###.##"), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);


            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(3);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblContentTotal.addCell(titleCellHeader);

            document.add(tblContentTotal);


            //==============================================================

            int tblApp[] = {21, 5, 21, 5, 21, 5, 21};
            Table tblApp1 = new Table(7);

            tblApp1.setWidth(100);
            tblApp1.setWidths(tblApp);
            tblApp1.setBorderColor(new Color(255, 255, 255));
            tblApp1.setBorderWidth(0);
            tblApp1.setAlignment(0);
            tblApp1.setCellpadding(0);
            tblApp1.setCellspacing(1);

            //==============
            String header0 = "";
            String header1 = "";
            String header2 = "";
            String header3 = "";
            String header4 = "";
            try {
                Approval appHead0 = DbApproval.getListApproval(11, DbApproval.URUTAN_0);
                header0 = appHead0.getKeterangan();
            } catch (Exception e) {
            }

            try {
                Approval appHead1 = DbApproval.getListApproval(11, DbApproval.URUTAN_1);
                header1 = appHead1.getKeterangan();
            } catch (Exception e) {
            }

            try {
                Approval appHead2 = DbApproval.getListApproval(11, DbApproval.URUTAN_2);
                header2 = appHead2.getKeterangan();
            } catch (Exception e) {
            }

            try {
                Approval appHead3 = DbApproval.getListApproval(11, DbApproval.URUTAN_3);
                header3 = appHead3.getKeterangan();
            } catch (Exception e) {
            }

            try {
                Approval appHead4 = DbApproval.getListApproval(11, DbApproval.URUTAN_4);
                header4 = appHead4.getKeterangan();
            } catch (Exception e) {
            }


            String footerPeriksa = "";
            String footerPeriksaJbt = "";

            try {
                User u = DbUser.fetch(br.getApproval2Id());
                Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                footerPeriksa = e.getName();
                footerPeriksaJbt = e.getPosition();
            } catch (Exception e) {
            }

            String footerSetuju = "";
            String footerSetujuJbt = "";
            try {
                Approval approval1 = DbApproval.getListApproval(11, DbApproval.URUTAN_4);
                Employee emp1 = DbEmployee.fetchExc(approval1.getEmployeeId());
                footerSetuju = emp1.getName();
                footerSetujuJbt = approval1.getKeteranganFooter();
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            String user = "";
            String jabatanUser = "";
            try {
                User usr = DbUser.fetch(br.getUserId());
                Employee emp2 = DbEmployee.fetchExc(usr.getEmployeeId());
                user = emp2.getName();
            } catch (Exception ex) {
            }

            String userApprove = "";
            try {
                User usr1 = DbUser.fetch(br.getApproval1Id());
                if (usr1.getEmployeeId() != 0) {
                    Employee emp21 = DbEmployee.fetchExc(usr1.getEmployeeId());
                    userApprove = emp21.getName();
                }
            } catch (Exception ex) {
            }



            titleCellHeader = new Cell(new Chunk(header0 + ", " + JSPFormater.formatDate(br.getTransDate(), "dd-MM-yyyy"), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            //==================================

            titleCellHeader = new Cell(new Chunk("" + header1, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + header2, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + header3, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + header4, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            //=======================================

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            String tglApprove = "";
            if (br.getApproval1Date() != null) {
                tglApprove = String.valueOf(JSPFormater.formatDate(br.getApproval1Date(), "dd-MM-yyyy"));
            }
            titleCellHeader = new Cell(new Chunk("Tanggal : " + tglApprove, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            String tglCheck = "";
            if (br.getApproval2Date() != null) {
                tglCheck = String.valueOf(JSPFormater.formatDate(br.getApproval2Date(), "dd-MM-yyyy"));
            }

            titleCellHeader = new Cell(new Chunk("Tanggal : " + tglCheck, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Tanggal : ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            // ========================================

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("  ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);


            //============================

            titleCellHeader = new Cell(new Chunk("" + user, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + userApprove, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + footerPeriksa, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + footerSetuju, tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            //===============

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + footerPeriksaJbt.toUpperCase(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(" ", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            tblApp1.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + footerSetujuJbt.toUpperCase(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorder(Rectangle.TOP);
            titleCellHeader.setBorderColor(blackColor);
            tblApp1.addCell(titleCellHeader);



            document.add(tblApp1);

        } catch (Exception e) {
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
