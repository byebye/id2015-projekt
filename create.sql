-- Skrypt tworzący wszystkie tabele i wypełniający je przykładowymi danymi --

-- ********************* dokumenty *********************

-- Na dokumenty moze wskazywac wlasciwie kazda inna tabela - dlatego w razie potrzeby robimy dodatkowa tabele w stylu: 'cos_dokumenty'
CREATE TABLE dokumenty(
   id          serial PRIMARY KEY,
   typ         int REFERENCES dokumenty_typy(id) NOT NULL,
   sciezka     varchar(250) NOT NULL, -- sciezka do pliku ?
);

CREATE TABLE dokumenty_typy(
   id          serial PRIMARY KEY,
   nazwa       varchar(100)
);

-- ********************* miejsca *********************

CREATE TABLE miejsca( -- w rodzaju miast, miasteczek
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
);

CREATE TABLE miejsca_dokumenty(
   id_miejsce       int REFERENCES ziemia(id) NOT NULL,
   id_dokument      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT miejsca_dokumenty_pk PRIMARY KEY(id_miejsce, id_dokument),
);

CREATE TABLE ziemie( -- wieksze obszary, zarzadzanie przez rody
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
   stolica     int REFERENCES miejsca(id),
   -- wielkosc    ??? - "duzy", "maly", "sredni" czy np. w km^2?
   polozenie   varchar(100),
);

CREATE TABLE ziemie_dokumenty(
   id_ziemia        int REFERENCES ziemia(id) NOT NULL,
   id_dokument      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT ziemie_dokumenty_pk PRIMARY KEY(id_ziemia, id_dokument),
);

-- ********************* wydarzenia *********************

CREATE TABLE wydarzenia(
   id                serial PRIMARY KEY,
   data              date, -- moze byc nieznana lub tylko przyblizona - czy chcemy to w jakis szczegolny sposob obslugiwac?
   nazwa             varchar(100),
   typ               int REFERENCES wydarzenia_typy(id),
   -- moze lepiej trzymac w osobnej tabeli, zeby nie zajmowac niepotrzebnie pamieci, albo tu tylko krotka notka i zalozyc, ze "porzadny" opis w dokumencie
   opis              varchar(300), 
   miejsce           int REFERENCES miejsca(id),
   czy_potwierdzone  bool, -- zrodlo o danym wydarzeniu moze byc pewne, np. kroniki lub np. na podstawie plotek, przekazywane ustnie
);

CREATE TABLE wydarzenia_typy(
   id       serial PRIMARY KEY,
   nazwa    varchar(50),
);

CREATE TABLE wydarzenia_dokumenty(
   id_wydarzenie         int REFERENCES wydarzenia(id) NOT NULL,
   id_dokument           int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT wydarzenia_dokumenty_pk PRIMARY KEY(id_wydarzenie, id_dokument),
);

-- ********************* zwiazane z osobami *********************

CREATE TABLE kolory(
   id       serial PRIMARY KEY,
   nazwa    varchar(30)
);

CREATE TABLE rody(
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
   zalozyciel  int REFERENCES osoby(id),
   ziemie      int REFERENCES ziemie(id),
    -- moze byc tez np. obrazek wpisany bezposrednio do bazy lub tez wpisany tylko odnosnik w tabeli rody_dokumenty z typem 'godlo'
   godlo       int REFERENCES dokumenty(id),
   dewiza      varchar(300),
);

CREATE TABLE rody_dokumenty(
   id_rodu           int REFERENCES rody(id) NOT NULL,
   id_dokument      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT rody_dokumenty_pk PRIMARY KEY(id_rodu, id_dokument),
);

CREATE TABLE rody_wydarzenia(
   id_rodu             int REFERENCES rody(id) NOT NULL,
   id_wydarzenie       int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT rody_wydarzenia_pk PRIMARY KEY(id_rodu, id_wydarzenie),
   -- pomyslec: zaleznosci pomiedzy rodami, kto komu podlegly -> moze sie zmieniac
);

CREATE TABLE religie(
   id       serial PRIMARY KEY,
   nazwa    varchar(50),
   opis     varchar(300),
);

CREATE TABLE religie_dokumenty(
   id_religia        int REFERENCES religie(id) NOT NULL,
   id_dokument       int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT religie_dokumenty_pk PRIMARY KEY(id_religia, id_dokument),
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
   id_rodu        int REFERENCES rody(id), -- trzeba sie zastanowic, czy ma byc osobna tabela - bo moga sie zmieniac
   plec           char, -- check: możliwe wartości 'm' lub 'k'
   matka_biol     int REFERENCES osoby(id),      -- check - musi byc starsza
   ojciec_biol    int REFERENCES osoby(id),      -- check - musi byc starszy
   kolor_oczu     int REFERENCES kolory(id),
   kolor_wlosow   int REFERENCES kolory(id),
   religia        int REFERENCES religie(id), -- moga sie zmieniac - chcemy to notowac?
);

CREATE TABLE osoby_funkcje(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_funkcja           int REFERENCES funkcje(id) NOT NULL,
   -- zamiast dat mozna tez zrobic odnosniki do wydarzen, gdzie moga byc wpisane szczegoly, np. dlaczego osoba zmienila pelniony zawod
   data_rozpoczecia     date, -- moze byc NULL, kiedy data jest nieznana
   data_zakonczenia     date
   -- triggery: np. tylko jeden krol naraz
);

CREATE TABLE osoby_dokumenty(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_dokument          int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT osoby_dokumenty_pk PRIMARY KEY(id_osoba, id_dokument),
);

CREATE TABLE osoby_wydarzenia(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_wydarzenie        int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT osoby_wydarzenia_pk PRIMARY KEY(id_osoba, id_wydarzenie),
   -- trigger - np. dla danej osoby tylko jedne możliwe narodziny, śmierć
);
