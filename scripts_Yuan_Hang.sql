-- Nous avonsprécisé le chemin pour enregistrer le fichier log C:/temp/... mais nous ne connaissons pas si c'est le même chemin dans votre ordinateur

SPOOL C:\temp\Execution_hang_yuan.log

connect system/Pise2025

SHOW USER

prompt '--> Suppression du schéma'

DROP USER hayu cascade;

prompt '--> Création du schéma'
CREATE USER hayu IDENTIFIED BY hangyuan2026 ;

SHOW USER

prompt '--> Attribut des privilèges'
GRANT  connect TO hayu ;
GRANT  create table TO hayu ;
GRANT  create view TO hayu ;
GRANT  create any index TO hayu ;
GRANT  create synonym TO hayu ;
GRANT  create sequence TO hayu ;

prompt '--> Suppression des tablespaces'
DROP TABLESPACE DATA_HY_PISE INCLUDING CONTENTS AND DATAFILES ;
DROP TABLESPACE INDX_HY_PISE INCLUDING CONTENTS AND DATAFILES ;

prompt '--> Création des tablespaces'
CREATE TABLESPACE DATA_HY_PISE
DATAFILE 
'C:/Apps/oradata/Data_Hy_Pise_1.dbf' SIZE 256 m,
'C:/Apps/oradata/Data_Hy_Pise_2.dbf' SIZE 256 m,
'C:/Apps/oradata/Data_Hy_Pise_3.dbf' SIZE 256 m
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE INDX_HY_PISE
DATAFILE 
'C:/Apps/oradata/Indx_Hy_Pise_1.dbf' SIZE 128 m,
'C:/Apps/oradata/Indx_Hy_Pise_2.dbf' SIZE 256 m
SEGMENT SPACE MANAGEMENT AUTO;

ALTER USER hayu DEFAULT TABLESPACE DATA_HY_PISE ;

ALTER USER hayu QUOTA UNLIMITED ON DATA_HY_PISE ;

ALTER USER hayu DEFAULT TABLESPACE INDX_HY_PISE ;

ALTER USER hayu QUOTA UNLIMITED ON INDX_HY_PISE ;

connect hayu/hangyuan2026

