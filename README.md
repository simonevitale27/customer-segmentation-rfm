# Customer Segmentation & RFM Analysis
<img width="1322" height="763" alt="Screenshot 2026-02-15 alle 17 17 53 (2)" src="https://github.com/user-attachments/assets/fea6a47a-936d-4ab7-ba37-a0c176bdf466" />

Analisi di segmentazione clienti per e-commerce UK basata su metodologia RFM (Recency, Frequency, Monetary) su 406.829 transazioni e 4.338 clienti nel periodo 2010-2011.

**Obiettivo:** Identificare clienti ad alto valore e clienti a rischio abbandono per ottimizzare investimenti in marketing e retention.

---

## Problema Business

L'azienda e-commerce necessita di:
- Identificare i clienti più profittevoli (Champions)
- Individuare clienti fedeli a rischio abbandono (At Risk)
- Allocare budget marketing in modo efficiente
- Calcolare ROI potenziale di campagne retention

---

## Stack Tecnologico

- **Database:** MySQL 8.0
- **Linguaggio Query:** SQL (CTE, Window Functions, Aggregazioni)
- **Visualizzazione:** Power BI Desktop
- **Dataset:** UK E-commerce Public Dataset (Kaggle)

---

## Metodologia RFM

### Metriche Calcolate

**Recency (R):** Giorni dall'ultimo acquisto
```sql
DATEDIFF('2011-12-09', MAX(order_date))
```
**Frequency (F):** Numero totale ordini
```sql
COUNT(DISTINCT order_id)
```
**Monetary (M):** Valore totale speso
```sql
SUM(quantity * unit_price)
```
### Scoring Sistema

Conversione metriche grezze in score 1-5 tramite quintili:
```sql
NTILE(5) OVER (ORDER BY recency_days DESC) as R_score
NTILE(5) OVER (ORDER BY frequency ASC) as F_score
NTILE(5) OVER (ORDER BY monetary_value ASC) as M_score
```
### Segmentazione Clienti

| Segmento | Definizione | Criteri RFM |
|----------|-------------|-------------|
| **Champions** | Clienti migliori, acquistano spesso e recentemente | R=5, F=5, M=5 |
| **Loyal** | Clienti fedeli, alto valore | R≥4, F≥4 |
| **At Risk** | Erano fedeli, ora inattivi (PRIORITÀ retention) | R≤2, F≥4 |
| **Lost** | Non tornano, basso valore | R=1, F≤2 |
| **Promising** | Nuovi clienti con potenziale | R≥4, F≤2 |

---

### Distribuzione Clienti e Revenue

| Segmento | N. Clienti | % Clienti | Revenue Totale | Revenue Media/Cliente |
|----------|------------|-----------|----------------|----------------------|
| **Champions** | 348 | 8,0% | £3,35M | £9.639 |
| **Loyal** | 876 | 20,2% | £1,85M | £2.116 |
| **At Risk** | 211 | 4,9% | £389k | £1.844 |
| **Lost** | 781 | 18,0% | £379k | £485 |
| **Promising** | 233 | 5,4% | £614k | £2.636 |
| **Others** | 1.889 | 43,5% | £1,62M | £856 |

### Insights

1. **Concentrazione Revenue:**
   - L'8% dei clienti (Champions) genera il 45% del revenue totale
   - Top 28% clienti (Champions + Loyal) = 69% revenue

2. **Rischio Churn:**
   - 211 clienti At Risk rappresentano £389k a rischio
   - Erano clienti alto valore (F≥4) ora inattivi da 60+ giorni

3. **Stagionalità:**
   - Picco revenue Q4: Novembre £1,16M (+47% vs Settembre)
   - Pattern stagionale chiaro per shopping natalizio

---

## Business Impact & Raccomandazioni

### Campagna Retention "At Risk"

**Scenario:** Email marketing + sconto 15% per riattivare segmento At Risk

**Calcolo ROI:**
- Clienti target: 211 (segmento At Risk)
- Tasso conversione stimato: 50%
- Clienti recuperati: 105
- Revenue media/cliente: £1.844
- **Revenue recuperato potenziale: £193.620**

**Costi stimati:**
- Setup campagna email: £2.000
- Sconto 15%: £29.043
- **Costo totale: £31.043**

**ROI = (£193.620 - £31.043) / £31.043 = 523%**

### Azioni Raccomandate

1. **Immediate (Q1):**
   - Campagna retention su At Risk (email personalizzate + sconto)
   - Programma fedeltà per Champions (early access, benefits esclusivi)

2. **Tattiche (Q2-Q3):**
   - Aumentare inventory Q4 per capitalizzare picco stagionale
   - Fidelizzazione progressiva (convertirli in Loyal)

3. **Strategiche (anno):**
   - Customer Lifetime Value analysis per Champions
   - Modello di intelligenza artificiale che cerca di capire quali clienti rischiano di andarsene, così da poter intervenire prima.

---

## Struttura Progetto

- Data:
   customer_segments.csv # Output segmentazione RFM
   monthly_trend.csv # Dati trend mensile
  
- SQL:
   01_rfm_scoring.sql # Calcolo metriche RFM e scoring
   02_customer_segmentation.sql # Logica segmentazione clienti
   03_monthly_trend_analysis.sql # Analisi trend temporale
   04_top_products_champions.sql # Prodotti preferiti per segmento

- Dashboard:
   Customer_Segmentation_RFM.pbix # File Power BI
   dashboard_rfm.png # Screenshot dashboard

---

## Come Replicare l'Analisi

### Prerequisiti
- MySQL 8.0+
- Power BI Desktop
- Dataset: [UK E-commerce Data]

### Step
1. Importa dataset in MySQL:
```sql
CREATE DATABASE ecommerce_analysis;
-- Importa CSV in tabella transactions
```
2. Esegui query SQL in ordine (cartella `/sql/`)

3. Esporta risultati segmentazione:
```sql
-- Vedi file 02_customer_segmentation.sql
```
4. Apri Power BI, importa CSV, ricrea dashboard

---

## Autore

**Simone Vitale**  
Data Analyst | Roma, Italia  
[LinkedIn](#www.linkedin.com/in/simone-vitale-analyst) | [Email](#vtlsmn@gmail.com)
