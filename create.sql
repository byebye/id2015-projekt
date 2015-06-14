-- Skrypt tworzący wszystkie tabele i wypełniający je przykładowymi danymi --
BEGIN;
-- ********************* dokumenty *********************

-- Na dokumenty moze wskazywac wlasciwie kazda inna tabela - dlatego w razie potrzeby robimy dodatkowa tabele w stylu: 'cos_dokumenty'

CREATE TABLE dokumenty_typy(
   id          serial PRIMARY KEY,
   nazwa       varchar(100) NOT NULL,
   wiarygodny  bool
);

CREATE TABLE dokumenty(
   id          serial PRIMARY KEY,
   typ         int REFERENCES dokumenty_typy(id) NOT NULL,
   sciezka     varchar(250) NOT NULL, -- sciezka do pliku ?
   wiarygodny  bool
);

-- ********************* miejsca *********************

CREATE TABLE miejsca_typy(
   id          serial PRIMARY KEY,
   nazwa       varchar(50) UNIQUE NOT NULL 
);

CREATE TABLE miejsca(
   id          serial PRIMARY KEY,
   nazwa       varchar(50) NOT NULL,
   typ         int REFERENCES miejsca_typy(id)
);

CREATE TABLE miejsca_dokumenty(
   id_miejsce       int REFERENCES miejsca(id) NOT NULL,
   id_dokument      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT miejsca_dokumenty_pk PRIMARY KEY(id_miejsce, id_dokument) 
);

CREATE TABLE ziemie( -- wieksze obszary, zarzadzanie przez rody
   id_miejsce  int REFERENCES miejsca(id) UNIQUE NOT NULL, -- check - nad jednym miejscem moze panowac jeden ród
   wielkosc    varchar(10) CHECK(wielkosc IN ('mały', 'średni', 'duży')),
   polozenie   varchar(100),
   CONSTRAINT ziemie_pk PRIMARY KEY(id_miejsce)
);

CREATE TABLE krainy_ziemie( --krainy geograficzne
   id_ziemia   int REFERENCES miejsca(id) UNIQUE NOT NULL, --musi nie byc kraina!
   id_kraina   int REFERENCES miejsca(id) NOT NULL, --musi byc kraina!
   CONSTRAINT krainy_ziemie_pk PRIMARY KEY(id_kraina,id_ziemia)
);

CREATE TABLE ziemie_dokumenty(
   id_ziemia        int REFERENCES ziemie(id_miejsce) NOT NULL,
   id_dokument      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT ziemie_dokumenty_pk PRIMARY KEY(id_ziemia, id_dokument) 
);

-- ********************* wydarzenia *********************

CREATE TABLE wydarzenia_typy(
   id       serial PRIMARY KEY,
   nazwa    varchar(50) 
);

CREATE TABLE wydarzenia(
   id                serial PRIMARY KEY,
   data              date, -- moze byc nieznana lub tylko przyblizona - czy chcemy to w jakis szczegolny sposob obslugiwac?
   nazwa             varchar(100),
   typ               int REFERENCES wydarzenia_typy(id),
   opis              varchar(300), -- krotki opis, wiecej w dokumentach
   miejsce           int REFERENCES miejsca(id)
   -- ta tabela bedzie duza, wiec trzeba zrobic dla niej indeks dla szybszego wyszukiwania
);

CREATE TABLE wydarzenia_dokumenty(
   id_wydarzenie         int REFERENCES wydarzenia(id) NOT NULL,
   id_dokument           int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT wydarzenia_dokumenty_pk PRIMARY KEY(id_wydarzenie, id_dokument) 
);

-- ********************* zwiazane z osobami *********************

CREATE TABLE kolory(
   id       serial PRIMARY KEY,
   nazwa    varchar(30)
);

CREATE TABLE religie(
   id       serial PRIMARY KEY,
   nazwa    varchar(50),
   opis     text
);

CREATE TABLE religie_dokumenty(
   id_religia        int REFERENCES religie(id) NOT NULL,
   id_dokument       int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT religie_dokumenty_pk PRIMARY KEY(id_religia, id_dokument) 
);

