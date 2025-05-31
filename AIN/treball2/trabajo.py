# Warning control
import warnings
warnings.filterwarnings('ignore')
from crewai_tools import SerperDevTool
import os
from crewai.project import CrewBase, agent, crew
from crewai_tools import SerperDevTool, DallETool
from dotenv import load_dotenv
from pydantic import BaseModel
from crewai.flow.flow import Flow, listen, router, start
from pptx import Presentation
from IPython.display import Image, display
from crewai import Agent, Task, Crew, Process



from crewai import LLM

os.environ['SERPER_API_KEY'] = "d8d071d38e4015d2f0aef8605a5e57c7b05c9dc1" # es necesario darse de alta y obtener la key
searching_tool = SerperDevTool()

llm = LLM(
    #model = "openai/qwen2.5:72b",
    #model = "openai/qwen-mini",
    #model = "openai/deepseek-r1:7b",
    model = "openai/llama3.2:3b",
    base_url="https://api.poligpt.upv.es/",
    api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
)


searching_tool = SerperDevTool()

investigador = Agent(
    role="Buscador de informacion",
    goal="Buscas contenido científico riguroso y atractivo sobre: {topic}",
    backstory="Eres un experto en buscar información sobre el tema: {topic}. Utilizas herramientas avanzadas de búsqueda para recopilar información.",
    allow_delegation=False,
    tools=[searching_tool],
    verbose=True,
    llm=llm
)

redactor = Agent(
    role="Redactor de Contenidos",
    goal="Escribir un artículo científico claro, riguroso y bien estructurado sobre el tema: {topic}",
    backstory="",
    allow_delegation=False,
    verbose=True,
    llm=llm
)

verificador = Agent(
    role="Comprueba que el documento este bein echo.",
    goal="Sujerir mejoras sobre un documento sobre un tema: {topic}",
    backstory="Eres un experto en: {topic}. Debes sujerir todas las mejoras que se te ocurran.",
    allow_delegation=False,
    verbose=True,
    llm=llm
)

investiga = Task(
    description=(
        "1. Entender la solicitud – Analizar la pregunta o tarea para identificar qué información se necesita.\n"
        "2. Buscar fuentes relevantes – Consultar bases de datos, APIs o documentos disponibles para obtener datos útiles.\n"
        "3. Procesar la información – Filtrar, resumir o estructurar los datos encontrados para extraer lo más importante.\n"
        "4. Validar la precisión – Verificar que la información sea correcta, contrastando con múltiples fuentes si es necesario.\n"
        "5. Entregar la respuesta – Presentar la información de manera clara y útil, adaptándose al formato requerido (texto, tabla, gráfico, etc.)."
    ),
    expected_output="Un artículo científico estructurado en formato markdown, listo para revisión académica, con secciones claramente diferenciadas.",
    agent=investigador,
    tools=[searching_tool],
)

redacta = Task(
    description=(
        "1. Redactar un artículo científico.\n"
        "2. Incluir claramente las secciones de introducción, estado del arte, temas abiertos, conclusiones y referencias.\n"
        "3. Utilizar palabras clave y citas adecuadas.\n"
        "4. Garantizar rigor académico, precisión en los datos y claridad en la exposición.\n"
        "5. Revisar ortografía y gramática, asegurando coherencia científica."
    ),
    expected_output="Un artículo científico estructurado en formato markdown, listo para revisión académica, con secciones claramente diferenciadas.",
    agent=redactor,
)

verifica = Task(
    description=(
        "1. Redactar un artículo científico.\n"
        "2. Incluir claramente las secciones de introducción, estado del arte, temas abiertos, conclusiones y referencias.\n"
        "3. Utilizar palabras clave y citas adecuadas.\n"
        "4. Garantizar rigor académico, precisión en los datos y claridad en la exposición.\n"
        "5. Revisar ortografía y gramática, asegurando coherencia científica."
    ),
    expected_output="Un artículo científico estructurado en formato markdown, listo para revisión académica, con secciones claramente diferenciadas.",
    agent=verificador,
)

class ExampleState(BaseModel):
    investigacion: str = ""


# crew = Crew(
#     agents=[redactor, redactor, verificador],
#     tasks=[investiga, redacta, verifica],
#     verbose=True,
#     process=Process.sequential
# )
test= ''
sol = ''

class GeneralFlow(Flow[ExampleState]):

    @start()
    def start_method(self):
        print("STARTING FLOW")
    
    @listen(start_method)
    def primero(self):
        crew = Crew(
            agents=[investigador],
            tasks=[investiga],
            process=Process.sequential,
            verbose=True
        )
        topico = input('Sobre que quieres escribir un articulo cientifico: ')
        test = crew.kickoff(inputs={"topic": topico})
        print(test.raw)

    @listen(primero)
    def segundo(self):
        crew = Crew(
            agents=[investigador],
            tasks=[investiga],
            process=Process.sequential,
            verbose=True
        )
        sol = crew.kickoff(inputs={"topic": test})
        print('==================================================================================')


def main():
    flow = GeneralFlow()
    result = flow.kickoff()

if __name__ == '__main__':
    main()
