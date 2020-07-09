/** 
 * Autori:
 * -------
 * René Bolf        <xbolfr00@stud.fit.vutbr.cz>
 * Radoslav Grenčík <xgrenc00@stud.fit.vutbr.cz>
 */

-- Zmazanie indexu --
DROP INDEX index1;

-- Zmazanie triggerov --
DROP TRIGGER autoink_trening;
DROP TRIGGER autoink_trener_tim;
DROP TRIGGER autoink_hrac_tim;
DROP TRIGGER autoink_vybavenie;
DROP TRIGGER autoink_zapas_domaci;
DROP TRIGGER autoink_zapas_hostia;
DROP TRIGGER autoink_sportovisko;
DROP TRIGGER goalkeeper;

-- Zmazanie procedur --
DROP PROCEDURE SUM_VYBAVENIE;
DROP PROCEDURE SUM_SCORE;

-- Zmazanie sekvencii --
DROP SEQUENCE seq_trening;
DROP SEQUENCE seq_trener_tim;
DROP SEQUENCE seq_hrac_tim;
DROP SEQUENCE seq_vybavenie;
DROP SEQUENCE seq_zapas_domaci; 
DROP SEQUENCE seq_zapas_hostia; 
DROP SEQUENCE seq_sportovisko; 

-- Zmazanie tabuliek --
DROP TABLE tim CASCADE CONSTRAINTS;
DROP TABLE hrac CASCADE CONSTRAINTS;
DROP TABLE "HRAC_TRENING" CASCADE CONSTRAINTS;
DROP TABLE trener CASCADE CONSTRAINTS;
DROP TABLE "TRENER_TRENING" CASCADE CONSTRAINTS;
DROP TABLE trening CASCADE CONSTRAINTS;
DROP TABLE "TRENER_TIM" CASCADE CONSTRAINTS;
DROP TABLE "HRAC_TIM" CASCADE CONSTRAINTS;
DROP TABLE vybavenie CASCADE CONSTRAINTS;
DROP TABLE "VYBAVENIE_CENA" CASCADE CONSTRAINTS;
DROP TABLE "ZAPAS_DOMACI" CASCADE CONSTRAINTS;
DROP TABLE "ZAPAS_HOSTIA" CASCADE CONSTRAINTS;
DROP TABLE sportovisko CASCADE CONSTRAINTS;

-- Vytvorenie tabuliek --
CREATE TABLE tim(
ICO_tim VARCHAR2(8) NOT NULL CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$')),
typ VARCHAR2(50) NOT NULL
CHECK(typ = 'zeny' OR typ = 'muzi' OR typ = 'juniori' OR typ = 'kadeti' OR typ = 'seniori')
);

CREATE TABLE hrac(
reg_cislo VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(reg_cislo, '^[0-9]{7}$')),
meno VARCHAR2(50) NOT NULL,
priezvisko VARCHAR2(50) NOT NULL,
ulica VARCHAR2(50),
cislo SMALLINT NOT NULL CHECK(cislo > 0),
PSC VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(PSC, '^[0-9]{5}$')),
mesto VARCHAR2(50) NOT NULL,
datum_narodenia DATE NOT NULL,
vyska NUMBER(4,1) NOT NULL,
CONSTRAINT chk_vyska CHECK(vyska >= 50 and vyska <= 250),
hmotnost NUMBER(4,1) NOT NULL,
CONSTRAINT chk_hmotnost CHECK(hmotnost >= 10 and hmotnost <= 200)
);

CREATE TABLE "HRAC_TRENING"(
reg_cislo VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(reg_cislo, '^[0-9]{7}$')),
ID_trening SMALLINT NOT NULL CHECK(ID_trening > 0)
);

CREATE TABLE trener(
ID_trener VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(ID_trener, '^[0-9]{7}$')),
meno VARCHAR2(50) NOT NULL,
priezvisko VARCHAR2(50) NOT NULL,
ulica VARCHAR2(50),
cislo SMALLINT NOT NULL CHECK(cislo > 0),
PSC VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(PSC, '^[0-9]{5}$')),
mesto VARCHAR2(50) NOT NULL,
datum_narodenia DATE NOT NULL
);

CREATE TABLE "TRENER_TRENING"(
ID_trener VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(ID_trener, '^[0-9]{7}$')),
ID_trening SMALLINT NOT NULL CHECK(ID_trening > 0)
);

CREATE TABLE trening(
ID_trening SMALLINT NOT NULL CHECK(ID_trening > 0),
typ VARCHAR2(50) NOT NULL
CHECK(typ = 'kondicny' OR typ = 'technicky' OR typ = 'brankarsky' OR typ = 'silovy' OR typ = 'individualny'),
-- foreign keys --
ID_sportovisko SMALLINT NOT NULL CHECK(ID_sportovisko > 0),
ICO_tim VARCHAR2(8) CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$')),
ID_trener VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(ID_trener, '^[0-9]{7}$'))
);

