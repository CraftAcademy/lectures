require './lib/dog.rb'

describe Dog do
  subject { Dog.new('basset', 'Fido') }
  
  it 'instatiates a new dog' do
    expect(subject).to be_a Dog
  end
  
  it 'sets breed' do
    byebug
    expect(subject.breed).to eql 'basset'
  end
  
  it 'sets name' do
    expect(subject.name).to eql 'Fido'
  end
  
end