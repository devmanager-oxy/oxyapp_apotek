
package com.project.general;  

import com.project.main.entity.*;

public class Vendor extends Entity { 

	private String name = "";
	private String code = "";
	private String address = "";
	private String city = "";
	private String state = "";
	private String phone = "";
	private String hp = "";
	private String fax = "";
	private int dueDate = 0;
	private String contact = "";
	private String countryName = "";
	private long countryId = 0;
        private int type;
        private String npwp = "";
        private double discount;
        private double prevLiability;
        private String email = "";
        private String vendorType = "";
        private String webPage = "";
        private int directReceive;
        private int isKonsinyasi;
        private int isPKP;
        private int includePPN;
        private double komisiPercent;
        
        //add by roy andika : 2012-12-27 untuk menghandle barang konsinyasi yang memiliki margin harga
        private double percentMargin;
        private double percentPromosi;
        private double percentBarcode;      
        private int system;    
        
        //add by roy andika : 2013-01-17 untuk menghandle barang komisi
        private double komisiMargin;
        private double komisiPromosi;
        private double komisiBarcode;      
        private int isKomisi;    
        
        private int odrSenin;
        private int odrSelasa;
        private int odrRabu;
        private int odrKamis;
        private int odrJumat;
        private int odrSabtu;
        private int odrMinggu;
        private int pendingOnePo;
        private String typeLocIncoming;
        
        private String noRek = "";
        private long bankId = 0;
        private int paymentType = 0;      
        private String pic = "";
        private int liabilitiesType = 0;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

	public String getAddress(){ 
		return address; 
	} 

	public void setAddress(String address){ 
		if ( address == null ) {
			address = ""; 
		} 
		this.address = address; 
	} 

	public String getCity(){ 
		return city; 
	} 

	public void setCity(String city){ 
		if ( city == null ) {
			city = ""; 
		} 
		this.city = city; 
	} 

	public String getState(){ 
		return state; 
	} 

	public void setState(String state){ 
		if ( state == null ) {
			state = ""; 
		} 
		this.state = state; 
	} 

	public String getPhone(){ 
		return phone; 
	} 

	public void setPhone(String phone){ 
		if ( phone == null ) {
			phone = ""; 
		} 
		this.phone = phone; 
	} 

	public String getHp(){ 
		return hp; 
	} 

	public void setHp(String hp){ 
		if ( hp == null ) {
			hp = ""; 
		} 
		this.hp = hp; 
	} 

	public String getFax(){ 
		return fax; 
	} 

	public void setFax(String fax){ 
		if ( fax == null ) {
			fax = ""; 
		} 
		this.fax = fax; 
	} 

	public int getDueDate(){ 
		return dueDate; 
	} 

	public void setDueDate(int dueDate){ 
		this.dueDate = dueDate; 
	} 

	public String getContact(){ 
		return contact; 
	} 

	public void setContact(String contact){ 
		if ( contact == null ) {
			contact = ""; 
		} 
		this.contact = contact; 
	} 

	public String getCountryName(){ 
		return countryName; 
	} 

	public void setCountryName(String countryName){ 
		if ( countryName == null ) {
			countryName = ""; 
		} 
		this.countryName = countryName; 
	} 

	public long getCountryId(){ 
		return countryId; 
	} 

	public void setCountryId(long countryId){ 
		this.countryId = countryId; 
	} 

        /**
         * Getter for property type.
         * @return Value of property type.
         */
        public int getType() {
            return this.type;
        }
        
        /**
         * Setter for property type.
         * @param type New value of property type.
         */
        public void setType(int type) {
            this.type = type;
        }
        
        /**
         * Getter for property npwp.
         * @return Value of property npwp.
         */
        public String getNpwp() {
            return this.npwp;
        }
        
        /**
         * Setter for property npwp.
         * @param npwp New value of property npwp.
         */
        public void setNpwp(String npwp) {
            this.npwp = npwp;
        }
        
        /**
         * Getter for property discount.
         * @return Value of property discount.
         */
        public double getDiscount() {
            return this.discount;
        }
        
        /**
         * Setter for property discount.
         * @param discount New value of property discount.
         */
        public void setDiscount(double discount) {
            this.discount = discount;
        }
        
        /**
         * Getter for property prevLiability.
         * @return Value of property prevLiability.
         */
        public double getPrevLiability() {
            return this.prevLiability;
        }
        
        /**
         * Setter for property prevLiability.
         * @param prevLiability New value of property prevLiability.
         */
        public void setPrevLiability(double prevLiability) {
            this.prevLiability = prevLiability;
        }
        
        /**
         * Getter for property email.
         * @return Value of property email.
         */
        public String getEmail() {
            return this.email;
        }
        
        /**
         * Setter for property email.
         * @param email New value of property email.
         */
        public void setEmail(String email) {
            this.email = email;
        }
        
