class DegreePolicy
  attr_reader :user, :degree

  def initialize(user, degree)
    @user = user
    @degree = degree
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    @user and @user.is_admin?
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # class Scope
  #   attr_reader :user, :scope

  #   def initialize(user, scope)
  #     @user = user
  #     @scope = scope
  #   end

  #   def resolve
  #     scope.all
  #   end
  # end
end
