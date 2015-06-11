-- Skrypt tworzący wszystkie tabele i wypełniający je przykładowymi danymi --

CREATE TABLE osoby(
   id             serial PRIMARY KEY,
   imie           varchar(50),
   nazwisko       varchar(50),
   id_rodu        int REFERENCES rody(id), -- trzeba sie zastanowic, czy ma byc osobna tabela - bo moga sie zmieniac
   plec           int REFERENCES rodzaje_plci(id), -- mozna tez zrobic jako char: 'm' lub 'k', ale nie wiem, czy bedzie to wtedy 3 postac normalna
   matka_biol     int REFERENCES osoby(id),      -- check - musi byc starsza
   ojciec_biol    int REFERENCES osoby(id),      -- check - musi byc starszy
   narodziny      int REFERENCES wydarzenia(id), -- trigger - tylko jedno możliwe wydarzenie, typ wydarzenia = narodziny
   smierc         int REFERENCES wydarzenia(id), -- trigger - tylko jedno możliwe wydarzenie, typ wydarzenia = smierc
   kolor_oczu     int REFERENCES kolory(id),
   kolor_wlosow   int REFERENCES kolory(id),
   religia        int REFERENCES religie(id), -- moga sie zmieniac - chcemy to notowac?
);

CREATE TABLE osoby_funkcje(
   id_osoba             int REFERENCES osoby(id) NOT NULL,
   id_funkcja           int REFERENCES funkcje(id) NOT NULL,
   data_rozpoczecia     date, -- moze byc NULL, kiedy data jest nieznana
   data_zakonczenia     date
   -- triggery: np. tylko jeden krol naraz
);

CREATE TABLE osoby_dokumenty(
   id_osoby             int REFERENCES osoby(id) NOT NULL,
   id_dokumentu         int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT osoby_dokumenty_pk PRIMARY KEY(id_osoby, id_dokumentu),
);

CREATE TABLE osoby_wydarzenia(
   id_osoby             int REFERENCES osoby(id) NOT NULL,
   id_wydarzenia        int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT osoby_wydarzenia_pk PRIMARY KEY(id_osoby, id_wydarzenia),
);

CREATE TABLE kolory(
   id       serial PRIMARY KEY,
   nazwa    varchar(30)
);

CREATE TABLE rodzaje_plci(
   id       serial PRIMARY KEY,
   nazwa    varchar(20)
);

CREATE TABLE rody(
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
   zalozyciel  int REFERENCES osoby(id),
   ziemie      int REFERENCES ziemie(id),
   -- godlo       ???  -- obrazek, dokument?,
   dewiza      varchar(300),
);

CREATE TABLE rody_dokumenty(
   id_rodu           int REFERENCES rody(id) NOT NULL,
   id_dokumentu      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT rody_dokumenty_pk PRIMARY KEY(id_rodu, id_dokumentu),
);

CREATE TABLE rody_wydarzenia(
   id_rodu             int REFERENCES rody(id) NOT NULL,
   id_wydarzenia       int REFERENCES wydarzenia(id) NOT NULL,
   CONSTRAINT rody_wydarzenia_pk PRIMARY KEY(id_rodu, id_wydarzenia),
   -- zaleznosci pomiedzy rodami - kto komu podlegly, moze sie zmieniac
);

CREATE TABLE religie(
   id       serial PRIMARY KEY,
   nazwa    varchar(50)
);

CREATE TABLE religie_dokumenty(
   id_religii        int REFERENCES religie(id) NOT NULL,
   id_dokumentu      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT religie_dokumenty_pk PRIMARY KEY(id_religii, id_dokumentu),
);

CREATE TABLE funkcje(
   id       serial PRIMARY KEY,
   nazwa    varchar(50)
);

-- END ********************* osoby *********************

CREATE TABLE wydarzenia(
   id       serial PRIMARY KEY,
   data     date,
   nazwa    varchar(100),
   opis     varchar(500), -- moze lepiej trzymac w osobnej tabeli, zeby nie zajmowac niepotrzebnie pamieci, albo zalozyc, ze "porzadny" opis w dokumencie
   miejsce  int REFERENCES miejsca(id),
);

CREATE TABLE wydarzenia_dokumenty(
   id_wydarzenia         int REFERENCES wydarzenia(id) NOT NULL,
   id_dokumentu          int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT wydarzenia_dokumenty_pk PRIMARY KEY(id_wydarzenia, id_dokumentu),
);

CREATE TABLE dokumenty(
   id          serial PRIMARY KEY,
   typ         int REFERENCES typy_dokumentow(id) NOT NULL,
   sciezka     varchar(250) NOT NULL, -- sciezka do pliku ?
);

CREATE TABLE typy_dokumentow(
   id          serial PRIMARY KEY,
   nazwa       varchar(100)
);

CREATE TABLE ziemie(
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
   stolica     int REFERENCES miejsca(id),
   -- wielkosc    ??? - "duzy", "maly", "sredni" czy np. w km^2?
   polozenie   varchar(100),
);

CREATE TABLE ziemie_dokumenty(
   id_ziemii         int REFERENCES ziemia(id) NOT NULL,
   id_dokumentu      int REFERENCES dokumenty(id) NOT NULL,
   CONSTRAINT ziemie_dokumenty_pk PRIMARY KEY(id_ziemii, id_dokumentu),
);

CREATE TABLE miejsca(
   id          serial PRIMARY KEY,
   nazwa       varchar(50),
);