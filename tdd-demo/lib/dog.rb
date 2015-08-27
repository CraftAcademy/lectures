class Dog
  attr_accessor :breed, :name
  
  def initialize(breed, name)
    @breed = breed
    @name = name 
  end
  
  def bark
    puts 'Voff, Voff'
  end
  
  def say_hi
    puts "Jag är en #{@breed} och heter #{@name}"
  end
  
end