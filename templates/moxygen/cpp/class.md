---
date: "2019-06-27"
layout: post
title: {{kind}}::{{name}}
katex: true
msc: true
viz: true
categories: {{kind}}
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

{{#if filtered.members}}

### Members

{{#each filtered.members}}###### {{cell proto}}

{{/each}}{{#each filtered.compounds}}###### {{cell proto}}

{{/each}}


### Details

{{#each filtered.compounds}}
{{anchor refid}}

##### {{title proto}}

{{detaileddescription}}

-----------------------------------

{{/each}}

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

