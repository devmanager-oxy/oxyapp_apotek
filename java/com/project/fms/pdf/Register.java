package com.project.fms.pdf;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class Register extends Entity {
    private String docNumber = "";
    private Date transDate = new Date();
    private String checkBGNumber = "";
    private String name = "";
    private String description = "";
    private double debet = 0;
    private double credit = 0;
    private double saldo = 0;
    private int status = 0;
    private boolean boldText = false;

    public boolean isBoldText() {
        return boldText;
    }

    public void setBoldText(boolean boldText) {
        this.boldText = boldText;
    }

    public String getCheckBGNumber() {
        return checkBGNumber;
    }

    public void setCheckBGNumber(String checkBGNumber) {
        this.checkBGNumber = checkBGNumber;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDocNumber() {
        return docNumber;
    }

    public void setDocNumber(String docNumber) {
        this.docNumber = docNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

}
