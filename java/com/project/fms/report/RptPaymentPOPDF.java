/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import java.util.*;
//import java.sql.*;
import java.awt.Color;
import java.io.ByteArrayOutputStream;

import javax.servlet.*;
import javax.servlet.http.*;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import com.project.util.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.postransaction.purchase.*;
import com.project.ccs.postransaction.request.*;
import com.project.ccs.report.SessIncomingGoods;
import com.project.ccs.report.SessIncomingGoodsL;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.general.*;
import com.project.util.jsp.JSPRequestValue;

/**
 *
 * @author Roy Andika
 */
public class RptPaymentPOPDF extends HttpServlet {

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
        
        
    }    
}
