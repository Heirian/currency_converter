# CurrencyConverter

é uma API Rest capaz de realizar a conversão entre duas moedas utilizando taxas de conversões atualizadas de um serviço externo ([`exchangerates`](https://exchangeratesapi.io/)).

## Instalação

Primeiramente faça uma cópia do projeto:
```bash
$ git clone git@github.com:Heirian/currency_converter.git
```

Depois entre na pasta do projeto:
```bash
$ cd currency_converter
```

Na pasta do projeto agora instalamos as dependências:
```bash
$ mix deps.get
```

Depois crie e migre o seu banco de dados:
```bash
$ mix ecto.setup
```

Resta apenas configurar a chave da api do serviço externo:
```bash
$ export EXCHANGERATESAPI_KEY="sua_chave_da_api"
```

Agora inicie o seu servidor com:
```bash
$ mix phx.server
```

Agora você pode visitar [`localhost:4000`](http://localhost:4000) no seu navegador.


## Uso

> Nota: Para propósito de teste você pode utilizar um cliente REST nessa seção como POSTMAN, INSOMNIA, etc

Primeiramente registre o seu usuário em http://localhost:4000/api/users com uma requisição POST
```json
{
	"user": {
		"email": "user@email.com",
		"password": "111111"
	}
}
```

Um novo usuário será criado e a seguinte resposta retornará em caso de sucesso:
```text
User successfully registered with email: user@email.com
```

Com o usuário registrado você poderá se conectar a aplicação em http://localhost:4000/api/session/new com uma requisição POST
```json
{
	"email": "user@email.com",
	"password": "111111"
}
```

Será retornado então um token para a sua sessão
```json
{
	"access_token": "token_gerado"
}
```

Com o token de acesso gerado você pode então adicioná-lo ao `Header` das suas requisições somado ao prefixo `Bearer ` como valor da chave `Authorization`. Assim você estará apto a fazer a conversão das moedas e a resgatar seu histórico de converções.

Agora devidamente autenticado você pode converter as moedas em http://localhost:4000/api/currency_conversion_histories com uma requisição POST
```json
{
	"origin_currency": "EUR",
	"target_currency": "BRL",
	"origin_currency_value": 500
}
```
> Nota2: Uma lista das moedas disponíveis se encontra no link do serviço externo ([`Lista de moedas`](https://api.exchangeratesapi.io/v1/symbols?)). Lembrando que é necessário também o uso da chave de acesso como `access_key=API_KEY` adicionado ao restante do link.
> Nota3: `origin_currency` sempre deverá ser enviado mesmo para o plano free do serviço externo que limita o uso de `EUR` como moeda base.

Será retornado a conversão
```json
{
	"data": {
		"conversion_rate": 6.100549,
		"date": "2022-02-04T20:50:41",
		"id": 1,
		"origin_currency": "EUR",
		"origin_currency_value": 500.0,
		"target_currency": "BRL",
		"target_currency_value": 3050.2745,
		"user_id": 1
	}
}
```

Enfim para ver a lista com seus históricos de conversão acesse http://localhost:4000/api/currency_conversion_histories com uma requisição GET. Então será retornado
```json
{
	"data": [
		{
			"conversion_rate": 6.100549,
			"date": "2022-02-04T20:50:41",
			"id": 1,
			"origin_currency": "EUR",
			"origin_currency_value": 500.0,
			"target_currency": "BRL",
			"target_currency_value": 3050.2745,
			"user_id": 1
		}
	]
}
```

> Nota4: Esta aplicação está disponível on-line no Heroku neste [`link`](https://guarded-dusk-20442.herokuapp.com)

## Apresentação

O projeto se trata de uma API Rest capaz de registrar e autenticar usuários para que eles possam converter valores em diversas moedas de acordo com taxas atualizas. Também tendo acesso ao seu histórico de conversões das moedas.

O usuário é capaz de se registrar, se contectar gerando um token de acesso para controlar a sua sessão. É capaz também de se desconectar e atualizar seu token.

No quesito das conversões o usuário é capaz de converter um valor entre duas moedas selecionados. Também é possível resgatar uma lista com o histórico de conversões feitas pelo usuário.

Foram selecionadas 4 dependências para auxiliar no propósito do projeto.
`bcrypt_elixir` foi escolhido para proteger a senha dos usuários no banco de dados.
`guardian` foi escolhido para gerenciar as sessões dos usuários.
`testa` e `hackney` foram escolhidos para gerenciar as requisições HTTP para o serviço externo.

As camadas foram separadas em 3. A camada que em que se enquadrava o usuário que era a `Accounts`, sendo assim responsável por manipular o usuário. A `Authentication` foi utilizada para a configuração do `guardian` sendo responsável pela sessão. E por fim `Finances` responsável pelo histórico de conversão de moedas.