CREATE TABLE "TRENER_TIM"(
"ID" SMALLINT NOT NULL CHECK("ID" > 0),
ID_trener VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(ID_trener, '^[0-9]{7}$')),
ICO_tim VARCHAR2(8) NOT NULL CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$')),
funkcia VARCHAR2(50) NOT NULL
CHECK(funkcia = 'hlavny' OR funkcia = 'asistent' OR funkcia = 'brankarsky' OR funkcia = 'silovy' OR funkcia = 'technicky' OR funkcia = 'kondicny')
);

CREATE TABLE "HRAC_TIM"(
"ID" SMALLINT NOT NULL CHECK("ID" > 0),
reg_cislo VARCHAR2(7) NOT NULL CHECK(REGEXP_LIKE(reg_cislo, '^[0-9]{7}$')),
ICO_tim VARCHAR2(8) NOT NULL CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$')),
pozicia VARCHAR2(50) NOT NULL
CHECK(pozicia = 'brankar' OR pozicia = 'obranca' OR pozicia = 'utocnik' OR pozicia = 'zaloznik'),
cislo_dresu SMALLINT NOT NULL CHECK(cislo_dresu >= 1 and cislo_dresu <= 99)
);

CREATE TABLE vybavenie(
ID_vybavenie SMALLINT NOT NULL CHECK(ID_vybavenie > 0),
typ VARCHAR2(100) NOT NULL,
-- foreign keys --
ID_trener VARCHAR2(7) CHECK(REGEXP_LIKE(ID_trener, '^[0-9]{7}$')),
reg_cislo VARCHAR2(7) CHECK(REGEXP_LIKE(reg_cislo, '^[0-9]{7}$')),
ICO_tim VARCHAR2(8) CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$'))
);

CREATE TABLE "VYBAVENIE_CENA"(
typ VARCHAR2(100) NOT NULL,
cena NUMBER(10,2) NOT NULL CHECK(cena >= 0)
);

CREATE TABLE "ZAPAS_DOMACI"(
ID_zapas SMALLINT NOT NULL CHECK(ID_zapas > 0),
datum DATE NOT NULL,
cas VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(cas, '^((0|1)[0-9]|2[0-3]):[0-5][0-9]$')),
kapacita_supisky SMALLINT NOT NULL CHECK(kapacita_supisky >= 0),
nase_skore SMALLINT CHECK(nase_skore >= 0),
superovo_skore SMALLINT CHECK(superovo_skore >= 0),
-- foreign keys --
ICO_tim VARCHAR2(8) NOT NULL CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$')),
ID_sportovisko SMALLINT NOT NULL CHECK(ID_sportovisko > 0)
);

CREATE TABLE "ZAPAS_HOSTIA"(
ID_zapas SMALLINT NOT NULL CHECK(ID_zapas > 0),
datum DATE NOT NULL,
cas VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(cas, '^((0|1)[0-9]|2[0-3]):[0-5][0-9]$')),
kapacita_supisky SMALLINT NOT NULL CHECK(kapacita_supisky >= 0),
nase_skore SMALLINT CHECK(nase_skore >= 0),
superovo_skore SMALLINT CHECK(superovo_skore >= 0),
ulica VARCHAR2(50),
cislo SMALLINT NOT NULL CHECK(cislo > 0),
PSC VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(PSC, '^[0-9]{5}$')),
mesto VARCHAR2(50) NOT NULL,
-- foreign keys --
ICO_tim VARCHAR2(8) NOT NULL CHECK(REGEXP_LIKE(ICO_tim, '^[0-9]{8}$'))
);

CREATE TABLE sportovisko(
ID_sportovisko SMALLINT NOT NULL CHECK(ID_sportovisko > 0),
typ VARCHAR2(50) NOT NULL
CHECK(typ = 'stadion' OR typ = 'posilnovna' OR typ = 'hala' OR typ = 'treningove_ihrisko'),
nazov VARCHAR2(50) NOT NULL,
ulica VARCHAR2(50),
cislo SMALLINT NOT NULL CHECK(cislo > 0),
PSC VARCHAR2(5) NOT NULL CHECK(REGEXP_LIKE(PSC, '^[0-9]{5}$')),
mesto VARCHAR2(50) NOT NULL,
vlastnictvo VARCHAR2(20) NOT NULL
CHECK(vlastnictvo = 'klub' OR vlastnictvo = 'prenajate'),
kapacita_divakov SMALLINT NOT NULL CHECK(kapacita_divakov >= 0),
kapacita_hracov SMALLINT NOT NULL CHECK(kapacita_hracov >= 0)
);

--------------------------
-- PROJEKT 4 - TRIGGERY --
--------------------------

-- Triggery pre autoinkrementáciu --
CREATE SEQUENCE seq_trening
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_trening
BEFORE INSERT ON trening
FOR EACH ROW
BEGIN
:new.ID_trening := seq_trening.nextval;
END autoink_trening;
/

