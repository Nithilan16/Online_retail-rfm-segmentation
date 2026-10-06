# Segmentation RFM et Clustering — Online Retail II

Projet d'analyse de données appliqué à la segmentation client, réalisé dans le cadre d'un projet personel. L'objectif est de segmenter les clients d'une entreprise de e-commerce britannique afin d'identifier des profils actionnables pour une stratégie marketing ciblée, en combinant deux approches complémentaires : un scoring RFM par règles métier et un clustering K-Means non supervisé.

## Données

Dataset **Online Retail II** (UCI Machine Learning Repository) : transactions 
d'une entreprise de e-commerce britannique sur la période de décembre 2009 à décembre 2011, environ 1,07 million 
de lignes brutes.

Les données ne sont pas versionnées dans ce repo pour des raisons de taille. 
Pour reproduire l'analyse :
1. Télécharger le dataset depuis [UCI](https://archive.ics.uci.edu/dataset/502/online+retail+ii).
2. Le placer dans `data/raw/`.
3. Exécuter le notebook `notebooks/online_retail.ipynb`, qui génère 
   automatiquement les fichiers nettoyés dans `data/processed/`.

## Structure du repo

retail-rfm-segmentation/
├── data/
│ ├── raw/ # dataset original (non versionné)
│ └── processed/ # données nettoyées, exports SQL/CSV (non versionné)
├── notebooks/
│ └── online_retail.ipynb # exploration, nettoyage, RFM, clustering
├── sql/
│ ├── create_tables.sql # schéma relationnel documenté
│ └── rfm_cte.sql # calcul RFM en SQL (CTE, NTILE, vue vw_customer_segments)
├── powerbi/
│ ├── retail_dashboard.pbix
│ └── Visualisation_powerbi/
├── docs/
│ └── notes_exploration.md
└── README.md


## Méthodologie

1. **Exploration et nettoyage** : 
- Identification et traitement des annulations, codes produits non-valides, valeurs aberrantes, doublons, valeurs manquantes. 
- Restriction du périmètre au marché UK (92% du volume).
2. **Feature engineering** : 
- Calcul de Recency, Frequency, Monetary par client.
3. **Segmentation (Méthode 1)** : 
- Scoring RFM par quintiles, avec règles métier (Champions, Fidèles, À risque, Perdus...).
4. **Segmentation (Méthode 2)** : 
- clustering K-Means (k=4, déterminé par méthode du coude et score de silhouette).
5. **Comparaison des deux méthodes** et interprétation croisée.
6. **Reproduction en SQL** (CTE, window functions)
7. **Restitution via dashboard Power BI**  interactif (3 pages).

## Résultats clés

- **15% des clients (Champions) génèrent 60% du chiffre d'affaires total**, confirmé indépendamment par le scoring RFM et le clustering K-Means.
- Forte saisonnalité du CA, avec un pic marqué en novembre.
- Taux de rétention global de 72,5% (clients ayant passé plus d'une commande).
- Les deux méthodes de segmentation convergent fortement sur les profils extrêmes (Champions, Perdus) mais divergent sur les segments intermédiaires.

Détail complet des insights et limites : section 11 du notebook.

## Requêtes SQL

Voir [`sql/README.md`](sql/README.md) pour le détail des scripts et leur 
exécution.

## Dashboard Power BI

Voir [`powerbi/README.md`](powerbi/README.md) pour la présentation détaillée 
des 3 pages, avec captures d'écran.

## Limites principales

- Analyse restreinte au marché UK (92% du dataset d'origine), le marché étranger étant assez peu représenté dans la base de donnée.
- Divergence méthodologique entre le scoring RFM calculé en Python (`pd.qcut`) et en SQL (`NTILE`) sur la variable Frequency, documentée en section 9 du notebook.
- Gros comptes B2B/revendeurs non isolés dans un segment dédié.
- Connexion Power BI via export CSV plutôt que connexion live à la base SQLite (cf. `powerbi/README.md`).

## Outils utilisés

Python (pandas, scikit-learn, matplotlib/seaborn), SQL (SQLite), Power BI.