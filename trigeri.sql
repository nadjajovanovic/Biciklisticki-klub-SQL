/*
Napraviti triger koji ce se aktivirati nakon upisa novog sadrzaja koji ce gledati da li je sadrzaj uneo registrovani korisnik, 
ako nije upisace gresku da mora da se registruje i upisuje datum kad je kreiran sadrzaj
*/

if object_id('Sadrzaj.UnosSadrzaja', 'TR') is not null drop trigger Sadrzaj.UnosSadrzaja;
go
create trigger Sadrzaj.UnosSadrzaja
on Sadrzaj.SadrzajStranice
after insert
as
begin
	declare @sadrzajId as int = (select sadrzaj_id from inserted);
	declare @regKorisnik as int = (select idrk from inserted);

	if @regKorisnik in (select idrk from Korisnici.Registrovan where idrk between 3 and 22)
		begin
			update Sadrzaj.SadrzajStranice
			set datum_kreiranja = getdate()
			where sadrzaj_id = @sadrzajId;
			print 'Sadrzaj je uspesno unet'
		end
	else
		print 'Korisnik ' + convert(varchar, @regKorisnik) + ' nema prava da unese sadrzaj';
end;
go

insert into Sadrzaj.SadrzajStranice values (next value for Sadrzaj.Seq_Sadrzaj, 3, cast(getdate() as date));
insert into Sadrzaj.SadrzajStranice values (next value for Sadrzaj.Seq_Sadrzaj, 23, cast(getdate() as date));
select * from Sadrzaj.SadrzajStranice;

