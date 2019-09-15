---
date: "2019-06-27"
layout: post
title: {{kind}}::{{name}}
katex: true
msc: true
viz: true
categories: {{kind}}
menu:
  sidebar:
    name: {{name}}
    parent: {{kind}}
---

{{anchor refid}}

{{#if basecompoundref}}
```cpp
{{kind}} {{name}}
  {{#each basecompoundref}}
  : {{prot}} {{name}}
  {{/each}}
```  
{{/if}}

{{detaileddescription}}

{{#each filtered.compounds}}- {{cell proto}}  
{{/each}}

{{#if filtered.members}}

## Details

{{#each filtered.members}}
{{anchor refid}}

##### {{title proto}}

{{#if enumvalue}}
{{#each enumvalue}}- `{{cell name}}` {{cell summary}}
{{/each}}
{{/if}}

{{detaileddescription}}

-----------------------------------

{{/each}}
{{/if}}
