require 'date'

def getting_value_of_regular_expression(text, regular_expression)
  text.match(regular_expression)
end

def update_new_text(text, text_to_remove)
  text.gsub(text_to_remove, '')
end
puts("Digite o agendamento.\nExemplo: Agendar com José reunião às 10:00 amanhã #trabalho")
$text_example = gets

$action_regex = Regexp.new '(ir)|([a-zA-Z]+)(?:ar|er|ir)'
$pessoa_regex = Regexp.new '[A-ZÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ][a-záàâãéèêíïóôõöúçñ]+'
$horario_regex = Regexp.new '(([0-9]?[0-9](((\:| )[0-9]{2})| *[a-z]+))|[a-záàâãéèêíïóôõöúçñ]{2} [0-9]?[0-9](horas|hora)?)'
$date_regex = Regexp.new '([0-9]{2}(( de [A-Za-z][a-z]+( de [0-9]{4})?)|(\/[0-9]{2}(\/[0-9]{4})?))|antes de ontem|anteontem|ontem|hoje|amanhã|depois de amanhã)'
$tag_regex = Regexp.new '\#[aA-zZ]+'

_action = getting_value_of_regular_expression($text_example, $action_regex).to_s
$text_example = update_new_text($text_example, _action)

_pessoa = getting_value_of_regular_expression($text_example, $pessoa_regex).to_s
$text_example = update_new_text($text_example, _pessoa)

_horario = getting_value_of_regular_expression($text_example, $horario_regex).to_s
$text_example = update_new_text($text_example, _horario)

_date = getting_value_of_regular_expression($text_example, $date_regex).to_s
$text_example = update_new_text($text_example, _date)

_tag = getting_value_of_regular_expression($text_example, $tag_regex).to_s
$text_example = update_new_text($text_example, _tag)


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