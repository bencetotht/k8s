FROM jupyter/base-notebook:latest

USER root

RUN apt-get update && \
    mkdir -p /var/lib/apt/lists/partial && \
    apt-get install -y texlive-full latexmk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install -U jupyterlab-latex && \
    jupyter lab build

USER jovyan

WORKDIR /home/jovyan/work

CMD ["start-notebook.sh", "--NotebookApp.token=''"]
