/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.io.Writer;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.fms.activity.DbModuleBudget;
import com.project.fms.activity.ModuleBudget;
import com.project.general.Company;
import com.project.general.DbCompany;

/**
 *
 * @author Roy Andika
 */
public class RptAnggaranXLS extends HttpServlet {

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
        int lang = 0;

        Vector listVectorAll = new Vector();
        Vector listVector = new Vector();
        int loopMonth = 0;
        String tahun = "";
        
        try {
            HttpSession session = request.getSession();
            listVectorAll = (Vector) session.getValue("LIST_REPORT_ANGGARAN");
            loopMonth = Integer.parseInt((String) listVectorAll.get(0));
            listVector = (Vector) listVectorAll.get(1);
            tahun = (String)session.getValue("SEARCH_PARAMETER");
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

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

        wb.println("      <?xml version=\"1.0\"?>");
        wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>PNCI</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2013-11-12T07:04:37Z</Created>");
        wb.println("      <Company>PNCI</Company>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8895</WindowHeight>");
        wb.println("      <WindowWidth>18975</WindowWidth>");
        wb.println("      <WindowTopX>120</WindowTopX>");
        wb.println("      <WindowTopY>120</WindowTopY>");
        wb.println("      <ProtectStructure>False</ProtectStructure>");
        wb.println("      <ProtectWindows>False</ProtectWindows>");
        wb.println("      </ExcelWorkbook>");
        wb.println("      <Styles>");
        wb.println("      <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m73973984\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"mmm\\-yy\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Alignment ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s115\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s120\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:Width=\"95.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"113.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"99\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"111\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"121.5\"/>");
        wb.println("      <Column ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"70.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"73.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s120\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s120\"><Data ss:Type=\"String\">LAPORAN ANGGARAN "+tahun.toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"5\">");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Nomor Kegiatan</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Nama Kegiatan</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Anggaran</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">COA</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Anggaran "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Dipakai s/d Dec "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Selisih</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Jan "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Feb "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Mar "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Apr "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Mei "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Jun "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Jul "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Agu "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">Sep "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Okt "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Nop "+tahun+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Des "+tahun+"</Data></Cell>");
        wb.println("      </Row>");

        String header02 = "";
        String strData01 = "";
        String strData02 = "";
        boolean statusSubTotal = false;

        double totAnggaran = 0;
        double totDiPakai = 0;
        double totSelisih = 0;
        double totMonth[] = new double[20];

        double anggaran = 0;
        double diPakai = 0;
        double selisih = 0;
        double month[] = new double[20];

        if (listVector != null && listVector.size() > 0) {
            for (int i = 0; i < listVector.size(); i++) {
                Vector vecDetail = (Vector) listVector.get(i);
                statusSubTotal = false;
                if (header02.equals((String) vecDetail.get(1))) {
                    strData01 = "";
                    strData02 = "";
                } else {
                    strData01 = (String) vecDetail.get(0);
                    strData02 = (String) vecDetail.get(1);
                    header02 = (String) vecDetail.get(1);
                    if (i > 0) {
                        statusSubTotal = true;
                    }
                }
                
                String description = "";
            long mbId = 0;
            long cId = 0;
            double anggaranx = 0;
            
            try{
                mbId = Long.parseLong(""+vecDetail.get(6));
            }catch(Exception e){}
            
            try{
                cId = Long.parseLong(""+vecDetail.get(7));
            }catch(Exception e){}
            Vector vMB = DbModuleBudget.list(0, 0, DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]+" = "+mbId+" and "+DbModuleBudget.colNames[DbModuleBudget.COL_COA_ID]+"="+cId, null);            
            
            if(vMB != null && vMB.size() > 0){
                for(int t = 0;t < vMB.size();t++){                    
                    ModuleBudget mb = (ModuleBudget)vMB.get(t);
                    if(description != null && description.length() > 0){
                        description = description+"&#10;";
                    }
                    description = description+mb.getDescription();
                    anggaranx = anggaranx + mb.getAmount(); 
                }
            }
                
                if (statusSubTotal) {
                    wb.println("      <Row ss:StyleID=\"s75\">");
                    wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m73973984\"><Data ss:Type=\"String\">SUB TOTAL</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + anggaran + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + diPakai + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + selisih + "</Data></Cell>");
                    for (int n = 0; n < loopMonth; n++) {
                        wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + month[n] + "</Data></Cell>");
                    }
                    wb.println("      </Row>");
                    anggaran = 0;
                    diPakai = 0;
                    selisih = 0;
                    for (int n = 0; n < loopMonth; n++) {
                        month[n] = 0;
                    }
                }

                double tmpAnggaran = 0;
                double tmpDipakai = 0;
                double tmpSelisih = 0;

                try {
                    tmpAnggaran = anggaranx;
                    anggaran = anggaran + tmpAnggaran;
                    totAnggaran = totAnggaran + tmpAnggaran;
                } catch (Exception e) {
                }

                try {
                    tmpDipakai = Double.parseDouble((String) vecDetail.get(loopMonth + 8));
                    diPakai = diPakai + tmpDipakai;
                    totDiPakai = totDiPakai + tmpDipakai;
                } catch (Exception e) {
                }

                try {
                    tmpSelisih = tmpAnggaran - tmpDipakai;
                    selisih = selisih + tmpSelisih;
                    totSelisih = totSelisih + tmpSelisih;
                } catch (Exception e) {
                }


                for (int n = 0; n < loopMonth; n++) {
                    month[n] = month[n] + Double.parseDouble((String) vecDetail.get(8 + n));
                    totMonth[n] = totMonth[n] + Double.parseDouble((String) vecDetail.get(8 + n));
                }

                wb.println("      <Row ss:Height=\"90\" ss:StyleID=\"s75\">");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">" + strData01 + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\">" + strData02 + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\">" + description + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\">" + vecDetail.get(3) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + tmpAnggaran + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + tmpDipakai + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + tmpSelisih + "</Data></Cell>");
                for (int p = 0; p < loopMonth; p++) {
                    wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"Number\">" + Double.parseDouble((String) vecDetail.get(8 + p)) + "</Data></Cell>");
                }
                wb.println("      </Row>");
            }
            wb.println("      <Row ss:StyleID=\"s75\">");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m73973984\"><Data ss:Type=\"String\">SUB TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + anggaran + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + diPakai + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + selisih + "</Data></Cell>");
            for (int n = 0; n < loopMonth; n++) {
                wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + month[n] + "</Data></Cell>");
            }
            wb.println("      </Row>");
            anggaran = 0;
            diPakai = 0;
            selisih = 0;
            for (int n = 0; n < loopMonth; n++) {
                month[n] = 0;
            }

            wb.println("      <Row ss:StyleID=\"s75\">");
            wb.println("      <Cell ss:StyleID=\"s114\"/>");
            wb.println("      <Cell ss:StyleID=\"s114\"/>");
            wb.println("      <Cell ss:StyleID=\"s114\"/>");
            wb.println("      <Cell ss:StyleID=\"s114\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      <Cell ss:StyleID=\"s115\"/>");
            wb.println("      </Row>");

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s72\"><Data ss:Type=\"String\">TOTAL KESELURUHAN</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + totAnggaran + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + totDiPakai + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + totSelisih + "</Data></Cell>");
            for (int o = 0; o < loopMonth; o++) {
                wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + totMonth[o] + "</Data></Cell>");
            }
            wb.println("      </Row>");

        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>6</ActiveRow>");
        wb.println("      <ActiveCol>5</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet3\">");
        wb.println("      <Table >");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      </Workbook>");
        wb.println("      ");

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
            String str = "";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
