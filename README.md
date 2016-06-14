jsxn
---

(work in progress)

jsx notation for json trees

`npm install @threepointone/jsxn --save`

jsxn is a natural fit for describing hierarchical "trees" of nodes made of `type`/`props`/`children`, such as -

- rich, structured text
- page layouts
- configs


```jsx
<carousel delay=300 animation='appear'>
  <banner src='photo1.jpg' title='slide 1'>
    some inner text
  </banner>  
  <banner src='photo2.jpg' title='slide 2' active/>
  ...
</carousel>

// corresponds to -

[{
  type: 'carousel',
  props: {
    delay: 300,
    animation: 'appear'
  },  
  children: [
    {
      type: 'banner',
      props: {
        src: 'photo1.jpg'
        title: 'slide 1'
      },
      children: [
        'some inner text',
      ]
    },

    {
      type: 'banner',
      props: {
        src: 'photo2.jpg'
        title: 'slide 2',
        active: true
      }
    },
    // ...
  ]
}]
```

api
---
```jsx
import { parse } from '@threepointone/jsxn'

let src = `<test prop=123 o={x: 'abc'}/>`
console.log(parse(src))
/* ... becomes */
[{
  type: 'test',
  props: {
    prop: 123,
    o: {
      x: 'abc'
    }
  }

}]

```


todo
---

- basic parsing - done!
- match jsx whitespace spec
- singlequotes/backticks
- quoteless json keys
- good errors
