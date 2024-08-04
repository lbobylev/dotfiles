from langgraph.prebuilt import create_react_agent
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool
from langchain_community.agent_toolkits.github.toolkit import GitHubToolkit
from langchain_community.utilities.github import GitHubAPIWrapper
import re
import sys
import os
from langchain_community.retrievers import TavilySearchAPIRetriever
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough

model = ChatOpenAI(model="gpt-4o-mini", temperature=0)
prompt = sys.argv[1]
with open("/Users/leonid/.tavily", "r") as file:
    key = file.read().strip()
    os.environ["TAVILY_API_KEY"] = key

@tool
def create_issue(
    title: str,
    body: str = "",
    # milestone: str = '',
    labels: list[str] = [],
    assignees: list[str] = [],
) -> None:
    """Create an issue in a GitHub repository."""
    r = github.github.get_repo(repo_name)
    r.create_issue(
        title=title,
        body=body,
        # milestone=milestone,
        labels=labels,
        assignees=assignees,
    )
    # print(issue)

def translate(language: str):
    def f (text: str) -> str:
        result = model.invoke(f"Translate the following text to {language}: {text}").content
        return str(result)
    return f

@tool
def get_news(question: str) -> str:
    """Get news articles based on a question."""
    retriever = TavilySearchAPIRetriever(k=10, kwargs={"days": 3, "topic": "news"})

    prompt = ChatPromptTemplate.from_template(
        """Answer the question based only on the context provided..

    Context: {context}

    Question: {question}"""
    )

    def format_docs(docs):
        return "\n\n".join(doc.page_content for doc in docs)

    chain = (
        {"context": retriever | format_docs, "question": RunnablePassthrough()}
        | prompt
        | model
        | StrOutputParser()
        | translate("russian")
    )

    return chain.invoke(question)

tools = [get_news]

extraction_prompt = f"Extract the GitHub repository name from this string: {prompt}; only output the full repository name; the repository name must follow the format username/repo-name; if you fail to get the name, return an 'fail'."
repo_name = str(model.invoke(extraction_prompt).content).strip()
if repo_name != "fail":
    os.environ["GITHUB_REPOSITORY"] = repo_name
    github = GitHubAPIWrapper()
    toolkit = GitHubToolkit.from_github_api_wrapper(github)
    tools.append(create_issue)
    for tool in toolkit.get_tools():
        tools.append(tool)
    for tool in tools:
        tool.name = re.sub(r"[^a-zA-Z0-9_-]", "_", tool.name).lower()

agent_executor = create_react_agent(model, tools)
events = agent_executor.stream(
    {"messages": [("user", prompt)]},
    stream_mode="values",
)
for event in events:
    event["messages"][-1].pretty_print()
