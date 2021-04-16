 

# The Nutshell

![](https://i.gyazo.com/d71b65600bfa78239d3847a00a5f7e0c.png)

***The Nutshell** is a command interpreter shell that was inspired by the Korn shell and developed by Daniel Hunkins and Monica Lewis. The Nutshell was implemented in the C language using Flex and Bison and runs on Unix.*

### How we built it
This application, built using C, Flex, and Bison, was developed using both Visual Studio Code and `nano` in a Unix environment. For the purposes of this project, Daniel was responsible for `[built-in commands, non-built in commands, I/O redirection, tilde expansion, testing]` and Monica was responsible for `[readme, built-in commands, environment variable expansion, background commands, testing]`. `alias` `Alias expansion` `cd` `bye` were completed prior to starting the project.

---
### What it does
The Nutshell scans input from a user on the command line and parses the input for commands that can be executed such as `cd`, `ls`, `alias`, or `bye`. At its core, the shell can execute commands on I/O redirection, pathname searching, and environment variables.

![](https://i.gyazo.com/8296d9842f56ec0696f92d807f816e73.png)

> [Figure 2] A few of the accepted commands. The last input is `bye`, just before execution.

![](https://i.gyazo.com/b8b83a785881fc82b95dd2237f7fa5b9.png)
> [Figure 3] After executing `bye`, shell is shown exiting gracefully.

For context, it is necessary to understand how tokens are treated in the program. Below is a macro-view of the elements that shell commands consist of:

 - `Word` is a sequence of characters treated as a single unit, generally known as a token. It is separated by white space, newlines, and metacharacters.
 - `White space` consists of any combination of spaces and tabs.
 - `.` refers to the current working directory.
 - `..` refers to the parent directory.
 - `~` refers to and substitutes for a user's home directory.
 - `< > | " \ & [Metacharacters]` represent themselves and cannot be part of a word unless they are escaped or inside quotes.

---
### Commands & Executable Content
*The commands accepted by the Nutshell are separated into several categories and are defined as follows:*

**Built-in Commands**

 - [x] `setenv variable word`
	 Sets the value of `variable` = `word`
	 
 - [x] `printenv`
 Prints all environment variables in the format `variable = value`
 
 - [x] `unsetenv variable`
Removes a `variable`'s binding, if the binding exists.

 - [x] Environment variables `HOME` and `PATH` are already included for searching or printing.

 - [x] `PATH` value is treated as a list of `word`s delimited by `:`, such as in `word:word:word`.

 - [x] `cd word`	 `cd`
Changes the current working directory to `word`. May be relative or absolute. In the case of `cd` alone, the shell returns to the home directory.

 - [x] `alias name word`
Adds an `alias` to the shell. `alias` is a shorthand way of triggering the `word` in the shell by typing its `name`.

 - [x] `unalias name`
Removes the `alias` for `name`.

 - [x] `alias`
Lists all `alias`es.

 - [x] `bye`
Exits the shell.

![](https://i.gyazo.com/7cf12b3f580017aa7238d0c7c7a67a09.png)
> [Figure 3] Using alias to store commands and running alias to test it.

**Non-built in Commands**
`cmd [arg]* [|cmd [arg]*]* [< fn1] [ >[>] fn2 ] [ 2>fn3 || 2>&1 ] [&]`
Commands in this format and their arguments, pipes, I/O redirection will be accepted.

Some examples include:
`ls` `cd` `nano file` `echo` `mv src dest` `pwd` `cat file`

![](https://i.gyazo.com/68ad50411244cf99e47766d98ec542db.png)
> [Figure 4] As shown: Viewing the contents of the current working directory, creating a new directory and moving to it. Creating a text file and displaying its contents. Echoing a word and returning to the previous directory.

![](https://i.gyazo.com/a18fa592f50847d2a1c64baa4e14f08e.png)
> [Figure 5] Using `nano` to create and edit a file in the shell.

![](https://i.gyazo.com/339066dc908ce610f7c9bbe5f385bf86.png)
> [Figure 6] Exhibiting the file in/out redirection of the shell.

**Environment Variable Expansion**
The input `${variable}` will tell the shell to read all characters between the `${ }`, namely the `variable`, and substitutes the value of the `variable` if it exists.

![](https://i.gyazo.com/06b955b765810b857d082a82769a42a6.png)

> [Figure 7] Exhibiting the environment variable expansion at work.

---

### Challenges we ran into
This project was a challenge in more ways than one. Namely, learning how to use the parser and lexer and comprehending how to use content learned from previous projects and apply it in this shell.
Below is a list of what was not implemented in the program:
* Wildcard Matching
* Piping

---

### What we learned
As challenging as developing this application was, the key takeaway was learning how to pair program, work collaboratively, and work with lexers and parsers in a short time frame. Much of the project's development time was spent researching how processes work and testing the program for processing errors. Through communication and teamwork, the project became much more feasible.
