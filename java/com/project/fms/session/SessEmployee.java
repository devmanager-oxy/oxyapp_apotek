/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.admin.DbUser;
import java.io.*;

import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.payroll.DbEmployee;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class SessEmployee {

    public static Vector listNameEmployee(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select " + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " as employee_id," +
                    DbEmployee.colNames[DbEmployee.COL_NAME] + " as name from " + DbEmployee.CON_EMPLOYEE;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Emp emp = new Emp();
                emp.setEmployeeId(rs.getLong("employee_id"));
                emp.setName(rs.getString("name"));
                lists.add(emp);
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

    public static Vector listUser(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select " + DbUser.colNames[DbUser.COL_USER_ID] + " as user_id," +
                    DbUser.colNames[DbUser.COL_LOGIN_ID] + " as login_id," +
                    DbUser.colNames[DbUser.COL_PASSWORD] + " as password," +
                    DbUser.colNames[DbUser.COL_USER_KEY] + " as user_key," +
                    DbUser.colNames[DbUser.COL_EMPLOYEE_ID] + " as employee_id," +
                    DbUser.colNames[DbUser.COL_REG_DATE] + " as reg_date, " +
                    DbUser.colNames[DbUser.COL_LAST_LOGIN_DATE] + " as last_login, " +
                    DbUser.colNames[DbUser.COL_UPDATE_DATE] + " as update_date, " +
                    DbUser.colNames[DbUser.COL_DESCRIPTION] + " as description, " +
                    DbUser.colNames[DbUser.COL_USER_STATUS] + " as status, " +
                    DbUser.colNames[DbUser.COL_USER_LEVEL] + " as level " +
                    " from " + DbUser.DB_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SysUser sUser = new SysUser();
                sUser.setUserId(rs.getLong("user_id"));
                sUser.setEmployeeId(rs.getLong("employee_id"));
                sUser.setLoginId(rs.getString("login_id"));
                sUser.setPassword(rs.getString("password"));                
                sUser.setRegDate(rs.getDate("reg_date"));
                //Date updateDate = CONHandler.convertDate(rs.getDate("update_date"), rs.getTime("update_date"));
                sUser.setUpdateDate(rs.getDate("update_date"));
                sUser.setUserKey(rs.getString("user_key"));
                Date lastDate = CONHandler.convertDate(rs.getDate("last_login"), rs.getTime("last_login"));
                sUser.setLastLogin(lastDate);
                sUser.setDescription(rs.getString("description"));
                sUser.setStatus(rs.getInt("status"));
                sUser.setLevel(rs.getInt("level"));
                lists.add(sUser);
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
}
