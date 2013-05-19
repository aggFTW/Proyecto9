def get_sample_random
   (1..20).to_a.sample
end 
def randomize(inquiry)
  values = Hash.new('')
  #Inserte su codigo para llenar values aqui
  values['^1'] = get_sample_random
  values['^2'] = get_sample_random
end