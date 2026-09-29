# 📋 Homologação em Par — Teste Cruzado (Flutter)

**Projeto avaliado:** Samuel / https://github.com/samuelgcabral/more-devs-ecomm

**Dupla autora:** Lucas e Samuel

**Dupla avaliadora:** Lucas e Samuel

**Data:** 10/09/2026

---

## 🐞 Bugs encontrados

- **Overflow na tela de cadastro:** na tela de cadastro, ao clicar em um campo que abre o teclado digital (seja no celular ou no emulador), os requisitos de senha apresentam um problema de `BottomOverflow`, fazendo com que o conteúdo ultrapasse o espaço disponível na tela.

![Overflow no Cadastro](https://i.imgur.com/h6i5GF1.png)

- **Query de busca persistente entre categorias:** na tela de categorias, ao realizar uma busca por produtos e sair da tela com a `query` preenchida, a `query` permanece armazenada internamente. Ao acessar uma categoria diferente, a busca continua sendo aplicada aos produtos da nova categoria. O ideal seria limpar a `query` ao sair da tela ou ao mudar de categoria.

![Query Persistindo](https://i.imgur.com/WsiMOdH.png)

---

## ⚠️ Práticas ruins de codificação

- **Redundância na nomeação do `signupController`:** na `SignupPage`, há uma declaração redundante do `SignupController`:

![Redundância](https://i.imgur.com/3xf8MI4.png)

Poderia ser simplificado para uma única instância:

```dart
SignupController _signupController = SignupController();
```

- **Código comentado no `AppTextField`:** há uma linha de código comentada que caracteriza _code smell_:

![Code Smell](https://i.imgur.com/HMVv35t.png)

Como o código não está sendo utilizado, o ideal é removê-lo para evitar ruído e manter o código mais limpo.
