/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptMargin {
    
    private String name = "";
    private double omset = 0;
    private double hpp = 0;
    private double marginRp = 0;
    private double marginPersen = 0;
    private Date startDate;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getOmset() {
        return omset;
    }

    public void setOmset(double omset) {
        this.omset = omset;
    }

    public double getHpp() {
        return hpp;
    }

    public void setHpp(double hpp) {
        this.hpp = hpp;
    }

    public double getMarginRp() {
        return marginRp;
    }

    public void setMarginRp(double marginRp) {
        this.marginRp = marginRp;
    }

    public double getMarginPersen() {
        return marginPersen;
    }

    public void setMarginPersen(double marginPersen) {
        this.marginPersen = marginPersen;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

}
