let tests = [`<test/>`,
`
leading text
<test>
  some inner text
  <inner/>
</test>`,
`<outer prop1=123>
  <inner prop2="asddf"/>
  something else 
  <inner prop3={"x": 213}/>
</outer>`]

import {parse} from '../src'
tests.map(x => console.log(x, JSON.stringify(parse(x), null, ' ')))
