use projet_foody;

SELECT * FROM produit;

SELECT * FROM produit limit 10;

SELECT * FROM produit ORDER BY PrixUnit ASC limit 10;

Select NomProd,PrixUnit from produit order by PrixUnit desc limit 3;

#1.Lister les clients français installés à Paris dont le numéro de fax n'est pas renseigné
Select Contact from cliente where Ville="Paris" and fax is null;

#2.Lister les clients français, allemands et canadiens
Select Contact,Pays from cliente where Pays in ('France','Germany','Canada');

#3.Lister les clients dont le nom de société contient "restaurant"
select contact from cliente where Societe like "%Restaurant%";

								######################################################################

#1.Lister les descriptions des catégories de produits (table Categorie)
Select Descriptionn from categorie;

#2.Lister les différents pays et villes des clients, le tout trié par ordre alphabétique croissant du pays et décroissant de la ville
Select pays, Ville from cliente order by pays asc, Ville desc;

#3.Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)
Select NomProd from produit where QteParUnit like "%bottles%" or QteParUnit like "%can%";

#4.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
Select societe, contact,ville from fournisseur where Pays="France";

#5.Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soitexplicite
Select upper(NomProd), RefProd from produit where NoFour="8" and PrixUnit between 10 and 100;

#6.Lister les numéros d'employés ayant réalisé une commande (cf table Commande) à livrer en France, à Lille, Lyon ou Nantes
Select NoEmp,VilleLiv from commande where VilleLiv in ('Lille','Lyon','Nantes');

#7.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco", dont le prix est inférieur à 100 euros (attention à la condition à écrire)
Select NomProd, PrixUnit from produit where NomProd like "%Tofu%" or NomProd like "%Choco%" and PrixUnit < 100;

								######################################################################
                                
/*La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande.
Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, le
montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table).
Afficher donc (dans une même requête) :
- le prix unitaire,
- la remise,
- la quantité,
- le montant de la remise,
- le montant à payer pour ce produit*/

Select PrixUnit, Remise, Qte, PrixUnit*Qte*Remise as "montant de la remise", (PrixUnit*Qte) - (PrixUnit*Qte*Remise) as "Montant à payer pour ce produit" from detailscommande where NoCom="10251";

#1.A partir de la table Produit, afficher "Produit non disponible" lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
Select NomProd,
	case 
		when Indisponible = 1 then "Produit non disponible"
        when Indisponible = 0 then "Produit disponible"
	end as Disponibilité
from produit;

/*2.À partir de la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
si elle vaut 0 : "aucune remise"
si elle vaut entre 1 et 5% (inclus) : "petite remise"
si elle vaut entre 6 et 15% (inclus) : "remise modérée"
sinon :"remise importante"*/

Select *,
	case
		when Remise = 0 then "aucune remise"
        when Remise<=0.051 then "petite remise"
        when Remise<=0.151 then "remise modérée"
        else "remise importante"
	end as Discount
from detailscommande;

#3.Indiquer pour les commandes envoyées si elles ont été envoyées en retard (date d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps
Select *, 
	case
		when DateEnv-ALiveAvant >0 then "en retard"
        when DateEnv-AliveAvant<0 then "à temps"
	end as Envoie
from commande;

/*Dans une même requête, sur la table Client :
* Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau
champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
* Extraire les deux derniers caractères des codes clients
* Mettre en minuscule le nom des sociétés
* Remplacer le terme "Owner" par "Freelance" dans Fonction
* Indiquer la présence du terme "Manager" dans Fonction*/

Select concat(Adresse,Ville,CodePostal,Pays) as "Adresse_complète", right(CodeCli,2), lower(Societe),replace(Fonction,"Owner","Freelance"),
	CASE
        WHEN  (Fonction LIKE '%Manager%') THEN 'Présent Manager'
        ELSE 'Absent Manager'
    END AS Manager
from cliente;

###################################################          BONUS          ######################################################################

#1.Récupérer l'année de naissance et l'année d'embauche des employés
Select left(DateNaissance,4),left(DateEmpauche,4) from employe;

#2.Calculer à l'aide de la requête précédente l'âge d'embauche et le nombre d'années dans l'entreprise
Select left(DateEmpauche,4)-left(DateNaissance,4) as "âge d'embauche",2021-left(DateEmpauche,4) as "nb d'années E" from employe;

#3.Afficher le prix unitaire original, la remise en pourcentage, le montant de la remise et le prix unitaire avec remise (tous deux arrondis aux centimes), pour les lignes de commande dont la remise est strictement supérieure à 10%
Select PrixUnit, (Remise*100) as "remise en %", PrixUnit*Qte*Remise as "montant de la remise", PrixUnit*Remise as "remise unitaire" from detailscommande where (Remise*100)>10;

#4.Calculer le délai d'envoi (en jours) pour les commandes dont l'envoi est après la date butoir, ainsi que le nombre de jours de retard;
Select *,DateEnv-ALiveAvant as "Jours de retard" from commande where DateEnv-ALiveAvant>0;

#5.Rechercher les sociétés clientes, dont le nom de la société contient le nom du contact de celle-ci
#Select Societe from cliente where Societe like %Contact%;

									######################################################################
                                    
#1.Calculer le nombre d'employés qui sont "Sales Manager"
Select count(fonction) from employe where fonction = 'Sales Manager';

#2.Calculer le nombre de produits de moins de 50 euros
Select count(NomProd) Cheap_product from produit where PrixUnit < 50;

#3.Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks
Select count(CodeCateg) Cat_2_10_stock from produit where CodeCateg = 2 and UnitesCom >10; #il y en aurait 12 avec stock < 10.

