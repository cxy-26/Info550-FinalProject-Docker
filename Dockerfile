# From rocker/rstudio

FROM rocker/r-ubuntu

# alternative method
RUN Rscript -e "install.packages('here')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('table1')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('Hmisc')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('kableExtra')"

RUN apt-get update && apt-get install -y pandoc

RUN mkdir /project
workdir /project

run mkdir code
run mkdir output
run mkdir data

copy code code
copy data data
copy Makefile .
copy report.Rmd .

#copy .Rprofile .
#copy renv.lock .
#run mkdir renv

#copy renv/activate.R renv
#copy renv/settings.dcf renv

#RUN Rscript -e "renv::restore(prompt = FALSE)"

Run mkdir report

CMD make && mv report.html report
