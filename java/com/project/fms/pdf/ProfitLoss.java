package com.project.fms.pdf;

/**
 *
 * @author gwawan
 */
public class ProfitLoss {
    private String description = "";
    private int level = 0;
    private boolean boldText = false;
    private double mtdRealLY = 0;
    private double mtdBudgetCY = 0;
    private double mtdRealCY = 0;
    private double mtdPercentLY = 0;
    private double mtdPercentBudget = 0;
    private double ytdRealLY = 0;
    private double ytdBudgetCY = 0;
    private double ytdRealCY = 0;
    private double ytdPercentLY = 0;
    private double ytdPercentBudget = 0;
    private boolean label = false;
    private boolean total = false;
    private boolean newPage = false;
    
    public static final int PNL_YTD = 0;
    public static final int PNL_MTD_YTD = 1; 

    public boolean isBoldText() {
        return boldText;
    }

    public void setBoldText(boolean boldText) {
        this.boldText = boldText;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public double getMtdBudgetCY() {
        return mtdBudgetCY;
    }

    public void setMtdBudgetCY(double mtdBudgetCY) {
        this.mtdBudgetCY = mtdBudgetCY;
    }

    public double getMtdPercentBudget() {
        return mtdPercentBudget;
    }

    public void setMtdPercentBudget(double mtdPercentBudget) {
        this.mtdPercentBudget = mtdPercentBudget;
    }

    public double getMtdPercentLY() {
        return mtdPercentLY;
    }

    public void setMtdPercentLY(double mtdPercentLY) {
        this.mtdPercentLY = mtdPercentLY;
    }

    public double getMtdRealCY() {
        return mtdRealCY;
    }

    public void setMtdRealCY(double mtdRealCY) {
        this.mtdRealCY = mtdRealCY;
    }

    public double getMtdRealLY() {
        return mtdRealLY;
    }

    public void setMtdRealLY(double mtdRealLY) {
        this.mtdRealLY = mtdRealLY;
    }

    public double getYtdBudgetCY() {
        return ytdBudgetCY;
    }

    public void setYtdBudgetCY(double ytdBudgetCY) {
        this.ytdBudgetCY = ytdBudgetCY;
    }

    public double getYtdPercentBudget() {
        return ytdPercentBudget;
    }

    public void setYtdPercentBudget(double ytdPercentBudget) {
        this.ytdPercentBudget = ytdPercentBudget;
    }

    public double getYtdPercentLY() {
        return ytdPercentLY;
    }

    public void setYtdPercentLY(double ytdPercentLY) {
        this.ytdPercentLY = ytdPercentLY;
    }

    public double getYtdRealCY() {
        return ytdRealCY;
    }

    public void setYtdRealCY(double ytdRealCY) {
        this.ytdRealCY = ytdRealCY;
    }

    public double getYtdRealLY() {
        return ytdRealLY;
    }

    public void setYtdRealLY(double ytdRealLY) {
        this.ytdRealLY = ytdRealLY;
    }

    public boolean isLabel() {
        return label;
    }

    public void setLabel(boolean label) {
        this.label = label;
    }

    public boolean isTotal() {
        return total;
    }

    public void setTotal(boolean total) {
        this.total = total;
    }

    public boolean isNewPage() {
        return newPage;
    }

    public void setNewPage(boolean newPage) {
        this.newPage = newPage;
    }

}
