/*
1 - Izlistati sifru deonic i njen naziv, procenat uspona dela deonice, naslov ture za tu deoinicu 
i koja su se prevozna sredstva koristila za tu turu
Poredjati po naslovu ture opadajuce*/

select d.deonica_id as 'Id deonice', d.naziv_deonice as Naziv, deod.procenat_uspona as Uspon, t.naslov_ture as Tura, ps.vrsta_ps as 'Prevozno sredstvo'
from Sadrzaj.Deonica d left join Sadrzaj.DeoDeonice deod on (d.deonica_id = deod.deonica_id) 
left join Sadrzaj.Tura t on (d.tura_id = t.tura_id) left join Sadrzaj.PrevoznoSredstvo ps on (d.prevozno_sredstvo_id = ps.prevozno_sredstvo_id)
order by deod.procenat_uspona desc;

/*
2 - Izlistati sifru smestaja, njegov kapacitet, ime i username registrovanog korisnika, 
koliko puta je boravio u tom smestaju i tip smestaja u kom je boravio.
Poredjati po kapacitetu rastuce a po imenu opadajuce
*/

select s.smestaj_id as 'Smestaj id', s.kapacitet as Kapacitet, r.ime + ' ' + r.prezime as 'Ime i prezime', r.username as Username, count(bo.idrk) as 'Broj boravka', ts.opis_smestaja as Smestaj
from Korisnici.Boravi bo left join Korisnici.Smestaj s on (s.smestaj_id = bo.smestaj_id) left join Korisnici.TipSmestaja ts on (s.tip_smestaja_id = ts.tip_smestaja_id)
	left join Korisnici.Biciklista bi on (bo.idrk = bi.idrk) left join Korisnici.Registrovan r on (bi.idrk = r.idrk)
group by s.smestaj_id, s.kapacitet, r.ime, r.prezime, r.username, ts.opis_smestaja
order by s.kapacitet asc, r.ime desc;


/*
3 - Izlistati sifru lokaciju, naziv lokacije, na kom elemntu lokacije se nalazi i nivo njene geografske oblasti
za sve lokacije cija je suma lokacija veca od minilane sume lokacije
Poredjati po sifri lokacije opadajuce a elemntu lokacije opadajuce
*/

select l.lokacija_id, l.naziv_lokacije, el.naziv_el_lokacije, geo.nivo, l.suma_lokacije
from Sadrzaj.NaLok nal left join Sadrzaj.Lokacija l on (nal.lokacija_id = l.lokacija_id) left join Sadrzaj.ElementLokacije el on (nal.el_lok_id = el.el_lok_id)
	left join Sadrzaj.GeografskaOblast geo on (l.geo_oblast_id = geo.geo_oblast_id)
where l.suma_lokacije > all (select min(suma_lokacije) from Sadrzaj.Lokacija)
order by l.lokacija_id desc, el.naziv_el_lokacije;


/*
4 - Izlistati sifru povlastice, ime registrovanog korisnika koji dobija tu polasticu i njegov mejl, 
vrednost te povlastice i tip povlatice za one koji imaju prosecnu vrednost povlastice vecu od 30
Poredjati po  vrednosti povlastice rastuce
*/

select p.povlastica_id as 'Povlastica id', r.ime as Ime, r.email as Email, p.vrednost as Vrednsot, tp.jedinica_mere as 'Tip povlastice', avg(p.vrednost) as 'Prosecna vrednost'
from Korisnici.Povlastica p left join Korisnici.Izdavac i on (p.idrk = i.idrk) left join Korisnici.Registrovan r on (i.idrk = r.idrk)
	left join Korisnici.TipPovlastice tp on (p.tip_povlastice_id = tp.tip_povlastice_id)
group by p.povlastica_id, r.ime, r.email, p.vrednost, tp.jedinica_mere
having avg(p.vrednost) > 30
order by p.vrednost;


/*
5 - Izlistati redni broj obilaska, naslov ture, username korisnika koji je obisao tu turu,
period i iskustvo za taj obilazak gde iskustva nisu null.
Poredjati po periodu obilaska opadajuce 
*/

select rob.rbr_obilaska, r.username, t.naslov_ture, job.period_obilaska, job.iskustvo
from Korisnici.JeObisao job left join Korisnici.Biciklista b on (job.idrk = b.idrk) left join Korisnici.Registrovan r on (b.idrk = r.idrk)
	left join Korisnici.RedniBrojObilaska rob on (job.rbr_obilaska = rob.rbr_obilaska) left join Sadrzaj.Tura t on (job.tura_id = t.tura_id)
where  job.iskustvo is not null
order by job.period_obilaska desc;

