# vim-tangle

Vim tangle is my first Plugin. The aim of it is to allow users to reproduce the
behavior of the emacs' tangle function, and output the code blocks of a markdown
file to another file using the metadata written in Yaml at the header of the
markdown file.

___

- [Installation & Documentation](#instalation-and-documentation)

## Installation and Documentation

### Installation

Using Plug

```vim
Plug 'luelvira/vim-tangle'
```

### Usage

Write the metadata at the header of the file like this:
```yaml
tangle: myfile.ext
```

Once you have this section, you can run the function `:TangleFile`, and it
generates a file with all the code blocks on the file



