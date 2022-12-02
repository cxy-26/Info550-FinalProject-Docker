# run in the docker container
report.html: report.Rmd output/baseline.rds output/newdata.rds \
  output/table1.rds \
  output/first.last.stage.table.rds output/first.last.stage.table.af.rds output/first.last.stage.noaf.rds \
  output/plot1.png output/plot2.png
	Rscript code/render.R

output/baseline.rds output/newdata.rds: code/data_cleaning.R
	Rscript code/data_cleaning.R

output/table1.rds output/first.last.stage.table.rds output/first.last.stage.table.af.rds output/first.last.stage.noaf.rds&: code/tables.R output/baseline.rds
	Rscript code/tables.R

output/plot1.png output/plot2.png&: code/plots.R output/newdata.rds
	Rscript code/plots.R

.PHONY:clean
clean:
	rm output/* *.html
	
.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
# docker related rule(run on loccal machine)

projectfiles = report.Rmd code/tables.R code/render.R code/plots.R code/data_cleaning.R Makefile

# renvfiles = renv.lock renv/activate.R renv/settings.dcf

# build a container

cxy26/final: Dockerfile $(projectfiles)
	docker build -t cxy26/final .

# run the container

report/report.html:
	docker run -v "/$$(pwd)/report":/project/report cxy26/final

