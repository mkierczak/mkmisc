# mkmisc
Miscellaneous odds and ends.

## Setting up projects using R, RStudio, DockerHub and GitHub

 1. Go to GitHub and create a new repo.
 
 2. Clone the repo locally, e.g.:
	`git clone https://github.com/quiestrho/mkmisc.git` 
	
 3. Open RStudio and start a new project from the existing directory.
 
 4. In R console do: 

```r
install.packages('renv')
renv::init()
```

 5. Create a separate directory that will contain all your scripts and that will be copied to docker container, e.g.
	`mkdir to_docker`
	
 6. Work inside the project saving everything you need to use (R scripts) inside the `to_docker` directory. Now, every time you install a package it  will be stored in a local project-specific library that is somewhat similar to conda. It, however differs from conda in that if two `renv` projects use the same package (in exactly the same version), it will be physically only one copy of the compiled package. The real magics of `renv` is, however, that the whole info needed to restore the environment will be stored in `renv.lock` file which you can use to re-create project environment inside the Docker container. 
 
 7. Create a text file `Dockerfile` inside the `/`.
 
 8. Inside the `Dockerfile` put the following:

```Docker
FROM rstudio/r-base:4.0.2-xenial AS builder
MAINTAINER Marcin Kierczak <marcin.kierczak@scilifelab.se>
ENV RENV_VERSION 0.12.0

RUN apt update -y && apt install -y \
  libssl-dev \
  libxml2-dev

RUN mkdir project
RUN mkdir project/scripts

WORKDIR project/
COPY renv.lock renv.lock

RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e 'renv::restore()'

WORKDIR project/scripts/
COPY to_docker/* .
```

9. Go to DockerHub (NBIS has own, contact our CTO to add you to the organisation).

10. Create a new repository.

11. Click on the 'Builds' tab and than on "Link to GitHub". Follow the instructions.

12. Go back to 'Repositories -> YourRepo -> Builds', select GitHub user or organisation and than the GitHub repository to link. If you select 'Branch' as 'Source Type', your container will be built every time you push anything to the repo. This might not be what you want. Instead, you can select 'Tag' and put `/^[0-9.]+$/` as 'Source'. Thus, every time you tag your git code with a version, like '1.2.1' and push the tag to GitHub, the container build will happen. 

13. `Save` or `Save and Build`

14. Now, every time you push to the repo with a tag like '1.2.1', Docker container will be built with and put on DockerHub tagged as 'release-1.2.1' so that you can pull it on Rackham and migrate to Bianca via Wharf (or pull it wherever you want). You tag by:

```sh
git tag -a 1.2.1 -m 'Adding new awesome 1.2.1 version' # or just 
git tag 1.2.1 # to create a lightweight tag
git push --tags
```

15. On another machine just do `docker pull user/repo:tag`, e.g.: 
```sh
docker pull quiestrho/mkmisc:latest
```

16. Run your code:
```
docker run mkmisc:latest R CMD BATCH /project/scripts/test.R
```

**NOTE**  
Sometimes everything works fine, but sometimes the build fails, you can see why on DockerHub in "Latest Builds" logs. In this test case, some R packages required `libssl-dev` and `libxml2-dev` which I had to install using `apt` (see `Dockerfile`).
