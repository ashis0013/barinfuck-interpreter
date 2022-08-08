# barinfuck-interpreter

Brainfuck interpreter written in Haskell from scratch without using any external library or any build tool (cabal). The parser with 50 lines of code only, using
interesting abstractions like Aplicatives and Alternatives. The details of the apporach taken for the parser can be found here (blog post coming soon).

To run this you need to have ghc installed. Just use the following commands and enjoy.
```bash
ghc --make main.hs
./main
```

![demo](https://user-images.githubusercontent.com/31564734/183342645-96b2d57a-b143-4167-a67b-d0e2a5f062cd.gif)
