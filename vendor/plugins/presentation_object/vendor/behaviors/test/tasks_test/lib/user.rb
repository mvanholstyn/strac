class User
  attr_accessor :age, :name
  def initialize(name,age)
    @name = name
    @age = age
  end

  def adult?
    @age >= 18
  end
end
