{{anchor refid}}

## {{kind}} `{{name}}`

{{detaileddescription}}

{{#if filtered.members}}

### Methods

{{#each filtered.members}}
- {{cell proto}} {{cell summary}}
{{/each}}{{#each filtered.compounds}}- {{cell proto}} {{cell summary}}
{{/each}}

### Details

{{#each filtered.compounds}}
{{anchor refid}}

#### {{title proto}} 

{{detaileddescription}}

-----------------------------------

{{/each}}

{{#each filtered.members}}
{{anchor refid}}

#### {{title proto}}

{{#if enumvalue}}
{{#each enumvalue}}- {{cell name}} {{cell summary}}
{{/each}}
{{/if}}

{{detaileddescription}}

-----------------------------------

{{/each}}

{{/if}}

