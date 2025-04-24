# FUNCIONES A COMPLETAR


## **update_embeddings** [*quien*]

Añade los vectores (embeddings) de los chuncks del texto (txt) correspondiente al articulo artid a los indices.


**Pasos**:

    1 - extraer los chuncks de txt
    2 - obtener con el LM los embeddings de cada chunck
    3 - normalizar los embeddings
    4 - actualizar: self.chuncks, self.embeddings, self.chunck_index y self.artid_to_emb


## **solve_semantic_query** [*quien*]


Resuelve una consulta utilizando el modelo de lenguaje.


**Pasos**:


    1 - obtiene el embedding normalizado de la consulta
    2 - extrae los MAX_EMBEDDINGS embeddings más próximos
    3 - convertir distancias euclideas a similitud coseno
    4 - considerar solo las similitudes >= que self.semantic_threshold
    5 - obtener los artids y su máxima similitud


## **semantic_reranking** [*quien*]


Ordena los articulos en la lista 'article' por similitud a la consulta 'query'.


**Pasos**:


    1 - obtener el vector normalizado de la consulta
    2 - calcular la similitud coseno de la consulta con todos los embeddings de cada artículo
    3 - ordenar los artículos en función de la mejor similitud.


## **index_dir** [*quien*]


Recorre recursivamente el directorio o fichero "root"


### NECESARIO PARA TODAS LAS VERSIONES


Recorre recursivamente el directorio "root"  y indexa su contenido.


los argumentos adicionales "**args" solo son necesarios para las funcionalidades ampliadas.


Completar si es necesario funcionalidad extra.


## **index_file** [*quien*]


Indexa el contenido de un fichero.


Solo se debe indexar el contenido self.DEFAULT_FIELD


    input: "filename" es el nombre de un fichero generado por el Crawler cada línea es un objeto json con la información de un artículo de la Wikipedia


### NECESARIO PARA TODAS LAS VERSIONES


dependiendo del valor de self.positional se debe ampliar el indexado




## **show_stats** [*quien*]
   
### NECESARIO PARA TODAS LAS VERSIONES


Muestra estadisticas de los indices


## **solve_query** [*quien*]


### NECESARIO PARA TODAS LAS VERSIONES


Resuelve una query.


Debe realizar el parsing de consulta que sera mas o menos complicado en funcion de la ampliacion que se implementen




    param:  "query": cadena con la query
            "prev": incluido por si se quiere hacer una version recursiva. No es necesario utilizarlo.

    return: posting list con el resultado de la query




## **get_posting** [*quien*]


### NECESARIO PARA TODAS LAS VERSIONES


Devuelve la posting list asociada a un termino.


Puede llamar self.get_positionals: para las búsquedas posicionales.




    param:  "term": termino del que se debe recuperar la posting list.

    return: posting list



## **get_positionals** [*quien*]


Devuelve la posting list asociada a una secuencia de terminos consecutivos.


### NECESARIO PARA LAS BÚSQUEDAS POSICIONALES


    param:  "terms": lista con los terminos consecutivos para recuperar la posting list.

    return: posting list




## **reverse_posting** [*quien*]


### NECESARIO PARA TODAS LAS VERSIONES


Devuelve una posting list con todas las noticias excepto las contenidas en p.


Util para resolver las queries con NOT.




    param:  "p": posting list

    return: posting list con todos los artid exceptos los contenidos en p




## **and_posting** [*quien*]


### NECESARIO PARA TODAS LAS VERSIONES


Calcula el AND de dos posting list de forma EFICIENTE


    param:  "p1", "p2": posting lists sobre las que calcular

    return: posting list con los artid incluidos en p1 y p2




## **minus_posting** [*quien*]


### OPCIONAL PARA TODAS LAS VERSIONES


Calcula el except de dos posting list de forma EFICIENTE.
Esta funcion se incluye por si es util, no es necesario utilizarla.


    param:  "p1", "p2": posting lists sobre las que calcular

    return: posting list con los artid incluidos de p1 y no en p2




## **solve_and_show** [*quien*]


### NECESARIO PARA TODAS LAS VERSIONES


Resuelve una consulta y la muestra junto al numero de resultados


    param:  "query": query que se debe resolver.

    return: el numero de artículo recuperadas, para la opcion -T