#4.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
Select count(CodeCateg) Cat_1_four1_18 from produit where NoFour = 1 or NoFour =18;

#5.Calculer le nombre de pays différents de livraison
Select count(Distinct PaysLiv) as Pays from commande;

#6.Calculer le nombre de commandes réalisées en Aout 2006.
Select count(DateCom) from commande where left(DateCom,7)="2006-07";

									######################################################################
                                    
#1.Calculer le coût du port minimum et maximum des commandes , ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
Select min(Portt) "frais de port min", max(Portt)"frais de port max", round(avg(Portt),2) "moyenne frais de port" from commande where CodeCli="QUICK";

#2.Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des frais de port leur correspondant
Select sum(Portt),NoMess from commande group by NoMess ;

									######################################################################
                                    
#1.Donner le nombre d'employés par fonction
Select fonction, count(fonction) from employe group by fonction;

#2.Donner le montant moyen du port par messager(shipper)
Select NoMess, AVG(Portt) from commande group by NoMess;

#3.Donner le nombre de catégories de produits fournis par chaque fournisseur
Select NoFour, count(CodeCateg) from produit group by NoFour;

#4.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
Select NoFour, CodeCateg, AVG(PrixUnit) from produit group by NoFour,CodeCateg ;

									######################################################################

#1.Lister les fournisseurs ne fournissant qu'un seul produit
Select NoFour, count(NomProd) as nb from produit group by NoFour having nb=1;

#2.Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
Select CodeCateg, AVG(PrixUnit) as nb from produit group by CodeCateg having nb>50;

#3.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
Select NoFour,CodeCateg from produit group by NoFour having CodeCateg =1;

#4.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
Select NoFour,max(PrixUnit) as max_price from produit group by NoFour having max_price>50;

###################################################          BONUS          ######################################################################

#1.Donner la quantité totale commandée par les clients, pour chaque produit

#2.Donner les cinq clients avec le plus de commandes, triés par ordre décroissant

#3.Calculer le montant total des lignes d'achats de chaque commande, sans et avec remise sur les produits

#4.Pour chaque catégorie avec au moins 10 produits, calculer le montant moyen des prix

#5.Donner le numéro de l'employé ayant fait le moins de commandes

									######################################################################
                                    
#1.Récupérer les informations des fournisseurs pour chaque produit
Select * from fournisseur natural join produit;

#2.Afficher les informations des commandes du client "Lazy K Kountry Store"
Select * from cliente natural join commande where societe like "%Lazy K Kountry Store%";

#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
Select NomMess,count(NoCom) as nb_commande from commande natural join messager group by NomMess;

								######################################################################
                                
#1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
Select * from produit inner join fournisseur on produit.NoFour=fournisseur.NoFour;

#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
Select * from cliente inner join commande on cliente.Codecli=Commande.Codecli where societe like "%Lazy K Kountry Store%";

#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom),avec une jointure interne
Select NomMess,count(NoCom) as nb_commande from commande inner join messager on commande.NoMess=messager.NoMess group by NomMess;

								######################################################################
                                
#1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
Select NomProd,count(NoCom) as nbCo from produit pr left outer join detailscommande dc on pr.RefProd=dc.RefProd group by NomProd;

#2.Lister les produits n'apparaissant dans aucune commande
Select NomProd,count(NoCom) as nbCo from produit pr left outer join detailscommande dc on pr.RefProd=dc.RefProd group by NomProd having nbCo=0;

#3.Existe-t'il un employé n'ayant enregistré aucune commande ?
Select co.NoEmp, count(NoCom) as nbCo from employe as em left outer join commande as co on em.NoEmp=em.NoEmp group by NoEmp having NbCo=0;

								######################################################################
                                
#1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
Select pd.NomProd,fo.*
	from produit pd, fournisseur as fo
    where pd.NoFour=fo.NoFour;
    
#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
Select cl.societe as x,co.* 
	from cliente as cl,commande as co
	where cl.CodeCli=co.Codecli 
    having x = "Lazy K Kountry Store" ;

#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
Select count(NoCom) as nb_commandes,msg.NomMess 
	from cliente cl, commande co, messager msg
    where cl.CodeCli=co.Codecli
    and co.NoMess=msg.NoMess
    group by NomMess;

###################################################          BONUS          

/*1.Compter le nombre de produits par fournisseur
2.Compter le nombre de produits par pays d'origine des fournisseurs
3.Compter pour chaque employé le nombre de commandes gérées, même pour ceux n'en ayant fait aucune
4.Afficher le nombre de pays différents des clients pour chaque employe (en indiquant son nom et son prénom)
5.Compter le nombre de produits commandés pour chaque client pour chaque catégorie */

								######################################################################

#1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête

Select Nom, Prenom
	from employe
    where NoEmp not in(select NoEmp
		from commande);
    
#2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
Select NomProd,count(refprod) from produit
	where NoFour = (Select NoFour from fournisseur where Societe="Ma Maison") group by NomProd;
    
#3.Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
Select count(codecli) as nb_commande from commande
	where NoEmp in (Select NoEmp from employe where RendComptEA=5);
    
								######################################################################
                                
#1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS
Select NomProd from produit as np
	where not Exists (Select RefProd from detailscommande where RefProd=np.RefProd);
    
#2.Lister les fournisseurs dont au moins un produit a été livré en France
Select Societe from founisseur as fo
	where exists (Select NoFour from produit where);
#3.Liste des fournisseurs qui ne proposent que des boissons (drinks)


################################# INSTRUCTIONS POUR Data analyze ##############################################

Select PaysLiv,count(Distinct NoCom) as "Nombre de commandes" from commande group by PaysLiv order by count(Distinct NoCom) ASC;

