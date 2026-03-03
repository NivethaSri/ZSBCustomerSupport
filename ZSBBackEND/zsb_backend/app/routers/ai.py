from fastapi import APIRouter
from pydantic import BaseModel

from ai_engine.loader import load_documents
from ai_engine.chunker import chunk_documents
from ai_engine.vector_store import create_vector_store
from ai_engine.rag_pipeline import build_rag
from ai_engine.escalation import should_escalate

router = APIRouter(prefix="/ai", tags=["AI"])

# Load once at startup

documents = load_documents()

chunks = chunk_documents(documents)
vectorstore = create_vector_store(chunks)
rag = build_rag(vectorstore)


class AIRequest(BaseModel):
    message: str


@router.post("/chat")
async def ai_chat(request: AIRequest):
    retriever = rag.retriever
    docs = retriever.get_relevant_documents(request.message)


    for i, doc in enumerate(docs):
        print(f"\n--- Retrieved Chunk {i+1} ---")
        print(doc.page_content[:800])

    answer = rag.run(request.message)

    escalate = should_escalate(request.message, answer)

    return {
        "answer": answer,
        "escalate": escalate
    }