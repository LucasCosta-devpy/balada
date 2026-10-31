# Estudo: balada pública com bonecos de pessoas reais

> Status: **estudo, não implementado.** Guardado para retomar depois.
> Data do estudo: 30/10/2026

## Ideia

Deixar a balada pública. Cada pessoa que abrir a página vira um boneco, e todos os visitantes se veem na mesma pista, andando e dançando em tempo real.

## Conclusão

**É possível.** Complexidade **média** para ver os outros bonecos. Sobe se houver música compartilhada ou muita gente ao mesmo tempo.

## Situação atual do projeto

- `index.html`: página única (Three.js 0.160 via CDN, sem build). Tudo roda no navegador.
- `iniciar.bat`: sobe `python -m http.server 8080` e abre `http://localhost:8080`.
- Não existe servidor próprio. Cada visitante vê só o próprio mundo, com bonecos automáticos (NPCs).
- O boneco do jogador (modo 1ª pessoa) já existe como `me`, criado com `buildFig`. É a base para o boneco de cada visitante.

## Como funcionaria

1. Ao abrir a página, o navegador conecta a um servidor por **WebSocket** e entra numa sala.
2. O servidor atribui um id, um nome e uma cor ao visitante.
3. O navegador envia, de 10 a 15 vezes por segundo: posição (x, z), direção (yaw) e estado (andando, dançando, bebendo, etc.).
4. O servidor repassa esses dados aos outros visitantes da sala.
5. Cada navegador cria um boneco por visitante remoto (`buildFig`) e **interpola** o movimento entre as atualizações para não parecer travado.
6. Quando alguém fecha a aba, o servidor avisa e o boneco sai pela porta (a animação de saída já existe).
7. Os NPCs continuam existindo. Eles podem diminuir conforme entram pessoas reais, por exemplo um NPC a menos para cada visitante.

### Opções de infraestrutura

| Opção | Prós | Contras |
|---|---|---|
| Servidor Node próprio (`ws` ou Socket.IO) | Controle total, simples de entender | Precisa hospedar e manter |
| PartyKit / Cloudflare Durable Objects | Feito para salas em tempo real, barato | Conceito novo para aprender |
| Ably / Supabase Realtime / Firebase | Pronto, sem servidor para manter | Custo cresce com o número de mensagens |

## Estimativa de esforço

| Escopo | Esforço |
|---|---|
| Ver os outros andando e dançando (posição, nome, entra e sai) | 1 a 2 dias |
| Chat curto, escolher cor do boneco e dança, ir ao bar | mais alguns dias |
| Música sincronizada para todos | mais 1 a 2 dias (parte mais delicada) |
| Centenas de pessoas ao mesmo tempo | exige dividir em várias salas e otimizar |

## Pontos de atenção

- **Música:** o YouTube toca no navegador de cada pessoa. Para todos ouvirem a mesma coisa, o servidor teria que guardar qual vídeo está tocando e em que segundo. A sincronia nunca é perfeita, mas fica boa o bastante. Se cada um escolher a própria música, os outros veem a balada "muda".
- **Modo áudio real:** a captura de áudio da aba é local. Nesse modo cada pessoa vê a batida da música que ela mesma toca.
- **Dança:** a batida vem do BPM e do tempo do vídeo de cada navegador. Para os bonecos remotos dançarem juntos, enviar o **nome da dança** em vez dos ângulos (cada navegador anima localmente). Isso reduz o tráfego.
- **Hospedagem:** precisa de servidor sempre ligado e de **HTTPS**. Há opções gratuitas ou baratas (Render, Fly.io, Railway, Cloudflare). O servidor em tempo real é o que costuma gerar custo se encher de gente.
- **Público de verdade:** pensar em moderação (nomes e chat ofensivos), limite de pessoas por sala e validação do que o servidor aceita (evitar posições falsas, como teletransporte). Sem chat livre e com nomes sorteados, o risco é bem menor.
- **Desempenho:** cada boneco tem cerca de 40 malhas. Com 30 ou mais bonecos visíveis, convém reduzir detalhe dos distantes ou limitar a sala (por exemplo, 30 a 50 pessoas).
- **Privacidade:** não pedir nem guardar dados pessoais. Usar apelido sorteado ou escolhido, sem cadastro.

## Plano sugerido (quando retomar)

1. **Versão mínima:** servidor de sala, visitantes aparecem como bonecos, andam, entram e saem pela porta. Limite de 30 por sala.
2. **Estado do boneco:** sincronizar a dança, o bar e o grupo.
3. **Música compartilhada:** um DJ escolhe o vídeo e o servidor sincroniza o início.
4. **Extras:** chat curto, cor e nome escolhidos, várias salas.

## Decisões em aberto

- Qual infraestrutura usar (servidor próprio ou serviço pronto) e onde hospedar.
- A música é única para todos ou cada um toca a sua?
- Quem pode ser DJ (qualquer um, só você, revezamento)?
- Haverá chat? Se sim, livre ou só frases prontas?
- Limite de pessoas por sala.
- O que fazer com os NPCs quando a sala tiver gente real.
