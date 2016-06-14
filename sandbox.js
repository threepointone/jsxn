import { parse } from './src'
let src = `&nbsp; <test>
  something else
  <inner/>
</test>`
let parsed = parse(src)
console.log(JSON.stringify(parsed)) //eslint-disable-line no-console
