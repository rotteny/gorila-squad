---
name: testes-frontend-ts
description: Referência de testes frontend e TypeScript: Vitest 2/3 (browser mode, coverage v8), Playwright 1.44+ (E2E e API testing, fixtures, trace viewer) e TypeScript strict mode. Carregue ao escrever teste de front ou configurar tsconfig — o núcleo PHP é Pest e PHPStan.
user-invocable: false
---

# Testes Frontend e TypeScript Strict

### Vitest 2.x / 3.x (projetos Vite/React/Vue)
- **Browser Mode estável** (v4+): `@vitest/browser-playwright` para testes em browser real, sem jsdom
- **Coverage V8 com AST remapping** (desde v3.2): velocidade do V8 + precisão do Istanbul — use `provider: 'v8'`
- **Snapshot inline**: `toMatchInlineSnapshot()` para snapshots pequenos direto no arquivo de teste
- **Visual Regression**: `toMatchScreenshot()` em browser mode — substitui libs externas para casos simples
- Config recomendada: `coverage: { provider: 'v8', thresholds: { lines: 80, branches: 80 } }`
- **Anti-pattern**: usar jsdom para testar componentes que dependem de APIs de browser reais (Canvas, Web Components)

### Playwright 1.44+ (E2E e API Testing)
- **Fixtures compostos**: fixtures podem depender uns dos outros — crie `authenticatedPage` que extende `page` com login automático
- **API Testing nativo**: use `request` fixture para testar endpoints sem browser — `await request.post('/api/users', { data: {...} })`
- **Visual comparisons**: `await expect(page).toHaveScreenshot('baseline.png', { maxDiffPixelRatio: 0.01 })` — gera diff automático
- **Action annotations**: anote ações com `test.step('descrição', ...)` para relatórios legíveis
- **Anti-pattern**: seletores por texto visível ou XPath frágil — prefira `data-testid` ou roles ARIA (`getByRole`, `getByLabel`)
- **Anti-pattern**: `page.waitForTimeout(2000)` — use `waitForSelector`, `waitForResponse` ou `expect(locator).toBeVisible()`


### TypeScript Strict Mode (2025)
- `strict: true` é o mínimo — adicione separadamente: `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `verbatimModuleSyntax`
- **`satisfies` operator**: use para validar configs sem perder o tipo inferido — `const config = { port: 3000 } satisfies Config`
- **`noUncheckedIndexedAccess`**: `arr[0]` passa a ser `T | undefined` — force tratamento de índices out-of-bounds
- **Template literal types**: use para tipar string patterns — `type Route = \`/api/\${string}\``; evita strings mágicas
- **Anti-pattern**: `as any` ou `// @ts-ignore` sem comentário — sinalize sempre com `// TODO: remover após X`
- **Anti-pattern**: enums em vez de `as const` objects — enums geram código JS extra; `satisfies` + `as const` é mais tree-shakeable
