require './lib/dog.rb'

describe Dog do
  subject { Dog.new('basset', 'Fido') }
  
  it 'instantiates a new dog' do
    expect(subject).to be_a Dog
  end
  
  it { expect(subject).to respond_to :breed }
  it { expect(subject).to respond_to :name }
  it { expect(subject).to respond_to :bark }
  it { expect(subject).to respond_to :say_hi }
  
  it 'sets breed' do
    expect(subject.breed).to eql 'basset'
  end
  
  it 'sets name' do
    expect(subject.name).to eql 'Fido'
  end
  
  it 'barks' do 
    expect{subject.bark}.to output(/Voff, Voff/).to_stdout
  end
  
  it 'says hi' do 
    output = /Jag är en basset och heter Fido/
    expect{subject.say_hi}.to output(output).to_stdout
  end
    
end

