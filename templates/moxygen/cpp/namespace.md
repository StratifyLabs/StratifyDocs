{{anchor refid}}

## {{kind}} `{{name}}`

{{detaileddescription}}

**Classes**

{{#each filtered.members}}
- {{cell proto}}
{{/each}}{{#each filtered.compounds}}- {{cell proto}}
{{/each}}

{{#if filtered.members}}
**Details**

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
