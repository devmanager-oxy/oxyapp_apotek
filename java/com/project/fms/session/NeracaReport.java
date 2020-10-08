/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

/**
 *
 * @author Roy
 */
public class NeracaReport {

    private int no = 0;
    private String description = "";
    private double lastYear = 0;
    private double thisYear = 0;
    private boolean isBold = false;
    private String level = "";
    private int coaLevel = 0;

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getLastYear() {
        return lastYear;
    }

    public void setLastYear(double lastYear) {
        this.lastYear = lastYear;
    }

    public double getThisYear() {
        return thisYear;
    }

    public void setThisYear(double thisYear) {
        this.thisYear = thisYear;
    }

    public boolean isIsBold() {
        return isBold;
    }

    public void setIsBold(boolean isBold) {
        this.isBold = isBold;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public int getCoaLevel() {
        return coaLevel;
    }

    public void setCoaLevel(int coaLevel) {
        this.coaLevel = coaLevel;
    }
}
