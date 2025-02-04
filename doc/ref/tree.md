# Why are languages commonly structured as trees?
> https://philosophy.stackexchange.com/questions/120393/why-are-languages-commonly-structured-as-trees

Trees are good at illustrating the Principle of Compositionality
and are good tools visually and algebraically in what is known as a phrase structure grammar.

From Wikipedia:
> In a broader sense, phrase structure grammars are also known as constituency grammars.
> The defining character of phrase structure grammars is thus their adherence to the constituency relation,
> as opposed to the dependency relation of dependency grammars.

The distance between words, psycholinguistically speaking,
increases our ability to use lexemes in combinations to efficiently chunk meaning.
For instance, in most languages, one tends to find modifiers immediately preceding or trailing nouns.
This closeness in distance might be considered an ostention of sort,
since the proximity allows for a rapid association to be perceived by the mind.
Since trees are topographically predisposed to indicating proximity, it helps to show lexemic relationships graphically.

The other major type of grammar in linguistic theory is called the dependency grammar.
This sort of grammar doesn't work as well because it deprives one the tool of 1:n relationships,
a fact noted in the section comparing the PSG and DG.

From Wikipedia:
> Dependency is a one-to-one correspondence:
> for every element (e.g. word or morph) in the sentence,
> there is exactly one node in the structure of that sentence that corresponds to that element.
> The result of this one-to-one correspondence is that dependency grammars are word (or morph) grammars.
> All that exist are the elements and the dependencies that connect the elements into a structure.
> This situation should be compared with phrase structure.
> Phrase structure is a one-to-one-or-more correspondence

Why would you want to limit yourself by excluding 1 to n mappings?
Yes, technically, one has a tree even if it's a strict sequence of populated nodes,
but by attaching more than one populated node to parent node, it's possible to compress our graph.

From a computational standpoint (read NLP),
trees allow us to parse grammars and build a data structure that are easy to deal with because we have a robust toolbox.
In CS, it's common for parsers of any grammar to build abstract syntax trees (ASTs).
ASTs improve computational efficiency because they minimize the distance between any two nodes in the tree.
Consider a string with 1,000 tokens. From the first to the last token has a distance of 999.
But collapse that into a binary tree (recall 210 is 1024),
and we can potentially shorten the distance between two nodes to less than 10.
There's also the strength that mathematical trees are amenable to recursion and processing by Turing machines,
which is an important property of more sophisticated grammars used in predicate logics and the like.

From a linguistic standpoint, trees also allow us to move around phrases as subtrees, a notion known originally as transformation.
Thus, when Chomsky and others adopted the notion of transformation from historical linguistics and began experimenting with expressing deep structure,
an idea related to syntactic synonymy of sentences,
part of the solution was to simply show those transformations by showing a sequence of trees with rearranged nodes.
Those nodes are frequently phrases represented as sub-trees which hints that it is not only syntax,
but semantics that is preserved under such transformations.

