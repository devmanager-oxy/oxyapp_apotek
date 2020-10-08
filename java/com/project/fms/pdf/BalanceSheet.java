package com.project.fms.pdf;

/**
 *
 * @author gwawan
 */
public class BalanceSheet {
    private String description = "";
    private int level = 0;
    private boolean boldText = false;
    private double realLY = 0;
    private double budgetCY = 0;
    private double realCY = 0;
    private double percentLY = 0;
    private double percentBudget = 0;
    private boolean label = false;
    private boolean total = false;
    private boolean newPage = false;

    public double getBudgetCY() {
        return budgetCY;
    }

    public void setBudgetCY(double budgetCY) {
        this.budgetCY = budgetCY;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isBoldText() {
        return boldText;
    }

    public void setBoldText(boolean boldText) {
        this.boldText = boldText;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public double getPercentBudget() {
        return percentBudget;
    }

    public void setPercentBudget(double percentBudget) {
        this.percentBudget = percentBudget;
    }

    public double getPercentLY() {
        return percentLY;
    }

    public void setPercentLY(double percentLY) {
        this.percentLY = percentLY;
    }

    public double getRealCY() {
        return realCY;
    }

    public void setRealCY(double realCY) {
        this.realCY = realCY;
    }

    public double getRealLY() {
        return realLY;
    }

    public void setRealLY(double realLY) {
        this.realLY = realLY;
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
