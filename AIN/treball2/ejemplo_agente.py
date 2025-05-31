# Warning control
import warnings
warnings.filterwarnings('ignore')



from crewai import Agent, Task, Crew



from crewai import LLM


llm = LLM(
    #model = "openai/qwen2.5:72b",
    #model = "openai/qwen-mini",
    #model = "openai/deepseek-r1:7b",
    model = "openai/llama3.2:3b",
    base_url="https://api.poligpt.upv.es/",
    api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
)




writer = Agent(
    role="Redactor de Contenidos",
    goal="Escribir un artículo científico claro, riguroso y bien estructurado sobre el tema: {topic}",
    backstory="Estás escribiendo un artículo científico sobre el tema: {topic}. Tu artículo debe contener una introducción clara, un análisis detallado del estado del arte, una discusión de los temas abiertos actuales, conclusiones sólidas y referencias científicas relevantes.",
    allow_delegation=False,
    verbose=True,
    llm=llm
)


write = Task(
    description=(
        "1. Redactar un artículo científico.\n"
        "2. Incluir claramente las secciones de introducción, estado del arte, temas abiertos, conclusiones y referencias.\n"
        "3. Utilizar palabras clave y citas adecuadas.\n"
        "4. Garantizar rigor académico, precisión en los datos y claridad en la exposición.\n"
        "5. Revisar ortografía y gramática, asegurando coherencia científica."
    ),
    expected_output="Un artículo científico estructurado en formato markdown, listo para revisión académica, con secciones claramente diferenciadas.",
    agent=writer,
)



def main():
    crew = Crew(
        agents=[writer],
        tasks=[write],
        verbose=True
    )

    topico = input('Sobre que quieres escribir un articulo cientifico: ')
    result = crew.kickoff(inputs={"topic": topico})



    print(result.raw)





if __name__ == '__main__':
    main()

