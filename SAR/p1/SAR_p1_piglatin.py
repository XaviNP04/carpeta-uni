#!/usr/bin/env python
#! -*- encoding: utf8 -*-

# 1.- Pig Latin
# Autor: Xavier Naya Pons

import re
import sys
from typing import Optional, Text
from os.path import isfile

class Translator():

    def __init__(self, punt:Optional[Text]=None):
        """
        Constructor de la clase Translator

        :param punt(opcional): una cadena con los signos de puntuación
                                que se deben respetar
        :return: el objeto de tipo Translator
        """
        if punt is None:
            punt = ".,;?!"
        self.re = re.compile(r"(\w+)([" + punt + r"]*)")

    def translate_word(self, word:Text) -> Text:
        """
        Recibe una palabra en inglés y la traduce a Pig Latin

        :param word: la palabra que se debe pasar a Pig Latin
        :return: la palabra traducida
        """
        # ------------------------------------------------------------
        vocals = re.compile(r'[aeiouy]+')
        if not word[0].isalpha() or word in ".,;?!":
            return word
        elif not vocals.match(word[0]): # si es una consonant

            posVoc = vocals.search(word.lower()).start()

            new_word=f"{word[posVoc:]}{word[:posVoc]}ay"
        else:
            new_word=f"{word}yay"

        if word[0].isupper():
            new_word=new_word.capitalize()
        if word.isupper():
            new_word=new_word.upper()

        return new_word
        # ------------------------------------------------------------

    def translate_sentence(self, sentence:Text) -> Text:
        """
        Recibe una frase en inglés y la traduce a Pig Latin

        :param sentence: la frase que se debe pasar a Pig Latin
        :return: la frase traducida
        """

        # ------------------------------------------------------------

        new_sentence = ""
        aux = self.re.split(sentence)
        for w in aux:
            if w not in ".,;?!":
                new_sentence += self.translate_word(w)
            else:
                new_sentence += w

        return new_sentence
        # ------------------------------------------------------------

    def translate_file(self, filename:Text):
        """
        Recibe un fichero y crea otro con su tradución a Pig Latin

        :param filename: el nombre del fichero que se debe traducir
        :return: None
        """
        
        if not isfile(filename):
            print(f'{filename} no existe o no es un nombre de fichero', file=sys.stderr)
        
        # ------------------------------------------------------------

        f = open(filename, "r")
        n = open(f"{filename[:len(filename)-4]}_latin.txt", "w")

        n.write(self.translate_sentence(f.read()))

        n.close()

        # ------------------------------------------------------------

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(f'Syntax: python {sys.argv[0]} [filename]')
        exit()
    t = Translator()
    if len(sys.argv) == 2:
        t.translate_file(sys.argv[1])
    else:
        sentence = input("ENGLISH: ")
        while len(sentence) > 1:
            print("PIG LATIN:", t.translate_sentence(sentence))
            sentence = input("ENGLISH: ")
