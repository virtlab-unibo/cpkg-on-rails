# can :manage, Course do |course|
#   user.is_admin? or course.user_ids.include?(user.id)
class CoursePolicy
  attr_reader :user, :course

  def initialize(user, course)
    @user = user
    @course = course
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    @user.is_admin?
  end

  def new?
    create?
  end

  def update?
    @user.is_admin? or @course.user_ids.include?(@user.id)
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def depend?
    update?
  end

  def undepend?
    update?
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