CREATE SEQUENCE seq_trener_tim
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_trener_tim
BEFORE INSERT ON trener_tim
FOR EACH ROW
BEGIN
:new."ID" := seq_trener_tim.nextval;
END autoink_trener_tim;
/

CREATE SEQUENCE seq_hrac_tim
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_hrac_tim
BEFORE INSERT ON hrac_tim
FOR EACH ROW
BEGIN
:new."ID" := seq_hrac_tim.nextval;
END autoink_hrac_tim;
/

CREATE SEQUENCE seq_vybavenie
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_vybavenie
BEFORE INSERT ON vybavenie
FOR EACH ROW
BEGIN
:new.ID_vybavenie := seq_vybavenie.nextval;
END autoink_vybavenie;
/

CREATE SEQUENCE seq_zapas_domaci
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_zapas_domaci
BEFORE INSERT ON zapas_domaci
FOR EACH ROW
BEGIN
:new.ID_zapas := seq_zapas_domaci.nextval;
END autoink_zapas_domaci;
/

CREATE SEQUENCE seq_zapas_hostia
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_zapas_hostia
BEFORE INSERT ON zapas_hostia
FOR EACH ROW
BEGIN
:new.ID_zapas := seq_zapas_hostia.nextval;
END autoink_zapas_hostia;
/

CREATE SEQUENCE seq_sportovisko
START WITH 1;

CREATE OR REPLACE TRIGGER autoink_sportovisko
BEFORE INSERT ON sportovisko
FOR EACH ROW
BEGIN
:new.ID_sportovisko := seq_sportovisko.nextval;
END autoink_sportovisko;
/

-- Trigger, ktory pri priradeni hraca na poziciu brankara, prideli tomuto hracovi vybavenie "brankárske rukavice" a ak toto vybavenie neexistuje tak ho vytvori --
CREATE OR REPLACE TRIGGER goalkeeper
BEFORE INSERT OR UPDATE ON hrac_tim
FOR EACH ROW
declare stuff int;
BEGIN
IF (:new.pozicia = 'brankar') THEN
select count(*) into stuff from VYBAVENIE_CENA where typ = 'brankárske rukavice';
IF stuff = 0 THEN
INSERT INTO vybavenie_cena(typ, cena) VALUES('brankárske rukavice', '25,00');
END IF;
insert into vybavenie(typ, reg_cislo) values('brankárske rukavice', :new.reg_cislo);
END IF;
END goalkeeper;
/

---------------
-- PROCEDURY --
---------------

/** 
 * Procedura vypocita sumu vybavenia, ktore je pridelene konkretnemu clenovi futbaloveho klubu (trener/hrac/tym)
 *
 * vlastnik je stlpec reg_cislo alebo ID_trener alebo ICO_tim
 * ID_vlastnik je jeho identifikacne cislo
 */
CREATE OR REPLACE PROCEDURE SUM_VYBAVENIE(vlastnik in varchar2, ID_vlastnik in varchar2)
IS
    CURSOR kurz_hrac is select * from vybavenie natural join vybavenie_cena where reg_cislo = ID_vlastnik;
    CURSOR kurz_trener is select * from vybavenie natural join vybavenie_cena where ID_trener = ID_vlastnik;
    CURSOR kurz_tim is select * from vybavenie natural join vybavenie_cena where ICO_tim = ID_vlastnik;
    kurzrow1 kurz_hrac%ROWTYPE;
    kurzrow2 kurz_trener%ROWTYPE;
    kurzrow3 kurz_tim%ROWTYPE;
    suma number(10,2);
    counter int;
    nazov_vlastnik varchar2(50);
    bad_column exception;
    not_found exception;
BEGIN
    if upper(vlastnik) = 'REG_CISLO' then
        OPEN kurz_hrac;
        nazov_vlastnik := 'hracovi';
    elsif upper(vlastnik) = 'ID_TRENER' then
        OPEN kurz_trener;
        nazov_vlastnik := 'trenerovi';
    elsif upper(vlastnik) = 'ICO_TIM' then
        OPEN kurz_tim;
        nazov_vlastnik := 'timu';
    else
        RAISE bad_column;
    end if;
    
    suma := 0;
    counter := 0;
    
    loop
        if upper(vlastnik) = 'REG_CISLO' then
            fetch kurz_hrac into kurzrow1;
            exit when kurz_hrac%NOTFOUND;
            counter := counter + 1;
            suma := suma + kurzrow1.cena;
        elsif upper(vlastnik) = 'ID_TRENER' then
            fetch kurz_trener into kurzrow2;
            exit when kurz_trener%NOTFOUND;
            counter := counter + 1;
            suma := suma + kurzrow2.cena;
        elsif upper(vlastnik) = 'ICO_TIM' then
            fetch kurz_tim into kurzrow3;
            exit when kurz_tim%NOTFOUND;
            counter := counter + 1;
            suma := suma + kurzrow3.cena;
        end if;
    end loop;
    if counter = 0 then
        raise not_found;
    end if;
    dbms_output.put_line('Cena vybavenia, ktore patri ' || nazov_vlastnik || ': ' || ID_vlastnik || ' je ' || suma || ' €.');
