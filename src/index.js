import grammar from './parser'

export function parse(src) {
  return grammar.parse(src)
}
