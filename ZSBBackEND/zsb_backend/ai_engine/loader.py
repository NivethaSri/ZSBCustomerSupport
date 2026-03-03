from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.chains import RetrievalQA
from pathlib import Path

def load_documents():
    path = Path("ai_engine/documents/zsb_printer_tools_guide.pdf")
    loader = PyPDFLoader(str(path))
    documents = loader.load()
    return documents