if not exists (select * from sys.schemas where name = 'Procedura')
begin
exec ('create schema Procedura')
end;
/*
Napisati proceduru koja ce za prosledjen id sadrzaja izlistati podatke o registrovanim korisnicima
koji su komentarisali taj sadrzaj
-Ako ima podatke o komentarima
Ispis treba da bude 
---Sadrzaj sa brojem <sadrzaj id> koji je kreiran datuma <datum kreiranja> komentarisali su sledeci clanovi:
---Zatim sledi lista clanova koji su komentarisali taj sadrzaj sortirano po vremenu komentara, tako da prvi u listi bude vreme poslednjeg komentara.
Ispisati vreme komenatara, tekst komenatar, ime i prezime korisnika i njegov email
---Na kraju napisati ukupno komentara i koliko korisnika je komentraisalo taj sadrzaj
-Ako nema podataka o komentarima ispisati poruku
Sadrzaj sa brojem <sadrzaj id> koji je kreiran datuma <datum kreiranja> niko nije komentarisao.
-Ako nema podataka o sadrzaju ispisati poruku
Ne postoji sadrzaj sa brojem <sadrzaj id>
*/

if object_id('Procedura.KorisnikKomentar','P') is not null drop procedure Procedura.KorisnikKomentar;
go
create proc Procedura.KorisnikKomentar
	@sadrzaj as int
as
begin
	declare @datumKreiranja as date;
	declare @ime as varchar(30);
	declare @prezime as varchar(30);
	declare @email as varchar(30);
	declare @vremeKomentara as time;
	declare @tekstKomentara as varchar(500);
	declare @ukupnoKomentara as int;
	declare @brojKorisnika as int;

	set @datumKreiranja = (select datum_kreiranja from Sadrzaj.SadrzajStranice where sadrzaj_id = @sadrzaj);
	set @ukupnoKomentara = (select count(komentar_id) from Sadrzaj.Komentar where sadrzaj_id = @sadrzaj);
	set @brojKorisnika = (select count(idrk) from Sadrzaj.Komentar where sadrzaj_id = @sadrzaj)

	if @sadrzaj not  in (select sadrzaj_id from Sadrzaj.SadrzajStranice)
		print 'Ne postoji sadrzaj sa brojem ' + convert(varchar, @sadrzaj);
	else
		begin 
			if @ukupnoKomentara > 0
				begin
					print 'Sadrzaj sa brojem ' + convert(varchar, @sadrzaj) + ' koji je kreiran datuma ' + convert(varchar, @datumKreiranja) + ' komentarisali su sledeci clanovi: ';

					declare korisnikKomentar cursor fast_forward for 
						select r.ime, r.prezime, r.email, k.vreme_kom, k.tekst_komentara
						from Sadrzaj.Komentar k left join Korisnici.Biciklista b on (k.idrk = b.idrk) left join Korisnici.Registrovan r on (b.idrk = r.idrk)
						where sadrzaj_id = @sadrzaj
						order by k.vreme_kom desc;

					open korisnikKomentar;

					fetch next from korisnikKomentar into @ime, @prezime, @email, @vremeKomentara, @tekstKomentara;

					while @@FETCH_STATUS = 0
						begin
							print ' ' + @ime + ' ' + @prezime + ' ' + @email + ' ' + convert(varchar, @vremeKomentara) + ' ' + @tekstKomentara;

							fetch next from korisnikKomentar into @ime, @prezime, @email, @vremeKomentara, @tekstKomentara;
						end

					close korisnikKomentar;
					deallocate korisnikKomentar;

					print 'Sadrzaj je komentarisan ' + convert(varchar, @ukupnoKomentara) + ' puta od strane ' + convert(varchar, @brojKorisnika) + ' clanova';
				end
			else
				print 'Sadrzaj sa brojem ' + convert(varchar, @sadrzaj) + ' koji je kreiran datuma ' + convert(varchar, @datumKreiranja) + ' nije komentarisan od strane nijednog clana ';
		end
end

