# Expressões Regulares
Também conhecidas como regex (abreviação de regular expression), são padrões de caracteres utilizados para realizar busca e manipulação de texto em diferentes linguagens de programação.<br>
Permitem que sejam realizadas buscas de texto em uma string usando uma série de regras e símbolos especiais. Com elas, podemos procurar por padrões específicos de caracteres, como um número de telefone, um endereço de e-mail ou uma palavra-chave.

Para esse trabalho em específico, temos como objetivo reconhecer datas, horários, nomes, ações e tags dentro de frases e separando os mesmos em blocos. 
Exemplo:
 - "Agendar reunião com João amanhã às 10:00 #trabalho"

Ao rodar nosso código em cima dessa frase, teremos separados os seguintes blocos:
 - Data: 03/04/2023 (Considerando o dia atual como 02/04/2023)
 - Horário: às 10
 - Pessoa: João
 - Ação: Agendar
 - Tag: #trabalho

## Modelagem
Como ponto de partida para resolução desse problema, quebramos o mesmo em partes, criando regex separadas para reconhecer cada um dos itens.

### Data
<pre>
/(([0-2][0-9]|3[0-1])(( de [A-Za-z][a-z]+( de [0-9]{4})?)|(\/[0-9]{2}(\/[0-9]{4})?))|antes de ontem|anteontem|ontem|hoje|amanhã|depois de amanhã)/
</pre>

|Cadeia de Caracteres|Descrição|
|:----:|----|
|([0-2][0-9]\|3[0-1])|Começa buscando por um dia do mês, que pode ser de 01 a 31. A primeira parte da expressão, "[0-2][0-9]", reconhece qualquer número de 01 a 29, enquanto que a segunda parte, "3[0-1]", reconhece o número 30 ou 31, que são os dias possíveis para os meses com 30 ou 31 dias, respectivamente|
|(( de [A-Za-z][a-z]+( de [0-9]{4})?)\|(/[0-9]{2}(/[0-9]{4})?))|Busca por um espaço seguido da palavra "de", seguida de uma palavra que representa o mês (com a primeira letra maiúscula e as demais minúsculas), que pode ser seguida de mais um espaço e da palavra "de" seguida de um número com 4 dígitos, que representa o ano. Alternativamente, a expressão reconhece a mesma informação no formato de data separada por barras, com o dia em primeiro lugar, depois o mês e por último o ano. Como no caso anterior, todo esse trecho entre parênteses é opcional|
|(\|antes de ontem\|anteontem\|ontem\|hoje\|amanhã\|depois de amanhã)|Busca por algumas palavras chave que representam datas específicas: "antes de ontem", "anteontem", "ontem", "hoje", "amanhã" e "depois de amanhã".|

