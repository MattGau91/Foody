#Drop database if exists projet_foody;
create database if not exists projet_foody;
use projet_foody;


CREATE TABLE IF NOT EXISTS categorie
(
CodeCateg int primary key,
NomCateg varchar(25),
Descriptionn varchar(50)
) ;

CREATE TABLE IF NOT EXISTS messager
(
NoMess INT primary key,
NomMess varchar(45),
tel varchar(25)
) ;

CREATE TABLE IF NOT EXISTS fournisseur
(
NoFour int primary key,
Societe varchar(50),
Contact varchar(25),
Fonction varchar(50),
Adresse varchar(150),
Ville varchar(25),
Region varchar(25),
CodePostal varchar(50),
Pays varchar(25),
Tel varchar(25),
Fax varchar(25),
PageAccueil varchar(150)
) ;

CREATE TABLE IF NOT EXISTS cliente
(
Codecli varchar(30) primary key,
Contact varchar(50),
Fonction varchar(50),
Adresse varchar(150),
Ville varchar(30),
Region varchar (45),
Codepostal varchar (45),
Pays varchar(25),
Tel varchar(25),
Fax varchar(25)
) ;

CREATE TABLE IF NOT EXISTS produit
(
RefProd INT primary key,
NomProd varchar(45),
NoFour int,
CodeCateg int,
PrixUnit int,
UnitesCom numeric (45),
NiveauReap int,
Indisponible varchar(25),
FOREIGN KEY (CodeCateg) REFERENCES categorie (CodeCateg)
) ;

CREATE TABLE IF NOT EXISTS detailscommande
(
NoCom int,
RefProd int,
PrixUnit float,
Qte int,
Remise float,
primary key (NoCom,RefProd),
foreign key (RefProd) references Produit(RefProd)
) ;


CREATE TABLE IF NOT EXISTS employe
(
NoEmp INT primary key,
Nom varchar(25),
Prenom varchar(25),
Fonction varchar(50),
TitreCourtoisie varchar(25),
DateNaissance date,
DateEmpauche date,
Adresse varchar(50),
Ville varchar(25),
Region varchar(25),
Codepostal varchar(25),
Pays varchar(25),
TelDom varchar(25),
Extension int,
RendComptEA int,
FOREIGN KEY (RendComptEA) REFERENCES employe (NoEmp)
) ;

CREATE TABLE IF NOT EXISTS commande
(
NoCom INT primary key,
Codecli varchar(30),
NoEmp int,
DateCom date,
ALiveAvant date,
DateEnv date,
NoMess int,
Portt float,
Destinataire varchar(50),
AdrLiv varchar(50),
VilleLiv varchar(25),
RegionLiv varchar(25),
CodepostalLiv varchar(25),
PaysLiv varchar(25),
foreign key (Codecli) references Cliente (Codecli),
foreign key (NoEmp) references employe(NoEmp),
foreign key (NoMess) references messager(NoMess)
);

alter table produit add foreign key(NoFour) references fournisseur(NoFour);

LOAD DATA LOCAL INFILE  'C:/Users/utilisateur/Documents/Python/S5/categorie.csv'
INTO TABLE categorie
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
set global local_infile=true;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
#OPT_LOCAL_INFILE=1