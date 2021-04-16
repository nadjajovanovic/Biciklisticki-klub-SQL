--kreiranje seme
if not exists (select * from sys.schemas where name = 'Sadrzaj')
begin
exec ('create schema Sadrzaj')
end;

if not exists (select * from sys.schemas where name = 'Korisnici')
begin
exec ('create schema Korisnici')
end;
------------------------

--brisanje tabela  
if object_id ('Korisnici.JeObisao', 'U') is not null drop table Korisnici.JeObisao; 
if object_id ('Korisnici.RedniBrojObilaska', 'U') is not null drop table Korisnici.RedniBrojObilaska; 
if object_id ('Sadrzaj.Komentar', 'U') is not null drop table Sadrzaj.Komentar; 
if object_id ('Sadrzaj.Pripada', 'U') is not null drop table Sadrzaj.Pripada; 
if object_id ('Sadrzaj.SeOdnosi', 'U') is not null drop table Sadrzaj.SeOdnosi; 
if object_id ('Sadrzaj.KljucnaRec', 'U') is not null drop table Sadrzaj.KljucnaRec; 
if object_id ('Sadrzaj.DeoDeonice', 'U') is not null drop table Sadrzaj.DeoDeonice; 
if object_id ('Sadrzaj.Deonica', 'U') is not null drop table Sadrzaj.Deonica; 
if object_id ('Sadrzaj.PrevoznoSredstvo', 'U') is not null drop table Sadrzaj.PrevoznoSredstvo; 
if object_id ('Sadrzaj.Tura', 'U') is not null drop table Sadrzaj.Tura; 
if object_id ('Sadrzaj.NaLok', 'U') is not null drop table Sadrzaj.NaLok; 
if object_id ('Sadrzaj.Lokacija', 'U') is not null drop table Sadrzaj.Lokacija;
if object_id ('Sadrzaj.GeografskaOblast', 'U') is not null drop table Sadrzaj.GeografskaOblast;;
if object_id ('Korisnici.Boravi', 'U') is not null drop table Korisnici.Boravi; 
if object_id ('Korisnici.Smestaj', 'U') is not null drop table Korisnici.Smestaj;
if object_id ('Korisnici.Admin', 'U') is not null drop table Korisnici.Admin;
if object_id ('Korisnici.Biciklista', 'U') is not null drop table Korisnici.Biciklista;
if object_id ('Korisnici.Izdavac', 'U') is not null drop table Korisnici.Izdavac; 
if object_id ('Sadrzaj.ElementLokacije', 'U') is not null drop table Sadrzaj.ElementLokacije;
if object_id ('Sadrzaj.SadrzajStranice', 'U') is not null drop table Sadrzaj.SadrzajStranice;
if object_id ('Korisnici.Povlastica', 'U') is not null drop table Korisnici.Povlastica;
if object_id ('Korisnici.TipPovlastice', 'U') is not null drop table Korisnici.TipPovlastice;
if object_id ('Korisnici.TipSmestaja', 'U') is not null drop table Korisnici.TipSmestaja;
if object_id ('Korisnici.RedniBrojRezervacije', 'U') is not null drop table Korisnici.RedniBrojRezervacije;
if object_id ('Korisnici.Registrovan', 'U') is not null drop table Korisnici.Registrovan;

--pravljenje tabela
--geografska oblast
create table Sadrzaj.GeografskaOblast (
geo_oblast_id int not null identity,
naziv_geo_oblasti varchar(300) not null,
nivo varchar(50)
);

if exists (select * from sys.key_constraints where name = 'PK_geografskaoblast')
alter table Sadrzaj.GeografskaOblast drop constraint PK_geografskaoblast;
alter table Sadrzaj.GeografskaOblast
add constraint PK_geografskaoblast primary key (geo_oblast_id);

