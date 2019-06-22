var markdownSample = r'''
An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

* this one
* that one
* the other one

Note that - not considering the asterisk - the actual text
content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Unicode is supported. ☺



An h2 header
------------

Here's a numbered list:

1. first item
2. second item
3. third item

Note again how the actual text starts at 4 columns in (4 characters
from the left side). Here's a code sample:

    # Let me re-iterate ...
    for i in 1 .. 10 { do-something(i) }

As you probably guessed, indented 4 spaces. By the way, instead of
indenting the block, you can use delimited blocks, if you like:

~~~
define foobar() {
    print "Welcome to flavor country!";
}
~~~

```
define foobar() {
    print "Welcome to flavor country!";
}
```

(which makes copying & pasting easier). You can optionally mark the
delimited block for Markdown to syntax highlight it:

```python
import time
# Quick, count to ten!
for i in range(10):
    # (but not *too* quick)
    time.sleep(0.5)
    print(i)
```


### An h3 header ###

Now a nested list:

1. First, get these ingredients:
  * carrots
  * celery
  * lentils

2. Boil some water.

3. Dump everything in the pot and follow
  this algorithm:

  ```
  find wooden spoon
  uncover pot
  stir
  cover pot
  balance wooden spoon precariously on pot handle
  wait 10 minutes
  goto first step (or shut off burner when done)
  ```

  Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 2- or 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header). Here's a footnote [^1].

[^1]: Some footnote text.

Tables can look like this:

Name         | Size|Material    |Color
-------------|-----|------------|------------
All Business |    9|leather     |brown
Roundabout   |   10|hemp canvas |natural
Cinderella   |   11|glass       |transparent

Table: Shoes sizes, materials, and colors.

(The above is the caption for the table.) Markdown also supports
multi-line tables:

--------|-----------------------
Keyword |Text
--------|-----------------------
red     |Sunsets, apples, and
        |other red or reddish
        |things.
green   |Leaves, grass, frogs
        |and other things it's
        |not easy being.
--------|-----------------------

A horizontal rule follows.

***

and another:

---

Images can be specified like so:

![example image](example-image.jpg "An exemplary image")

And note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, ex.: \`foo\`, \*bar\*, etc.


Github Flavored Markdown (GFMD) is based on [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) with some overwriting as described at [Github Flavored Markdown](http://github.github.com/github-flavored-markdown/)

## Text Writing
It is easy to write in GFMD. Just write simply like text and use the below simple "tagging" to mark the text and you are good to go!  

To specify a paragraph, leave 2 spaces at the end of the line

## Headings

# Sample H1
## Sample H2
### Sample H3


## Horizontal Rules

Horizontal rule is created using `---` on a line by itself:

---


## Coding - Block

```ruby
# The Greeter class
class Greeter
  def initialize(name)
    @name = name.capitalize
  end

  def salute
    puts "Hello #{@name}!"
  end
end

# Create a new object
g = Greeter.new("world")

# Output "Hello World!"
g.salute
```

Note: You can specify the different syntax highlighting based on the coding language eg. ruby, sh (for shell), php, etc  
Note: You must leave a blank line before the `\`\`\``

## Coding - In-line
You can produce inline-code by using only one \` to enclose the code:

This is some code: `echo something`


## Text Formatting
**Bold Text** or *Italic Text*.


## Hyperlinks
- GFMD will automatically detect URL and convert them to links like this http://www.futureworkz.com
- To specify a link on a text, do this:  
  This is [an example](http://example.com/ "Title") inline link.  
  [This link](http://example.net/) has no title attribute.


## Escape sequence
You can escape using \\ eg. \\\`


## Creating list

Adding a `-` will change it into a list:

- Item 1
- Item 2
- Item 3


## Quoting

You can create a quote using `>`:

> This is a quote

## Table and Definition list

These two can be created via HTML:

<table>
  <tr>
    <th>ID</th><th>Name</th><th>Rank</th>
  </tr>
  <tr>
    <td>1</td><td>Tom Preston-Werner</td><td>Awesome</td>
  </tr>
  <tr>
    <td>2</td><td>Albert Einstein</td><td>Nearly as awesome</td>
  </tr>
</table>

<dl>
  <dt>Lower cost</dt>
  <dd>The new version of this product costs significantly less than the previous one!</dd>
  <dt>Easier to use</dt>
  <dd>We've changed the product so that it's much easier to use!</dd>
</dl>


Alternatively

ID | Name | Rank
-- | ---- | ----
1 | Tom Preston-Werner | Awesome
2 | Albert Einstein | Nearly as awesome

## Adding Image

![Branching Concepts](http://git-scm.com/figures/18333fig0319-tn.png "Branching Map")
''';