CREATE TABLE funkcje(
   id       serial PRIMARY KEY,
   nazwa    varchar(50)
);

-- ********************* osoby *********************

CREATE TABLE osoby(
   id             serial PRIMARY KEY,
   imie           varchar(50),
   nazwisko       varchar(50),
   plec           char(9) CHECK (plec = 'Kobieta' OR plec = 'Mężczyzna'),
   matka_biol     int REFERENCES osoby(id), 
   ojciec_biol    int REFERENCES osoby(id),
   kolor_oczu     int REFERENCES kolory(id),
   kolor_wlosow   int REFERENCES kolory(id),
   religia        int REFERENCES religie(id) -- moga sie zmieniac - chcemy to notowac?
);

CREATE TABLE rody(
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
   zalozyciel  int REFERENCES osoby(id),
   stolica     int REFERENCES ziemie(id_miejsce), --musi być miasto
    -- moze byc tez np. obrazek wpisany bezposrednio do bazy lub tez wpisany tylko odnosnik w tabeli rody_dokumenty z typem 'godlo'
   godlo       int REFERENCES dokumenty(id),
   dewiza      varchar(300) 
);

CREATE TABLE rody_dokumenty(
   id_rodu          int REFERENCES rody(id),
   id_dokument      int REFERENCES dokumenty(id),
   CONSTRAINT rody_dokumenty_pk PRIMARY KEY(id_rodu, id_dokument) 
);

CREATE TABLE rody_wydarzenia(
   id_rodu             int REFERENCES rody(id) NOT NULL,
   id_wydarzenie       int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT rody_wydarzenia_pk PRIMARY KEY(id_rodu, id_wydarzenie) 
);

CREATE TABLE rody_ziemie(
   id_rodu     int REFERENCES rody(id) NOT NULL,
   id_ziemia   int REFERENCES ziemie(id_miejsce) NOT NULL,
   CONSTRAINT rody_ziemie_pk PRIMARY KEY(id_rodu,id_ziemia)
);

CREATE TABLE rody_zaleznosci(
   id                serial PRIMARY KEY,
   rod_podlegly      int REFERENCES rody(id) NOT NULL,
   rod_nadrzedny     int REFERENCES rody(id) NOT NULL,
   id_wydarzenie     int REFERENCES wydarzenia(id) -- wydarzenie, po ktorym zmienily sie zaleznosci
   -- trigger - nie moze byc cyklu w zaleznosciach
);

CREATE TABLE osoby_rody(
   id_osoba       int REFERENCES osoby(id),
   id_rodu        int REFERENCES rody(id),
    -- wydarzenie, ktore spowodowalo, ze osoba zaczela nalezec do rodu, np. narodziny, malzenstwo, przygarniecie
    -- check: tylko okreslone wydarzenia moga spowodowac zmiane przynaleznosci
   wydarzenie     int REFERENCES wydarzenia(id),
   CONSTRAINT osoby_rody_pk PRIMARY KEY(id_osoba, id_rodu) 
);

CREATE TABLE osoby_funkcje(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_funkcja           int REFERENCES funkcje(id) NOT NULL,
   -- zamiast dat mozna tez zrobic odnosniki do wydarzen, gdzie moga byc wpisane szczegoly, np. dlaczego osoba zmienila pelniony zawod
   data_rozpoczecia     date, -- moze byc NULL, kiedy data jest nieznana
   data_zakonczenia     date CHECK (data_zakonczenia >= data_rozpoczecia)
   -- triggery: np. tylko jeden krol naraz
);

CREATE TABLE osoby_dokumenty(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_dokument          int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT osoby_dokumenty_pk PRIMARY KEY(id_osoba, id_dokument) 
);

CREATE TABLE osoby_wydarzenia(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_wydarzenie        int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT osoby_wydarzenia_pk PRIMARY KEY(id_osoba, id_wydarzenie)
   -- trigger - np. dla danej osoby tylko jedne możliwe narodziny, śmierć - chyba, że była wskrzeszona, wtedy wskrzeszenie musi być po śmierci :)
);

END;