/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;

/**
 *
 * @author gwawan
 */
public class RptListAR {
    private String sarana = "";
    private String lot = "";
    private double lastYear = 0;
    private double current = 0;
    private double until1Year = 0;
    private double between1_2Year = 0;
    private double between2_3Year = 0;
    private double between3_4Year = 0;
    private double moreThan4Year = 0;

    public String getSarana() {
        return sarana;
    }

    public void setSarana(String sarana) {
        this.sarana = sarana;
    }

    public String getLot() {
        return lot;
    }

    public void setLot(String lot) {
        this.lot = lot;
    }

    public double getLastYear() {
        return lastYear;
    }

    public void setLastYear(double lastYear) {
        this.lastYear = lastYear;
    }

    public double getCurrent() {
        return current;
    }

    public void setCurrent(double current) {
        this.current = current;
    }

    public double getUntil1Year() {
        return until1Year;
    }

    public void setUntil1Year(double until1Year) {
        this.until1Year = until1Year;
    }

    public double getBetween1_2Year() {
        return between1_2Year;
    }

    public void setBetween1_2Year(double between1_2Year) {
        this.between1_2Year = between1_2Year;
    }

    public double getBetween2_3Year() {
        return between2_3Year;
    }

    public void setBetween2_3Year(double between2_3Year) {
        this.between2_3Year = between2_3Year;
    }

    public double getBetween3_4Year() {
        return between3_4Year;
    }

    public void setBetween3_4Year(double between3_4Year) {
        this.between3_4Year = between3_4Year;
    }

    public double getMoreThan4Year() {
        return moreThan4Year;
    }

    public void setMoreThan4Year(double moreThan4Year) {
        this.moreThan4Year = moreThan4Year;
    }

}
