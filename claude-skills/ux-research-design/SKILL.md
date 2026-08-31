---
name: ux-research-design
description: Referência de UX Research e design: wireframes, fluxos de usuário, usability testing, WCAG 2.2 e design tokens. Carregue ao planejar uma interface do zero, fazer auditoria de acessibilidade ou montar design system — não para implementar componente.
user-invocable: false
---

# UX Research e Design


**Métodos que um dev frontend aplica sozinho (sem time de design):**
- **Guerrilla testing**: aborde 5 pessoas com um protótipo ou staging — 80% dos problemas aparecem em 5 sessões de 15 min
- **5-second test**: mostre a tela por 5 segundos e peça para descrever o que viram — revela problemas de hierarquia visual instantaneamente
- **Think-aloud**: peça para o usuário narrar o que está tentando fazer enquanto usa — grave a tela e o áudio
- **Heuristic review**: autoavalie contra as 10 heurísticas de Nielsen antes de entregar qualquer tela nova

**WCAG 2.2 — novos critérios publicados em outubro de 2023 (ainda ignorados em 2025):**
- **2.4.11 Focus Not Obscured (AA)**: sticky headers/footers não podem ocultar completamente o elemento focado — ao menos parte do foco deve estar visível
- **2.4.12 Focus Not Obscured Enhanced (AAA)**: nenhuma parte do indicador de foco pode estar oculta por outros elementos
- **2.5.7 Dragging Movements (AA)**: toda interação de drag-and-drop precisa de alternativa por clique/toque simples
- **2.5.8 Target Size Minimum (AA)**: alvos interativos devem ter pelo menos 24×24 CSS pixels (ou ter espaçamento suficiente entre si)
- **3.2.6 Consistent Help (A)**: mecanismos de ajuda (chat, FAQ, telefone) devem aparecer na mesma posição relativa em todas as páginas
- **3.3.7 Redundant Entry (A)**: formulários multi-etapa não podem pedir a mesma informação duas vezes — autopreench ou exiba o valor já inserido
- **3.3.8 Accessible Authentication (AA)**: login não pode exigir testes cognitivos (CAPTCHA visual) sem alternativa — permita colar senha, use magic link ou passkey

**Wireframing lean — quando fazer e qual fidelidade:**
- **Low-fi (Excalidraw)**: use no início de qualquer feature nova — esboce fluxo e layout em 15 min antes de codar; descarte após alinhamento
- **Mid-fi (Figma)**: use quando há múltiplas telas interdependentes ou quando precisa validar com stakeholders — não pixelize, foque em estrutura
- **High-fi**: só se o cliente precisar de aprovação visual antes do desenvolvimento; evite se você mesmo vai codar — o código é o high-fi

**Design tokens — estrutura e integração com Tailwind v4 e PrimeVue 4:**
- 3 camadas: **Primitive** (valores brutos: `#3B82F6`) → **Semantic** (intenção: `--color-primary`) → **Component** (uso: `button.background`)
- No Tailwind v4, declare tokens no `@theme {}` — viram CSS custom properties automaticamente e ficam acessíveis em qualquer contexto
- No PrimeVue 4, sobrescreva tokens do preset via `extend` — nunca edite CSS global para mudar cores de componente
- Use `oklch()` para cores — gamut mais amplo, manipulação de lightness previsível, ideal para dark mode automático

**User flow — quando documentar vs quando ir direto ao código:**
- **Documente** quando: a feature tem 3+ telas ou estados, envolve outros devs, ou o fluxo tem bifurcações condicionais (ex: onboarding, checkout)
- **Vá direto ao código** quando: é uma tela única sem navegação complexa, ou o fluxo já existe e você está apenas modificando um componente
- Ferramenta mínima: Excalidraw com formas padrão — retângulos para telas, losangos para decisões, setas para fluxo; exporte como PNG e cole no PR

