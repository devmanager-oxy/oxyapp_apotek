package com.project.general;

import com.project.main.entity.*;

public class Bank extends Entity {

    private String name = "";
    private String adress = "";
    private double defaultBunga;
    private long coaARId;
    private long coaDebitCardId;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAdress() {
        return adress;
    }

    public void setAdress(String adress) {
        if (adress == null) {
            adress = "";
        }
        this.adress = adress;
    }

    public double getDefaultBunga() {
        return defaultBunga;
    }

    public void setDefaultBunga(double defaultBunga) {
        this.defaultBunga = defaultBunga;
    }

    public long getCoaARId() {
        return coaARId;
    }

    public void setCoaARId(long coaARId) {
        this.coaARId = coaARId;
    }

    public long getCoaDebitCardId() {
        return coaDebitCardId;
    }

    public void setCoaDebitCardId(long coaDebitCardId) {
        this.coaDebitCardId = coaDebitCardId;
    }
}
