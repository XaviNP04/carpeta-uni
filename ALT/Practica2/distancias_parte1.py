######################################################################
#
# INTEGRANTES DEL EQUIPO/GRUPO:
#
# - Alex
# - Anaís
# - Estrella
# - Xavi
#
######################################################################


import numpy as np

def levenshtein_matriz(x, y):
    lenX, lenY = len(x), len(y)
    D = np.zeros((lenX + 1, lenY + 1), dtype=np.int32)
    # i cambia filas
    # j cambia columna
    # fila
    for i in range(1, lenX + 1):
        D[i][0] = D[i - 1][0] + 1
    # columna + diagonal
    for j in range(1, lenY + 1):
        D[0][j] = D[0][j - 1] + 1
        for i in range(1, lenX + 1):
            D[i][j] = min(
                D[i - 1][j] + 1,
                D[i][j - 1] + 1,
                D[i - 1][j - 1] + (x[i - 1] != y[j - 1]),
            )
    return D[lenX, lenY]

def levenshtein_edicion(x, y):
    # a partir de la versión levenshtein_matriz
    lenX, lenY = len(x), len(y)
    matrizsol = []
    D = np.zeros((lenX + 1, lenY + 1), dtype=np.int32)
    for i in range(1, lenX + 1):
        D[i][0] = D[i - 1][0] + 1
    for j in range(1, lenY + 1):
        D[0][j] = D[0][j - 1] + 1
        for i in range(1, lenX + 1):
            D[i][j] = min(
                D[i - 1][j] + 1,
                D[i][j - 1] + 1,
                D[i - 1][j - 1] + (x[i - 1] != y[j - 1]),
            )
    i, j = lenX, lenY
    # append es mas facil de leer que insert, solo le tienes que dar la vuelta al final y ya esta
    while i > 0 or j > 0:
        if i > 0 and j > 0 and x[i - 1] == y[j - 1]: # si es la misma letra vamos a la diagonal
            matrizsol.append((x[i - 1], y[j - 1]))
            i -= 1
            j -= 1
        else:
            if i > 0 and j > 0 and D[i][j] == D[i - 1][j - 1] + 1: # si la actual es igual a la de la diagonal +1
                matrizsol.append((x[i - 1], y[j - 1]))
                i -= 1
                j -= 1
            elif i > 0 and (D[i][j] == D[i - 1][j] + 1): # si la actual es igual a la de la izquierda +1
                matrizsol.append((x[i - 1], ''))
                i -= 1
            elif j > 0 and (D[i][j] == D[i][j - 1] + 1): # si la actual es igual a la de abajo +1
                matrizsol.append(('', y[j - 1]))
                j -= 1

    matrizsol.reverse()
    return D[lenX][lenY],matrizsol# COMPLETAR Y REEMPLAZAR ESTA PARTE

def damerau_restricted_matriz(x, y):
    # completar versión Damerau-Levenstein restringida con matriz
    lenX, lenY = len(x), len(y)
    D = np.zeros((lenX + 1, lenY + 1), dtype=np.int32)
    # siempre que vas a la derecha o arriba sumas 1
    for i in range(1, lenX + 1):
        D[i][0] = D[i - 1][0] + 1
    for j in range(1, lenY + 1):
        D[0][j] = D[0][j - 1] + 1
        # el unico caso que no sumas 1 es si vas en diagonal
        for i in range(1, lenX + 1):
            D[i][j] = min(
                D[i - 1][j] + 1,
                D[i][j - 1] + 1,
                D[i - 1][j - 1] + (x[i - 1] != y[j - 1]),
            )
            # NUEVO -----------------------------------------------------------
            if i > 1 and j > 1 and x[i - 2] == y[j-1] and x[i-1] == y[j - 2]: # transpa 24 al la ultima comparacion
                D[i][j] = min(D[i][j], D[i - 2][j - 2] + 1)
    return D[lenX, lenY]

def damerau_restricted_edicion(x, y):
    lenX, lenY = len(x), len(y)
    matrizsol = []
    D = np.zeros((lenX + 1, lenY + 1), dtype=np.int32)
    for i in range(1, lenX + 1):
        D[i][0] = D[i - 1][0] + 1
    for j in range(1, lenY + 1):
        D[0][j] = D[0][j - 1] + 1
        for i in range(1, lenX + 1):
            D[i][j] = min(
                D[i - 1][j] + 1,
                D[i][j - 1] + 1,
                D[i - 1][j - 1] + (x[i - 1] != y[j - 1]),
            )
            # NUEVO -----------------------------------------------------------
            if (i > 1 and j > 1 and x[i - 2] == y[j-1] and x[i-1] == y[j - 2]): # creo que esta bien
                D[i][j] = min(D[i][j], D[i - 2][j - 2] + 1)

    i, j = lenX, lenY
    while i > 0 or j > 0:
        if i > 0 and j > 0 and x[i - 1] == y[j - 1]:
            matrizsol.append((x[i - 1], y[j - 1]))
            i -= 1
            j -= 1
        else:
            if i > 1 and j > 1 and x[i - 2] == y[j-1] and x[i-1] == y[j - 2]:
                matrizsol.append((x[i-2:i], y[j-2:j]))
                i -= 2
                j -= 2
            elif i > 0 and j > 0 and D[i][j] == D[i - 1][j - 1] + 1:
                matrizsol.append((x[i - 1], y[j - 1]))
                i -= 1
                j -= 1
            elif j > 0 and (i == 0 or D[i][j] == D[i][j - 1] + 1):
                matrizsol.append(('', y[j - 1]))
                j -= 1
            elif i > 0 and (j == 0 or D[i][j] == D[i - 1][j] + 1):
                matrizsol.append((x[i - 1], ''))
                i -= 1

    matrizsol.reverse()
    return D[lenX][lenY],matrizsol

def damerau_intermediate_matriz(x, y):
    # completar versión Damerau-Levenstein intermedia con matriz
     return 0 # COMPLETAR Y REEMPLAZAR ESTA PARTE

def damerau_intermediate_edicion(x, y):
    # partiendo de matrix_intermediate_damerau añadir recuperar
    # secuencia de operaciones de edición
    # completar versión Damerau-Levenstein intermedia con matriz
    return 0,[] # COMPLETAR Y REEMPLAZAR ESTA PARTE
    
opcionesSpell = {
    'levenshtein_m': levenshtein_matriz,
    'damerau_rm':    damerau_restricted_matriz,
    'damerau_im':    damerau_intermediate_matriz,
}

opcionesEdicion = {
    'levenshtein': levenshtein_edicion,
    'damerau_r':   damerau_restricted_edicion,
    'damerau_i':   damerau_intermediate_edicion
}

if __name__ == "__main__":
    print(levenshtein_matriz("ejemplo", "campos"))