--registrovan korisnik
create table Korisnici.Registrovan (
idrk int not null,
ime varchar(30) not null,
prezime varchar(30) not null,
username varchar(30) not null,
password varchar(30) not null,
email varchar(30) not null,
status bit not null
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_Registrovan') drop sequence Korisnici.Seq_Registrovan;
create sequence Korisnici.Seq_Registrovan
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_Registrovan_id')
alter table Korisnici.Registrovan drop constraint DFT_Registrovan_id;
alter table Korisnici.Registrovan
add constraint DFT_Registrovan_id default (next value for Korisnici.Seq_Registrovan) for idrk;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_registrovan')
alter table Korisnici.Registrovan drop constraint PK_registrovan;
alter table Korisnici.Registrovan
add constraint PK_registrovan primary key (idrk);

if exists (select * from sys.objects where name = 'UQ_username')
alter table Korisnici.Registrovan drop constraint UQ_username;
alter table Korisnici.Registrovan
add constraint UQ_username unique (username);

--admin
create table Korisnici.Admin (
idrk int not null
);

if exists (select * from sys.key_constraints where name = 'PK_admin')
alter table Korisnici.Admin drop constraint PK_admin;
alter table Korisnici.Admin
add constraint PK_admin primary key (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_admin')
alter table Korisnici.Admin drop constraint FK_admin;
alter table Korisnici.Admin
add constraint FK_admin foreign key (idrk) references Korisnici.Registrovan (idrk);

--biciklista
create table Korisnici.Biciklista (
idrk int not null
);

if exists (select * from sys.key_constraints where name = 'PK_biciklista')
alter table Korisnici.Biciklista drop constraint PK_biciklista;
alter table Korisnici.Biciklista
add constraint PK_biciklista primary key (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_biciklista')
alter table Korisnici.Biciklista drop constraint FK_biciklista;
alter table Korisnici.Biciklista
add constraint FK_biciklista foreign key (idrk) references Korisnici.Registrovan (idrk);

--izdavac
create table Korisnici.Izdavac (
idrk int not null
);

if exists (select * from sys.key_constraints where name = 'PK_izdavac')
alter table Korisnici.Izdavac drop constraint PK_izdavac;
alter table Korisnici.Izdavac
add constraint PK_izdavac primary key (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_izdavac')
alter table Korisnici.Izdavac drop constraint FK_izdavac;
alter table Korisnici.Izdavac
add constraint FK_izdavac foreign key (idrk) references Korisnici.Registrovan (idrk);

--tip povlastice
create table Korisnici.TipPovlastice (
tip_povlastice_id int not null identity,
jedinica_mere varchar(15) not null
);

if exists (select * from sys.key_constraints where name = 'PK_tip_povlastice')
alter table Korisnici.TipPovlastice drop constraint PK_tip_povlastice;
alter table Korisnici.TipPovlastice
add constraint PK_tip_povlastice primary key (tip_povlastice_id);

--povlastica
create table Korisnici.Povlastica (
povlastica_id int not null,
idrk int not null,
vrednost float not null,
tip_povlastice_id int not null
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_Povlastica') drop sequence Korisnici.Seq_Povlastica;
create sequence Korisnici.Seq_Povlastica
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_Povlastica_id')
alter table Korisnici.Povlastica drop constraint DFT_Povlastica_id;
alter table Korisnici.Povlastica
add constraint DFT_Povlastica_id default (next value for Korisnici.Seq_Povlastica) for povlastica_id;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_povlastica')
alter table Korisnici.Povlastica drop constraint PK_povlastica;
alter table Korisnici.Povlastica
add constraint PK_povlastica primary key (povlastica_id, idrk);

if exists (select * from sys.foreign_keys where name = 'FK_povlastica_izdavac')
alter table Korisnici.Povlastica drop constraint FK_povlastica_izdavac;
alter table Korisnici.Povlastica
add constraint FK_povlastica_izdavac foreign key (idrk) references Korisnici.Izdavac (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_povlastica_izdavac')
alter table Korisnici.Povlastica drop constraint FK_povlastica_izdavac;
alter table Korisnici.Povlastica
add constraint FK_povlastica_tippovlastice foreign key (tip_povlastice_id) references Korisnici.TipPovlastice (tip_povlastice_id);

--tip smestaja
create table Korisnici.TipSmestaja (
tip_smestaja_id int not null identity,
opis_smestaja varchar(30) not null
);

if exists (select * from sys.key_constraints where name = 'PK_tip_smestaja')
alter table Korisnici.TipSmestaja drop constraint PK_tip_smestaja;
alter table Korisnici.TipSmestaja
add constraint PK_tip_smestaja primary key (tip_smestaja_id);

--smestaj
create table Korisnici.Smestaj (
smestaj_id int not null,
el_lok_id int not null,
dostupnost bit not null,
kapacitet int not null,
tip_smestaja_id int not null,
idrk int not null,
raspolozivost bit not null,
datum_od date,
datum_do date
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_Smestaj') drop sequence Korisnici.Seq_Smestaj;
create sequence Korisnici.Seq_Smestaj
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_Smestaj_id')
alter table Korisnici.Smestaj drop constraint DFT_Smestaj_id;
alter table Korisnici.Smestaj
add constraint DFT_Smestaj_id default (next value for Korisnici.Seq_Smestaj) for smestaj_id;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_smestaj')
alter table Korisnici.Smestaj drop constraint PK_smestaj;
alter table Korisnici.Smestaj
add constraint PK_smestaj primary key (smestaj_id);

if exists (select * from sys.foreign_keys where name = 'FK_smestaj_tipsmestaja')
alter table Korisnici.Smestaj drop constraint FK_smestaj_tipsmestaja;
alter table Korisnici.Smestaj
add constraint FK_smestaj_tipsmestaja foreign key (tip_smestaja_id) references Korisnici.TipSmestaja (tip_smestaja_id);

if exists (select * from sys.foreign_keys where name = 'FK_smestaj_izdavac')
alter table Korisnici.Smestaj drop constraint FK_smestaj_izdavac;
alter table Korisnici.Smestaj
add constraint FK_smestaj_izdavac foreign key (idrk) references Korisnici.Izdavac (idrk);

if exists (select * from sys.check_constraints where name = 'CHK_dostupnost_raspolozivost')
alter table Korisnici.Smestaj drop constraint CHK_dostupnost_raspolozivost;
alter table Korisnici.Smestaj
add constraint CHK_dostupnost_raspolozivost check (dostupnost = 1 and (raspolozivost = 0 or raspolozivost = 1) or (dostupnost = 0 and raspolozivost = 0));

--redni broj rezervacije
create table Korisnici.RedniBrojRezervacije (
rbr_rez int not null
);

if exists (select * from sys.key_constraints where name = 'PK_rednibrrez')
alter table Korisnici.RedniBrojRezervacije drop constraint PK_rednibrrez;
alter table Korisnici.RedniBrojRezervacije
add constraint PK_rednibrrez primary key (rbr_rez);

--poveznik boravi
create table Korisnici.Boravi (
idrk int not null,
smestaj_id int not null,
rbr_rez int not null
);

if exists (select * from sys.key_constraints where name = 'PK_boravi')
alter table Korisnici.Boravi drop constraint PK_boravi;
alter table Korisnici.Boravi
add constraint PK_boravi primary key (idrk, smestaj_id, rbr_rez);

if exists (select * from sys.foreign_keys where name = 'FK_boravi_biciklista')
alter table Korisnici.Boravi drop constraint FK_boravi_biciklista;
alter table Korisnici.Boravi
add constraint FK_boravi_biciklista foreign key (idrk) references Korisnici.Biciklista (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_boravi_smestaj')
alter table Korisnici.Boravi drop constraint FK_boravi_smestaj;
alter table Korisnici.Boravi
add constraint FK_boravi_smestaj foreign key (smestaj_id) references Korisnici.Smestaj (smestaj_id);

if exists (select * from sys.foreign_keys where name = 'FK_boravi_rbrrez')
alter table Korisnici.Boravi drop constraint FK_boravi_rbrrez;
alter table Korisnici.Boravi
add constraint FK_boravi_rbrrez foreign key (rbr_rez) references Korisnici.RedniBrojRezervacije (rbr_rez);

--sadrzaj
create table Sadrzaj.SadrzajStranice (
sadrzaj_id int not null,
idrk int not null,
datum_kreiranja date not null
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_Sadrzaj') drop sequence Sadrzaj.Seq_Sadrzaj;
create sequence Sadrzaj.Seq_Sadrzaj
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_Sadrzaj_id')
alter table Sadrzaj.SadrzajStranice drop constraint DFT_Sadrzaj_id;
alter table Sadrzaj.SadrzajStranice
add constraint DFT_Sadrzaj_id default (next value for Sadrzaj.Seq_Sadrzaj) for sadrzaj_id;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_sadrzaj')
alter table Sadrzaj.SadrzajStranice drop constraint PK_sadrzaj;
alter table Sadrzaj.SadrzajStranice
add constraint PK_sadrzaj primary key (sadrzaj_id);

if exists (select * from sys.foreign_keys where name = 'FK_sadrzaj_regkor')
alter table Sadrzaj.SadrzajStranice drop constraint FK_sadrzaj_regkor;
alter table Sadrzaj.SadrzajStranice
add constraint FK_sadrzaj_regkor foreign key (idrk) references Korisnici.Registrovan (idrk);

--tura
create table Sadrzaj.Tura (
tura_id int not null,
naslov_ture varchar(30) not null,
opis_ture varchar(500),
suma_ture int not null
);

if exists (select * from sys.key_constraints where name = 'PK_tura')
alter table Sadrzaj.Tura drop constraint PK_tura;
alter table Sadrzaj.Tura
add constraint PK_tura primary key (tura_id);

if exists (select * from sys.key_constraints where name = 'FK_tura')
alter table Sadrzaj.Tura drop constraint FK_tura;
alter table Sadrzaj.Tura
add constraint FK_tura foreign key (tura_id) references Sadrzaj.SadrzajStranice (sadrzaj_id);


--prevozno sredstvo
create table Sadrzaj.PrevoznoSredstvo (
prevozno_sredstvo_id int not null identity,
vrsta_ps varchar(30) not null
);

if exists (select * from sys.key_constraints where name = 'PK_prevozno_sredstvo')
alter table Sadrzaj.PrevoznoSredstvo drop constraint PK_prevozno_sredstvo;
alter table Sadrzaj.PrevoznoSredstvo
add constraint PK_prevozno_sredstvo primary key (prevozno_sredstvo_id);

--deonica
create table Sadrzaj.Deonica (
deonica_id int not null,
naziv_deonice varchar(30) not null,
opis_deonice varchar(500),
kvalitet_podloge varchar(50) not null,
tura_id int not null,
prevozno_sredstvo_id int not null,
koristio bit,
preporucio bit,
pocetna_lok int not null,
krajnja_lok int not null
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_Deonica') drop sequence Sadrzaj.Seq_Deonica;
create sequence Sadrzaj.Seq_Deonica
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_Deonica_id')
alter table Sadrzaj.Deonica drop constraint DFT_Deonica_id;
alter table Sadrzaj.Deonica
add constraint DFT_Deonica_id default (next value for Sadrzaj.Seq_Deonica) for deonica_id;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_deonica')
alter table Sadrzaj.Deonica drop constraint PK_deonica;
alter table Sadrzaj.Deonica
add constraint PK_deonica primary key (tura_id, deonica_id);

if exists (select * from sys.objects where name = 'UQ_naziv_deonice')
alter table Sadrzaj.Deonica drop constraint UQ_naziv_deonice;
alter table Sadrzaj.Deonica
add constraint UQ_naziv_deonice unique (naziv_deonice);

if exists (select * from sys.foreign_keys where name = 'FK_deonica_tura')
alter table Sadrzaj.Deonica drop constraint FK_deonica_tura;
alter table Sadrzaj.Deonica
add constraint FK_deonica_tura foreign key (tura_id) references Sadrzaj.Tura (tura_id);

if exists (select * from sys.foreign_keys where name = 'FK_deonica_prevoznosredstvo')
alter table Sadrzaj.Deonica drop constraint FK_deonica_prevoznosredstvo;
alter table Sadrzaj.Deonica
add constraint FK_deonica_prevoznosredstvo foreign key (prevozno_sredstvo_id) references Sadrzaj.PrevoznoSredstvo (prevozno_sredstvo_id);


--deo deonice
create table Sadrzaj.DeoDeonice (
deo_deonice_id int not null,
procenat_uspona float not null,
tura_id int not null,
deonica_id int not null
);

--pravljenje sekvence
if exists (select name from sys.sequences where name = 'Seq_DeoDeonice') drop sequence Sadrzaj.Seq_DeoDeonice;
create sequence Sadrzaj.Seq_DeoDeonice
start with 1
increment by 1
cycle

--dodavanje sekvence u tabelu
if exists (select * from sys.default_constraints where name = 'DFT_DeoDeonice_id')
alter table Sadrzaj.DeoDeonice drop constraint DFT_DeoDeonice_id;
alter table Sadrzaj.DeoDeonice
add constraint DFT_DeoDeonice_id default (next value for Sadrzaj.Seq_DeoDeonice) for deo_deonice_id;
----------------------

if exists (select * from sys.key_constraints where name = 'PK_deo_deonice')
alter table Sadrzaj.DeoDeonice drop constraint PK_deo_deonice;
alter table Sadrzaj.DeoDeonice
add constraint PK_deo_deonice primary key (tura_id, deonica_id, deo_deonice_id);

if exists (select * from sys.foreign_keys where name = 'FK_deo_deonice_tura_deonica')
alter table Sadrzaj.DeoDeonice drop constraint FK_deo_deonice_tura_deonica;
alter table Sadrzaj.DeoDeonice
add constraint FK_deo_deonice_tura_deonica foreign key (tura_id, deonica_id) references Sadrzaj.Deonica (tura_id, deonica_id);

--lokacija
create table Sadrzaj.Lokacija (
lokacija_id int not null,
naziv_lokacije varchar(30) not null,
opis_lokacije varchar(500),
suma_lokacije int not null,
geo_oblast_id int not null
);

if exists (select * from sys.key_constraints where name = 'PK_lokacija')
alter table Sadrzaj.Lokacija drop constraint PK_lokacija;
alter table Sadrzaj.Lokacija
add constraint PK_lokacija primary key (lokacija_id);

if exists (select * from sys.foreign_keys where name = 'FK_lokacija')
alter table Sadrzaj.Lokacija drop constraint FK_lokacija;
alter table Sadrzaj.Lokacija
add constraint FK_lokacija foreign key (lokacija_id) references Sadrzaj.SadrzajStranice (sadrzaj_id);

if exists (select * from sys.objects where name = 'UQ_naziv_lokacije')
alter table Sadrzaj.Lokacija drop constraint UQ_naziv_lokacije;
alter table Sadrzaj.Lokacija
add constraint UQ_naziv_lokacije unique (naziv_lokacije);

if exists (select * from sys.foreign_keys where name = 'FK_lokacija_geo_oblast')
alter table Sadrzaj.Lokacija drop constraint FK_lokacija_geo_oblast;
alter table Sadrzaj.Lokacija
add constraint FK_lokacija_geo_oblast foreign key (geo_oblast_id) references Sadrzaj.GeografskaOblast (geo_oblast_id);

--dodavanje u tabelu deonica strane kljuceve za pocetnu i krajnju lokaciju
if exists (select * from sys.foreign_keys where name = 'FK_deonica_pocetnalok')
alter table Sadrzaj.Deonica drop constraint FK_deonica_pocetnalok;
alter table Sadrzaj.Deonica
add constraint FK_deonica_pocetnalok foreign key (pocetna_lok) references Sadrzaj.Lokacija (lokacija_id);

if exists (select * from sys.foreign_keys where name = 'FK_deonica_krajnjalok')
alter table Sadrzaj.Deonica drop constraint FK_deonica_krajnjalok;
alter table Sadrzaj.Deonica
add constraint FK_deonica_krajnjalok foreign key (krajnja_lok) references Sadrzaj.Lokacija (lokacija_id);
-------------------

--element lokacije
create table Sadrzaj.ElementLokacije (
el_lok_id int not null,
naziv_el_lokacije varchar(30) not null,
vrsta_el_lok varchar(30) not null,
suma_el_lok int not null
);

if exists (select * from sys.key_constraints where name = 'PK_element_lokacije')
alter table Sadrzaj.ElementLokacije drop constraint PK_element_lokacije;
alter table Sadrzaj.ElementLokacije
add constraint PK_element_lokacije primary key (el_lok_id);

if exists (select * from sys.foreign_keys where name = 'FK_element_lokacije')
alter table Sadrzaj.ElementLokacije drop constraint FK_element_lokacije;
alter table Sadrzaj.ElementLokacije
add constraint FK_element_lokacije foreign key (el_lok_id) references Sadrzaj.SadrzajStranice (sadrzaj_id);

--dodavanje stranog kljuca elementa lokacije u smestaj
if exists (select * from sys.foreign_keys where name = 'FK_smestaj_el_lok')
alter table Korisnici.Smestaj drop constraint FK_smestaj_el_lok;
alter table Korisnici.Smestaj
add constraint FK_smestaj_el_lok foreign key (el_lok_id) references Sadrzaj.ElementLokacije (el_lok_id);
---------------

--poveznik na_lok
create table Sadrzaj.NaLok (
lokacija_id int not null,
el_lok_id int not null,
udaljenost varchar(50),
opis_prilaska varchar(500)
);

if exists (select * from sys.key_constraints where name = 'PK_na_lok')
alter table Sadrzaj.NaLok drop constraint PK_na_lok;
alter table Sadrzaj.NaLok
add constraint PK_na_lok primary key (lokacija_id, el_lok_id);

if exists (select * from sys.foreign_keys where name = 'FK_na_lok_lokacija')
alter table Sadrzaj.NaLok drop constraint FK_na_lok_lokacija;
alter table Sadrzaj.NaLok
add constraint FK_na_lok_lokacija foreign key (lokacija_id) references Sadrzaj.Lokacija (lokacija_id);

if exists (select * from sys.foreign_keys where name = 'FK_na_lok_el_lok')
alter table Sadrzaj.NaLok drop constraint FK_na_lok_el_lok;
alter table Sadrzaj.NaLok
add constraint FK_na_lok_el_lok foreign key (el_lok_id) references Sadrzaj.ElementLokacije (el_lok_id);

--kljucna rec
create table Sadrzaj.KljucnaRec (
kljucna_rec_id int not null identity,
naziv_kr varchar(50) not null
);

if exists (select * from sys.key_constraints where name = 'PK_kljucna_rec')
alter table Sadrzaj.KljucnaRec drop constraint PK_kljucna_rec;
alter table Sadrzaj.KljucnaRec
add constraint PK_kljucna_rec primary key (kljucna_rec_id);

--rekurzivni tip poveznika seodnosi
create table Sadrzaj.SeOdnosi (
kljucna_odn int not null,
kljucna_rec_id int not null
);

if exists (select * from sys.key_constraints where name = 'PK_se_odnosi')
alter table Sadrzaj.SeOdnosi drop constraint PK_se_odnosi;
alter table Sadrzaj.SeOdnosi
add constraint PK_se_odnosi primary key (kljucna_odn, kljucna_rec_id);

if exists (select * from sys.foreign_keys where name = 'FK_se_odnosi_kljucna_se_odnosi')
alter table Sadrzaj.SeOdnosi drop constraint FK_se_odnosi_kljucna_se_odnosi;
alter table Sadrzaj.SeOdnosi
add constraint FK_se_odnosi_kljucna_se_odnosi foreign key (kljucna_odn) references Sadrzaj.KljucnaRec (kljucna_rec_id);

if exists (select * from sys.foreign_keys where name = 'FK_se_odnosi_kljucna_rec')
alter table Sadrzaj.SeOdnosi drop constraint FK_se_odnosi_kljucna_rec;
alter table Sadrzaj.SeOdnosi
add constraint FK_se_odnosi_kljucna_rec foreign key (kljucna_rec_id) references Sadrzaj.KljucnaRec (kljucna_rec_id);

--tip poveznika priprada
create table Sadrzaj.Pripada (
kljucna_rec_id int not null,
el_lok_id int not null
);

if exists (select * from sys.key_constraints where name = 'PK_pripada')
alter table Sadrzaj.Pripada drop constraint PK_pripada;
alter table Sadrzaj.Pripada
add constraint PK_pripada primary key (kljucna_rec_id, el_lok_id);

if exists (select * from sys.foreign_keys where name = 'FK_pripada_kljucna_rec')
alter table Sadrzaj.Pripada drop constraint FK_pripada_kljucna_rec;
alter table Sadrzaj.Pripada
add constraint FK_pripada_kljucna_rec foreign key (kljucna_rec_id) references Sadrzaj.KljucnaRec (kljucna_rec_id);

if exists (select * from sys.foreign_keys where name = 'FK_pripada_el_lok')
alter table Sadrzaj.Pripada drop constraint FK_pripada_el_lok;
alter table Sadrzaj.Pripada
add constraint FK_pripada_el_lok foreign key (el_lok_id) references Sadrzaj.ElementLokacije (el_lok_id);

--komentar
create table Sadrzaj.Komentar (
komentar_id int not null,
tekst_komentara varchar(500) not null,
datum_kom date not null,
vreme_kom time not null,
sadrzaj_id int not null,
idrk int not null,
datum_brisanja date 
);

if exists (select * from sys.key_constraints where name = 'PK_komentar')
alter table Sadrzaj.Komentar drop constraint PK_komentar;
alter table Sadrzaj.Komentar
add constraint PK_komentar primary key (komentar_id);

if exists (select * from sys.foreign_keys where name = 'FK_komentar_id')
alter table Sadrzaj.Komentar drop constraint FK_komentar_id;
alter table Sadrzaj.Komentar
add constraint FK_komentar_id foreign key (komentar_id) references Sadrzaj.SadrzajStranice (sadrzaj_id);

if exists (select * from sys.foreign_keys where name = 'FK_komentar_sadrzaj')
alter table Sadrzaj.Komentar drop constraint FK_komentar_sadrzaj;
alter table Sadrzaj.Komentar
add constraint FK_komentar_sadrzaj foreign key (sadrzaj_id) references Sadrzaj.SadrzajStranice (sadrzaj_id);

if exists (select * from sys.foreign_keys where name = 'FK_komentar_korisnik')
alter table Sadrzaj.Komentar drop constraint FK_komentar_korisnik;
alter table Sadrzaj.Komentar
add constraint FK_komentar_korisnik foreign key (idrk) references Korisnici.Registrovan (idrk);

--poveznik redni broj obilaska
create table Korisnici.RedniBrojObilaska (
rbr_obilaska int not null 
);

if exists (select * from sys.key_constraints where name = 'PK_redni_broj_obilaska')
alter table Korisnici.RedniBrojObilaska drop constraint PK_redni_broj_obilaska;
alter table Korisnici.RedniBrojObilaska
add constraint PK_redni_broj_obilaska primary key (rbr_obilaska);

--tip poveznika je obisao
create table Korisnici.JeObisao (
idrk int not null,
tura_id int not null,
rbr_obilaska int not null,
period_obilaska time not null,
iskustvo varchar(300)
);

if exists (select * from sys.key_constraints where name = 'PK_je_obisao')
alter table Korisnici.JeObisao drop constraint PK_je_obisao;
alter table Korisnici.JeObisao
add constraint PK_je_obisao primary key (idrk, tura_id, rbr_obilaska);

if exists (select * from sys.foreign_keys where name = 'FK_je_obisao_korisnik')
alter table Korisnici.JeObisao drop constraint FK_je_obisao_korisnik;
alter table Korisnici.JeObisao
add constraint FK_je_obisao_korisnik foreign key (idrk) references Korisnici.Registrovan (idrk);

if exists (select * from sys.foreign_keys where name = 'FK_je_obisao_tura')
alter table Korisnici.JeObisao drop constraint FK_je_obisao_tura;
alter table Korisnici.JeObisao
add constraint FK_je_obisao_tura foreign key (tura_id) references Sadrzaj.Tura (tura_id);

if exists (select * from sys.foreign_keys where name = 'FK_je_obisao_rbr_obilaska')
alter table Korisnici.JeObisao drop constraint FK_je_obisao_rbr_obilaska;
alter table Korisnici.JeObisao
add constraint FK_je_obisao_rbr_obilaska foreign key (rbr_obilaska) references Korisnici.RedniBrojObilaska (rbr_obilaska);