EXCEPTION
    WHEN bad_column THEN
        dbms_output.put_line('ERROR: Bad column.');
    WHEN not_found THEN
        dbms_output.put_line('ERROR: Record does not exist.');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: Some other error.');
END;
/

/**
 * Procedura spocita pocet strelelnych a inkasovanych golov celeho klubu za urcite obdobie
 *
 * date1 datum od
 * date2 datum do
 */
CREATE OR REPLACE PROCEDURE SUM_SCORE(date1 zapas_domaci.datum%TYPE, date2 zapas_domaci.datum%TYPE) 
IS
    CURSOR kurz1 is select * from zapas_domaci where datum between date1 and date2;
    CURSOR kurz2 is select * from zapas_hostia where datum between date1 and date2;
    kurzrow1 kurz1%ROWTYPE;
    kurzrow2 kurz2%ROWTYPE;
    nase_score smallint;
    super_score smallint;
    counter int;
    bad_params exception;
BEGIN
    if date1 > date2 then
        RAISE bad_params;
    end if;
    counter := 0;
    nase_score := 0;
    super_score := 0;
    OPEN kurz1;
    OPEN kurz2;
    
    loop
        loop
            FETCH kurz1 into kurzrow1;
            exit when kurzrow1.nase_skore is not null or kurz1%NOTFOUND;
        end loop;
        exit when kurz1%NOTFOUND;
        counter := counter + 1;
        nase_score := nase_score + kurzrow1.nase_skore;
        super_score := super_score + kurzrow1.superovo_skore;
    end loop;
    
    loop
        loop
            FETCH kurz2 into kurzrow2;
            exit when kurzrow2.nase_skore is not null or kurz2%NOTFOUND;
        end loop;
        exit when kurz2%NOTFOUND;
        counter := counter + 1;
        nase_score := nase_score + kurzrow2.nase_skore;
        super_score := super_score + kurzrow2.superovo_skore;
    end loop;
    if counter <> 0 then
        dbms_output.put_line('V obdobi od ' || date1 || ' do ' || date2 || ' nas klub strelil ' || nase_score || ' golov a dostal ' || super_score || ' golov.');
    else
        dbms_output.put_line('V obdobi od ' || date1 || ' do ' || date2 || ' neboli odohrate ziadne zapasy.');
    end if;
EXCEPTION
    when bad_params then
        dbms_output.put_line('ERROR: Bad params.');
     WHEN OTHERS THEN
        dbms_output.put_line('ERROR: Some other error.');
END;
/

-- PRIMARY KEYS --
ALTER TABLE tim ADD CONSTRAINT PK_tim PRIMARY KEY(ICO_tim);
ALTER TABLE hrac ADD CONSTRAINT PK_hrac PRIMARY KEY(reg_cislo);
ALTER TABLE hrac_tim ADD CONSTRAINT PK_hrac_tim PRIMARY KEY("ID", reg_cislo, ICO_tim);
ALTER TABLE hrac_trening ADD CONSTRAINT PK_hrac_trening PRIMARY KEY(reg_cislo, ID_trening);
ALTER TABLE trener ADD CONSTRAINT PK_trener PRIMARY KEY(ID_trener);
ALTER TABLE trener_trening ADD CONSTRAINT PK_trener_trening PRIMARY KEY(ID_trener, ID_trening);
ALTER TABLE trening ADD CONSTRAINT PK_trening PRIMARY KEY (ID_trening);
ALTER TABLE trener_tim ADD CONSTRAINT PK_trener_tim PRIMARY KEY("ID", ID_trener,ICO_tim);
ALTER TABLE vybavenie ADD CONSTRAINT PK_vybavenie PRIMARY KEY(ID_vybavenie);
ALTER TABLE vybavenie_cena ADD CONSTRAINT PK_vybavenie_cena PRIMARY KEY(typ);
ALTER TABLE zapas_domaci ADD CONSTRAINT PK_zapas_domaci PRIMARY KEY(ID_zapas);
ALTER TABLE zapas_hostia ADD CONSTRAINT PK_zapas_hostia PRIMARY KEY(ID_zapas);
ALTER TABLE sportovisko ADD CONSTRAINT PK_sportovisko PRIMARY KEY(ID_sportovisko);

