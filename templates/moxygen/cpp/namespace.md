---
date: "2019-06-27"
layout: post
title: {{kind}}::{{name}}
katex: true
categories: {{kind}}
menu:
  sidebar:
    name: {{name}}
    parent: {{kind}}
---

{{anchor refid}}

{{detaileddescription}}

{{#each filtered.members}}
- {{cell proto}}
{{/each}}{{#each filtered.compounds}}- {{cell proto}}
{{/each}}

{{#if filtered.members}}

## Details

{{#each filtered.members}}
{{anchor refid}}

### {{title proto}}

{{#if enumvalue}}
{{#each enumvalue}}- {{cell name}} {{cell summary}}
{{/each}}
{{/if}}

{{detaileddescription}}

-----------------------------------

{{/each}}
{{/if}}
