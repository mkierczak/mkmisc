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
 6. Work inside the project saving everything you need to use (R scripts) inside the `to_docker` directory. Now, every time you install a package
    it  will be stored in a local project-specific library that is somewhat similar to conda. It, however differs from conda in that if 
    two `renv` projects use the same package (in exactly the same version), it will be physically only one copy of the compiled package. The real magics of `renv` is, however, 
    that the whole info needed to restore the environment will be stored in `renv.lock` file which you can use to re-create project environment inside the Docker container. 
 
 7. Create `build` directory inside the project.
