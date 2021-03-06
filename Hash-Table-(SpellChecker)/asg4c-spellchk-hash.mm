.so Tmac.mm-etc
.if t .Newcentury-fonts
.INITR* \n[.F]
.SIZE 12
.TITLE CMPS-012B Winter\~2015 Program\~5 "Hashing and Spell Checking"
.RCS "$Id: asg4c-spellchk-hash.mm,v 1.51 2015-02-20 18:18:39-08 - - $"
.PWD
.URL
.GETST* SPELLCHEQUER Figure_SPELLCHEQUER
.GETST* YYLEX Figure_YYLEX
.GETST* HASHDOUBLING Figure_HASHDOUBLING
.GETST* SAMPLEDEBUG Figure_SAMPLEDEBUG
.EQ
delim $$
.EN
.H 1 "Overview"
In this assignment you will implement a spelling checker that uses a
hash table to look up words in a dictionary.
Collision resolution will be done by separate chaining.
A scanner generated by
.V= flex
will be used to extract words form the files to be checked.
.H 1 "Program specification"
We present the program in the form of a Unix 
.V= man (1)
page.
.SH=BVL
.MANPAGE=LI "NAME"
spellchk \[em] spell check some files based on dictionary words
.MANPAGE=LI "SYNOPSIS"
.V= spellchk
.=V \|[ -nxy ]
.=V \|[ -d
.IR dictionary ]
.=V \|[ -@
.IR debugflags ]
.RI \|[ filename \|.\|.\|.]
.MANPAGE=LI "DESCRIPTION"
This program examines files for correct spell checking.
Some number of dictionaries are read in, including
the default dictionary,
plus any other auxiliary dictionaries.
then each file is read, and a report of any incorrectly spelled words
is made.
.MANPAGE=LI "OPTIONS"
Options are scanned using
.V= getopt (3c),
and are subject to its restrictions and conventions.
It is an error if no dictionaries are specified.
.VL \n[Pi]
.MANOPT=LI -d dictionary
The specified dictionary is loaded and used in addition to the default
dictionary.
This is optional unless
.V= -n
is used.
.MANOPT=LI -n
The default special dictionary
is excluded and only explicitly specified dictionaries are used.
.MANOPT=LI -x
Debug statistics about the hash table are dumped.
If the
.V= -x
option is given more than once,
the entire hash table is dumped.
The files to be spell checked are ignored if this option is specified.
.MANOPT=LI -y
Turns on the scanner's debug flag.
.MANOPT=LI -@ debugflags
Turns on debugging flags for the
.V= DEBUGF
macro.
The option
.V= -@@
turns on all debug flags.
.LE
.MANPAGE=LI "OPERANDS"
Each operand is the name of file whose words are to be checked for
spelling errors.
A word is any sequence of letters and digits, possibly with the
characters ampersand
.=V ( & ),
apostrophe
.=V ( ' ),
hyphen
.=V ( - ),
or period
.=V ( . )
embedded with the word.
If a filename is specified as a minus sign
.=V ( - ),
it causes
.V= stdin
it be read at that point.
If no filenames are specified,
.V= stdin
is spell checked.
.MANPAGE=LI "EXIT STATUS"
.VL \n[Pi]
.LI 0
No errors nor misspelled words were detected.
.LI 1
One or more misspelled words were detected, but there were no errors.
.LI 2
One or more errors were detected and error messages were printed.
.LE
.MANPAGE=LI "FILES"
.VL \n[Pi]
.MANOPT=LI /afs/cats.ucsc.edu/courses/cmps012b-wm/usr/dict/words
.br
Contains the default dictionary.
.LE
.MANPAGE=LI "BUGS"
Standard spell-checking algorithms for variations on words as to
number and tense are not performed.
In any case, poems like the one in
Figure \*[Figure_SPELLCHEQUER] are likely to confuse most spelling
checkers.
.LE
.de poem-column1
.nf
.P
Eye halve a spelling chequer
It came with my pea sea
It plainly marques four my revue
Miss steaks eye kin knot sea
.P
Eye strike a quay and type a word
And weight four it two say
Weather eye am wrong oar rite
It shows me strait a weigh
..
.de poem-column2
.nf
.P
As soon as a mist ache is maid
It nose bee fore two long
And eye can put the error rite
Its rare lea ever wrong
.P
Eye have run this poem threw it
Eye am shore your pleased two no
Its letter perfect all the weigh
My chequer tolled me sew.
..
.DF CB
.ie t \{.\"
.TS
box tab(|); l lfI lfI l.
.SP
|T{
.poem-column1
T}|T{
.poem-column2
T}
.SP
.TE
.\}
.el \{.\"
.poem-column1
.poem-column2
.\}
.FG "Test file for \f[CB]spellchk\f[R]" "" 0 SPELLCHEQUER
\&
.DE
.H 1 "Survey of the code"
Study the existing code, which is a partial implementation of your
program.
There are several modules and other files,
most with a separate
.V= \&.h
and
.V= \&.c
file.
.ALX i ()
.LI
The default dictionary really ought to be
.V= /usr/share/dict/words ,
and would actually be in a real implementation,
however it is very large on Linux,
so a smaller dictionary was copied from a Solaris machine.
Using the smaller dictionary will allow you to test your program
without needing to use a very large amount of memory,
expecially when debugging.
See the output of
.V= wc (1)\(::
.VTCODE* 1 "  25143   25143  206663 cmps012b-wm/usr/dict/words"
.VTCODE* 1 " 479623  479623 4950996 /usr/share/dict/words"
.LI
.V= Makefile
contains the usual building information.
.V= Makefile.deps
is a generated file which lists the dependencies.
It must be regenerated any time there is a change to any
.V= #include 
statement in your program.
.LI
The program
.V= pspell.perl
is a reference implementation,
but does  not contain debug switches.
.LI
The module
.V= debugf
contains some useful utility functions which are generally
useful for debugging.
See
.V= debugf.h
for a description of each function.
.LI
The module
.V= hashset
will require the most work.
A stub has been provided,
along with a hashing function
.V= strhash .
You will need to add functions that print out the required debugging
and also replace the calls to
.V= STUBPRINTF
or
.V= DEBUGF
with working code.
.LI
The file
.V= scanner.l
contains a scanner which reads words from the files to be tested.
You need not understand exactly how this works,
just how to call it to extract words.
The file
.V= yyextern.h
has definitions of the files in the program generated by the scanner.
See Figure \*[Figure_YYLEX] for a description of the variables.
.LI
The main program,
.V= spellchk ,
will scan the options, load the dictionaries,
and then do the spell checking.
.LE
.SP
.DF CB
.TS
allbox tab(|); lw(200)fCB lw(281p).
FILE *yyin;|T{
.fi
Is the file from which
.V= yylex
reads its input.
It must be opened before calling
.V= yylex
to read any file.
If it is not
.V= stdin ,
then it should be closed when 
.V= yylex 
is done with the file.
T}
char *yytext;|T{
.fi
Whenever
.V= yylex
returns from scanning,
this variable points into its buffer at the word just recognized.
T}
int yy_flex_debug;|T{
.fi
This is a debug flag which puts
.V= yylex
into verbose mode.
You probably don't need it.
T}
int yylex (void);|T{
.fi
Scans the file
.V= yyin
and for each word found, returns a non-zero integer code, leaving 
.V= yytext
to point at the word.
It returns 0 at end of file.
T}
int yylineno;|T{
.fi
is used by
.V= yylex
to keep track of the current line number,
which is useful to you in error reporting.
It needs to be reset to 1 before beginning a scan.
T}
void yylex_destroy (void);|T{
.fi
Cleans up the buffers allocated by
.V= yylex
and releases their storage.
This is called only when
.V= yylex
is no longer needed.
T}
.TE
.FG "Interface to the function \f[CB]yylex()\f[P]" "" 0 YYLEX
\&
.DE
.H 1 "Implementation \[em] Loading the dictionaries"
Before implementing the hash sets,
the dictionaries must be loaded into memory.
.ALX i ()
.LI
There are two dictionaries to be loaded.
Look for the stub which prints the message
``Load dictionaries''.
Replace this with a loop that loads the dictionaries into the
hash set.
.LI
The variables
.V= default_dictionary
and
.V= user_dictionary
contain, respectively, the names of the default and user dictionaries.
A null value indicates that the dictionary should not be loaded.
Print an error message and stop if neither dictionary is present.
.LI
Create a
.V= hashset
and iterate over each dictionary.
Read each line using
.V= fgets (3c)
and chomp off the trailing
newline character.
Then call
.V= put_hashset
with each word.
.LI
Test your program.
Use
.V= "valgrind"
to find problems with uninitialized pointers and other bad memory
references.
Ignore any complaints it makes about memory leak.
Fix any problems with segmentation faults or bus errors or other
problems reported by
.V= valgrind
and
.V= gdb .
.LE
.H 1 "Implementation \[em] The hash set"
Allocation and freeing of the hash set has been implement,
but not insertion and searching.
.ALX i ()
.LI
A function
.V= strhash
has been provided which takes a string and, using Horner's method,
iterates over the string to compute
$ sum from { i = 0 } to { n - 1 }
c sub i times 65599 sup { n - i - 1 } $
where $c$ is the integer coded value for each character in the string.
Since overflow happens with longer words,
we avoid negative numbers by using the defined data type
.V= size_t ,
which is defined to be an unsigned 64-bit integer.
You must declare any variable that is the result of the function
.V= strhash
of this type, and not
.V= int .
.LI
To search the hash set,
compute the hash code first,
then take it remainder the size of the array\(::
.VINDENT* "hash_index = strhash (word) % hashset->size;"
Then use that index to choose a particular hash chain
and perform a linear search down that hash chain using
.V= strcmp (1)
until you find equality or run off the end of the chain.
.LI
Note that searching the chain is
.E= *not*
an $ O ( n ) $
operation, because we consider $n$ to be the total number of
elements in the has set.
If there are $k$ hash chains, then on the average,
each chain will be about $ O ( n / k ) $ in length.
If each chain is about the same length and $ n <= k / 2 $,
this works out to be $ O ( 1 ) $.
.LI
To put a new word into the hash set,
first hash it, and then search exactly as you did for
.V= has_hashset .
If the word is found and already there,
.E= "do not"
insert it\(;;
just return.
If you find a null pointer before finding the word,
store the address of the word in the hash set
by prepending it to the particular hash chain.
.LI
At any time if the 
.V= "load * 2 > size"
(the number of words in the hash set is more than a half the size
of the array),
perform array doubling.
A hash modulus works better when it is not a power of two,
but $ 2 sup k - 1 $ works fine,
where $k$ is a small positive integer,
which is why the initial size was 15.
To double the array, the new size should be $ 2 n + 1 $ if
the previous size was $ n $.
This means that the sequence of sizes is
.nr size 15
.nr max 479623*4
.while \n[size]<\n[max] \{ .\"
.   nop \n[size],
.   nr size \n[size]*2+1
.\}
etc.
.LI
The algorithm for doubling the size of the hash table is
given in pseudocode in Figure \*[Figure_HASHDOUBLING].
Note that initial insertion does a
.V= strdup (3c),
but here, only the pointer is copied.
.br
.DF CB
.TS
box tab(|); lw(350p).
\&
    Allocate a new array and set all its pointers to null.
    For each entry in the old array\(::
          While that entry is not null\(::
                Pop the hash node from the front of the list.
                Recompute the hash number.
                Compute its index in the new array.
                Push the hash node onto that index of the new array.
    Free the old array.
    Point the struct hash at the new array.
\&
.TE
.FG "Array doubling for a hash table" "" 0 HASHDOUBLING
.DE
.LI
Implement the debugging requirements.
For the 
.V= -x
option given once,
print out a table like the one in Figure \*[Figure_SAMPLEDEBUG]
with numbers actually gleaned from the hash table.
.DF CB
.TS
box tab(|); lfCRw(230p).
\&
     25143 words in the hash set
     65535 size of the hash array
     24802 chains of size  1
       100 chains of size  2
        40 chains of size  3
         3 chains of size  7
\&
.TE
.FG "Sample \f[CB]-x\f[P] debug output" "" 0 SAMPLEDEBUG
.DE
.LI
If the
.V= -x
option is specified more than once,
follow this information with an actual dump of the
hash set,
printing out each entry with subscript,
hash code, and string.
For elements of the same chain,
print out the subscript only once.
Print out only those entries that are not null.
For example\(::
.VINDENT* "array[        20] =              2489332 \[Dq]foobar\[Dq]"
.VINDENT* "                  =           2872521232 \[Dq]testing\[Dq]"
.VINDENT* "array[        24] =              3482567 \[Dq]quux\[Dq]"
This indicates that chain 20 has ``foobar'' and ``testing'',
and that chain 24 has ``quux''.
Use the format string
.VINDENT* "\[Dq]array[%10d] = %20lu \[rs]\[Dq]%s\[rs]\[Dq]\[rs]n\[Dq]"
for the first item on a chain, and a similar format without the
array index for the other items.
Neatly align everything in vertical columns.
.LE
.H 1 "Implementation \[em] The final stages"
At this point the program is almost complete.
A few more things need to be done.
.ALX i ()
.LI
The scanner
.V= scanner.l
is written in the 
.V= flex
language and extracts words from a file that has been opened for the 
.V= FILE*
variable
.V= yyin .
It is used to generate the C module
.V= scanner.c ,
the contents of which you do not need to read.
Just treat it like any other library module.
.LI
Implement the function
.V= spellcheck
so that for each word that is found,
the word is looked up in the dictionary.
If it is not found, convert the word to lower case
.=V ( tolower (3c)),
and then look it up again.
This is done so that capitalized words,
such as at the beginning of a sentence,
will be found.
Proper names in the dictionaries are given in upper case,
so will not be found if spelled in lower case.
.LI
Make sure the exit status of the program is correct as defined in the
man page at the beginning of this document.
Run
.V= gdb
and
.V= "valgrind"
to verify that you have no memory problems.
.LI
If you have time,
eliminate memory leak by freeing up all of storage.
Check the errors file generated by
.V= valgrind .
.LI
Use
.V= checksource
and
.V= lint
to verify good coding style.
Read
.V= Coding-style/ .
.LE
.H 1 "What to submit"
.V= README ,
.V= Makefile ,
.V= debugf.h ,
.V= hashset.h ,
.V= strhash.h ,
.V= yyextern.h ,
.V= debugf.c ,
.V= hashset.c ,
.V= spellchk.c ,
.V= strhash.c ,
.V= scanner.l .
Do not submit the file
.V= scanner.c ,
which will be created when 
.V= gmake
is run.
Do not submit any files that are built by
.V= gmake .
Verify that the 
.V= submit
target in the 
.V= Makefile
is in fact correct and really does submit all files
needed to build the target and does not submit any files that
need to be generated.
If you are doing pair programming,
carefully follow the instructions in
.V= /afs/cats.ucsc.edu/courses/cmps012b-wm/Syllabus/pair-programming/ .
.FINISH