-- FOREIGN KEYS AND REFERENCES --
ALTER TABLE hrac_tim ADD CONSTRAINT FK_hrac_tim_hrac FOREIGN KEY(reg_cislo) REFERENCES hrac;
ALTER TABLE hrac_tim ADD CONSTRAINT FK_hrac_tim_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE trener_tim ADD CONSTRAINT FK_trener_tim_trener FOREIGN KEY(ID_trener) REFERENCES trener;
ALTER TABLE trener_tim ADD CONSTRAINT FK_trener_tim_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE hrac_trening ADD CONSTRAINT FK_hrac_trening_hrac FOREIGN KEY(reg_cislo) REFERENCES hrac;
ALTER TABLE hrac_trening ADD CONSTRAINT FK_hrac_trening_trening FOREIGN KEY(ID_trening) REFERENCES trening;
ALTER TABLE trener_trening ADD CONSTRAINT FK_trener_trening_trener FOREIGN KEY(ID_trener) REFERENCES trener;
ALTER TABLE trener_trening ADD CONSTRAINT FK_trener_trening_trening FOREIGN KEY(ID_trening) REFERENCES trening;
ALTER TABLE trening ADD CONSTRAINT FK_trening_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE trening ADD CONSTRAINT FK__trening_sportovisko FOREIGN KEY(ID_sportovisko) REFERENCES sportovisko;
ALTER TABLE trening ADD CONSTRAINT FK__trening_trener FOREIGN KEY(ID_trener) REFERENCES trener;
ALTER TABLE vybavenie ADD CONSTRAINT FK_vybavenie_vybavenie_cena FOREIGN KEY(typ) REFERENCES vybavenie_cena;
ALTER TABLE vybavenie ADD CONSTRAINT FK_vybavenie_trener FOREIGN KEY(ID_trener) REFERENCES trener;
ALTER TABLE vybavenie ADD CONSTRAINT FK_vybavenie_hrac FOREIGN KEY(reg_cislo) REFERENCES hrac;
ALTER TABLE vybavenie ADD CONSTRAINT FK_vybavenie_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE zapas_hostia ADD CONSTRAINT FK_zapas_hostia_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE zapas_domaci ADD CONSTRAINT FK_zapas_domaci_tim FOREIGN KEY(ICO_tim) REFERENCES tim;
ALTER TABLE zapas_domaci ADD CONSTRAINT FK_zapas_domaci_sportovisko FOREIGN KEY(ID_sportovisko) REFERENCES sportovisko;

-- Naplnenie tabuliek --
INSERT INTO tim VALUES('00001234', 'muzi');
INSERT INTO tim VALUES('00401234', 'kadeti');
INSERT INTO tim VALUES('01251234', 'seniori');
INSERT INTO tim VALUES('05401234', 'juniori');
INSERT INTO tim VALUES('10001234', 'zeny');

INSERT INTO hrac VALUES('1324756', 'Ivan',      'Kukumberg', 'Karpatská',  '17', '97411', 'Banská Bystrica', '21/11/1978', '180',   '80');
INSERT INTO hrac VALUES('1354756', 'Rastislav', 'Hnedý',     'Tatranská',  '88', '97411', 'Banská Bystrica', '30/12/1999', '175,0', '71');
INSERT INTO hrac VALUES('0324756', 'Svorad',    'Sasko',     'Saskova',    '1',  '99001', 'Veľký Krtíš',    '1/3/1968',   '183,0', '79');
INSERT INTO hrac VALUES('5324755', 'Jana',      'Papučová',  'Kvetinkova', '32', '97530', 'Veľká Mača',     '1/11/2001',  '160,7', '53');
INSERT INTO hrac VALUES('1124156', 'Markéta',   'Rubiková',  'Táslerova',  '59', '60200', 'Brno',            '24/12/2005', '155,0', '49');

-- Test triggeru goalkeeper --
select * from vybavenie; -- select nam vrati prazdnu tabulku
select * from vybavenie_cena; -- select nam vrati prazdnu tabulku
INSERT INTO hrac_tim(reg_cislo, ICO_tim, pozicia, cislo_dresu) VALUES('1324756', '00001234', 'brankar',  '1'); -- do tabulky vybavenie a vybavenie_cena pribudol zaznam
INSERT INTO hrac_tim(reg_cislo, ICO_tim, pozicia, cislo_dresu) VALUES('1354756', '05401234', 'utocnik',  '10');
INSERT INTO hrac_tim(reg_cislo, ICO_tim, pozicia, cislo_dresu) VALUES('0324756', '01251234', 'obranca',  '3');
INSERT INTO hrac_tim(reg_cislo, ICO_tim, pozicia, cislo_dresu) VALUES('5324755', '10001234', 'zaloznik', '99');
INSERT INTO hrac_tim(reg_cislo, ICO_tim, pozicia, cislo_dresu) VALUES('1124156', '10001234', 'brankar',  '12'); -- do tabulky vybavenie pribudol dalsi zaznam
select * from vybavenie; -- select nam vrati 2 zaznamy
select * from vybavenie_cena; -- select nam vrati 1 zaznam

