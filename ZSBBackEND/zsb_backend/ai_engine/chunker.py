from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.chains import RetrievalQA
import re

# chunker.py

from langchain.text_splitter import RecursiveCharacterTextSplitter

def chunk_documents(documents):
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=800,          # Increased from 400
        chunk_overlap=150,        # Increased overlap
    )

    chunks = splitter.split_documents(documents)
    for dochun in chunks:
        print(f"=====================================================================")

        print(f"chunks::::{dochun}")
        print(f"=====================================================================")


    print(f"✅ Total Chunks Created: {len(chunks)}")
    return chunks