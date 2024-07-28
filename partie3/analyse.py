#!/usr/bin/env -S python3 -i
import sys
import numpy as np
import sys
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression


def start_operation(name: str) -> None:
    print(name+'...', end='', file=sys.stderr)


def end_operation(status: str) -> None:
    print(status, file=sys.stderr)


def Centreduire(T):
    T = np.array(T, dtype=np.float64)  # données ne sont pas de type float donc cette ligne le change
    (n, p) = T.shape
    Moyennes = np.mean(T, 0)
    EcartTypes = np.std(T, 0)
    Res = np.eye(n, p)
    for j in range(p):
        Res[:, j] = (T[:, j]-Moyennes[j])/EcartTypes[j]
    return Res


def DiagBatons(colonne, nom_image: str, titre: str, *, xlabel: str = '', ylabel: str = '') -> None:
    min = sys.maxsize  # taille minimum
    Max = -sys.maxsize - 1  # taille maximum
    for i in colonne:
        if min > i:
            min = i
        if Max < i:
            Max = i
    inter = np.linspace(min, Max, num=21)
    print("\n", list(inter))
    x = [i*20 for i in range(20)]
    plt.figure()
    plt.title(titre)
    plt.hist(colonne, inter, histtype="bar", color="g")
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.savefig(nom_image)


def show_bar(x, y):
    fig, ax = plt.subplots()
    ax.bar(x, y)
    fig.show()


# Import des données
start_operation('Import des données')

CollegesDF = pd.read_csv("Colleges.csv")
CollegesDF = CollegesDF.dropna()  # to fix nan :supprime les lignes ayant des cases vides, sans changer le nom des lignes conservées

CollegesAr = np.delete(CollegesDF.to_numpy(), 0, axis=1) # enlève la colonne uai car elle n'est pas numérique (à discuter avec matt)
CollegesAr_CR = Centreduire(CollegesAr)

CollegesAr0 = CollegesAr[:, 2:]  # enlever la clé (UAI) et la variable endogène
CollegesAr0_CR = Centreduire(CollegesAr0)

end_operation('ok')

# Exploration des données
# représentations graphiques

start_operation('Création du diagramme en bâtons')

DiagBatons(CollegesAr[:, 0], "Colleges_AR.png", "Effectifs de collégiens en SEGPA sur l'année scolaire 2022-2023",
            xlabel='Effectif', ylabel='Fréquence')

end_operation('ok')

# matrice de covariance

start_operation('Matrice de coviariance')

MatriceCov = np.cov(CollegesAr0_CR, rowvar=False)

end_operation('ok')

# Régression linéaire multiple

start_operation('Calcul de la régression linéaire')

linear_regression = LinearRegression()
x, y = CollegesAr0_CR, CollegesAr_CR[:, 1]
linear_regression.fit(x, y)
regression_coefs = linear_regression.coef_
regression_score = linear_regression.score(x, y)
show_bar(x, y)

end_operation('ok')
