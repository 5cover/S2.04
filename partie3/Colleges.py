import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt;
from sklearn.linear_model import LinearRegression

def Centreduire(T):
  T = np.array(T,dtype=np.float64) # données ne sont pas de type float donc cette ligne le change
  (n,p) = T.shape
  Moyennes = np.mean(T, 0)
  EquartTypes = np.std(T, 0)
  Res = np.eye(n,p)
  for j in range(p):
          Res[:,j]= (T[:,j]-Moyennes[j])/   EquartTypes[j]
  return Res

def DiagBatons(colonne,nom_image:str,titre:str):
  min = sys.maxsize #taille minimum
  Max = -sys.maxsize - 1 #taille maximum
  for i in colonne:
      if min > i :
           min = i
      if Max < i :
           Max = i
  inter = np.linspace(min,Max,num=21)
  print("\n",list(inter))
  x = [i*20 for i in range(20)]
  plt.figure()
  plt.title(titre)
  plt.hist(colonne,inter, histtype="bar",color="g")
  plt.savefig(nom_image)


# Import des données
CollegesDF=pd.read_csv("Colleges.csv")
CollegesDF = CollegesDF.dropna() # to fix nan :supprime les lignes ayant des cases vides, sans changer le nom des lignes conservées

CollegesAr = CollegesDF.to_numpy()

CollegesAr0 = CollegesAr[:,2:]
CollegesAr0_CR = Centreduire(CollegesAr0)

# Exploration des données 
## représentations graphiques

DiagBatons(CollegesAr[:,0],"Colleges_AR.png")

## matrice de covariance
MatriceCov = np.cov(CollegesAr0_CR, rowvar=False)

# Régression linéaire multiple

linear_regression = LinearRegression()
linear_regression.fit(x, y)
regression_coefs=linear_regression.coef_
regression_score=linear_regression.score(x,y)

def show_regression():
     fig, ax = plt.subplots()
     ax.bar(CollegesDF.columns, regression_coefs)
     fig.show()