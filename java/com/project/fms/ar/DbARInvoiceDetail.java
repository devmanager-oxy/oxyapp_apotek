package com.project.fms.ar;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.crm.*;
import com.project.crm.project.DbProjectTerm;
import com.project.crm.project.Project;
import com.project.crm.project.ProjectTerm;

public class DbARInvoiceDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String TBL_AR_INVOICE_DETAIL = "ar_invoice_detail";
    public static final int COL_AR_INVOICE_ID = 0;
    public static final int COL_AR_INVOICE_DETAIL_ID = 1;
    public static final int COL_ITEM_NAME = 2;
    public static final int COL_COA_ID = 3;
    public static final int COL_QTY = 4;
    public static final int COL_PRICE = 5;
    public static final int COL_DISCOUNT = 6;
    public static final int COL_TOTAL_AMOUNT = 7;
    public static final int COL_DEPARTMENT_ID = 8;
    public static final int COL_COMPANY_ID = 9;
    public static final int COL_MEMO = 10;
    public static final String[] colNames = {
        "ar_invoice_id",
        "ar_invoice_detail_id",
        "item_name",
        "coa_id",
        "qty",
        "price",
        "discount",
        "total_amount",
        "department_id",
        "company_id",
        "memo"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public DbARInvoiceDetail() {
    }

    public DbARInvoiceDetail(int i) throws CONException {
        super(new DbARInvoiceDetail());
    }

    public DbARInvoiceDetail(String sOid) throws CONException {
        super(new DbARInvoiceDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbARInvoiceDetail(long lOid) throws CONException {
        super(new DbARInvoiceDetail(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return TBL_AR_INVOICE_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbARInvoiceDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ARInvoiceDetail arinvoicedetail = fetchExc(ent.getOID());
        ent = (Entity) arinvoicedetail;
        return arinvoicedetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ARInvoiceDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ARInvoiceDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ARInvoiceDetail fetchExc(long oid) throws CONException {
        try {
            ARInvoiceDetail arinvoicedetail = new ARInvoiceDetail();
            DbARInvoiceDetail pstARInvoiceDetail = new DbARInvoiceDetail(oid);
            arinvoicedetail.setOID(oid);

            arinvoicedetail.setArInvoiceId(pstARInvoiceDetail.getlong(COL_AR_INVOICE_ID));
            arinvoicedetail.setItemName(pstARInvoiceDetail.getString(COL_ITEM_NAME));
            arinvoicedetail.setCoaId(pstARInvoiceDetail.getlong(COL_COA_ID));
            arinvoicedetail.setQty(pstARInvoiceDetail.getInt(COL_QTY));
            arinvoicedetail.setPrice(pstARInvoiceDetail.getdouble(COL_PRICE));
            arinvoicedetail.setDiscount(pstARInvoiceDetail.getdouble(COL_DISCOUNT));
            arinvoicedetail.setTotalAmount(pstARInvoiceDetail.getdouble(COL_TOTAL_AMOUNT));
            arinvoicedetail.setDepartmentId(pstARInvoiceDetail.getlong(COL_DEPARTMENT_ID));
            arinvoicedetail.setCompanyId(pstARInvoiceDetail.getlong(COL_COMPANY_ID));
            arinvoicedetail.setMemo(pstARInvoiceDetail.getString(COL_MEMO));

            return arinvoicedetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoiceDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ARInvoiceDetail arinvoicedetail) throws CONException {
        try {
            DbARInvoiceDetail pstARInvoiceDetail = new DbARInvoiceDetail(0);

            pstARInvoiceDetail.setLong(COL_AR_INVOICE_ID, arinvoicedetail.getArInvoiceId());
            pstARInvoiceDetail.setString(COL_ITEM_NAME, arinvoicedetail.getItemName());
            pstARInvoiceDetail.setLong(COL_COA_ID, arinvoicedetail.getCoaId());
            pstARInvoiceDetail.setInt(COL_QTY, arinvoicedetail.getQty());
            pstARInvoiceDetail.setDouble(COL_PRICE, arinvoicedetail.getPrice());
            pstARInvoiceDetail.setDouble(COL_DISCOUNT, arinvoicedetail.getDiscount());
            pstARInvoiceDetail.setDouble(COL_TOTAL_AMOUNT, arinvoicedetail.getTotalAmount());
            pstARInvoiceDetail.setLong(COL_DEPARTMENT_ID, arinvoicedetail.getDepartmentId());
            pstARInvoiceDetail.setLong(COL_COMPANY_ID, arinvoicedetail.getCompanyId());
            pstARInvoiceDetail.setString(COL_MEMO, arinvoicedetail.getMemo());

            pstARInvoiceDetail.insert();
            arinvoicedetail.setOID(pstARInvoiceDetail.getlong(COL_AR_INVOICE_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoiceDetail(0), CONException.UNKNOWN);
        }
        return arinvoicedetail.getOID();
    }

    public static long updateExc(ARInvoiceDetail arinvoicedetail) throws CONException {
        try {
            if (arinvoicedetail.getOID() != 0) {
                DbARInvoiceDetail pstARInvoiceDetail = new DbARInvoiceDetail(arinvoicedetail.getOID());

                pstARInvoiceDetail.setLong(COL_AR_INVOICE_ID, arinvoicedetail.getArInvoiceId());
                pstARInvoiceDetail.setString(COL_ITEM_NAME, arinvoicedetail.getItemName());
                pstARInvoiceDetail.setLong(COL_COA_ID, arinvoicedetail.getCoaId());
                pstARInvoiceDetail.setInt(COL_QTY, arinvoicedetail.getQty());
                pstARInvoiceDetail.setDouble(COL_PRICE, arinvoicedetail.getPrice());
                pstARInvoiceDetail.setDouble(COL_DISCOUNT, arinvoicedetail.getDiscount());
                pstARInvoiceDetail.setDouble(COL_TOTAL_AMOUNT, arinvoicedetail.getTotalAmount());
                pstARInvoiceDetail.setLong(COL_DEPARTMENT_ID, arinvoicedetail.getDepartmentId());
                pstARInvoiceDetail.setLong(COL_COMPANY_ID, arinvoicedetail.getCompanyId());
                pstARInvoiceDetail.setString(COL_MEMO, arinvoicedetail.getMemo());

                pstARInvoiceDetail.update();
                return arinvoicedetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoiceDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbARInvoiceDetail pstARInvoiceDetail = new DbARInvoiceDetail(oid);
            pstARInvoiceDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoiceDetail(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_AR_INVOICE_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ARInvoiceDetail arinvoicedetail = new ARInvoiceDetail();
                resultToObject(rs, arinvoicedetail);
                lists.add(arinvoicedetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, ARInvoiceDetail arinvoicedetail) {
        try {
            arinvoicedetail.setOID(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_DETAIL_ID]));
            arinvoicedetail.setArInvoiceId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID]));
            arinvoicedetail.setItemName(rs.getString(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_ITEM_NAME]));
            arinvoicedetail.setCoaId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_COA_ID]));
            arinvoicedetail.setQty(rs.getInt(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_QTY]));
            arinvoicedetail.setPrice(rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_PRICE]));
            arinvoicedetail.setDiscount(rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_DISCOUNT]));
            arinvoicedetail.setTotalAmount(rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT]));
            arinvoicedetail.setDepartmentId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_DEPARTMENT_ID]));
            arinvoicedetail.setCompanyId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_COMPANY_ID]));
            arinvoicedetail.setMemo(rs.getString(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_MEMO]));

        } catch (Exception e) {
        }
    }
    
    public static Vector list(String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_AR_INVOICE_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
        
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ARInvoiceDetail arinvoicedetail = new ARInvoiceDetail();
                resultToObjectx(rs, arinvoicedetail);
                lists.add(arinvoicedetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    
    private static void resultToObjectx(ResultSet rs, ARInvoiceDetail arinvoicedetail) {
        try {
            arinvoicedetail.setOID(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_DETAIL_ID]));
            arinvoicedetail.setArInvoiceId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID]));
            arinvoicedetail.setItemName(rs.getString(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_ITEM_NAME]));
            arinvoicedetail.setCoaId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_COA_ID]));
            arinvoicedetail.setQty(rs.getInt(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_QTY]));
            double amount = rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT]);
            if(amount != 0){
                arinvoicedetail.setPrice(-1 * rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT]));            
                arinvoicedetail.setTotalAmount(-1 * rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT]));
            }  
            
            arinvoicedetail.setDiscount(rs.getDouble(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_DISCOUNT]));
            arinvoicedetail.setDepartmentId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_DEPARTMENT_ID]));
            arinvoicedetail.setCompanyId(rs.getLong(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_COMPANY_ID]));
            arinvoicedetail.setMemo(rs.getString(DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_MEMO]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long arInvoiceId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_AR_INVOICE_DETAIL + " WHERE " +
                    DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID] + " = " + arInvoiceId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID] + ") FROM " + TBL_AR_INVOICE_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    ARInvoiceDetail arinvoicedetail = (ARInvoiceDetail) list.get(ls);
                    if (oid == arinvoicedetail.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    public static ARInvoiceDetail executeDetailData(ARInvoice arInvoice, Project project, ProjectTerm projectTerm, String detailDesc) {

        Vector v = list(0, 1, DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + "=" + arInvoice.getOID(), "");

        ARInvoiceDetail ard = new ARInvoiceDetail();

        //update
        if (v != null && v.size() > 0) {

            ard = (ARInvoiceDetail) v.get(0);

            try {
                ard = DbARInvoiceDetail.fetchExc(ard.getOID());

                ard.setArInvoiceId(arInvoice.getOID());
                ard.setItemName(detailDesc);
                //ard.setCompanyId(projectTerm.getCurrencyId());
                ard.setQty(1);
                ard.setPrice(projectTerm.getAmount());
                ard.setTotalAmount(projectTerm.getAmount());
                ard.setCompanyId(arInvoice.getCompanyId());

                DbARInvoiceDetail.updateExc(ard);

            } catch (Exception e) {
            }

        } //add
        else {
            ard = new ARInvoiceDetail();

            ard.setArInvoiceId(arInvoice.getOID());
            ard.setItemName(detailDesc);
            //ard.setCurrencyId(projectTerm.getCurrencyId());
            ard.setQty(1);
            ard.setPrice(projectTerm.getAmount());
            ard.setTotalAmount(projectTerm.getAmount());
            ard.setCompanyId(arInvoice.getCompanyId());

            try {
                DbARInvoiceDetail.insertExc(ard);
            } catch (Exception e) {
            }
        }

        //update term status
        if (ard.getOID() > 0) {
            try {
                projectTerm = DbProjectTerm.fetchExc(projectTerm.getOID());
                projectTerm.setStatus(I_Crm.TERM_STATUS_INVOICED);
                DbProjectTerm.updateExc(projectTerm);
            } catch (Exception e) {

            }
        }

        return ard;
    }

    public static double getTotalAmount(long arInvoiceId) {

        String sql = "select sum(" + colNames[COL_TOTAL_AMOUNT] + ") from " + TBL_AR_INVOICE_DETAIL + " where " + colNames[COL_AR_INVOICE_ID] + "=" + arInvoiceId;

        double result = 0;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static void insertARItem(long arInvoiceId,Vector vARInvoiceItem){
        if(arInvoiceId != 0){
            try{                
                deleteAllItem(arInvoiceId);    
                double total = 0;
                if(vARInvoiceItem != null && vARInvoiceItem.size() > 0){                    
                    for(int i = 0; i < vARInvoiceItem.size(); i++){  
                        ARInvoiceDetail ri = (ARInvoiceDetail)vARInvoiceItem.get(i);   
                        total = total + ri.getTotalAmount();
                        ri.setArInvoiceId(arInvoiceId);
                        long oid = DbARInvoiceDetail.insertExc(ri);
                        updateAmount(oid,ri.getTotalAmount());
                    }
                }                
                try{
                    ARInvoice arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                    total = total * -1;
                    arInvoice.setTotal(total);
                    DbARInvoice.updateExc(arInvoice);
                }catch(Exception e){}
            }catch(Exception e){
                System.out.print(e);
            }
        }
    }
    
    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM " + TBL_AR_INVOICE_DETAIL +
                    " WHERE " + colNames[COL_AR_INVOICE_ID] + "=" + oidMain;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoiceDetail(0), CONException.UNKNOWN);
        }
        return oidMain;
    }
    
    
    public static void updateAmount(long arInvoiceDetailId,double amount){
        CONResultSet dbrs = null;
        
        try{
            double x = amount * -1;
            
            String sql = "UPDATE "+DbARInvoiceDetail.TBL_AR_INVOICE_DETAIL+" set "+DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_PRICE]+" = "+x+","+
                    DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT]+" = "+x+" where "+DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_DETAIL_ID]+" = "+arInvoiceDetailId;
            
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){
            System.out.println("Exception");
        }finally{
            CONResultSet.close(dbrs);
        }
    }
    
}

