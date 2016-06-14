JXON =
  xs:(Element/ Text)*
  {
    return xs.filter(x => typeof x !== 'string' || x.trim().length > 0)
  }


Element =
  startTag:sTag children:(Element / Text)* endTag:eTag {
    if (startTag.type != endTag) {
      throw new Error(
        "Expected </" + startTag.type + "> but </" + endTag + "> found."
      );
    }
    children = children.filter(x => typeof x !== 'string' || x.trim().length > 0)
    if(children.length === 0){
      return startTag;
    }
    return {
      ...startTag,
      children: children
    };
  }
  / startTag:selfTag {
      return startTag
    }

prop =
  (ws
  name:label
  ws
  "="
  ws
  val: (number / string / JSON_text )
  )
  {
    return {key: name, val: val}
  }

props = p:prop*
  { return p.reduce((o, prop) => (o[prop.key] = prop.val, o), {}) }

sTag =
  "<" name:TagName props:props ws ">" { return {type: name, props: props} }

selfTag =
  "<" name:TagName props:props ws "/>" { return {type: name, props: props} }

eTag =
  "</" name:TagName ">" { return name; }

TagName = chars:[a-zA-Z]+ { return chars.join("") }
Text    = chars:[^<]+  { return chars.join("").trim() }

label = chars:[a-zA-Z0-9]+ { return chars.join("") }

ws "whitespace" = [ \t\n\r]*

JSON_text
  = ws value:value ws { return value; }

begin_attrs     = ws "(" ws
end_attrs       = ws ")" ws
begin_array     = ws "[" ws
begin_object    = ws "{" ws
end_array       = ws "]" ws
end_object      = ws "}" ws
name_separator  = ws ":" ws
value_separator = ws "," ws



/* ----- 3. Values ----- */

value
  = false
  / null
  / true
  / object
  / array
  / number
  / string

false = "false" { return false; }
null  = "null"  { return null;  }
true  = "true"  { return true;  }

/* ----- 4. Objects ----- */

object
  = begin_object
    members:(
      head:member
      tail:(value_separator m:member { return m; })*
      {
        var result = {}, i;

        result[head.name] = head.value;

        for (i = 0; i < tail.length; i++) {
          result[tail[i].name] = tail[i].value;
        }

        return result;
      }
    )?
    end_object
    { return members !== null ? members: {}; }

member
  = name:string name_separator value:value {
      return { name: name, value: value };
    }

/* ----- 5. Arrays ----- */

array
  = begin_array
    values:(
      head:value
      tail:(value_separator v:value { return v; })*
      { return [head].concat(tail); }
    )?
    end_array
    { return values !== null ? values : []; }

/* ----- 6. Numbers ----- */

number "number"
  = minus? int frac? exp? { return parseFloat(text()); }

decimal_point = "."
digit1_9      = [1-9]
e             = [eE]
exp           = e (minus / plus)? DIGIT+
frac          = decimal_point DIGIT+
int           = zero / (digit1_9 DIGIT*)
minus         = "-"
plus          = "+"
zero          = "0"

/* ----- 7. Strings ----- */

string "string"
  = quotation_mark chars:char* quotation_mark { return chars.join(""); }

char
  = unescaped
  / escape
    sequence:(
        '"'
      / "\\"
      / "/"
      / "b" { return "\b"; }
      / "f" { return "\f"; }
      / "n" { return "\n"; }
      / "r" { return "\r"; }
      / "t" { return "\t"; }
      / "u" digits:$(HEXDIG HEXDIG HEXDIG HEXDIG) {
          return String.fromCharCode(parseInt(digits, 16));
        }
    )
    { return sequence; }

escape         = "\\"
quotation_mark = '"'
unescaped      = [^\0-\x1F\x22\x5C]

/* ----- Core ABNF Rules ----- */

/* See RFC 4234, Appendix B (http://tools.ietf.org/html/rfc4627). */
DIGIT  = [0-9]
HEXDIG = [0-9a-f]i
