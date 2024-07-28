-- statistiques_colleges_db_create.sql
-- Script de création de la base de données colleges
-- Réalisé par Raphaël BARDINI & Mattéo KERVADEC (équipe C23)
-- 21/05/2024

create schema colleges;

set schema 'colleges';

-- Classes

create table _region (
  code_region varchar(2) primary key,
  libelle_region varchar(34) not null unique
);

create table _departement (
  code_du_departement varchar(3) primary key,  
  nom_departement varchar(23) not null unique,
  code_region varchar(2) not null,

  -- Cela ne prend pas en compte la cardinalité min de 1 du côté de Departement dans le diagramme de classes (qui signifie que 1 région a au moins 1 département)
  constraint departement_fk_region
    foreign key (code_region)
    references _region (code_region)
);

create table _commune (
  code_insee_de_la_commune varchar(5) primary key,
  nom_de_la_commune varchar(45) not null unique,
  code_du_departement varchar(3) not null,

  constraint commune_fk_departement
    foreign key (code_du_departement)
    references _departement (code_du_departement)
);

create table _academie (
  code_academie int primary key,
  lib_academie varchar(16) not null unique
);

create table _type (
  code_nature varchar(3) primary key,
  -- pour simuler 2 clés primaires sur une table (impossible en SQL), on la colonne unique
  libelle_nature varchar(7) not null unique
);

create table _quartier_prioritaire (
  code_quartier_prioritaire varchar(8) primary key,
  nom_quartier_prioritaire varchar(85) not null
);

create table _classe (
  -- École : ps, ms, gs, cp, ce1, ce2, cm1, cm2
  -- Collège : 6eme, 5eme, 4eme, 3eme
  -- Lycée : seconde, premiere, terminale
  id_classe varchar(9) primary key
);

create table _annee (
  annee_scolaire varchar(19) primary key
);

create table _etablissement (
  uai varchar(8) primary key,
  nom_etablissement varchar(108) not null,
  secteur varchar(18) not null,
  code_postal varchar(5) not null,
  lattitude numeric(18,16) not null,
  longitude numeric(22,20) not null,
  code_nature varchar(3) not null,
  code_academie int not null,
  code_insee_de_la_commune varchar(5) not null,

  constraint etablissement_fk_type
    foreign key (code_nature)
    references _type (code_nature),
  constraint etablissement_fk_academie
    foreign key (code_academie)
    references _academie (code_academie),
  -- Cela ne prend pas en compte la cardinalité min de 1 du côté de Etablissement dans le diagramme de classes (qui signifie que 1 commune a au moins 1 etablissement)
  constraint etablissement_fk_commune
    foreign key (code_insee_de_la_commune)
    references _commune (code_insee_de_la_commune)
);

-- Associations

create table _caracteristiques_selon_classe (
  nbre_eleves_segpa_selon_niveau int not null,
  nbre_eleves_ulis_selon_niveau int not null,
  effectif_filles int not null,
  effectif_garcons int not null,
  id_classe varchar(9) not null,
  annee_scolaire varchar(19) not null,
  uai varchar(8) not null,

  constraint caracteristiques_selon_classe_pk
    primary key (id_classe, annee_scolaire, uai),
  constraint caracteristiques_selon_classe_fk_classe
    foreign key (id_classe)
    references _classe (id_classe),
  constraint caracteristiques_selon_classe_fk_annee
    foreign key (annee_scolaire) 
    references _annee (annee_scolaire),
  constraint caracteristiques_selon_classe_fk_etablissement
    foreign key (uai)
    references _etablissement (uai)
);

-- Vue pour les attributs calculés
create view caracteristiques_selon_classe as (
  select *,
    effectif_filles
    + effectif_garcons
    - nbre_eleves_segpa_selon_niveau
    - nbre_eleves_ulis_selon_niveau
    nbre_eleves_hors_segpa_hors_ulis_selon_niveau
  from _caracteristiques_selon_classe
);

create table _caracteristiques_tout_etablissement (
  ips numeric(5, 3) not null,
  ecart_type_de_l_ips double precision not null,
  ep varchar(7) not null,
  annee_scolaire varchar(19) not null,
  uai varchar(8) not null,

  constraint caracteristiques_tout_etablissement_pk
    primary key (annee_scolaire, uai),
  constraint caracteristiques_tout_etablissement_fk_annee
    foreign key (annee_scolaire) 
    references _annee (annee_scolaire),
  constraint caracteristiques_tout_etablissement_fk_etablissement
    foreign key (uai)
    references _etablissement (uai)
);

-- Vue pour les attributs calculés
create view caracteristiques_tout_etablissement as (
  select *,
    (select sum(csc.effectif_filles + csc.effectif_garcons)
     from Caracteristiques_selon_classe csc
     where csc.uai = uai and csc.annee_scolaire = annee_scolaire)
    effectifs
  from _caracteristiques_tout_etablissement
);

create table _caracteristiques_college (
  nbre_eleves_segpa int not null,
  nbre_eleves_ulis int not null,
  annee_scolaire varchar(19) not null,
  uai varchar(8) not null,

  constraint caracteristiques_college_pk
    primary key (annee_scolaire, uai),
  constraint caracteristiques_college_fk_annee
    foreign key (annee_scolaire)
    references _annee (annee_scolaire),
  constraint caracteristiques_college_fk_etablissement
    foreign key (uai)
    references _etablissement (uai)
);

-- Vue pour les attributs calculés
create view caracteristiques_college as (
  select *,
    cte.effectifs
    - nbre_eleves_segpa
    - nbre_eleves_ulis
    nbre_eleves_hors_segpa_hors_ulis_selon_niveau
  from _caracteristiques_college
  natural join caracteristiques_tout_etablissement cte
);

create table _est_a_proximite_de (
  uai varchar(8) primary key,
  code_quartier_prioritaire varchar(8) not null,

  constraint est_a_proximite_fk_etablissement
    foreign key (uai)
    references _etablissement (uai),
  constraint est_a_proximite_fk_quartier_prioritaire
    foreign key (code_quartier_prioritaire)
    references _quartier_prioritaire (code_quartier_prioritaire)
);
