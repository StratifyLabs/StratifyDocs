{{anchor refid}}

## {{name}}

{{detaileddescription}}

{{#if filtered.members}}

### Prototypes

{{#each filtered.compounds}}
- {{cell proto}} {{cell summary}}
{{/each}}{{#each filtered.members}}- {{cell proto}}
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
