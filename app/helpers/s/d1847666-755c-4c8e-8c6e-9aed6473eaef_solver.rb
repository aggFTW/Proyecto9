def add_number n, with_m
	return (n + with_m)
end
def get_error
   (1..3).to_a.sample
end 
def solve(inquiry, values)
  answers = Hash.new('')
  #Inserte su codigo para llenar generar answers aqui
  answers[1] = add_number(values['^1'], values['^2'])
  answers[2] = add_number(values['^1'], values['^2']) - get_error
  answers[2] = add_number(values['^1'], values['^2']) + get_error
  #Inserte su codigo para indicar la respuesta correcta
  correct = 1
  [answers, correct]
end