prompt '--> Création des tables'
CREATE TABLE  DEMANDE
(
	Num_demande   	         VARCHAR2(20),
	Date_creation	         DATE,
	Date_MAJ                 DATE,
	Num_client       	     VARCHAR2(20),
	id_canal     	         VARCHAR2(20),
	Code_intervenant         VARCHAR2(20),
	Code_type_demande        VARCHAR2(20),
	Code_produit	         VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  CLIENT
(
	Num_client   	         VARCHAR2(20),
	Nom_client   	         VARCHAR2(20),
	Prenom_client            VARCHAR2(20),
	Adresse         	     VARCHAR2(30),
	Tel                      NUMBER,
	Email        	         VARCHAR2(20),
	Code_civilite            NUMBER
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_CIVILITE
(
	Code_civilite   	     NUMBER,
	Libelle_civilite         VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  CANAL_EMISSION
(
	id_canal        	     VARCHAR2(20),
	Type_canal               VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_TYPE_DECISION
(
	Code_type_decision        NUMBER,
	Libelle_type_decision     VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  HISTORIQUE_DECISION
(
	Num_demande               VARCHAR2(20),
	Code_type_decision        NUMBER,
	Date_decision             DATE,
	Confidentialite_decision  VARCHAR2(80),
	Contenu_decision          VARCHAR2(80),
	Statut_decision           VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_STATUTS
(
	Code_statut               NUMBER,
	Libelle_statut            VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  HISTORIQUE_STATUT_DEMANDE
(
	Num_demande               VARCHAR2(20),
	Code_statut               NUMBER,
	Motif_changement_statut   VARCHAR2(80),
	Date_debut                DATE,
	Date_fin                  DATE
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  PRODUIT
(
	Code_produit              VARCHAR2(20),
	Libelle_produit           VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_TYPE_INTERACTION
(
	Code_type_interaction     NUMBER,
	Libelle_type_interaction  VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  HISTORIQUE_INTERACTION
(
	Num_demande               VARCHAR2(20),
	Code_type_interaction     NUMBER,
	Date_interaction          DATE,
	Statut_interaction        VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_TYPE_DEMANDE
(
	Code_type_demande         VARCHAR2(20),
	Libelle_type_demande      VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  PRODUCTEUR
(
	Code_intervenant           VARCHAR2(20),
	Code_commercial           VARCHAR2(20),
	Code_reseau               VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  REF_TYPE_EVENEMENT
(
	Code_type_evenement       NUMBER,
	Libelle_evenement         VARCHAR2(100)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  HISTORIQUE_EVENEMENT
(
	Num_demande               VARCHAR2(20),
	Code_type_evenement       NUMBER,
	Date_evenement            DATE,
	Commentaire_evenement     VARCHAR2(80)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  EMETTEUR
(
	Code_emetteur             VARCHAR2(20),
	Origine                   VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

CREATE TABLE  EST_EMIS_PAR
(
	Num_demande               VARCHAR2(20),
	Code_emetteur             VARCHAR2(20)
) TABLESPACE DATA_HY_PISE ;

prompt '--> Création des PKs'
ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE_PK PRIMARY KEY (Num_demande) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE CLIENT ADD CONSTRAINT CLIENT_PK PRIMARY KEY (Num_client) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_CIVILITE ADD CONSTRAINT REF_CIVILITE_PK PRIMARY KEY (Code_civilite) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE CANAL_EMISSION ADD CONSTRAINT CANAL_EMISSION_PK PRIMARY KEY (id_canal) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_TYPE_DECISION ADD CONSTRAINT REF_TYPE_DECISION_PK PRIMARY KEY (Code_type_decision) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE HISTORIQUE_DECISION ADD CONSTRAINT HISTORIQUE_DECISION_PK PRIMARY KEY (Num_demande, Code_type_decision) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_STATUTS ADD CONSTRAINT REF_STATUTS_PK PRIMARY KEY (Code_statut) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE HISTORIQUE_STATUT_DEMANDE ADD CONSTRAINT HISTORIQUE_STATUT_DEMANDE_PK PRIMARY KEY (Num_demande, Code_statut) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE PRODUIT ADD CONSTRAINT PRODUIT_PK PRIMARY KEY (Code_produit) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_TYPE_INTERACTION ADD CONSTRAINT REF_TYPE_INTERACTION_PK PRIMARY KEY (Code_type_interaction) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE HISTORIQUE_INTERACTION ADD CONSTRAINT HISTORIQUE_INTERACTION_PK PRIMARY KEY (Num_demande, Code_type_interaction) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_TYPE_DEMANDE ADD CONSTRAINT REF_TYPE_DEMANDE_PK PRIMARY KEY (Code_type_demande) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE PRODUCTEUR ADD CONSTRAINT PRODUCTEUR_PK PRIMARY KEY (Code_intervenant) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE REF_TYPE_EVENEMENT ADD CONSTRAINT REF_TYPE_EVENEMENT_PK PRIMARY KEY (Code_type_evenement) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE HISTORIQUE_EVENEMENT ADD CONSTRAINT HISTORIQUE_EVENEMENT_PK PRIMARY KEY (Num_demande, Code_type_evenement) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE EMETTEUR ADD CONSTRAINT EMETTEUR_PK PRIMARY KEY (Code_emetteur) USING INDEX TABLESPACE INDX_HY_PISE ;
ALTER TABLE EST_EMIS_PAR ADD CONSTRAINT EST_EMIS_PAR_PK PRIMARY KEY (Num_demande, Code_emetteur) USING INDEX TABLESPACE INDX_HY_PISE ;

prompt '--> Création des FKs'
ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE1_FK
FOREIGN KEY (Num_Client) REFERENCES CLIENT(Num_Client) ;

ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE2_FK
FOREIGN KEY (id_canal) REFERENCES CANAL_EMISSION(id_canal) ;

ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE3_FK
FOREIGN KEY (Code_intervenant) REFERENCES PRODUCTEUR(Code_intervenant) ;

ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE4_FK
FOREIGN KEY (Code_type_demande) REFERENCES REF_TYPE_DEMANDE(Code_type_demande) ;

ALTER TABLE DEMANDE ADD CONSTRAINT DEMANDE5_FK
FOREIGN KEY (Code_produit) REFERENCES PRODUIT(Code_produit) ;

ALTER TABLE CLIENT ADD CONSTRAINT CLIENT_FK
FOREIGN KEY (Code_civilite) REFERENCES REF_CIVILITE(Code_civilite) ;

ALTER TABLE HISTORIQUE_DECISION ADD CONSTRAINT HISTORIQUE_DECISION1_FK
FOREIGN KEY (Num_demande) REFERENCES DEMANDE(Num_demande) ;

ALTER TABLE HISTORIQUE_DECISION ADD CONSTRAINT HISTORIQUE_DECISION2_FK
FOREIGN KEY (Code_type_decision) REFERENCES REF_TYPE_DECISION(Code_type_decision) ;

ALTER TABLE HISTORIQUE_STATUT_DEMANDE ADD CONSTRAINT HISTORIQUE_STATUT_DEMANDE1_FK
FOREIGN KEY (Num_demande) REFERENCES DEMANDE(Num_demande) ;

ALTER TABLE HISTORIQUE_STATUT_DEMANDE ADD CONSTRAINT HISTORIQUE_STATUT_DEMANDE2_FK
FOREIGN KEY (Code_statut) REFERENCES REF_STATUTS(Code_statut) ;

ALTER TABLE HISTORIQUE_INTERACTION ADD CONSTRAINT HISTORIQUE_INTERACTION1_FK
FOREIGN KEY (Num_demande) REFERENCES DEMANDE(Num_demande) ;

ALTER TABLE HISTORIQUE_INTERACTION ADD CONSTRAINT HISTORIQUE_INTERACTION2_FK
FOREIGN KEY (Code_type_interaction) REFERENCES REF_TYPE_INTERACTION(Code_type_interaction) ;

ALTER TABLE HISTORIQUE_EVENEMENT ADD CONSTRAINT HISTORIQUE_EVENEMENT1_FK
FOREIGN KEY (Num_demande) REFERENCES DEMANDE(Num_demande) ;

ALTER TABLE HISTORIQUE_EVENEMENT ADD CONSTRAINT HISTORIQUE_EVENEMENT2_FK
FOREIGN KEY (Code_type_evenement) REFERENCES REF_TYPE_EVENEMENT(Code_type_evenement) ;

ALTER TABLE EST_EMIS_PAR ADD CONSTRAINT EST_EMIS_PAR1_FK
FOREIGN KEY (Num_demande) REFERENCES DEMANDE(Num_demande) ;

ALTER TABLE EST_EMIS_PAR ADD CONSTRAINT EST_EMIS_PAR2_FK
FOREIGN KEY (Code_emetteur) REFERENCES EMETTEUR(Code_emetteur) ;

prompt '--> Ajout des données du référentiel '
INSERT INTO REF_TYPE_DEMANDE (Code_type_demande, Libelle_type_demande) 
VALUES ('ADHPRE', 'Demande d’adhésion à la prévoyance individuelle') ;

INSERT INTO REF_TYPE_DEMANDE (Code_type_demande, Libelle_type_demande) 
VALUES ('SUCCDM', 'Demande de succession') ;

INSERT INTO REF_TYPE_DEMANDE (Code_type_demande, Libelle_type_demande) 
VALUES ('INDEM', 'Demande d’indemnisation') ;

-- On n'a pas créé la séquence quand on insère le code pour ces tableaux référenciels ci-dessous, parce que les données dans ces tableaux sont déjà prédéfinis et on ne va pas insérer d'autres lignes. 

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (1, 'Création initiale') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (2, 'En cours de traitement') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (3, 'En attente') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (4, 'Annulé') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (5, 'Terminé') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (6, 'Traité') ;

INSERT INTO REF_STATUTS (Code_statut, Libelle_statut) 
VALUES (7, 'Clôturé') ;

INSERT INTO REF_CIVILITE (Code_civilite, Libelle_civilite) 
VALUES (1, 'M. Monsieur') ;

INSERT INTO REF_CIVILITE (Code_civilite, Libelle_civilite) 
VALUES (2, 'MME. Madame') ;

INSERT INTO REF_TYPE_INTERACTION (Code_type_interaction, Libelle_type_interaction) 
VALUES (1, 'Appel téléphonique du client') ;

INSERT INTO REF_TYPE_INTERACTION (Code_type_interaction, Libelle_type_interaction) 
VALUES (2, 'En cours de traitement') ;

INSERT INTO REF_TYPE_INTERACTION (Code_type_interaction, Libelle_type_interaction) 
VALUES (3, 'Email reçu') ;

INSERT INTO REF_TYPE_INTERACTION (Code_type_interaction, Libelle_type_interaction)  
VALUES (4, 'Réponse à un email') ;

INSERT INTO REF_TYPE_DECISION (Code_type_decision, Libelle_type_decision) 
VALUES (1, 'Décision temporaire') ;

INSERT INTO REF_TYPE_DECISION (Code_type_decision, Libelle_type_decision) 
VALUES (2, 'Décision finale') ;

INSERT INTO REF_TYPE_DECISION (Code_type_decision, Libelle_type_decision) 
VALUES (3, 'Ajourné') ;

INSERT INTO REF_TYPE_EVENEMENT (Code_type_evenement, Libelle_evenement) 
VALUES (1, 'Création initiale') ;

INSERT INTO REF_TYPE_EVENEMENT (Code_type_evenement, Libelle_evenement) 
VALUES (2, 'Prise de décision') ;

INSERT INTO REF_TYPE_EVENEMENT (Code_type_evenement, Libelle_evenement)  
VALUES (3, 'Modification du statut') ;

INSERT INTO REF_TYPE_EVENEMENT (Code_type_evenement, Libelle_evenement)   
VALUES (4, 'Complément du dossier après remplissage du questionnaire') ;

COMMIT;

--1
SELECT hisdec.Date_decision, hisdec.Confidentialite_decision, hisdec.Contenu_decision, 
	   hisdec.Statut_decision, dem.Num_demande, RTD.Code_type_decision, RTD.Libelle_type_decision
FROM HISTORIQUE_DECISION hisdec
INNER JOIN DEMANDE dem ON (hisdec.Num_demande = dem.Num_demande)
INNER JOIN REF_TYPE_DECISION RTD ON (hisdec.Code_type_decision = RTD.Code_type_decision)
WHERE upper(dem.Num_demande)='ADH1452';

--2
SELECT pdc.Code_intervenant, pdc.Code_commercial, pdc.Code_reseau, dem.Num_demande, cli.Nom_client, cli.Prenom_client
FROM PRODUCTEUR pdc
INNER JOIN DEMANDE dem ON (pdc.Code_intervenant = dem.Code_intervenant)
INNER JOIN CLIENT cli ON (dem.Num_Client = cli.Num_Client)
WHERE upper(cli.Nom_client) = 'DURAND' AND upper(cli.Prenom_client) = 'PHILIPPE';

--3
SELECT 
Dde.Num_Demande, Dde.Date_Creation, Dde.Date_MAJ
FROM Demande Dde 
INNER JOIN Historique_interaction HI ON (Dde.Num_Demande= HI.Num_Demande)
INNER JOIN Ref_type_interaction REFTI ON (REFTI.code_Type_interaction = HI.code_Type_interaction)
WHERE UPPER(REFTI.Libelle_type_interaction) LIKE '%email%' ;

--4
SELECT 
Dde.Num_Demande, Dde.Date_Creation, Dde.Date_MAJ, HSD.Date_debut, REFS.Libelle_statut
FROM Demande Dde 
INNER JOIN Historique_statut_demande HSD ON (Dde.Num_Demande= HSD.Num_Demande)
INNER JOIN Ref_statuts REFS ON (REFS.code_statut = HSD.code_statut)
WHERE UPPER(REFS.libelle_statut) = 'CLOTURE' AND TO_CHAR(HSD.Date_debut, 'DD-MM-YYYY') = '10/02/2025';

--5
SELECT COUNT(Historique_evenement.Num_Demande), 
Ref_Type_evenement.Libelle_evenement
FROM Historique_evenement
INNER JOIN Ref_Type_evenement ON (Ref_Type_evenement.code_type_evenement = Historique_evenement.code_type_evenement)
GROUP BY Ref_Type_evenement.Libelle_evenement
HAVING COUNT(Historique_evenement.Num_Demande) = 
(SELECT MAX(Nb_evenement)
  FROM (SELECT COUNT(Historique_evenement.Num_Demande) AS Nb_evenement
        FROM Historique_evenement
        GROUP BY Ref_Type_evenement.Libelle_evenement));

--6
SELECT 
Demande.Num_Demande, 
Demande.Date_Creation, 
Ref_Type_decision.libelle_type_decision, 
Historique_decision.Contenu_decision, 
MAX(Historique_decision.Date_decision)
FROM Demande
INNER JOIN Historique_decision ON (Historique_decision.Num_Demande= Demande.Num_Demande)
INNER JOIN Ref_Type_decision ON (Ref_Type_decision.code_Type_decision= Historique_decision. code_Type_decision)
WHERE Demande.Num_Demande= 'ADH1452'
GROUP BY Demande.Num_Demande, Demande.Date_Creation, Ref_Type_decision.libelle_type_decision, Historique_decision.Contenu_decision ;


--7
SELECT 
COUNT(Demande.Num_Demande), 
Demande.Code_intervenant
FROM Demande
GROUP BY Demande.Code_intervenant;

--8
SELECT 
Demande.Code_intervenant, 
COUNT(Demande.Num_Demande)
FROM Demande
GROUP BY Demande.Code_intervenant
HAVING COUNT(Demande.Num_Demande) = 
(SELECT MAX(Nb_demandes)
  FROM (SELECT COUNT(Demande.Num_Demande) as Nb_demandes
               FROM Demande
               GROUP BY Demande.Code_intervenant ));

--9
SELECT 
Client.Num_client, 
Client.Nom_client, 
Client.Prenom_client, 
Demande.Num_Demande, 
Demande.Date_creation
FROM Client
INNER JOIN Demande ON (Demande.Num_client = Client.Num_client)
WHERE Demande.Date_creation = (SELECT MIN( Demande.Date_creation) FROM Demande);

--10
SELECT 
Historique_evenement.Code_type_evenement,
Ref_type_evenement.Libelle_evenement, 
Historique_evenement.Date_evenement
FROM Historique_evenement
INNER JOIN Ref_type_evenement ON (Historique_evenement.Code_type_evenement = Ref_type_evenement.Code_type_evenement)
WHERE Historique_evenement.Date_evenement BETWEEN to_date('01/01/2025', 'dd/mm/yyyy') AND to_date('18/03/2025', 'dd/mm/yyyy');

SPOOL OFF ;