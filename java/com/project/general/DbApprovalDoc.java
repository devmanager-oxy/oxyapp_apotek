package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.system.DbSystemProperty;
import com.project.util.lang.I_Language;

public class DbApprovalDoc extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_APPROVAL_DOC = "approval_doc";
    public static final int COL_APPROVAL_DOC_ID = 0;
    public static final int COL_APPROVAL_ID = 1;
    public static final int COL_DOC_ID = 2;
    public static final int COL_STATUS = 3;
    public static final int COL_NOTES = 4;
    public static final int COL_APPROVE_DATE = 5;
    public static final int COL_EMPLOYEE_ID = 6;
    public static final int COL_DOC_TYPE = 7;
    public static final int COL_SEQUENCE = 8;
    public static final int COL_SIGNED = 9;
    
    public static final String[] colNames = {
        "approval_doc_id",
        "approval_id",
        "doc_id",
        "status",
        "notes",
        "approve_date",
        "employee_id",
        "doc_type",
        "sequence",
        "signed"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_BOOL
    };
    public static final int STATUS_DRAFT = 0;
    public static final int STATUS_APPROVED = 1;
    public static final int STATUS_NOT_APPROVED = 2;
    public static final String[] strStatus = {"Draft", "Approved", "Not Approved"};

    public DbApprovalDoc() {
    }

    public DbApprovalDoc(int i) throws CONException {
        super(new DbApprovalDoc());
    }

    public DbApprovalDoc(String sOid) throws CONException {
        super(new DbApprovalDoc(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbApprovalDoc(long lOid) throws CONException {
        super(new DbApprovalDoc(0));
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
        return DB_APPROVAL_DOC;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbApprovalDoc().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ApprovalDoc approvaldoc = fetchExc(ent.getOID());
        ent = (Entity) approvaldoc;
        return approvaldoc.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ApprovalDoc) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ApprovalDoc) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ApprovalDoc fetchExc(long oid) throws CONException {
        try {
            ApprovalDoc approvaldoc = new ApprovalDoc();
            DbApprovalDoc pstApprovalDoc = new DbApprovalDoc(oid);
            approvaldoc.setOID(oid);

            approvaldoc.setApprovalId(pstApprovalDoc.getlong(COL_APPROVAL_ID));
            approvaldoc.setDocId(pstApprovalDoc.getlong(COL_DOC_ID));
            approvaldoc.setStatus(pstApprovalDoc.getInt(COL_STATUS));
            approvaldoc.setNotes(pstApprovalDoc.getString(COL_NOTES));
            approvaldoc.setApproveDate(pstApprovalDoc.getDate(COL_APPROVE_DATE));
            approvaldoc.setEmployeeId(pstApprovalDoc.getlong(COL_EMPLOYEE_ID));
            approvaldoc.setDocType(pstApprovalDoc.getInt(COL_DOC_TYPE));
            approvaldoc.setSequence(pstApprovalDoc.getInt(COL_SEQUENCE));
            approvaldoc.setSigned(pstApprovalDoc.getboolean(COL_SIGNED));

            return approvaldoc;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApprovalDoc(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ApprovalDoc approvaldoc) throws CONException {
        try {
            DbApprovalDoc pstApprovalDoc = new DbApprovalDoc(0);

            pstApprovalDoc.setLong(COL_APPROVAL_ID, approvaldoc.getApprovalId());
            pstApprovalDoc.setLong(COL_DOC_ID, approvaldoc.getDocId());
            pstApprovalDoc.setInt(COL_STATUS, approvaldoc.getStatus());
            pstApprovalDoc.setString(COL_NOTES, approvaldoc.getNotes());
            pstApprovalDoc.setDate(COL_APPROVE_DATE, approvaldoc.getApproveDate());
            pstApprovalDoc.setLong(COL_EMPLOYEE_ID, approvaldoc.getEmployeeId());
            pstApprovalDoc.setInt(COL_DOC_TYPE, approvaldoc.getDocType());
            pstApprovalDoc.setInt(COL_SEQUENCE, approvaldoc.getSequence());
            pstApprovalDoc.setboolean(COL_SIGNED, approvaldoc.isSigned());

            pstApprovalDoc.insert();
            approvaldoc.setOID(pstApprovalDoc.getlong(COL_APPROVAL_DOC_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApprovalDoc(0), CONException.UNKNOWN);
        }
        return approvaldoc.getOID();
    }

    public static long updateExc(ApprovalDoc approvaldoc) throws CONException {
        try {
            if (approvaldoc.getOID() != 0) {
                DbApprovalDoc pstApprovalDoc = new DbApprovalDoc(approvaldoc.getOID());

                pstApprovalDoc.setLong(COL_APPROVAL_ID, approvaldoc.getApprovalId());
                pstApprovalDoc.setLong(COL_DOC_ID, approvaldoc.getDocId());
                pstApprovalDoc.setInt(COL_STATUS, approvaldoc.getStatus());
                pstApprovalDoc.setString(COL_NOTES, approvaldoc.getNotes());
                pstApprovalDoc.setDate(COL_APPROVE_DATE, approvaldoc.getApproveDate());
                pstApprovalDoc.setLong(COL_EMPLOYEE_ID, approvaldoc.getEmployeeId());
                pstApprovalDoc.setInt(COL_DOC_TYPE, approvaldoc.getDocType());
                pstApprovalDoc.setInt(COL_SEQUENCE, approvaldoc.getSequence());
                pstApprovalDoc.setboolean(COL_SIGNED, approvaldoc.isSigned());

                pstApprovalDoc.update();
                return approvaldoc.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApprovalDoc(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbApprovalDoc pstApprovalDoc = new DbApprovalDoc(oid);
            pstApprovalDoc.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApprovalDoc(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_APPROVAL_DOC;
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
                ApprovalDoc approvaldoc = new ApprovalDoc();
                resultToObject(rs, approvaldoc);
                lists.add(approvaldoc);
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

    private static void resultToObject(ResultSet rs, ApprovalDoc approvaldoc) {
        try {
            approvaldoc.setOID(rs.getLong(DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_DOC_ID]));
            approvaldoc.setApprovalId(rs.getLong(DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_ID]));
            approvaldoc.setDocId(rs.getLong(DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID]));
            approvaldoc.setStatus(rs.getInt(DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS]));
            approvaldoc.setNotes(rs.getString(DbApprovalDoc.colNames[DbApprovalDoc.COL_NOTES]));
            approvaldoc.setApproveDate(rs.getDate(DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVE_DATE]));
            approvaldoc.setEmployeeId(rs.getLong(DbApprovalDoc.colNames[DbApprovalDoc.COL_EMPLOYEE_ID]));
            approvaldoc.setDocType(rs.getInt(DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_TYPE]));
            approvaldoc.setSequence(rs.getInt(DbApprovalDoc.colNames[DbApprovalDoc.COL_SEQUENCE]));
            approvaldoc.setSigned(rs.getBoolean(colNames[COL_SIGNED]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long approvalDocId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_APPROVAL_DOC + " WHERE " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_DOC_ID] + " = " + approvalDocId;

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
            String sql = "SELECT COUNT(" + DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_DOC_ID] + ") FROM " + DB_APPROVAL_DOC;
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
                    ApprovalDoc approvaldoc = (ApprovalDoc) list.get(ls);
                    if (oid == approvaldoc.getOID()) {
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

    public static void initiateApprovalDetail(int type, long docId, double totalAmount, long userId) {

        //delete semua approval pada id ini dulu
        deleteApprovalByDocId(docId);

        String str = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");

        if (str.equalsIgnoreCase("Y")) {

            User user = new User();
            try {
                user = DbUser.fetch(userId);
            } catch (Exception e) {
            }

            String where = DbApproval.colNames[DbApproval.COL_TYPE] + "=" + type +
                    " and " + DbApproval.colNames[DbApproval.COL_URUTAN_APPROVAL] + ">0";

            Vector temp = DbApproval.list(0, 0, where, DbApproval.colNames[DbApproval.COL_URUTAN_APPROVAL]);

            if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    Approval ap = (Approval) temp.get(i);

                    boolean ok = false;
                    if (ap.getJumlahDari() == 0) {
                        ok = true;
                    } else if (ap.getJumlahDari() <= totalAmount) {
                        ok = true;
                    }

                    if (ok) {
                        ApprovalDoc apd = new ApprovalDoc();
                        apd.setApprovalId(ap.getOID());
                        apd.setSequence(ap.getUrutanApproval());
                        apd.setDocId(docId);
                        apd.setDocType(type);
                        
                        if (i == 0) {
                            apd.setEmployeeId(user.getEmployeeId());
                            apd.setApproveDate(new Date());
                            apd.setStatus(STATUS_APPROVED);
                            apd.setSigned(true); //always true if it is signed, even though accepted or rejected
                        } else {
                            apd.setEmployeeId(ap.getEmployeeId());
                            apd.setStatus(STATUS_DRAFT);
                        }

                        try {
                            DbApprovalDoc.insertExc(apd);
                        } catch (Exception e) {
                        }
                    }
                }
            }
        }
    }

    public static void deleteApprovalByDocId(long docId) {
        try {
            CONHandler.execUpdate("delete from " + DB_APPROVAL_DOC + " where " + colNames[COL_DOC_ID] + "=" + docId);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
    public static Vector getDocApproval(long docId) {
        Vector temp = list(0, 0, colNames[COL_DOC_ID] + "=" + docId, colNames[COL_SEQUENCE]);
        Vector temp1 = new Vector();
        if (temp != null && temp.size() > 0) {
            int tempSeg = -1;
            for (int i = 0; i < temp.size(); i++) {
                ApprovalDoc apd = (ApprovalDoc) temp.get(i);
                if (apd.getSequence() != tempSeg) {
                    temp1.add(apd);
                }
                tempSeg = apd.getSequence();
            }
        }

        if (temp1 != null && temp1.size() > 0) {
            for (int i = 0; i < temp1.size(); i++) {
                ApprovalDoc apd = (ApprovalDoc) temp1.get(i);
                String where = colNames[COL_DOC_ID] + "=" + apd.getDocId() + " and " +
                        colNames[COL_SEQUENCE] + "=" + apd.getSequence() + " and " +
                        colNames[COL_STATUS] + "=" + STATUS_APPROVED;

                Vector v = list(0, 1, where, "");
                if (v != null && v.size() > 0) {
                    ApprovalDoc apdx = (ApprovalDoc) v.get(0);
                    temp1.set(i, apdx);
                }
            }
        }

        return temp1;
    }

    /**
     * update by gwawan 2012
     */
    public static boolean isPostingReady(long docId) {
        Vector vApprovalDoc = getDocApproval(docId);
        boolean isReady = false;
        
        if (vApprovalDoc != null && vApprovalDoc.size() > 0) {
            for (int i = 0; i < vApprovalDoc.size(); i++) {
                ApprovalDoc apd = (ApprovalDoc) vApprovalDoc.get(i);
                if(apd.getStatus() == STATUS_APPROVED) isReady = true;
                else return false;
            }
        }
        return isReady;
    }

    public static void approveDoc(long docId, long userId, int status, String notes) {

        User user = new User();
        try {
            user = DbUser.fetch(userId);
        } catch (Exception e) {

        }

        String where = colNames[COL_EMPLOYEE_ID] + "=" + user.getEmployeeId() +
                " and  " + colNames[COL_DOC_ID] + "=" + docId;

        Vector temp = list(0, 1, where, "");

        if (temp != null && temp.size() > 0) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(0);

            apd.setStatus(status);
            apd.setApproveDate(new Date());
            apd.setNotes(notes);

            try {
                long oid = DbApprovalDoc.updateExc(apd);

                //jika calcel ke draft	
                if (oid != 0 && status == STATUS_DRAFT) {
                    where = colNames[COL_DOC_ID] + "=" + docId + " and " + colNames[COL_SEQUENCE] + ">" + apd.getSequence();
                    temp = list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        for (int i = 0; i < temp.size(); i++) {

                            ApprovalDoc apd1 = (ApprovalDoc) temp.get(i);
                            apd1.setStatus(STATUS_DRAFT);
                            apd1.setNotes("");

                            DbApprovalDoc.updateExc(apd1);
                        }
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    public static void approveDoc(long approvalDocId, User user, int status, String notes) {
        ApprovalDoc apd = new ApprovalDoc();
        
        try {
            apd = DbApprovalDoc.fetchExc(approvalDocId);
        } catch (Exception e) {
        }

        apd.setStatus(status);
        apd.setApproveDate(new Date());
        apd.setNotes(notes);
        apd.setEmployeeId(user.getEmployeeId());
        apd.setSigned(true); //always true if it is signed, even though accepted or rejected

        try {
            long oid = DbApprovalDoc.updateExc(apd);

            //jika calcel ke draft	
            if (oid != 0 && status == STATUS_DRAFT) {
                String where = colNames[COL_DOC_ID] + "=" + apd.getDocId() + " and " + colNames[COL_SEQUENCE] + ">" + apd.getSequence();
                Vector temp = list(0, 0, where, "");

                if (temp != null && temp.size() > 0) {
                    for (int i = 0; i < temp.size(); i++) {

                        ApprovalDoc apd1 = (ApprovalDoc) temp.get(i);
                        apd1.setStatus(STATUS_DRAFT);
                        apd1.setNotes("");

                        DbApprovalDoc.updateExc(apd1);

                    }
                }
            }
        } catch (Exception e) {
        }
    }

    public static Vector getDocumentByUser(User user) {

        Vector result = new Vector();
        Employee emp = new Employee();
        
        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }

        String sql = " select * from " + DB_APPROVAL_DOC +
                " apd inner join " + DbEmployee.CON_EMPLOYEE +
                " emp on emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] +
                " = apd." + colNames[COL_EMPLOYEE_ID] +
                " where emp." + DbEmployee.colNames[DbEmployee.COL_POSITION] + "='" + emp.getPosition() + "' and " +
                " emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " = " + emp.getOID();

        String where = " and apd." + colNames[COL_STATUS] + "=" + STATUS_DRAFT;

        for (int i = 0; i < I_Project.approvalTypeStr.length; i++) {
            String wherex = where + " and apd." + colNames[COL_DOC_TYPE] + "=" + i;
            String sqlx = sql + wherex;
            Vector temp = new Vector();
            CONResultSet crs = null;
            
            try {
                crs = CONHandler.execQueryResult(sqlx);
                ResultSet rs = crs.getResultSet();
                
                while (rs.next()) {
                    ApprovalDoc apdx = new ApprovalDoc();
                    resultToObject(rs, apdx);
                    temp.add(apdx);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

            if (temp != null && temp.size() > 0) {
                Vector temp1 = new Vector();

                for (int x = 0; x < temp.size(); x++) {
                    ApprovalDoc apd = (ApprovalDoc) temp.get(x);
                    boolean isOpen = checkUserSequence(apd);
                    if (isOpen) {
                        temp1.add(apd);
                    }
                }

                if (temp1 != null && temp1.size() > 0) {
                    Vector store = new Vector();
                    store.add("" + i);
                    store.add(temp1);

                    result.add(store);
                }
            }
        }

        return result;
    }

    public static Vector getArsipDocumentByUser(User user, int status) {

        Vector result = new Vector();
        String where = colNames[COL_EMPLOYEE_ID] + "=" + user.getEmployeeId() + " and " + colNames[COL_STATUS] + "=" + status;

        for (int i = 0; i < I_Project.approvalTypeStr.length; i++) {
            String wherex = where + " and " + colNames[COL_DOC_TYPE] + "=" + i;
            Vector temp = list(0, 0, wherex, colNames[COL_APPROVAL_DOC_ID]);
            
            if (temp != null && temp.size() > 0) {
                Vector store = new Vector();
                store.add("" + i);
                store.add(temp);
                result.add(store);
            }
        }

        return result;
    }

    //cek apakah pada dokumen, user sudah boleh approve, approver sebelumnya
    //sudah approve
    public static boolean checkUserSequence(ApprovalDoc apd) {

        //handle untuk approval pada level yang sama tapi user berbeda
        //misal akunting ada 2 orang, level sama. maka dokumen tidak boleh approve lagi oleh 
        //user lain yang levelnya sama

        String where = colNames[COL_DOC_ID] + "=" + apd.getDocId() + " and " + colNames[COL_STATUS] + "=" + STATUS_APPROVED +
                " and " + colNames[COL_SEQUENCE] + "=" + apd.getSequence();

        //sudah ada yang approve		
        if (getCount(where) > 0) {
            return false;
        } //jika belum ada yang approve	
        else {

            //jika urutan pertama
            if (apd.getSequence() == 0) {
                return true;
            } //
            else {

                boolean result = false;
                boolean ok = false;

                int idxS = apd.getSequence() - 1;

                while (!ok) {
                    where = colNames[COL_DOC_ID] + "=" + apd.getDocId() +
                            " and " + colNames[COL_SEQUENCE] + "=" + idxS;

                    Vector tempX = list(0, 0, where, "");
                    if (tempX != null && tempX.size() > 0) {
                        for (int xx = 0; xx < tempX.size(); xx++) {
                            ApprovalDoc apdX = (ApprovalDoc) tempX.get(xx);
                            if (apdX.getStatus() == STATUS_APPROVED) {
                                result = true;
                                break;
                            }
                        }
                        ok = true;
                    } else {
                        idxS = idxS - 1;
                        //paksa berhenti	
                        if (idxS < 0) {
                            ok = true;
                        }
                    }

                }

                return result;
            }
        }
    }

    public static boolean isEditable(boolean isPosted, ApprovalDoc apd, User user) {

        if (!isPosted && apd.getEmployeeId() == user.getEmployeeId()) {
            String where = colNames[COL_DOC_ID] + "=" + apd.getDocId() +
                    " and " + colNames[COL_SEQUENCE] + "=" + (apd.getSequence() + 1);
            Vector temp = list(0, 0, where, "");

            //jika ada cek statusnya	
            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {
                    ApprovalDoc apdx = (ApprovalDoc) temp.get(i);

                    //jika salah satu saja approved return ga editable
                    if (apdx.getStatus() == STATUS_APPROVED) {
                        return false;
                    }
                }
                return true;
            } //jika tidak ada level diatasnya maka editable
            else {
                return true;
            }
        }

        return false;
    }

    public static Vector listDocCancel(User user) {
        try {
            Employee emp = new Employee();
            try {
                emp = DbEmployee.fetchExc(user.getEmployeeId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            Vector result = new Vector();

            for (int i = 0; i < I_Project.approvalTypeStr.length; i++) {

                String sql = "select distinct doc.* from " + DbApprovalDoc.DB_APPROVAL_DOC + " doc ";

                sql = sql + " where " + DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_TYPE] + " = " + i + " and " +
                        DbApprovalDoc.colNames[DbApprovalDoc.COL_EMPLOYEE_ID] + " = " + emp.getOID() + " and " + DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + STATUS_APPROVED + " and " +
                        DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " in ( select " + DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " FROM " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                        DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + STATUS_NOT_APPROVED + " ) ";

                CONResultSet crs = null;
                Vector temp = new Vector();

                try {
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    while (rs.next()) {
                        ApprovalDoc apdx = new ApprovalDoc();
                        resultToObject(rs, apdx);
                        temp.add(apdx);
                    }

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                } finally {
                    CONResultSet.close(crs);
                }

                if (temp != null && temp.size() > 0) {
                    Vector store = new Vector();
                    store.add("" + i);
                    store.add(temp);
                    result.add(store);
                }
            }

            return result;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return null;
    }

    public static ApprovalDoc listPersonCancel(long docId) {

        CONResultSet crs = null;
        try {

            String sql = "select * from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + STATUS_NOT_APPROVED;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {

                ApprovalDoc apdx = new ApprovalDoc();
                resultToObject(rs, apdx);
                return apdx;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static int listTotalDocCancel(long docId) {
        CONResultSet crs = null;

        try {
            String sql = "select count(" + DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_DOC_ID] + ") from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " + DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + STATUS_NOT_APPROVED;

            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    int sum = rs.getInt(1);
                    return sum;
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return 0;
    }

    public static int listTotalDocDraft(long docId) {
        CONResultSet crs = null;

        try {
            String sql = "select count(" + DbApprovalDoc.colNames[DbApprovalDoc.COL_APPROVAL_DOC_ID] + ") from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " + DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + STATUS_DRAFT;

            try {

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    int sum = rs.getInt(1);
                    return sum;
                }

            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return 0;
    }

    public static ApprovalDoc listAppIdx1(long docId) {
        CONResultSet crs = null;
        
        try {
            String sql = "select * from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_SEQUENCE] + " = 1";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ApprovalDoc apdx = new ApprovalDoc();
                resultToObject(rs, apdx);
                return apdx;
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return new ApprovalDoc();
    }

    /**
     * Untuk mereset approval
     */
    public static void resetApproval(int type, long docId) {
        CONResultSet crs = null;

        try {
            String sql = "delete from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_TYPE] + " = " + type;

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }

    //select * from approval_doc where doc_id = 504404484358973379 and status = 1 order by sequence desc ;  
    public static ApprovalDoc lastApp(long docId) {
        CONResultSet crs = null;
        
        try {
            String sql = "select * from " + DbApprovalDoc.DB_APPROVAL_DOC + " where " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_DOC_ID] + " = " + docId + " and " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_STATUS] + " = " + DbApprovalDoc.STATUS_APPROVED + " order by " +
                    DbApprovalDoc.colNames[DbApprovalDoc.COL_SEQUENCE] + " desc";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ApprovalDoc apdx = new ApprovalDoc();
                resultToObject(rs, apdx);
                return apdx;
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }
}