INSERT INTO trener VALUES('1324789', 'Jaroslav',   'Huspenina', 'Polhorská',     '42', '87411', 'Japonská Bystrica',  '23/7/1963');
INSERT INTO trener VALUES('1384789', 'Ferdinand',  'Mihalnica', 'Bolonská',      '99', '35811', 'Talianska Omáčka',   '1/7/1949');
INSERT INTO trener VALUES('9999999', 'Rostislava', 'Krupicová', 'Na Príjazde',   '25', '84545', 'Bratislava',         '12/8/1955');
INSERT INTO trener VALUES('1364658', 'Sushil',     'Vetrovku',  'Staré Chrumky', '69', '69696', 'Jarná Dolná',        '30/6/1978');
INSERT INTO trener VALUES('2324789', 'Pavel',      'Bruchala',  'Žarnovická',    '2',  '98611', 'Žarnovická Jaskyňa', '3/10/1959');

INSERT INTO trener_tim(ID_trener, ICO_tim, funkcia) VALUES('1324789', '00001234', 'hlavny');
INSERT INTO trener_tim(ID_trener, ICO_tim, funkcia) VALUES('1384789', '01251234', 'technicky');
INSERT INTO trener_tim(ID_trener, ICO_tim, funkcia) VALUES('9999999', '01251234', 'brankarsky');
INSERT INTO trener_tim(ID_trener, ICO_tim, funkcia) VALUES('1364658', '05401234', 'asistent');
INSERT INTO trener_tim(ID_trener, ICO_tim, funkcia) VALUES('2324789', '10001234', 'silovy');

INSERT INTO sportovisko VALUES('1', 'stadion',            'Štadión Šťiavničky', 'Na Troskách',   '6',  '97401', 'Banská Bystrica', 'klub',      '15000', '35');
INSERT INTO sportovisko VALUES('2', 'hala',               'Hala A. Nálepku',    'Strmá',         '38', '54568', 'Brezno',          'prenajate', '500',   '25');
INSERT INTO sportovisko VALUES('3', 'treningove_ihrisko', 'Ihrisko Malá Mača',  '',              '98', '78965', 'Malá Mača',       'klub',      '200',   '25');
INSERT INTO sportovisko VALUES('4', 'posilnovna',         'Be Strong',          'Hudcova',       '70', '60200', 'Brno',            'prenajate', '0',     '30');
INSERT INTO sportovisko VALUES('5', 'stadion',            'Štadión Pasienky',   'Na Pasienkoch', '56', '84545', 'Bratislava',      'klub',      '20000', '40');

INSERT INTO trening(ID_trening,typ,ID_sportovisko,ICO_tim,ID_trener) VALUES('1', 'kondicny',     '1', '00001234', '1324789');
INSERT INTO trening(ID_trening,typ,ID_sportovisko,ICO_tim,ID_trener) VALUES('2', 'technicky',    '1', '01251234', '1384789');
INSERT INTO trening(ID_trening,typ,ID_sportovisko,ICO_tim,ID_trener) VALUES('3', 'brankarsky',   '3', '01251234', '9999999');
INSERT INTO trening(ID_trening,typ,ID_sportovisko,ICO_tim,ID_trener) VALUES('4', 'silovy',       '2', '05401234', '2324789');
INSERT INTO trening(ID_trening,typ,ID_sportovisko,ICO_tim,ID_trener) VALUES('5', 'individualny', '1', '',         '1364658');

INSERT INTO hrac_trening(reg_cislo, ID_trening) VALUES('1324756', '1');
INSERT INTO hrac_trening(reg_cislo, ID_trening) VALUES('1354756', '2');
INSERT INTO hrac_trening(reg_cislo, ID_trening) VALUES('0324756', '3');
INSERT INTO hrac_trening(reg_cislo, ID_trening) VALUES('5324755', '4');
INSERT INTO hrac_trening(reg_cislo, ID_trening) VALUES('1124156', '5');

INSERT INTO trener_trening(ID_trener, ID_trening) VALUES('1324789', '1');
INSERT INTO trener_trening(ID_trener, ID_trening) VALUES('1384789', '2');
INSERT INTO trener_trening(ID_trener, ID_trening) VALUES('9999999', '3');
INSERT INTO trener_trening(ID_trener, ID_trening) VALUES('1364658', '4');
INSERT INTO trener_trening(ID_trener, ID_trening) VALUES('2324789', '5');

INSERT INTO vybavenie_cena(typ, cena) VALUES('kopačky',             '80,00');
INSERT INTO vybavenie_cena(typ, cena) VALUES('kompresné tričko',    '35,00');
INSERT INTO vybavenie_cena(typ, cena) VALUES('mikina',              '55,99');
INSERT INTO vybavenie_cena(typ, cena) VALUES('štucne',              '19,99');

INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('1', 'kopačky',          '',        '1324756', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('2', 'kompresné tričko', '',        '5324755', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('12','mikina',           '',        '5324755', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('13','mikina',           '',        '0324756', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('14','kopačky',          '',        '0324756', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('15','štucne',           '',        '0324756', '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('3', 'mikina',           '1364658', '',        '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('4', 'mikina',           '2324789', '',        '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('11','kopačky',          '2324789', '',        '');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('5', 'štucne',           '',        '',        '10001234');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('6', 'kopačky',          '',        '',        '10001234');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('7', 'mikina',           '',        '',        '10001234');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('8', 'štucne',           '',        '',        '00001234');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('9', 'kompresné tričko', '',        '',        '00001234');
INSERT INTO vybavenie(ID_vybavenie, typ, ID_trener, reg_cislo, ICO_tim) VALUES('10','štucne',           '',        '',        '00401234');

INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('1', '22/8/2018',  '16:00', '40', '3', '0', '10001234', '5');
INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('2', '21/8/2018',  '20:05', '40', '5', '2', '00001234', '5');
INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('6', '21/8/2018',  '12:05', '40', '5', '2', '00001234', '5');
INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('3', '19/10/2018', '20:30', '40', '3', '3', '05401234', '1');
INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('4', '1/4/2018',   '18:30', '40', '0', '0', '01251234', '4');
INSERT INTO zapas_domaci(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ICO_tim, ID_sportovisko) VALUES('5', '11/11/2018', '20:45', '40', '3', '1', '10001234', '2');

INSERT INTO zapas_hostia(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ulica, cislo, PSC, mesto, ICO_tim) VALUES('1', '24/4/2018',  '11:30', '36', '0', '0', 'Pekárenská',    '8',  '60200', 'Brno',       '10001234');
INSERT INTO zapas_hostia(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ulica, cislo, PSC, mesto, ICO_tim) VALUES('2', '30/11/2018', '11:25', '36', '1', '2', 'Murilova',      '57', '84545', 'Bratislava', '00001234');
INSERT INTO zapas_hostia(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ulica, cislo, PSC, mesto, ICO_tim) VALUES('3', '27/2/2018',  '17:10', '36', '4', '0', 'Plachetnicová', '1',  '65110', 'Olomouc',    '05401234');
INSERT INTO zapas_hostia(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ulica, cislo, PSC, mesto, ICO_tim) VALUES('4', '31/1/2018',  '13:15', '36', '2', '5', 'Václavská',     '42', '42421', 'Ostrava',    '01251234');
INSERT INTO zapas_hostia(ID_ZAPAS, datum, cas, kapacita_supisky, nase_skore, superovo_skore, ulica, cislo, PSC, mesto, ICO_tim) VALUES('5', '20/8/2019',  '12:20', '36',  '', '',  'Jundrášová',    '80', '60200', 'Brno',       '10001234');

------------------------
-- PROJEKT 3 - DOTAZY --
------------------------

-- select spojenie 3 tabuliek --
-- Ktori hraci dostali vybavenie drahsie ako 50€ a aky typ vybavenia to je? Odstrante duplicity. (REG_CISLO, MENO, PRIEZVISKO, TYP) --
select distinct REG_CISLO, MENO, PRIEZVISKO, typ
from vybavenie natural join VYBAVENIE_CENA natural join HRAC
where cena > 50;

-- SELECT S GROUP BY A S AGREGACNOU FUNKCIOU --
-- Kolko trenerov maju jednotlive timy? Zoradte zostupne podla poctu trenerov. (TIM, POCET_TRENEROV) --
select ICO_TIM as tim, count(ID_TRENER) as POCET_TRENEROV
from TRENER_TIM
group by ICO_TIM
order by count(ID_TRENER) desc;

-- Select spojenie 3 tabuliek a s klauzulou IN a vnorenym selectom --
-- Ktori hraci sa zucastnili kondicneho alebo siloveho treningu? (reg_cislo, meno, priezvisko, pozicia) --
select reg_cislo, meno, priezvisko, pozicia
from hrac natural join HRAC_TRENING natural join hrac_tim
where ID_TRENING in (
select ID_TRENING from trening
where typ in ('kondicny', 'silovy')
);

-- Select spojenie 2 tabuliek a s klauzulou IN a vnorenym selectom --
-- Ktori hraci sa zucastnili domaceho zapasu v auguste 2018? (reg_cislo meno, priezvisko, pozicia) --
select reg_cislo, meno, priezvisko, pozicia
from hrac natural join HRAC_TIM
where ICO_TIM in(
select ICO_TIM from ZAPAS_DOMACI
where datum between '01/08/2018' and '31/08/2018'
);

-- select s klauzulou EXISTS --
-- Vyberte tymy, ktore maju pridelene iba stucne a nic ine. (ICO_TIM, typ) --
select t.ICO_TIM, t.typ
from tim t join vybavenie v 
on t.ICO_TIM = v.ICO_TIM where v.typ = 'štucne' and not exists(
select *
from vybavenie v
where t.ICO_TIM = v.ICO_TIM and v.typ != 'štucne'
);

-- SELECT S GROUP BY A S AGREGACNOU FUNKCIOU --
-- Aka je priemerna kapacita jednotlivych typov sportovisk? Zaokruhlite na cele cisla. (typ, priemerna_kapacita_divakov, priemerna_kapacita_hracov) --
select typ, round(avg(kapacita_divakov), 0) as priemerna_kapacita_divakov, round(avg(kapacita_hracov), 0) as priemerna_kapacita_hracov
from sportovisko
group by typ;

-- select spojenie 2 tabuliek --
-- Ktori hraci maju pridelene viac ako 1 vybavenie a kolko vybaveni? (reg_cislo, meno, priezvisko, pocet_vybaveni) --
select h.reg_cislo, h.meno, h.priezvisko, count(distinct v.ID_vybavenie) as pocet_vybaveni
from vybavenie v join hrac h on h.reg_cislo = v.reg_cislo
group by h.reg_cislo, h.meno, h.priezvisko
having count(distinct v.ID_VYBAVENIE) > 1;

-- select spojenie 2 tabuliek --
-- Kolko domacich zapasov sa odohralo v roku 2018 na stadione Pasienky? (nazov, pocet_zapasov) --
select nazov, count(ID_zapas) as pocet_zapasov
from ZAPAS_DOMACI natural join sportovisko
where typ = 'stadion' and nazov = 'Štadión Pasienky' and datum between '01/01/2018' and '31/12/2018'
group by nazov;

----------------------------------
-- PROJEKT 4 - VOLANIE PROCEDUR --
----------------------------------
set SERVEROUTPUT on;

-- correct --
exec SUM_VYBAVENIE('ICO_Tim', '00001234');

-- exception bad_column --
exec SUM_VYBAVENIE('ICTim', '00001234');

-- exception not_found --
exec SUM_VYBAVENIE('ICO_Tim', '01234'); 

-- correct --
exec SUM_SCORE('21/08/2018', '31/8/2019');

-- correct --
exec SUM_SCORE('21/08/2010', '31/8/2011');

-- exception bad_params --
exec SUM_SCORE('21/08/2020', '31/8/2019');

--------------------------------------
-- PROJEKT 4 - EXPLAIN PLAN a index --
--------------------------------------

EXPLAIN PLAN FOR
select h.reg_cislo, h.meno, h.priezvisko, count(distinct v.ID_vybavenie) as pocet_vybaveni
from vybavenie v join hrac h on h.reg_cislo = v.reg_cislo
group by h.reg_cislo, h.meno, h.priezvisko
having count(distinct v.ID_VYBAVENIE) > 1;
SELECT * FROM TABLE(DBMS_XPLAN.display);

CREATE INDEX index1 ON vybavenie(reg_cislo);

EXPLAIN PLAN FOR
select h.reg_cislo, h.meno, h.priezvisko, count(distinct v.ID_vybavenie) as pocet_vybaveni
from vybavenie v join hrac h on h.reg_cislo = v.reg_cislo
group by h.reg_cislo, h.meno, h.priezvisko
having count(distinct v.ID_VYBAVENIE) > 1;
SELECT * FROM TABLE(DBMS_XPLAN.display);

-- Pridelenie prav pouzivatelovi xbolfr00 - rola trenera --

GRANT ALL ON Trening TO xbolfr00;
GRANT ALL ON Hrac_trening TO xbolfr00;
GRANT ALL ON Trener_trening TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Tim TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Hrac TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Trener TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Hrac_tim TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Trener_tim TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Sportovisko TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Zapas_domaci TO xbolfr00;
GRANT SELECT, READ, ON COMMIT REFRESH ON Zapas_hostia TO xbolfr00;
GRANT EXECUTE ON SUM_SCORE TO xbolfr00;

-- Materializovany pohlad patriaci pouzivatelovi xbolfr00 (spusta xbolfr00) --

DROP MATERIALIZED VIEW mat_view_trener;

CREATE MATERIALIZED VIEW mat_view_trener
CACHE -- postupne optimalizuje citanie z materializovaneho pohladu
BUILD IMMEDIATE -- materializovany pohlad je naplneny hned po vytvoreni
REFRESH ON COMMIT AS
-- Vypis hracov prihlasenych na treningy (reg_cislo, meno, priezvisko, ID_treningu) --
SELECT XGRENC00.hrac_trening.reg_cislo, XGRENC00.hrac.meno, XGRENC00.hrac.priezvisko, XGRENC00.hrac_trening.ID_trening
from XGRENC00.hrac join XGRENC00.hrac_trening on XGRENC00.hrac.reg_cislo = XGRENC00.hrac_trening.reg_cislo;

-- Demonstracia --
select * from mat_view_trener;
INSERT INTO XGRENC00.hrac_trening(reg_cislo, ID_trening) VALUES('1354756', '1');
select * from mat_view_trener;
COMMIT; -- materializovany pohlad sa zaktualizuje
select * from mat_view_trener;
