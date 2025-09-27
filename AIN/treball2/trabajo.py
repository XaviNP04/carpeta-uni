# Warning control
import warnings
warnings.filterwarnings('ignore')
import os
from crewai import Agent, Task, Crew, Process, LLM
from crewai.flow.flow import Flow, start
from crewai.tools import tool
from dotenv import load_dotenv
from pydantic import BaseModel
from crewai_tools import SerperDevTool
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from typing import Optional

os.environ['SERPER_API_KEY'] = "d8d071d38e4015d2f0aef8605a5e57c7b05c9dc1" # es necesario darse de alta y obtener la key

llm = LLM(
    #model = "openai/qwen2.5:72b",
    #model = "openai/qwen-mini",
    #model = "openai/deepseek-r1:7b",
    model = "openai/llama3.2:3b",
    base_url="https://api.poligpt.upv.es/",
    api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
)

# ░▀█▀░█▀█░█▀█░█░░░█▀▀
# ░░█░░█░█░█░█░█░░░▀▀█
# ░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀

@tool("PDF Creator Tool")
def create_pdf_tool(
    content: str, 
    filename: str, 
    title: Optional[str] = None,
    output_dir: Optional[str] = None
) -> str:
    """
    Crea un documento PDF con el contenido proporcionado.

    Argumentos:
        contenido: El texto que se incluirá en el PDF
        nombre_archivo: Nombre del archivo PDF (sin extensión)
        título: Título opcional para el documento PDF
        directorio_salida: Directorio opcional para guardar el PDF (predeterminado: el directorio actual)

    Devuelve:
        Cadena que confirma la creación del PDF con la ruta del archivo
    """
    try:
        # Convigurar el directorio de salida
        if output_dir is None:
            output_dir = os.getcwd()

        # Asegurar que el nombre tiene .pdf 
        if not filename.endswith('.pdf'):
            filename += '.pdf'

        file_path = os.path.join(output_dir, filename)

        # Crear documento PDF
        doc = SimpleDocTemplate(file_path, pagesize=letter)
        styles = getSampleStyleSheet()
        story = []

        # Añadir titulo si se le pasa uno
        if title:
            title_style = styles['Title']
            story.append(Paragraph(title, title_style))
            story.append(Spacer(1, 12))

        # Añadir contenido
        normal_style = styles['Normal']

        # Dividir contenido en paragrafos
        paragraphs = content.split('\n\n')
        for para in paragraphs:
            if para.strip():
                story.append(Paragraph(para.strip(), normal_style))
                story.append(Spacer(1, 12))
        
        # Construir PDF
        doc.build(story)
        
        return f"PDF successfully created at: {file_path}"
        
    except Exception as e:
        return f"Error creating PDF: {str(e)}"

searching_tool = SerperDevTool()

# ░█▀█░█▀▀░█▀▀░█▀█░▀█▀░█▀▀░█▀▀
# ░█▀█░█░█░█▀▀░█░█░░█░░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀

investigador = Agent(
    role="Especialista sénior en investigación.",
    goal="Realice investigaciones exhaustivas y basadas en hechos sobre {topic} utilizando la investigación web.",
    backstory="""Eres un investigador con experiencia, con gran atención al detalle y talento para descubrir datos de múltiples fuentes.""",
    verbose=True,
    allow_delegation=False,
    tools=[searching_tool],
    llm=llm,
)

redactor = Agent(
    role="Redactor de Contenidos",
    goal="Escribir un artículo científico claro, riguroso y bien estructurado sobre el texto dado.",
    backstory="""Eres un profesor doctorado experto sobre el {topic} y ha escrito muchos papers cientificos.""",
    allow_delegation=False,
    verbose=True,
    llm=llm
)

resumidor = Agent(
    role="Separa el documento por partes.",
    goal="Hacer un indice del texto que se le pasa.",
    backstory="""eres un experto en {topic}. debes resumir el documento por apartados.""",
    allow_delegation=False,
    verbose=True,
    llm=llm
)

creador_pdf= Agent(
    role="Creador de pdf.",
    goal="Crear un pdf usando una herramienta para ello pasandole el contenido del pdf, el nombre del documento, titulo y dirección donde guardarlo.",
    backstory="Experto en crear documentos, confirmando su creación.",
    tools=[create_pdf_tool],
    verbose=True,
    llm=llm
)



# ░▀█▀░█▀█░█▀▀░█░█░█▀▀
# ░░█░░█▀█░▀▀█░█▀▄░▀▀█
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

investiga = Task(
    description=(
        "Investiga el tema: {topic}"
        "1. Conceptos clave y desarrollos recientes"
        "2. Principales tendencias y patrones"
        "3. Aplicaciones o casos prácticos destacados"
        "4. Desafíos y oportunidades actuales"
    ),
    agent=investigador,
    expected_output="""Un informe de investigación completo con fuentes y redactado en formato markdown.""",
)

redacta = Task(
    description=(
        "1. Redactar un artículo científico con la informaciñon obtenida.\n"
        "2. Incluir claramente las secciones de introducción, estado del arte, temas abiertos, conclusiones y referencias.\n"
        "3. Utilizar palabras clave y citas adecuadas.\n"
        "4. Garantizar rigor académico, precisión en los datos y claridad en la exposición.\n"
        "5. Revisar ortografía y gramática, asegurando coherencia científica."
    ),
    expected_output="Un artículo científico estructurado en formato markdown, listo para revisión académica, con secciones claramente diferenciadas.",
    agent=redactor,
    context=[investiga],
    output_file="reports/redaccion.md",
)

resume = Task(
    description=(
        "1. Identificar las ideas principales y los puntos clave del texto.\n"
        "2. Redactar un resumen conciso que capture la esencia del texto original.\n"
        "3. Mantener la estructura lógica del contenido original, si es relevante.\n"
        "4. Eliminar información redundante o secundaria, conservando solo lo esencial.\n"
        "5. Asegurar claridad, coherencia y fidelidad al texto fuente.\n"
        "6. Revisar ortografía y gramática."
    ),
    expected_output="Un resumen bien estructurado en formato markdown, que condense el texto original de manera clara y precisa.",
    agent=resumidor,
    context=[redacta],
    output_file="reports/resumen.md",
)

pdf_creator= Task(
    description=(
        "1. Leer el documento de entrada.\n"
        "2. Crear el documento con la tool apropiada con un titulo acorde al tema y se debe guardar en el directorio actual.\n"
    ),
    expected_output="Archivo pdf situado en el directorio actual del tema dado con un titulo corto.",
    agent=creador_pdf,
    context=[resume],
)

# ░█▀▀░█░░░█▀█░█░█
# ░█▀▀░█░░░█░█░█▄█
# ░▀░░░▀▀▀░▀▀▀░▀░▀

class ExampleState(BaseModel):
    investigacion: str = ""

class GeneralFlow(Flow[ExampleState]):

    @start()
    def start_method(self):
        equipo = Crew(
            agents=[investigador, redactor, resumidor, creador_pdf],
            tasks=[investiga, redacta, resume, pdf_creator],
            process=Process.sequential,
            verbose=True
        )

        self.investigacion = equipo.kickoff(inputs={"topic": topico})
        print(self.investigacion)

topico = "patata"

def main():
    topico = input('Sobre que quieres escribir un articulo cientifico (por defecto patata): ')
    flow = GeneralFlow()
    result = flow.kickoff()

if __name__ == '__main__':
    main()
