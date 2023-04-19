# go-dev
Projects and resources for the Development Go Training Team

## Contribution Guidelines
Clone the repository and create a branch with your DOU email handler: `fistName.lastName`  
This will be your main branch to work with, do not delete this branch and whenever you are ready, create a pull request to `main` following best practices (describing briefly the changes), you can tag any contributor for reviews. You can create more feature branches with any name you want, but delete them after merging.

To create a new project, create a directory with your package name, following the [Standard Project Layout](https://github.com/golang-standards/project-layout):
+ Use `cmd` directory for applications (cli, servers, executables, etc...)
+ Use `pkg` directory for importable libraries (those that are safe to be imported by others)
+ Use `internal` directory for private libraries (used by your projects, importing outside of your project is discouraged but not enforced)
+ Check the documentation for more directory information

Create a `README.md` file in your package's root directory and provide basic info:
+ Author's name and DOU Email *(required)*
+ Brief description of the project *(required)*
+ Usage information
+ Examples
+ Documentation

Follow best practices! 
+ Document your code following Go's standard documentation comments: brief comment before any exported symbol (package, types, constants, vars, functions, etc...), starting with the symbol's name. 
+ Add tests! You learn more about Go the more tests you write! Use a library like [testify](https://github.com/stretchr/testify) to make assertions easier. 
+ Be mindful of imports, use the standard library as much as possible, *a little copying is better than a little dependency*. Whenever you include third party code, remember to include attribution (author's name or link as reference) and license if possible.

If for whatever reason (i.e. license compatibility with external libraries) your code should have a different license than MIT (included in the repository), please add a `LICENSE` file at the root of your package with the right license for your project.

Have fun!

## Resources

### Getting Started
- Golang Download and Install (https://golang.org)
- GoLand IDE (https://www.jetbrains.com/go/)
- Visual Studio Code Extensions (https://code.visualstudio.com/docs/languages/go)

### Learning
- How to Write Go Code (https://golang.org/doc/code)
- A Tour of Go (https://tour.golang.org/)
- Go By Example (https://gobyexample.com/)
- Gophercises (https://gophercises.com/)
- Effective Go (https://golang.org/doc/effective_go)

### Best Practices
- Standard Project Layout (https://github.com/golang-standards/project-layout) <- For large projects
- Go Proverbs (https://go-proverbs.github.io/)
- The Zen of Go (https://the-zen-of-go.netlify.app/) 🔥
- Uber: Go Style Guide (https://github.com/uber-go/guide/blob/master/style.md)
- Practical Go - Real World Advice (https://dave.cheney.net/practical-go/presentations/qcon-china.html) 🔥
- GoCodeReviewComments (https://github.com/golang/go/wiki/CodeReviewComments) 🔥

### Books
- https://www.golang-book.com/
- https://astaxie.gitbooks.io/build-web-application-with-golang/content/en/
- http://www.golangbootcamp.com/book
- https://github.com/dariubs/GoBooks (Index)

### Udemy 
_(contact Gabriel Martinez for access)_
- https://www.udemy.com/course/learn-how-to-code/
- https://www.udemy.com/course/go-programming-language/
- https://www.udemy.com/course/go-the-complete-developers-guide/
Go for Java Devs (Dev Talk)
- https://www.youtube.com/watch?v=SyLT6qT0Neo
Cloud Native Compute Foundation: Landscape (https://landscape.cncf.io/)

### Third-Party Libraries
Awesome Go (https://github.com/avelino/awesome-go) 🔥