        /**
         * Getter for property vendorType.
         * @return Value of property vendorType.
         */
        public String getVendorType() {
            return this.vendorType;
        }
        
        /**
         * Setter for property vendorType.
         * @param vendorType New value of property vendorType.
         */
        public void setVendorType(String vendorType) {
            this.vendorType = vendorType;
        }
        
        /**
         * Getter for property webPage.
         * @return Value of property webPage.
         */
        public String getWebPage() {
            return this.webPage;
        }
        
        /**
         * Setter for property webPage.
         * @param webPage New value of property webPage.
         */
        public void setWebPage(String webPage) {
            this.webPage = webPage;
        }

    public int getDirectReceive() {
        return directReceive;
    }

    public void setDirectReceive(int directReceive) {
        this.directReceive = directReceive;
    }

    public int getIsKonsinyasi() {
        return isKonsinyasi;
    }

    public void setIsKonsinyasi(int isKonsinyasi) {
        this.isKonsinyasi = isKonsinyasi;
    }

    public int getIsPKP() {
        return isPKP;
    }

    public void setIsPKP(int isPKP) {
        this.isPKP = isPKP;
    }

    public int getIncludePPN() {
        return includePPN;
    }

    public void setIncludePPN(int includePPN) {
        this.includePPN = includePPN;
    }

    public double getKomisiPercent() {
        return komisiPercent;
    }

    public void setKomisiPercent(double komisiPercent) {
        this.komisiPercent = komisiPercent;
    }

    public double getPercentMargin() {
        return percentMargin;
    }

    public void setPercentMargin(double percentMargin) {
        this.percentMargin = percentMargin;
    }

    public double getPercentPromosi() {
        return percentPromosi;
    }

    public void setPercentPromosi(double percentPromosi) {
        this.percentPromosi = percentPromosi;
    }

    public double getPercentBarcode() {
        return percentBarcode;
    }

    public void setPercentBarcode(double percentBarcode) {
        this.percentBarcode = percentBarcode;
    }

    public int getSystem() {
        return system;
    }

    public void setSystem(int system) {
        this.system = system;
    }

    public double getKomisiMargin() {
        return komisiMargin;
    }

    public void setKomisiMargin(double komisiMargin) {
        this.komisiMargin = komisiMargin;
    }

    public double getKomisiPromosi() {
        return komisiPromosi;
    }

    public void setKomisiPromosi(double komisiPromosi) {
        this.komisiPromosi = komisiPromosi;
    }

    public double getKomisiBarcode() {
        return komisiBarcode;
    }

    public void setKomisiBarcode(double komisiBarcode) {
        this.komisiBarcode = komisiBarcode;
    }

    public int getIsKomisi() {
        return isKomisi;
    }

    public void setIsKomisi(int isKomisi) {
        this.isKomisi = isKomisi;
    }

    public int getOdrSenin() {
        return odrSenin;
    }

    public void setOdrSenin(int odrSenin) {
        this.odrSenin = odrSenin;
    }

    public int getOdrSelasa() {
        return odrSelasa;
    }

    public void setOdrSelasa(int odrSelasa) {
        this.odrSelasa = odrSelasa;
    }

    public int getOdrRabu() {
        return odrRabu;
    }

    public void setOdrRabu(int odrRabu) {
        this.odrRabu = odrRabu;
    }

    public int getOdrKamis() {
        return odrKamis;
    }

    public void setOdrKamis(int odrKamis) {
        this.odrKamis = odrKamis;
    }

    public int getOdrJumat() {
        return odrJumat;
    }

    public void setOdrJumat(int odrJumat) {
        this.odrJumat = odrJumat;
    }

    public int getOdrSabtu() {
        return odrSabtu;
    }

    public void setOdrSabtu(int odrSabtu) {
        this.odrSabtu = odrSabtu;
    }

    public int getOdrMinggu() {
        return odrMinggu;
    }

    public void setOdrMinggu(int odrMinggu) {
        this.odrMinggu = odrMinggu;
    }

    public int getPendingOnePo() {
        return pendingOnePo;
    }

    public void setPendingOnePo(int pendingOnePo) {
        this.pendingOnePo = pendingOnePo;
    }

    public String getTypeLocIncoming() {
        return typeLocIncoming;
    }

    public void setTypeLocIncoming(String typeLocIncoming) {
        this.typeLocIncoming = typeLocIncoming;
    }

    public String getNoRek() {
        return noRek;
    }

    public void setNoRek(String noRek) {
        this.noRek = noRek;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public int getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(int paymentType) {
        this.paymentType = paymentType;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public int getLiabilitiesType() {
        return liabilitiesType;
    }

    public void setLiabilitiesType(int liabilitiesType) {
        this.liabilitiesType = liabilitiesType;
    }

    
        
}
