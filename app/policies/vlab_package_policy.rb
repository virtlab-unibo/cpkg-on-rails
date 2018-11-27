# can :manage, package do |package|
# user.is_admin? or package.user_ids.include?(user.id)
class VlabPackagePolicy
  attr_reader :user, :package

  def initialize(user, package)
    @user = user
    @package = package
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    @user and (@user.is_admin? or @package.user_ids.include?(@user.id))
  end

  def new?
    create?
  end

  def update?
    @user and (@user.is_admin? or @package.user_ids.include?(@user.id))
  end

  def edit?
    update?
  end

  def destroy?
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
