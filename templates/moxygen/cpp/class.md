## {{kind}} `{{name}}`

{{detaileddescription}}

{{#if filtered.members}}

### Summary

 Members                        | Descriptions                                
--------------------------------|---------------------------------------------
{{#each filtered.compounds}}{{cell proto}}        | {{cell summary}}
{{/each}}{{#each filtered.members}}{{cell proto}} | {{cell summary}}
{{/each}}

### Members

{{#each filtered.compounds}}
#### {{title proto}}

{{detaileddescription}}

-----------------------------------

{{/each}}

{{#each filtered.members}}
#### {{title proto}}

{{#if enumvalue}}
 Values                         | Descriptions                                
--------------------------------|---------------------------------------------
{{#each enumvalue}}{{cell name}}            | {{cell summary}}
{{/each}}
{{/if}}

{{detaileddescription}}

-----------------------------------

{{/each}}

{{/if}}

