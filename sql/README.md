# Requêtes SQL — Segmentation RFM

Ce dossier contient les scripts SQL utilisés pour reproduire le calcul RFM directement en base de données (SQLite), en complément du calcul effectué en Python dans le notebook.

## Fichiers

### `create_table.sql`
Documente le schéma relationnel de la base (`orders`, `products`, `customer_segments_python`) avec clés primaires et étrangères. Les tables sont déjà créées via l'export pandas (`to_sql()`) en section 8.3 du notebook. Ce fichier sert de documentation formelle du schéma plutôt que d'être nécessaire à l'exécution.

### `rfm_cte.sql`
Calcule Recency, Frequency et Monetary par client à partir de la table `orders`, via une CTE (Common Table Expression), puis attribue un score par quintile avec `NTILE(5)` et un segment métier via `CASE WHEN`. Enfin, il crée la vue `vw_customer_segments`.

**Limite connue** : le scoring de Frequency diverge de son équivalent Python (`pd.qcut`, limité à 4 niveaux à cause de valeurs dupliquées, contre 5 niveaux ici avec `NTILE`), entraînant un taux de divergence de segment d'environ 50% entre les deux implémentations. Documenté en détail dans la section 4-5 du notebook.

## Comment exécuter

Ces requêtes sont exécutées depuis le notebook (`notebooks/online_retail.ipynb`, section 9), via SQLAlchemy :

\`\`\`python
from sqlalchemy import text

with engine.connect() as conn:
    with open('../sql/rfm_cte.sql', 'r') as f:
        query = f.read()
    conn.execute(text(query))
    conn.commit()
\`\`\`

## Base de données

Les requêtes s'exécutent sur une base SQLite (`data/processed/online_retail.db`, non versionnée dans ce repo, cf. README principal pour la régénérer).