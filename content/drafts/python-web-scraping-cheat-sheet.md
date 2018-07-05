# urllib
draft: true

## urllib.parse

## urllib.request

`urlopen()` - returns a file-like object

`urlretrieve()` - saves to file; returns filename and headers

# requests

`get()`

- `params` - dictionary of parameters

`post()`

- `data` - dictionary of parameters

## Response Class:

- `.status_code`
- `.url`
- `.text` - response as text
- `.content` - response as binary
- `.encoding`
- `.json()`

# LXML:

```
import lxml.html
```

`.fromstring()` - parses a document string

## Element Class

Acts like a list for sub-elements.

- `.tag` - tag name
- `.get()` - retrieve attributes
- `.cssselect()` - search into sub-elements
- `.text_content()`

# Beautiful Soup

## Tag Objects

Attributes are accessed like a dictionary.

- `.name`
- `.string` but you'll probably prefer `.text`
- `.has_attr()`
- `.get_text()` - merge text from all descendant tags


- `.descendants`
- `.children` - only immediate descendants


- `.parent`


- `.next_sibling` and `.previous_sibling` (and plural versions)


- `.find_all()` and `.find()` - all matches

    - `name` - tag name
    - `string` - text content; value can be string literal or regular expression
    - `**kwargs` - filter on attributes; value can be string literal or regular expression

- `.select()` and `.select_one()` - use CSS selector

# Scrapy

`fetch()`

`response.css()`
`response.url`
`response.urljoin()`

`.extract()` and `.extract_first()`

`::text` - filter
`::attr()` - filter

# Selenium

`.get()`
`.page_source`

## Elements

- `.text`
- `.get_attribute()`

- `.find_element_by_css_selector()`
- `.find_element_by_class_name()`
- `.find_element_by_id()`
- `.find_element_by_name()` - matches the name attribute
- `.find_element_by_link_text()`
- `.find_element_by_tag_name()`
- `.find_element_by_xpath()`

These also have plural versions.

- `.send_keys()`
- `.click()`
- `.clear()`