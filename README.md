**Documentação**

Url Usuários: https://lemoney.herokuapp.com/
Url admin: https://lemoney.herokuapp.com/admin

Ao criar uma oferta e selecionar o dia de inicio, um worker será agendado para a data escolhida, assim ela será ativada automaticamente.

Caso a data de inicio selecionada, já tenha passado, a oferta será ativada imediatamente.

Para rodar localmente, é necessario ter o redis-server rodando e o sidekiq.