exec Procedura.KorisnikKomentar 33
exec Procedura.KorisnikKomentar 9
exec Procedura.KorisnikKomentar 5


/*
Napisati proceduru koja ce za prosledjen id izdavaca izlistati podatke o smestajima koji izdaje
koji su komentarisali taj sadrzaj
-Ako ima podatke o komentarima
Ispis treba da bude 
---<ime i prezime izadavaca> sa korisnickim imenom <username> izdaje sledece smestaje 
---Zatim sledi lista smestaja koji izdaje taj izdavac sortirano po kapacitetu, tako da prvi u listi bude kapacitet sa najmanjim brojem
Ispisati smestaj id, naziv elementa lokacije, kapacitet, opis smestaja
---Na kraju napisati Ukupno smestaja koji izdaje: <koliko ima smestaja>
-Ako nema podataka o komentarima ispisati poruku
<ime i prezime izadavaca> sa korisnickim imenom <username> ne izdaje ni jedan smestaj
-Ako nema podataka o sadrzaju ispisati poruku
Ne postoji izadavac sa brojem <sadrzaj id>
*/

if object_id('Procedura.SmestajIzdavac','P') is not null drop procedure Procedura.SmestajIzdavac;
go
create proc Procedura.SmestajIzdavac
	@izdavac as int
as
begin
	declare @ime as varchar(30);
	declare @prezime as varchar(30);
	declare @username as varchar(30);
	declare @smestaj_id as int;
	declare @nazivEL as varchar(30);
	declare @kapacitet as int;
	declare @opisSmestaja as varchar(30);
	declare @ukupnoSmestaja as int;

	set @ime = (select r.ime from Korisnici.Izdavac i left join Korisnici.Registrovan r on (i.idrk = r.idrk) where i.idrk = @izdavac);
	set @prezime = (select r.prezime from Korisnici.Izdavac i left join Korisnici.Registrovan r on (i.idrk = r.idrk) where i.idrk = @izdavac);
	set @username = (select r.username from Korisnici.Izdavac i left join Korisnici.Registrovan r on (i.idrk = r.idrk) where i.idrk = @izdavac);
	set @ukupnoSmestaja = (select count(smestaj_id) from Korisnici.Smestaj where idrk = @izdavac);

	if @izdavac not in (select idrk from Korisnici.Izdavac)
		print 'Ne postoji izdavac sa brojem ' + convert(varchar, @izdavac);
	else
		begin 
			if @ukupnoSmestaja > 0 
				begin
					print ' ' + @ime + ' ' + @prezime + ' sa korisnickim imenom ' + @username + ' izdaje sledece smestaje: '

					declare izdavacSmestaj cursor fast_forward for 
						select s.smestaj_id, el.naziv_el_lokacije, s.kapacitet, ts.opis_smestaja
						from Korisnici.Smestaj s left join Sadrzaj.ElementLokacije el on (s.el_lok_id = el.el_lok_id) left join Korisnici.TipSmestaja ts on (s.tip_smestaja_id = ts.tip_smestaja_id)
						where idrk = @izdavac
						order by s.kapacitet;

					open izdavacSmestaj;

					fetch next from izdavacSmestaj into @smestaj_id, @nazivEL, @kapacitet, @opisSmestaja;

					while @@FETCH_STATUS = 0
						begin
							print ' ' + convert(varchar, @smestaj_id) + ' ' + @nazivEL + ' ' + convert(varchar, @kapacitet) + ' ' + @opisSmestaja;

							fetch next from izdavacSmestaj into @smestaj_id, @nazivEL, @kapacitet, @opisSmestaja;
						end

					close izdavacSmestaj;
					deallocate izdavacSmestaj;

					print 'Smestaj je izdat ' + convert(varchar, @ukupnoSmestaja) + ' put/a';
				end
			else
				print ' ' + @ime + ' ' + @prezime + ' sa korisnickim imenom ' + @username + ' ne izdaje smestaj'
		end
end

exec Procedura.SmestajIzdavac 45
exec Procedura.SmestajIzdavac 25
exec Procedura.SmestajIzdavac 24