#! -*- encoding: utf8 -*-

## Nombres: Xavier Naya Pons

########################################################################
########################################################################
###                                                                  ###
###  Todos los metodos y funciones que se crehan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################

import argparse
import os
import re
from typing import Optional

def sort_dic_by_values(d:dict) -> list:
    return sorted(d.items(), key=lambda a: (-a[1], a[0]))

class WordCounter:

    def __init__(self):
        """
           Constructor de la clase WordCounter
        """
        self.clean_re = re.compile('\W+')

    def write_stats(self, filename:str, stats:dict, use_stopiords:bool, full:bool):
        """
        Este metodo escribe en fichero las estadicas de un texto
            
        :param 
            filename: el nombre del fichero destino.
            stats: las estadisticas del texto.
            use_stopwords: booleano, si se han utilizado stopwords
            full: boolean, si se deben mostrar las stats completas
        """

        with open(filename, 'w', encoding='utf-8', newline='\n') as fh:
            ## completar
            fh.write(f'Lines: {stats['nlines']}\n') 
            fh.write(f'Number words (including stopwords): {stats['nwords']}\n') 
            if args.stopwords:
                fh.write(f'Number words (without stopwords): {stats['nostop']}\n') 
            fh.write(f'Vocabylary size: {len(stats['word'])}\n') 
            fh.write(f'Number of symbols: {sum(stats['symbol'].values())}\n') 
            fh.write(f'Number of different symbols: {len(stats['symbol'])}\n') 

            fh.write('Words (alphabetical order):\n') 
            aux = sorted(stats['word'].items()) 
            if args.full:
                for w in aux:
                    fh.write(f'\t{w[0]}: {w[1]}\n')
            else: 
                i = 0
                while i < 20 and i < len(stats['word']):
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            fh.write('Words (by frequency):\n') 
            aux = sort_dic_by_values(stats['word'])
            if args.full:
                for w in aux:
                    fh.write(f'\t{w[0]}: {w[1]}\n')
            else:
                i = 0
                while i < 20 and i < len(stats['word']):
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            fh.write('Symbols (alphabetical order):\n') 
            aux = sorted(stats['symbol'].items()) 
            if args.full:
                for l in aux:
                    fh.write(f'\t{l[0]}: {l[1]}\n')
            else:
                i = 0
                while i < 20 and i < len(stats['symbol']):
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            fh.write('Symbols (by frequency):\n') 
            aux = sort_dic_by_values(stats['symbol'])
            if args.full:
                for l in aux:
                    fh.write(f'\t{l[0]}: {l[1]}\n')
            else:
                i = 0
                while i < 20 and i < len(stats['symbol']):
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            if args.bigram:
                fh.write('Word pairs (alphabetical order):\n')
                aux = sorted(stats['biword'].items())
                if args.full:
                    for l in aux:
                        fh.write(f'\t{l[0]}: {l[1]}\n')
                else:
                    i = 0
                    while i < 20 and i < len(stats['biword']):
                        p = aux[i]
                        fh.write(f'\t{p[0]}: {p[1]}\n')
                        i += 1

                fh.write('Word pairs (by frequiency):\n')
                aux = sort_dic_by_values(stats['biword'])
                if args.full:
                    for l in aux:
                        fh.write(f'\t{l[0]}: {l[1]}\n')
                else:
                    i = 0
                    while i < 20 and i < len(stats['biword']):
                        p = aux[i]
                        fh.write(f'\t{p[0]}: {p[1]}\n')
                        i += 1

                fh.write('Symbol pairs (alphabetical order):\n')
                aux = sorted(stats['bisymbol'].items())
                if args.full:
                    for l in aux:
                        fh.write(f'\t{l[0]}: {l[1]}\n')
                else:
                    i = 0
                    while i < 20 and i < len(stats['bisymbol']):
                        p = aux[i]
                        fh.write(f'\t{p[0]}: {p[1]}\n')
                        i += 1

                fh.write('Symbol pairs (by frequiency):\n')
                aux = sort_dic_by_values(stats['bisymbol'])
                if args.full:
                    for l in aux:
                        fh.write(f'\t{l[0]}: {l[1]}\n')
                else:
                    i = 0
                    while i < 20 and i < len(stats['bisymbol']):
                        p = aux[i]
                        fh.write(f'\t{p[0]}: {p[1]}\n')
                        i += 1

            fh.write('Prefixes (by frequiency):\n')
            aux = sort_dic_by_values(stats['prefix'])
            if args.full:
                for l in aux:
                    fh.write(f'\t{l[0]}: {l[1]}\n')
            else:
                i = 0
                while i < 20 and i < len(stats['prefix']):
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            fh.write('Suffixes (by frequiency):\n')
            aux = sort_dic_by_values(stats['suffix'])
            if args.full:
                for l in aux:
                    fh.write(f'\t{l[0]}: {l[1]}\n')
            else:
                i = 0
                while i < 20:
                    p = aux[i]
                    fh.write(f'\t{p[0]}: {p[1]}\n')
                    i += 1

            pass


    def file_stats(self, fullfilename:str, lower:bool, stopwordsfile:Optional[str], bigrams:bool, full:bool):
        """
        Este metodo calcula las estadisticas de un fichero de texto

        :param 
            fullfilename: el nombre del fichero, puede incluir ruta.
            lower: booleano, se debe pasar todo a minusculas?
            stopwordsfile: nombre del fichero con las stopwords o None si no se aplican
            bigram: booleano, se deben calcular bigramas?
            full: booleano, se deben montrar la estadÃ­sticas completas?
        """

        stopwords = set() if stopwordsfile is None else set(open(stopwordsfile, encoding='utf-8').read().split())


        # variables for results

        sts = {
                'nwords': 0,
                'nlines': 0,
                'nostop': 0,
                'word': {},
                'symbol': {},
                'prefix': {},
                'suffix': {}
                }

        if bigrams:
            sts['biword'] = {}
            sts['bisymbol'] = {}

        f = open(fullfilename,'r')

        for line in f:
            sts['nlines'] += 1
            line = self.clean_re.sub(' ', line)
            if args.lower:
                line = line.lower()
            par = line.split()
            sts['nwords'] += len(par)

            # analitzar paraules
            for w in par:
                # si es una stopwords ja no sutilitza per a res
                if args.stopwords and w in stopwords:
                    continue
                sts['nostop']+=1
                tam = len(w)
                # prefixos 
                i = 2
                while i <= 4 and i < tam:
                    pre = f'{w[:i]}-'
                    if pre not in sts['prefix']:
                        sts['prefix'][pre] = 1
                    else:
                        sts['prefix'][pre] += 1
                    i += 1

                # sufixos
                i = 2
                while i <= 4 and i < tam:
                    suf = f'-{w[tam-i:]}'
                    if suf not in sts['suffix']:
                        sts['suffix'][suf] = 1
                    else:
                        sts['suffix'][suf] += 1
                    i += 1

                if w not in sts['word']:
                    sts['word'][w] =  1
                else:
                    sts['word'][w] += 1

                # analitzar lletres
                for l in w:
                    if l not in sts['symbol']:
                        sts['symbol'][l] =  1
                    else:
                        sts['symbol'][l] += 1

                if args.bigram:
                    i = 0
                    while i < len(w)-1:
                        bisymbol = f'{w[i]}{w[i+1]}'
                        if bisymbol not in sts['bisymbol']:
                            sts['bisymbol'][bisymbol ] = 1
                        else:
                            sts['bisymbol'][bisymbol] += 1
                        i += 1


        f.close()
        f = open(fullfilename,'r')
        if args.bigram:
            for line in f:
                line = self.clean_re.sub(' ', line)
                if args.lower:
                    line = line.lower()
                line = '$ ' + line + ' $'
                # fer parelles
                # split?
                paraules = line.split()
                i = 0
                while i < len(paraules)-1:
                    if args.stopwords and paraules[i] in stopwords or paraules[i+1] in stopwords:
                        i+=1
                        continue
                    biword = f'{paraules[i]} {paraules[i+1]}'
                    if biword not in sts['biword']:
                        sts['biword'][biword] = 1
                    else:
                        sts['biword'][biword] += 1
                    i += 1


        filename, ext0 = os.path.splitext(fullfilename)
        opc = ''
        if args.lower:
            opc += 'l'
        if args.stopwords:
            opc += 's'
        if args.bigram:
            opc += 'b'
        if args.full:
            opc += 'f'
        if len(opc) != 0:
            filename += '_'

        new_filename = f"{filename}{opc}_stats{ext0}" # cambiar a nom segons les opcions
        self.write_stats(new_filename, sts, stopwordsfile is not None, full)


    def compute_files(self, filenames:str, **args):
        """
        Este metodotodo calcula las estadissticas de una lista de ficheros de texto

        :param 
            filenames: lista con los nombre de los ficheros.
            args: argumentos que se pasan a "file_stats".

        :return: None
        """

        for filename in filenames:
            self.file_stats(filename, **args)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Compute some statistics from text files.')
    parser.add_argument('file', metavar='file', type=str, nargs='+',
                        help='text file.')

    parser.add_argument('-l', '--lower', dest='lower',
                        action='store_true', default=False, 
                        help='lowercase all words before computing stats.')

    parser.add_argument('-s', '--stop', dest='stopwords', action='store',
                        help='filename with the stopwords.')

    parser.add_argument('-b', '--bigram', dest='bigram',
                        action='store_true', default=False, 
                        help='compute bigram stats.')

    parser.add_argument('-f', '--full', dest='full',
                        action='store_true', default=False, 
                        help='show full stats.')

    args = parser.parse_args()
    wc = WordCounter()
    wc.compute_files(args.file,
                     lower=args.lower,
                     stopwordsfile=args.stopwords,
                     bigrams=args.bigram,
                     full=args.full)

