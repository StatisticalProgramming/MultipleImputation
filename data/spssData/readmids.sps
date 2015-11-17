DATA LIST FILE= "data/spssData//midsdata.txt"  free (TAB)
   / Imputation_ age bmi hyp chl .


VARIABLE LABELS
  Imputation_ "Imputation_" 
 age "age" 
 bmi "bmi" 
 hyp "hyp" 
 chl "chl" 
 .

EXECUTE.
SORT CASES by Imputation_.
SPLIT FILE layered by Imputation_.
