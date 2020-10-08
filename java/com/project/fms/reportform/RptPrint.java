/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.reportform;
import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class RptPrint extends Entity {
    
    private int typeReport ;
    private int no ;
    private Date dateReport = new Date();
    private long userId;
    private int typeData ;
    private double realisasiLastYear;
    private double budgetThisYear;
    private double realisasiThisYear;    
    private double percentThisYear;
    private double percentBudgetThisYear;

    public int getTypeReport() {
        return typeReport;
    }

    public void setTypeReport(int typeReport) {
        this.typeReport = typeReport;
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public Date getDateReport() {
        return dateReport;
    }

    public void setDateReport(Date dateReport) {
        this.dateReport = dateReport;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getTypeData() {
        return typeData;
    }

    public void setTypeData(int typeData) {
        this.typeData = typeData;
    }

    public double getRealisasiLastYear() {
        return realisasiLastYear;
    }

    public void setRealisasiLastYear(double realisasiLastYear) {
        this.realisasiLastYear = realisasiLastYear;
    }

    public double getBudgetThisYear() {
        return budgetThisYear;
    }

    public void setBudgetThisYear(double budgetThisYear) {
        this.budgetThisYear = budgetThisYear;
    }

    public double getRealisasiThisYear() {
        return realisasiThisYear;
    }

    public void setRealisasiThisYear(double realisasiThisYear) {
        this.realisasiThisYear = realisasiThisYear;
    }

    public double getPercentThisYear() {
        return percentThisYear;
    }

    public void setPercentThisYear(double percentThisYear) {
        this.percentThisYear = percentThisYear;
    }

    public double getPercentBudgetThisYear() {
        return percentBudgetThisYear;
    }

    public void setPercentBudgetThisYear(double percentBudgetThisYear) {
        this.percentBudgetThisYear = percentBudgetThisYear;
    }
    
    
    

}
