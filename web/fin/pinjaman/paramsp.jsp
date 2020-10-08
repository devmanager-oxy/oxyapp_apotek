<%
/*----------------  parameter accounting sp -------------------*/
//*** pinjaman koperasi ke bank ***

//*** pinjaman member ke koperasi - cash

//*** bayar pinjaman koperasi - cash

String[] debetPokokCash = {"1.1.1.1.01", "1.1.2.1.01"}; //cash sp, mandiri sp
String[] debetBungaCash = {"1.1.1.1.01", "1.1.2.1.01"};
String[] debetDendaCash = {"1.1.1.1.01", "1.1.2.1.01"};
String[] creditPihutangCash = {"1.1.4.1.01"};
String[] creditPihutangCashMandiri = {"1.1.4.1.24"};
String[] creditBungaIncomeCash = {"4.2.1.1.4.01"};
String[] creditDendaIncomeCash = {"4.2.1.1.4.01"};

//*** pinjaman member ke koperasi - motor

//*** bayar member ke koperasi - motor

String[] debetPokokMotor = {"1.1.1.1.02", "1.1.2.1.02"}; //nama2 akun
String[] debetBungaMotor = {"1.1.1.1.02", "1.1.2.1.02"};
String[] debetDendaMotor = {"1.1.1.1.02", "1.1.2.1.02"};
String[] creditPihutangMotor = {"1.1.4.1.04"};
String[] creditBungaIncomeMotor = {"4.2.2.3.4.01"};
String[] creditDendaIncomeMotor = {"4.2.2.3.4.01"};


//*** pinjaman member ke koperasi - elektronik

//*** bayar member ke koperasi - elektronik

String[] debetPokokElektro = {"1.1.1.1.02", "1.1.2.1.02"}; //nama2 akun
String[] debetBungaElektro = {"1.1.1.1.02", "1.1.2.1.02"};
String[] debetDendaElektro = {"1.1.1.1.02", "1.1.2.1.02"};
String[] creditPihutangElektro = {"1.1.4.1.03"};
String[] creditBungaIncomeElektro = {"4.2.2.1.4.01"};
String[] creditDendaIncomeElektro = {"4.2.2.1.4.01"};

//***  simpanan member

String[] debetSimpananPokok = {"1.1.1.1.02", "1.1.2.1.02"}; //nama2 akun
String[] debetSimpananWajib = {"1.1.1.1.02", "1.1.2.1.02"};
String[] debetSimpananSukarelaSHU = {"1.1.1.1.01", "1.1.2.1.01"};
String[] creditSimpananPokok = {"3.1.1.1.01"};
String[] creditSimpananWajib = {"3.1.2.1.01"};
String[] creditSimpananSukarelaSHU = {"2.1.3.1.01"};


%>