#### Testes
![image](https://user-images.githubusercontent.com/76501071/229380056-e2f3de28-60ee-420e-acb4-e9da2f7d46df.png)

#### Script de Código
Para a parte de datas, utilizamos uma parte do código para focar em datas escritas na forma de "amanhã", "ontem", "hoje" e etc. Com o intuito de manter uma padronização na demonstração.

Seguindo o código abaixo:

```ruby
if 'AMANHÃ' == _date.upcase
  hoje = Date.today
  data = hoje.next_day.strftime('%d/%m/%Y')
elsif 'DEPOIS DE AMANHÃ' == _date.upcase
  hoje = Date.today
  data = hoje.next_day.next_day.strftime('%d/%m/%Y')
elsif 'HOJE' == _date.upcase
  data = Date.today.strftime('%d/%m/%Y')
elsif 'ONTEM' == _date.upcase
  hoje = Date.today
  data = hoje.prev_day.strftime('%d/%m/%Y')
elsif 'ANTEONTEM' == _date.upcase or 'ANTES DE ONTEM' == _date.upcase
  hoje = Date.today
  data = hoje.prev_day.prev_day.strftime('%d/%m/%Y')
else
  data = _date
end

puts("Data: " + data)
puts("Horário: " + _horario)
puts("Pessoa: " + _pessoa)
puts("Ação: " + _action)
puts("Tag: " + _tag)
```


### Horário
<pre>
/(([0-9]?[0-9](((\:| )[0-9]{2})| *[a-z]+))|[a-záàâãéèêíïóôõöúçñ]{2} [0-9]?[0-9](horas|hora)?)/
</pre>

|Cadeia de Caracteres|Descrição|
|:----:|----|
|([0-9]?[0-9](((\:\| )[0-9]{2})\| \*[a-z]+))|Reconhece padrões de tempo no formato hh:mm ou hh mm. Os dois primeiros dígitos podem ser opcionais, permitindo que a hora seja reconhecida em formatos como "8:30" ou "08:30". A parte do meio da regex, ((\:\| )[0-9]{2})\| [a-z]+, reconhece o separador de hora ":" ou " " e os dois últimos dígitos que representam os minutos. Alternativamente, se em vez dos minutos vier uma palavra, como "manhã" ou "tarde", a regex reconhece esses padrões de hora.|
|[a-záàâãéèêíïóôõöúçñ]{2} [0-9]?[0-9](horas\|hora)?|Reconhece padrões de hora como "duas horas", "três horas da tarde", "meia-noite", etc. Ela reconhece duas letras minúsculas que representam o horário, seguidas de um espaço e depois dois dígitos que representam a hora. A parte final, (horas\|hora)?, é opcional e reconhece a palavra "hora" ou "horas" se estiver presente.|

#### Testes
![image](https://user-images.githubusercontent.com/76501071/229380200-e2351017-43f0-47d7-a273-6ec942b37ef8.png)


### Pessoa
<pre>
/[A-ZÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ][a-záàâãéèêíïóôõöúçñ]+/
</pre>

|Cadeia de Caracteres|Descrição|
|:----:|----|
|[A-ZZÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ]|Define um conjunto de caracteres que deve aparecer no início da palavra. Nesse caso, são letras maiúsculas (A-Z) e algumas letras acentuadas utilizadas em português|
|[a-zzáàâãéèêíïóôõöúçñ]+|Define um conjunto de caracteres que deve seguir imediatamente o conjunto anterior. Nesse caso, são letras minúsculas (a-z) e algumas letras acentuadas utilizadas em português.|

#### Testes
![image](https://user-images.githubusercontent.com/76501071/229380263-0888756d-e7e5-485c-a99e-250cceaec1c9.png)


### Ação
Para esse caso em específico, focamos em retirar das frases os verbos em sua forma natural (no infinitivo)
<pre>
/(ir)|([a-zA-Z]+)(?:ar|er|ir)/
</pre>

|Cadeia de Caracteres|Descrição|
|:----:|----|
|(ir)|Grupo de captura que reconhece o verbo "ir".|
|([a-zA-Z]+)|Grupo de captura que reconhece uma ou mais letras maiúsculas ou minúsculas.|
|(?:ar\|er\|ir)|Grupo que reconhece os sufixos "ar", "er" ou "ir" dos verbos em português.|

Essa expressão regular reconhece qualquer palavra que comece com uma letra maiúscula ou minúscula, seguida por um dos sufixos "ar", "er" ou "ir", ou a palavra "ir".

#### Testes
![image](https://user-images.githubusercontent.com/76501071/229380342-91205a17-0a70-4e59-a637-2be7d5923d2c.png)


### Tag
<pre>
/\#[aA-zZ]+/
</pre>

|Cadeia de Caracteres|Descrição|
|:----:|----|
|#|Sequência de escape que corresponde ao caractere "#" literal.|
|[aA-zZ]|Conjunto de caracteres que correspondem a letras maiúsculas e minúsculas.|

Esta expressão regular corresponde a qualquer sequência de caracteres que comece com "#" e contenha uma ou mais letras de a a z (tanto maiúsculas quanto minúsculas) após o "#" inicial.

#### Testes
![image](https://user-images.githubusercontent.com/76501071/229380393-20433068-10bf-42af-af20-c8748ee9de8f.png)

