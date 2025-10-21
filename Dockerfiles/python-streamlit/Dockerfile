FROM python:3.13-slim

WORKDIR /app

COPY . .

# omit packages you don't need    
RUN pip3 install schedule tqdm PyMySQL pandas numpy sqlalchemy streamlit

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
