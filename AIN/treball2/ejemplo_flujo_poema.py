from crewai import Agent, Task, Crew, Process, LLM
import os
from dotenv import load_dotenv
from pydantic import BaseModel
from random import randint
from crewai.flow.flow import Flow, listen, start

# Carga variables de entorno si las necesitas
load_dotenv()

# Configuración del modelo LLM

llm = LLM(
    model = "openai/qwen3:4b",
    #model = "openai/qwen-mini",
    #model = "openai/deepseek-r1:7b",
    #model = "openai/llama",
    #model = "openai/gemma",
    base_url="https://api.poligpt.upv.es/",
    api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
)


# Crear el agente directamente
poem_writer = Agent(
    role="CrewAI Poem Writer",
    goal="Generate a funny, light-hearted poem about how Computer Science is awesome with a sentence count of {sentence_count}",
    backstory=(
        "You're a creative poet with a talent for capturing the essence of any topic "
        "in a beautiful and engaging way. Known for your ability to craft poems that "
        "resonate with readers, you bring a unique perspective and artistic flair to "
        "every piece you write."
    ),
    llm=llm,
    verbose=True
)

# Crear la tarea directamente
write_poem = Task(
    description=(
        "Write a poem in Spanish about how Computer Science is awesome. "
        "Ensure the poem is engaging and adheres to the specified sentence count of {sentence_count}."
    ),
    expected_output=(
        "A beautifully crafted poem in Spanish about Computer Science, with exactly {sentence_count} sentences."
    ),
    agent=poem_writer
)




class PoemState(BaseModel):
    sentence_count: int = 1
    poem: str = ""


class PoemFlow(Flow[PoemState]):

    @start()
    def generate_sentence_count(self):
        print("Generar numero de frases")
        self.state.sentence_count = randint(4, 8)

    @listen(generate_sentence_count)
    def generate_poem(self):
        print("Generar poema")
        # Crear el crew
        crew = Crew(
            agents=[poem_writer],
            tasks=[write_poem],
            process=Process.sequential,
            verbose=True
        )
        result = crew.kickoff(inputs={"sentence_count": self.state.sentence_count})
        

        print("Poema generado", result.raw)
        self.state.poem = result.raw

    @listen(generate_poem)
    def save_poem(self):
        print("Guardando poema")
        with open("poema.txt", "w") as f:
            f.write(self.state.poem)


def kickoff():
    poem_flow = PoemFlow()
    poem_flow.kickoff()


def plot():
    poem_flow = PoemFlow()
    poem_flow.plot()


if __name__ == "__main__":
    kickoff()
    plot()
    
