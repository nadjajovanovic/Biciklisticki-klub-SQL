if not exists (select * from sys.schemas where name = 'Funkcija')
begin
exec ('create schema Funkcija')
end;


/*
Kreirati funkciju VratiDatum koja za prosledjeni id sadrzaja 
vraca datum koji je veci od danasnjeg datuma.
Ako je datum veci ispisati ga, ako nije ispisati na konzoli gresku
*/

if object_id ('Funkcija.VratiDatum', 'FN') is not null drop function Funkcija.VratiDatum;
go
create function Funkcija.VratiDatum
(
	@sadrzaj_id as int
)
returns varchar(50)
as
begin
	declare @datum as date;
	set @datum = (select datum_kreiranja from Sadrzaj.SadrzajStranice where sadrzaj_id = @sadrzaj_id);
	declare @godina as int;
	set @godina = datepart(year, @datum);
	declare @trenutnagodina as int;
	set @trenutnagodina = datepart(year, getdate());
	declare @mesec as int;
	set @mesec = datepart(month, @datum);
	declare @trenutnimesec as int;
	set @trenutnimesec = datepart(month, getdate());
	declare @dan as int;
	set @dan = datepart(day, @datum);
	declare @trenutnidan as int;
	set @trenutnidan = datepart(day, getdate());

	if @dan >= @trenutnidan and @mesec >= @trenutnimesec  and @godina >= @trenutnagodina
		return 'Datum je ' + convert(varchar, @datum);
	else
		return 'Datum ' +  convert(varchar, @datum) + ' je vec prosao'
		
	return 'Datum je ' + convert(varchar, @datum);
end;
go

select Funkcija.VratiDatum(2);
select Funkcija.VratiDatum(20);



/*
Kreirati funckiju VratiElementLokacije koja za prosledjeni naziv kljucne reci vraca 
naziv elemnta lokacije, njenu lokaciju, opis lokacije
*/


if object_id ('Funkcija.VratiElementLokacije', 'FN') is not null drop function Funkcija.VratiElementLokacije;
go
create function Funkcija.VratiElementLokacije
(
	@naziv_kr as varchar(50)
)
returns varchar(50)
as
begin
	declare @naziv_el as varchar(50);
	declare @naziv_lokacije as varchar(50);
	declare @opis_lokacije as varchar(50);

	set @naziv_el = (select el.naziv_el_lokacije from Sadrzaj.Pripada p left join Sadrzaj.KljucnaRec kr on (p.kljucna_rec_id = kr.kljucna_rec_id) left join 
					Sadrzaj.ElementLokacije el on (p.el_lok_id = el.el_lok_id)
					where naziv_kr = @naziv_kr);
	set @naziv_lokacije = (select l.naziv_lokacije from Sadrzaj.Pripada p left join Sadrzaj.KljucnaRec kr on (p.kljucna_rec_id = kr.kljucna_rec_id) left join 
							Sadrzaj.ElementLokacije el on (p.el_lok_id = el.el_lok_id) left join Sadrzaj.NaLok nal on (el.el_lok_id = nal.el_lok_id)
							left join Sadrzaj.Lokacija l on (nal.lokacija_id = l.lokacija_id)
							where naziv_kr = @naziv_kr);
	set @opis_lokacije = (select l.opis_lokacije from Sadrzaj.Pripada p left join Sadrzaj.KljucnaRec kr on (p.kljucna_rec_id = kr.kljucna_rec_id) left join 
							Sadrzaj.ElementLokacije el on (p.el_lok_id = el.el_lok_id) left join Sadrzaj.NaLok nal on (el.el_lok_id = nal.el_lok_id)
							left join Sadrzaj.Lokacija l on (nal.lokacija_id = l.lokacija_id)
							where naziv_kr = @naziv_kr);

	return ' ' + @naziv_el + ' ' + @naziv_lokacije + ' ' + @opis_lokacije;
end;
go

select Funkcija.VratiElementLokacije('park');