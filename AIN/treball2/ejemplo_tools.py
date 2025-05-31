

from crewai import Crew, Process, LLM, Agent, Task
import os
from crewai.project import CrewBase, agent, crew
from crewai_tools import SerperDevTool



os.environ['SERPER_API_KEY'] = ”xxxxxxxxx”  # es necesario darse de alta y obtener la key

serper_tool = SerperDevTool()



# llm = LLM(
#     model="ollama/llama3.2:3b",
#     base_url="http://localhost:11434",
#     api_key="noapi"
# )


llm = LLM(
    #model = "openai/qwen3:4b",
    #model = "openai/qwen-mini",
    #model = "openai/deepseek-r1:7b",
    model = "openai/llama",
    #model = "openai/gemma",
    base_url="https://api.poligpt.upv.es/",
    api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
)




# llm = LLM(
#     model = "openai/qwen2.5:72b",
#     base_url="https://api.poligpt.upv.es/",
#     api_key = "sk-LFXs1kjaSxtEDgOMlPUOpA",
# )




blog_writer = Agent(
  role='Writer',
  goal='Write a blog of the list of a search in the web for the given {topic} '
       'searched by the serper tool search, along with its description. Also write about the {topic}.',
  verbose=True,
  memory=True,
  backstory=(
    "As a good summarizer,"
    "a list of few list of links searched using the tool "
    "and about the {topic}"
    "Give the description of it."
    "You are the best to summarize the list with its description and provide in a neat way."
  ),
  tools=[serper_tool],
  llm=llm,
  allow_delegation=False
)


# Writing task with language model configuration
write_task = Task(
  description=(
    "Compose a the list of few links on the {topic} searched by the serper tool search"
    "Also provide a description of the links searched and write about the links."
    "This article should be easy to understand, engaging, and positive."
  ),
  expected_output='A blog having summary of about 3 paragraphs on the '
                  'the list of few links on {topic} and about the {topic} formatted as markdown.',
  tools=[serper_tool],
  agent=blog_writer,
  async_execution=False,
  output_file='new-blog-post.md'  # Example of output customization
)


# Forming the tech focused crew with some enhanced configuration
crew = Crew(
    agents=[blog_writer],
    tasks=[write_task],
    process=Process.sequential,
)

# starting the task execution process with enhanced feedback

result = crew.kickoff(inputs={"topic": "Multi-agent systems"})

print(result)