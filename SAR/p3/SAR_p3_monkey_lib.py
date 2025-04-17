#!/usr/bin/env python
#! -*- encoding: utf8 -*-
# 3.- Mono Library

import pickle
import random
import re
import sys
from typing import List, Optional, TextIO

## Nombres: Xavier Naya Pons

########################################################################
########################################################################
###                                                                  ###
###  Todos los métodos y funciones que se añadan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################


def convert_to_lm_dict(d: dict):
    for k in d:
        l = sorted(((y, x) for x, y in d[k].items()), reverse=True)
        d[k] = (sum(x for x, _ in l), l)

# l'argument d'entrada es la llista de probabilitats de cada paraula en una tupla determina
def dict_random_choice(l:list) -> list:
    opcions = ''
    for i in range(len(l)):
        for k in range(l[i][0]):
            opcions += f'{l[i][1]} '
    return opcions.split()

class Monkey():

    def __init__(self):
        self.r1 = re.compile('[.;?!]') # split
        self.r2 = re.compile('\W+') # sub
        self.r3 = re.compile('(\n\n)[\n]*')
        self.info = {}

    def get_n(self):
        return self.info.get('n', 0)

    # recibe una frase y añade sus estadisticas a los modelos de lenguaje
    def index_sentence(self, sentence:str):
        n = self.info['n']
        while n > 1:
            frasen = sentence
            for i in range(n-1):
                frasen = f'$ {frasen} $'
            paraules = frasen.split()
            for i in range(len(paraules) - n + 1):
                ngrama = tuple(paraules[i:i+n-1])
                seg_paraula = paraules[i+n-1]

                if ngrama not in self.info['lm'][n]:
                    self.info['lm'][n][ngrama] = {}

                if seg_paraula not in self.info['lm'][n][ngrama]:
                    self.info['lm'][n][ngrama][seg_paraula] = 0

                self.info['lm'][n][ngrama][seg_paraula] += 1
            n-=1


    # recibe una lista de nombres de ficheros, los procesa, extrae las frases y llama a index_sentence para crear el modelo de lenguaje
    def compute_lm(self, filenames:List[str], lm_name:str, n:int):
        self.info = {'name': lm_name, 'filenames': filenames, 'n': n, 'lm': {}}
        for i in range(2, n+1):
            self.info['lm'][i] = {}
        for filename in filenames:
            with open(filename, encoding='utf-8') as fh:
                arxiu = fh.read()
                arxiu_nointro = self.r3.sub(';\n', arxiu)
                frase = self.r1.split(arxiu_nointro)
                for f in frase:
                    frase_neta = self.r2.sub(' ', f).strip().lower()
                    self.index_sentence(frase_neta)
                
        for i in range(2, n+1):
            convert_to_lm_dict(self.info['lm'][i])

    def load_lm(self, filename:str):
        with open(filename, "rb") as fh:
            self.info = pickle.load(fh)

    def save_lm(self, filename:str):
        with open(filename, "wb") as fh:
            pickle.dump(self.info, fh)

    def save_info(self, filename:str):
        with open(filename, "w", encoding='utf-8', newline='\n') as fh:
            self.print_info(fh=fh)

    def show_info(self):
        self.print_info(fh=sys.stdout)

    def print_info(self, fh:TextIO):
        print("#" * 20, file=fh)
        print("#" + "INFO".center(18) + "#", file=fh)
        print("#" * 20, file=fh)
        print(f"language model name: {self.info['name']}", file=fh)
        print(f'filenames used to learn the language model: {self.info["filenames"]}', file=fh)
        print("#" * 20, file=fh)
        print(file=fh)
        for i in range(2, self.info['n']+1):
            print("#" * 20, file=fh)
            print("#" + f'{i}-GRAMS'.center(18) + "#", file=fh)
            print("#" * 20, file=fh)
            for prev in sorted(self.info['lm'][i].keys()):
                wl = self.info['lm'][i][prev]
                print(f"'{' '.join(prev)}'\t=>\t{wl[0]}\t=>\t{', '.join(['%s:%s' % (x[1], x[0]) for x in wl[1]])}" , file=fh)

    # genera frases aleatorias usando un podelo de lenguaje
    def generate_sentences(self, n:Optional[int], nsentences:int=10, prefix:Optional[str]=None):

        tupla = ''
        for i in range(n-1):
            tupla += ' $'

        if prefix is not None:
            tupla += f' {prefix}'
            ini = tuple(tupla.split()[len(tupla.split())-n+1:])
        else:
            prefix = ''
            ini = tuple(tupla.split())


        reini = ini
        nextreini = tupla.split()[len(tupla.split())-n+1:]
        next = nextreini
        
        i = 0
        while i < nsentences:
            ini = reini
            next = nextreini
            dado=''
            frase = f'{prefix}'
            while dado != '$':
                frase+=f' {dado}'
                dado = random.choice(dict_random_choice(self.info['lm'][n][ini][1]))
                next = next[1:] + [dado]
                ini = tuple(next)
            
            if frase == ' ':
                i-=1
            else:
                print(f'---------\n{frase}')
            i+=1

        pass



if __name__ == "__main__":
    print("Este fichero es una librería, no se puede ejecutar directamente")


