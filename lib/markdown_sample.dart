var markdownSample = r'''
## Text Writing
It is easy to write in GFMD. Just write simply like text and use the below simple "tagging" to mark the text and you are good to go!

To specify a paragraph, leave 2 spaces at the end of the line.  
Unicode is supported. ☺

## Headings

# Sample H1
## Sample H2
### Sample H3
#### Sample H4
##### Sample H5
###### Sample H6

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
end
```

## Coding - In-line
This is some code: `echo something`

## Text Formatting
**Bold Text** or *Italic Text*.

## Hyperlinks
GFMD will automatically detect URL and convert them to links like this http://www.futureworkz.com
This is [an example](http://example.com/ "Title") inline link.  
[This link](http://example.net/) has no title attribute.

## Creating list

- Item 1
- Item 2
- Item 3


## Quoting

> This is a quote

## Table

ID | Name | Rank
-- | ---- | ----
1 | Tom Preston-Werner | Awesome
2 | Albert Einstein | Nearly as awesome

## Image

![Branching Concepts](http://git-scm.com/figures/18333fig0319-tn.png "Branching Map")
''';
